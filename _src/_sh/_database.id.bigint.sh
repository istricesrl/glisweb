#!/bin/bash

## CONVERSIONE DELLE CHIAVI DA int(11) A bigint(20)
#
# Porta a bigint tutte le colonne `id` e `id_*` di tipo intero: la chiave primaria di ogni
# tabella e i riferimenti che la citano.
#
# PERCHE'. Con int(11) il tetto e' 2.147.483.647, e su questo progetto e' gia' quasi tutto
# occupato: la ripartizione decisa il 2026-08-27 assegna www2 sotto il miliardo, DEV
# 1,0-1,5 miliardi e connor 1,5-2,0, e il travaso delle attivita' del 2026-09-01 ha dovuto
# infilare le righe storiche a 1,6 miliardi, cioe' DENTRO lo spazio di connor, perche' fuori
# non ce n'era piu'. Non resta margine per un quarto ambiente, per un secondo blocco storico
# ne' per un errore di calcolo. Con bigint il problema sparisce invece di essere rimandato,
# e gli scarti tornano leggibili ( 10^12 per ambiente ).
#
# COME. Un solo ALTER TABLE per tabella, con tutte le sue colonne insieme: sono ~2.900 colonne
# su ~250 tabelle, e 250 ALTER si contano, 2.900 no. I vincoli esterni ( ~950 ) impongono che
# le due parti di ogni riferimento abbiano lo STESSO tipo: per questo si lavora con
# FOREIGN_KEY_CHECKS = 0 e si converte tutto in un colpo, altrimenti ogni singolo ALTER
# fallirebbe contro il vincolo che lo lega alla tabella non ancora convertita.
#
# I valori non cambiano: bigint contiene int, e le colonne restano NULL/NOT NULL e AUTO_INCREMENT
# come sono. E' una conversione allargante, quindi non perde nulla; l'inverso invece taglierebbe.
#
# uso: _database.id.bigint.sh <STATO> [ --server <nome> ] [ --database <db> ] [ --prova | --forza | --verifica ]
#
#   --prova     stampa gli ALTER e non tocca niente ( default se non si passa --forza )
#   --database  lavora su un database diverso da quello del profilo: serve per collaudare
#               sul banco di _database.rebuild.check.sh prima di toccare un ambiente vero
#   --forza     esegue davvero
#
# LE TRE TRAPPOLE, e come sono gestite qui. Sono costate tutte e tre, il 2026-09-01:
#
#   1. FOREIGN_KEY_CHECKS = 0 NON BASTA. Sospende il controllo dei valori, non permette di
#      cambiare la FORMA di una colonna vincolata: MariaDB rifiuta con 1832/1833. Senza sganciare
#      i vincoli, 39 tabelle su 246 restano indietro. -> lo script li sgancia e li riaggancia.
#   2. NON TUTTE LE CHIAVI SI CHIAMANO id_*. Con un prefisso davanti ( destinatario_id_comune )
#      sfuggono al filtro ovvio: restano int mentre la padre diventa bigint, e i loro vincoli non
#      si riagganciano piu'. L'errore che MariaDB restituisce manda fuori strada ( "Missing index
#      for constraint ... in the referenced table": l'indice c'e', e' il tipo a non combaciare ).
#      -> il filtro prende le tre specie di colonna descritte sopra.
#   3. "ZERO ERRORI" NON VUOL DIRE FINITO. Le chiavi che nessun vincolo dichiara si convertono o
#      si dimenticano senza che nulla protesti: 51 per ambiente, scoperte solo ricontando a mano.
#      -> alla fine lo script RICONTA e, se qualcosa e' rimasto indietro o un vincolo non e'
#         tornato al suo posto, lo dice, prova a ripararlo e in ogni caso esce con errore.
#
# --verifica esegue solo quel controllo finale, senza convertire niente: e' il modo di sapere
# in ogni momento se un database e' davvero a posto.
#
# PRIMA DI ESEGUIRLO SU UN AMBIENTE VERO: un backup ( _backup.nightly.sh ) e una finestra in
# cui il sito possa rallentare. Su un database di 360.000 righe dura meno di un minuto, ma
# ogni ALTER blocca la sua tabella per il tempo della riscrittura.

RL="../../"
cd $(dirname "$0")
. ./_lib/_functions.sh
cd $RL

if [ -z "$1" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ --server <nome> ] [ --database <db> ] [ --prova ] [ --forza ]"
    exit 1
