#!/bin/bash

## RICOSTRUZIONE DEL DATABASE DAI PATCH, E CONFRONTO CON QUELLO VERO
#
# Crea un database vuoto, gli applica i file di _usr/_database/_patch/ ( e quelli di
# usr/database/patch/, se il progetto ne ha ) nell'ordine, e poi lo confronta con il
# database in esercizio. Alla fine lo butta via.
#
# A COSA SERVE. I file di patch sono la fonte di verita' dichiarata dello schema, ma finche'
# nessuno li esegue restano un documento: il 1/09/2026 si e' scoperto che _090000999999.views.sql
# conteneva `id_mastro_provenienzagggggggggggg`, un refuso che rendeva documenti_view NON
# CREABILE dai file - e nessuno se n'era accorto, perche' il database vero non e' mai stato
# ricostruito da li'. Questo script rende quell'errore impossibile da non vedere.
#
# COSA RIPORTA:
#   1. il primo errore incontrato applicando i patch, con file e patch ( ci si ferma li', come il
#      task: l'applicazione e' quella di _src/_lib/_mysql.tools.php, la stessa di un deploy );
#   2. le divergenze fra lo schema ricostruito e quello vero, in tre gruppi:
#      - solo nei patch      ( dichiarato e mai creato: di solito un patch che non gira )
#      - solo nel database   ( esiste ma nessuno lo dichiara: la fonte di verita' e' altrove )
#      - colonne diverse     ( stesso oggetto, forma diversa )
#
# La seconda parte e' anche l'inventario di quanto i patch coprano davvero lo schema.
#
# uso: _database.rebuild.check.sh <STATO> [ --server <nome> ] [ --prova <db> ] [ --inventario ] [ --tieni ]
#
#   STATO          DEV | TEST | PROD, come per _backup.nightly.sh: in shell non c'e' HTTP_HOST
#                  da cui ricavarlo.
#   --server       server su cui costruire il database di prova, se diverso da quello del
#                  profilo. Serve un utente con CREATE / DROP DATABASE: l'utente applicativo
#                  di solito ha i privilegi sul solo database del progetto.
#   --prova        nome del database di prova ( default: <database>__rebuild ); deve finire
#                  anch'esso con __rebuild
#   --inventario   elenca tutti gli oggetti divergenti invece del solo riepilogo
#   --tieni        non cancella il database di prova alla fine ( per guardarci dentro )
#
# IL DATABASE DI PROVA E' USA-E-GETTA, E LO SCRIPT LO GARANTISCE. Fino al 29/09/2026 lo script
# faceva `DROP DATABASE IF EXISTS` sul nome ricevuto con --prova, all'inizio e alla fine: bastava
# passargli per sbaglio il nome del database vero perche' lo distruggesse. Ora cancella soltanto
# un database che ha creato lui, e lo riconosce da due firme insieme:
#
#   - il nome finisce con __rebuild ( --prova con un altro nome viene rifiutato );
#   - dentro c'e' la tabella __rebuild_check__, che lo script crea subito dopo il database e che
#     il confronto ignora.
#
# Un database che porta il nome giusto ma non la tabella e' di qualcun altro: lo script si
# rifiuta di toccarlo e si ferma. Rifiuta anche qualunque nome coincida con il database di uno
# dei server dichiarati in mysql.servers ( config e shadow ), qualunque sia il suffisso.

RL="../../"
cd $(dirname "$0")
. ./_lib/_functions.sh
cd $RL

if [ -z "$1" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ --server <nome> ] [ --prova <db> ] [ --inventario ] [ --tieni ]"
    exit 1
fi

python3 - "$( pwd )" "$@" <<'PYTHON'
import json, os, re, subprocess, sys

docroot = sys.argv[1]
args    = sys.argv[2:]
stato   = args[0]
def opzione( nome, default = None ):
    return args[ args.index( nome ) + 1 ] if nome in args else default
SERVER     = opzione( '--server' )
PROVA      = opzione( '--prova' )
INVENTARIO = '--inventario' in args
TIENI      = '--tieni' in args

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

VERO  = servers[ nomi[0] ]
BANCO = dict( servers[ SERVER ] ) if SERVER else dict( VERO )
banco_db = PROVA or ( VERO[ 'db' ] + '__rebuild' )

# le due firme del database usa-e-getta: il suffisso del nome e la tabella marcatore
SUFFISSO = '__rebuild'
MARCA    = '__rebuild_check__'

# il nome finisce dentro backtick e apici: si accettano solo caratteri che non ne escano
if not re.match( r'^[A-Za-z0-9_]+$', banco_db ):
    print( 'ERRORE: nome del database di prova non valido: %s' % banco_db ); sys.exit( 1 )