fi

python3 - "$( pwd )" "$@" <<'PYTHON'
import json, os, subprocess, sys

docroot = sys.argv[1]
args    = sys.argv[2:]
stato   = args[0]
def opzione( nome, default = None ):
    return args[ args.index( nome ) + 1 ] if nome in args else default
SERVER = opzione( '--server' )
DBNOME = opzione( '--database' )
FORZA    = '--forza' in args
VERIFICA = '--verifica' in args

def carica( nome ):
    try:    return json.load( open( os.path.join( docroot, 'src', nome ) ) )
    except Exception: return {}

cf, sh = carica( 'config.json' ), carica( 'shadow.json' )
servers = dict( cf.get( 'mysql', {} ).get( 'servers', {} ) )
for k, v in sh.get( 'mysql', {} ).get( 'servers', {} ).items():
    servers.setdefault( k, {} ).update( v )

nomi = ( cf.get( 'mysql', {} ).get( 'profiles', {} ).get( stato, {} ) or {} ).get( 'servers' ) or []
if isinstance( nomi, str ): nomi = [ nomi ]
if not nomi:
    print( 'ERRORE: nessun server dichiarato in mysql.profiles.%s' % stato ); sys.exit( 1 )

S  = dict( servers[ SERVER ] ) if SERVER else dict( servers[ nomi[0] ] )
db = DBNOME or S[ 'db' ]

def mysql( query, database = None, force = False ):
    env = dict( os.environ, MYSQL_PWD = S.get( 'password' ) or '' )
    cmd = [ 'mysql', '-h', S.get( 'address' ) or '127.0.0.1', '-P', str( S.get( 'port' ) or 3306 ),
            '-u', S.get( 'username' ) or 'root', '-N', '-B' ]
    if force: cmd.append( '--force' )
    cmd += [ database or db, '-e', query ]
    r = subprocess.run( cmd, env = env, capture_output = True, text = True )
    return r.returncode, r.stdout, r.stderr

CHIAVI = ( "( c.column_name = 'id' OR c.column_name LIKE 'id\\_%' "
           "  OR c.column_name LIKE '%\\_id' OR c.column_name LIKE '%\\_id\\_%' )" )

def residui():
    """Le chiavi rimaste int: nome per nome, non solo il conteggio."""
    _, out, _ = mysql(
        "SELECT concat( c.table_name, '.', c.column_name ) FROM information_schema.columns c "
        "JOIN information_schema.tables t ON t.table_schema = c.table_schema AND t.table_name = c.table_name "
        "WHERE c.table_schema = database() AND t.table_type = 'BASE TABLE' AND c.data_type = 'int' AND "
        + CHIAVI + " ORDER BY 1;" )
    return [ r for r in out.split( '\n' ) if r.strip() ]

def elenco_vincoli():
    _, out, _ = mysql(
        "SELECT concat_ws( '|', k.table_name, k.constraint_name ) FROM information_schema.key_column_usage k "
        "WHERE k.table_schema = database() AND k.referenced_table_name IS NOT NULL GROUP BY 1 ORDER BY 1;" )
    return set( r for r in out.split( '\n' ) if r.strip() )

def verifica( attesi = None ):
    """Il controllo che la terza trappola ha insegnato a fare: ricontare invece di fidarsi."""
    male = 0
    r = residui()
    if r:
        print( '  ATTENZIONE: %d chiavi sono ancora int' % len( r ) )
        for x in r[:12]:
            print( '     %s' % x )
        if len( r ) > 12:
            print( '     ... e altre %d' % ( len( r ) - 12 ) )
        male += len( r )
    else:
        print( '  chiavi ancora int: nessuna' )
    ora = elenco_vincoli()
    if attesi is not None:
        persi = sorted( attesi - ora )
        if persi:
            print( '  ATTENZIONE: %d vincoli non sono tornati al loro posto' % len( persi ) )
            for x in persi[:12]:
                print( '     %s' % x.replace( '|', ' -> ' ) )
            male += len( persi )
        else:
            print( '  vincoli: %d, tutti al loro posto' % len( ora ) )
    else:
        print( '  vincoli: %d' % len( ora ) )
    return male

print( 'conversione delle chiavi a bigint: %s su %s' % ( db, S.get( 'address' ) ) )

if VERIFICA:
    print( '  ( solo verifica: non tocco niente )' )
    sys.exit( 1 if verifica() else 0 )