if not banco_db.endswith( SUFFISSO ) or banco_db == SUFFISSO:
    print( 'ERRORE: il database di prova deve chiamarsi <qualcosa>%s, non %s' % ( SUFFISSO, banco_db ) )
    print( '  ( e\' la firma che lo rende riconoscibile come usa-e-getta )' ); sys.exit( 1 )
configurati = sorted( set( s.get( 'db' ) for s in servers.values() if s.get( 'db' ) ) )
if banco_db in configurati:
    print( 'ERRORE: %s e\' il database di un server dichiarato in mysql.servers: non lo uso come banco' % banco_db )
    sys.exit( 1 )

def cli( s, db = None, extra = None ):
    c = [ 'mysql', '-h', s.get( 'address' ) or '127.0.0.1', '-P', str( s.get( 'port' ) or 3306 ),
          '-u', s.get( 'username' ) or 'root' ] + ( extra or [] )
    return c + ( [ db ] if db else [] )

def sql( s, db, query, force = False ):
    env = dict( os.environ, MYSQL_PWD = s.get( 'password' ) or '' )
    extra = [ '-N', '-B', '-e', query ] if not force else [ '-N', '-B', '--force', '-e', query ]
    r = subprocess.run( cli( s, db, extra ), env = env, capture_output = True, text = True )
    return r.returncode, r.stdout, r.stderr

def oggetti( s, db ):
    _, out, _ = sql( s, db,
        "SELECT c.table_name, t.table_type, group_concat( c.column_name ORDER BY c.ordinal_position ) "
        "FROM information_schema.columns c JOIN information_schema.tables t "
        "ON t.table_schema = c.table_schema AND t.table_name = c.table_name "
        "WHERE c.table_schema = database() AND c.table_name <> '%s' "
        "GROUP BY c.table_name, t.table_type;" % MARCA )
    d = {}
    for riga in out.split( '\n' ):
        if riga.count( '\t' ) >= 2:
            nome, tipo, colonne = riga.split( '\t', 2 )
            d[ nome ] = ( 'vista' if tipo == 'VIEW' else 'tabella', colonne.split( ',' ) )
    return d

print( 'ricostruzione dello schema dai patch' )
print( '  profilo %s, database vero: %s su %s' % ( stato, VERO[ 'db' ], VERO.get( 'address' ) ) )
print( '  banco di prova: %s su %s' % ( banco_db, BANCO.get( 'address' ) ) )

def esiste( db ):
    rc, out, err = sql( BANCO, None, "SELECT count(*) FROM information_schema.schemata "
                                     "WHERE schema_name = '%s';" % db )
    if rc != 0:
        print( '  ERRORE: non riesco a interrogare il server del banco: %s' % err.strip()[:300] ); sys.exit( 1 )
    return out.strip() != '0'

def usa_e_getta( db ):
    """Vero solo se il database porta la tabella marcatore che questo script crea insieme a lui."""
    rc, out, _ = sql( BANCO, None, "SELECT count(*) FROM information_schema.tables "
                                   "WHERE table_schema = '%s' AND table_name = '%s';" % ( db, MARCA ) )
    return rc == 0 and out.strip() == '1'

def butta( db ):
    # si ricontrolla la firma anche qui: il DROP non parte mai su un database che non e' del banco
    if usa_e_getta( db ):
        sql( BANCO, None, 'DROP DATABASE `%s`;' % db )
    else:
        print( '  ATTENZIONE: %s non porta piu\' la tabella %s, non lo cancello' % ( db, MARCA ) )

# un banco lasciato in piedi da un giro precedente ( --tieni ) si ricrea; qualunque altro no
if esiste( banco_db ):
    if not usa_e_getta( banco_db ):
        print( '  ERRORE: %s esiste gia\' e non l\'ha creato questo script ( manca la tabella %s ):'
               % ( banco_db, MARCA ) )
        print( '  non lo tocco. Scegliere un altro nome con --prova, oppure cancellarlo a mano se e\' davvero da buttare.' )
        sys.exit( 1 )
    print( '  il banco di un giro precedente viene ricreato' )
    butta( banco_db )

rc, _, err = sql( BANCO, None, 'CREATE DATABASE `%s` DEFAULT CHARACTER SET utf8; '
                  'CREATE TABLE `%s`.`%s` ( `database_vero` varchar( 64 ), `creato` datetime ); '
                  "INSERT INTO `%s`.`%s` VALUES ( '%s', now() );"
                  % ( banco_db, banco_db, MARCA, banco_db, MARCA, VERO[ 'db' ].replace( "'", '' ) ) )
if rc != 0:
    print( '  ERRORE: non riesco a creare il database di prova: %s' % err.strip()[:300] )
    print( '  ( serve un utente con CREATE DATABASE: usare --server per indicarne un altro )' )
    sys.exit( 1 )

# i patch si applicano con le funzioni mysqlPatch...() di _src/_lib/_mysql.tools.php, le stesse del
# task _mysql.patch.php e di _mysql.upgrade.sh, tramite _src/_cli/_mysql.patch.php: l'ordine dei file
# ( prima lo standard, poi il progetto ), un blocco per marcatore `-- |` eseguito come UNA query, la
# registrazione in __patch__ e l'arresto al primo errore sono quelli di un deploy vero. Fino al
# 29/09/2026 questo script aveva un suo spezzatore e dava i blocchi al client `mysql` con --force e
# DELIMITER: proseguiva dopo gli errori, e non vedeva i blocchi che il task saltava o registrava
# senza eseguirli. Ora un errore ferma l'applicazione, e il confronto che segue e' su uno schema
# parziale: va letto sapendolo.
print( '\napplicazione dei patch' )
env = dict( os.environ, MYSQL_PWD = BANCO.get( 'password' ) or '' )
r = subprocess.run( [ 'php', os.path.join( docroot, '_src/_cli/_mysql.patch.php' ),
                      BANCO.get( 'address' ) or '127.0.0.1', str( BANCO.get( 'port' ) or 3306 ),
                      BANCO.get( 'username' ) or 'root', banco_db ],
                    cwd = docroot, env = env, capture_output = True, text = True )
sys.stdout.write( r.stdout )
if r.stderr.strip():
    print( '      %s' % r.stderr.strip()[:600] )
errori = 0 if r.returncode == 0 else 1
if r.returncode == 2:
    print( '  ERRORE: patch non applicate, niente da confrontare' )
    if not TIENI:
        butta( banco_db )
    sys.exit( 1 )
if errori:
    print( '  ATTENZIONE: le patch si sono fermate al primo errore, il confronto qui sotto e\' su uno schema parziale' )

# confronto
ric  = oggetti( BANCO, banco_db )
vero = oggetti( VERO, VERO[ 'db' ] )

solo_patch = sorted( set( ric ) - set( vero ) )
solo_db    = sorted( set( vero ) - set( ric ) )
diverse    = sorted( n for n in set( ric ) & set( vero ) if ric[ n ][1] != vero[ n ][1] )

def conta( elenco, fonte ):
    t = len( [ n for n in elenco if fonte[ n ][0] == 'tabella' ] )
    return t, len( elenco ) - t

print( '\nconfronto con %s' % VERO[ 'db' ] )
print( '  ricostruito dai patch : %3d tabelle, %3d viste' % conta( list( ric ),  ric  ) )
print( '  nel database vero     : %3d tabelle, %3d viste' % conta( list( vero ), vero ) )
print( '  solo nei patch        : %3d tabelle, %3d viste   ( dichiarati e non creati )' % conta( solo_patch, ric ) )
print( '  solo nel database     : %3d tabelle, %3d viste   ( creati e non dichiarati )' % conta( solo_db, vero ) )
print( '  stesso nome, forma diversa: %d' % len( diverse ) )

if INVENTARIO:
    for titolo, elenco, fonte in ( ( 'SOLO NEI PATCH', solo_patch, ric ),
                                   ( 'SOLO NEL DATABASE', solo_db, vero ),
                                   ( 'FORMA DIVERSA', diverse, vero ) ):
        if not elenco: continue
        print( '\n%s ( %d )' % ( titolo, len( elenco ) ) )
        for n in elenco:
            if titolo == 'FORMA DIVERSA':
                a, b = set( ric[ n ][1] ), set( vero[ n ][1] )
                note = []
                if b - a: note.append( 'solo nel database: ' + ','.join( sorted( b - a ) ) )
                if a - b: note.append( 'solo nei patch: '    + ','.join( sorted( a - b ) ) )
                if not note: note.append( 'stesse colonne, ordine diverso' )
                print( '  %-8s %-44s %s' % ( fonte[ n ][0], n, '; '.join( note )[:160] ) )
            else:
                print( '  %-8s %s' % ( fonte[ n ][0], n ) )

if TIENI:
    print( '\n  il database di prova %s e\' stato lasciato in piedi' % banco_db )
else:
    butta( banco_db )

print( '\nesito: %d errori nei patch, %d oggetti non dichiarati, %d divergenti'
       % ( errori, len( solo_db ), len( diverse ) ) )
sys.exit( 1 if ( errori or diverse ) else 0 )
PYTHON