# le colonne da convertire, con quel che serve a riscriverle uguali
# Le colonne da convertire sono di due specie, e la seconda e' quella che si dimentica:
#  - quelle che si chiamano `id` o `id_*`, cioe' chiavi e riferimenti per convenzione;
#  - quelle con un PREFISSO davanti ( destinatario_id_comune, model_id_attivita, causale_id_contratto ):
#    sono chiavi a tutti gli effetti e vanno convertite anche dove nessun vincolo le protegge,
#    altrimenti restano int mentre la tabella che citano e' bigint;
#  - quelle COINVOLTE IN UN VINCOLO ESTERNO, comunque si chiamino. Su questo schema ce ne sono
#    parecchie con il prefisso davanti ( destinatario_id_comune, intestazione_id_stato... ):
#    se la tabella padre diventa bigint e la figlia resta int, il vincolo non si riaggancia piu'
#    e MariaDB lo dice in un modo che manda fuori strada ( "Missing index for constraint ...
#    in the referenced table", mentre l'indice c'e' benissimo: a non combaciare e' il tipo ).
rc, out, err = mysql(
    "SELECT c.table_name, c.column_name, c.is_nullable, c.extra, c.column_default "
    "FROM information_schema.columns c "
    "JOIN information_schema.tables t ON t.table_schema = c.table_schema AND t.table_name = c.table_name "
    "WHERE c.table_schema = '%(db)s' AND t.table_type = 'BASE TABLE' AND c.data_type = 'int' "
    "AND ( c.column_name = 'id' OR c.column_name LIKE 'id\\_%%' "
    "      OR c.column_name LIKE '%%\\_id' OR c.column_name LIKE '%%\\_id\\_%%' "
    "      OR EXISTS ( SELECT 1 FROM information_schema.key_column_usage k "
    "                  WHERE k.table_schema = c.table_schema AND k.table_name = c.table_name "
    "                  AND k.column_name = c.column_name AND k.referenced_table_name IS NOT NULL ) "
    "      OR EXISTS ( SELECT 1 FROM information_schema.key_column_usage k "
    "                  WHERE k.referenced_table_schema = c.table_schema AND k.referenced_table_name = c.table_name "
    "                  AND k.referenced_column_name = c.column_name ) ) "
    "ORDER BY c.table_name, c.ordinal_position;" % { 'db': db } )
if rc != 0:
    print( '  ERRORE: %s' % err.strip()[:300] ); sys.exit( 1 )

tabelle = {}
for riga in out.split( '\n' ):
    if riga.count( '\t' ) < 4: continue
    tab, col, nullable, extra, default = riga.split( '\t' )
    pezzo = '`%s` bigint(20)' % col
    pezzo += ' NULL' if nullable == 'YES' else ' NOT NULL'
    if default not in ( 'NULL', '' ):
        pezzo += " DEFAULT '%s'" % default
    elif nullable == 'YES':
        pezzo += ' DEFAULT NULL'
    if extra:
        pezzo += ' ' + extra
    tabelle.setdefault( tab, [] ).append( pezzo )

if not tabelle:
    print( '  niente da fare: nessuna colonna id di tipo int' ); sys.exit( 0 )

colonne = sum( len( v ) for v in tabelle.values() )
print( '  %d colonne su %d tabelle' % ( colonne, len( tabelle ) ) )

alter = [ 'ALTER TABLE `%s` %s;' % ( t, ', '.join( 'MODIFY ' + p for p in sorted( pezzi ) ) )
          for t, pezzi in sorted( tabelle.items() ) ]

if not FORZA:
    print( '\n  ( prova: non eseguo nulla. I primi tre ALTER, dopo lo sgancio dei vincoli: )\n' )
    for a in alter[:3]:
        print( '  %s' % a[:300] )
    print( '\n  passare --forza per eseguire' )
    sys.exit( 0 )

# i vincoli esterni: si annotano per intero, si sganciano e si riagganciano identici
rc, out, err = mysql(
    "SELECT k.constraint_name, k.table_name, k.column_name, k.referenced_table_name, "
    "k.referenced_column_name, r.delete_rule, r.update_rule "
    "FROM information_schema.key_column_usage k "
    "JOIN information_schema.referential_constraints r "
    "ON r.constraint_schema = k.table_schema AND r.constraint_name = k.constraint_name "
    "WHERE k.table_schema = '%s' AND k.referenced_table_name IS NOT NULL "
    "ORDER BY k.table_name, k.constraint_name, k.ordinal_position;" % db )
if rc != 0:
    print( '  ERRORE nella lettura dei vincoli: %s' % err.strip()[:300] ); sys.exit( 1 )

vincoli = {}
for riga in out.split( '\n' ):
    if riga.count( '\t' ) < 6: continue
    nome, tab, col, rtab, rcol, canc, agg = riga.split( '\t' )
    v = vincoli.setdefault( ( tab, nome ), { 'cols': [], 'rtab': rtab, 'rcols': [], 'del': canc, 'upd': agg } )
    v[ 'cols' ].append( col )
    v[ 'rcols' ].append( rcol )

sgancia = [ 'ALTER TABLE `%s` DROP FOREIGN KEY `%s`;' % ( t, n ) for ( t, n ) in sorted( vincoli ) ]
riaggancia = []
for ( t, n ), v in sorted( vincoli.items() ):
    riaggancia.append(
        'ALTER TABLE `%s` ADD CONSTRAINT `%s` FOREIGN KEY ( `%s` ) REFERENCES `%s` ( `%s` ) ON DELETE %s ON UPDATE %s;'
        % ( t, n, '`, `'.join( v[ 'cols' ] ), v[ 'rtab' ], '`, `'.join( v[ 'rcols' ] ), v[ 'del' ], v[ 'upd' ] ) )

attesi = elenco_vincoli()
print( '  %d vincoli esterni da sganciare e riagganciare' % len( vincoli ) )
print( '  eseguo...' )
script = ( 'SET FOREIGN_KEY_CHECKS = 0;\n'
           + '\n'.join( sgancia ) + '\n'
           + '\n'.join( alter ) + '\n'
           + '\n'.join( riaggancia ) + '\n'
           + 'SET FOREIGN_KEY_CHECKS = 1;\n' )
env = dict( os.environ, MYSQL_PWD = S.get( 'password' ) or '' )
cmd = [ 'mysql', '-h', S.get( 'address' ) or '127.0.0.1', '-P', str( S.get( 'port' ) or 3306 ),
        '-u', S.get( 'username' ) or 'root', '--force', db ]
r = subprocess.run( cmd, input = script, env = env, capture_output = True, text = True )
errori = [ l for l in r.stderr.split( '\n' ) if l.startswith( 'ERROR' ) ]
for l in errori[:10]:
    print( '  %s' % l[:220] )
if len( errori ) > 10:
    print( '  ... e altri %d' % ( len( errori ) - 10 ) )

print( '\ncontrollo del risultato' )
male = verifica( attesi )

# riparazione: se qualcosa e' rimasto indietro, quasi sempre e' una colonna che ha impedito a un
# vincolo di tornare al suo posto. Si converte quel che resta e si riprovano i vincoli persi.
if male:
    print( '\n  provo a riparare' )
    r = residui()
    persi = sorted( attesi - elenco_vincoli() )
    riparazione = [ 'SET FOREIGN_KEY_CHECKS = 0;' ]
    per_tabella = {}
    for x in r:
        t, c = x.split( '.', 1 )
        per_tabella.setdefault( t, [] ).append( c )
    for t, cc in sorted( per_tabella.items() ):
        riparazione.append( 'ALTER TABLE `%s` %s;' % ( t, ', '.join( 'MODIFY `%s` bigint(20) DEFAULT NULL' % c for c in cc ) ) )
    for chiave in persi:
        t, n = chiave.split( '|' )
        if ( t, n ) in vincoli:
            v = vincoli[ ( t, n ) ]
            riparazione.append(
                'ALTER TABLE `%s` ADD CONSTRAINT `%s` FOREIGN KEY ( `%s` ) REFERENCES `%s` ( `%s` ) ON DELETE %s ON UPDATE %s;'
                % ( t, n, '`, `'.join( v[ 'cols' ] ), v[ 'rtab' ], '`, `'.join( v[ 'rcols' ] ), v[ 'del' ], v[ 'upd' ] ) )
    riparazione.append( 'SET FOREIGN_KEY_CHECKS = 1;' )
    r2 = subprocess.run( cmd, input = '\n'.join( riparazione ) + '\n', env = env, capture_output = True, text = True )
    male = verifica( attesi )

print( '\nesito: %d errori durante la conversione, %d cose fuori posto' % ( len( errori ), male ) )
sys.exit( 1 if ( errori or male ) else 0 )
PYTHON
