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
#   1. gli errori incontrati applicando i patch, con file e riga;
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
#   --prova        nome del database di prova ( default: <database>__rebuild )
#   --inventario   elenca tutti gli oggetti divergenti invece del solo riepilogo
#   --tieni        non cancella il database di prova alla fine ( per guardarci dentro )

RL="../../"
cd $(dirname "$0")
. ./_lib/_functions.sh
cd $RL

if [ -z "$1" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ --server <nome> ] [ --prova <db> ] [ --inventario ] [ --tieni ]"
    exit 1
fi

python3 - "$( pwd )" "$@" <<'PYTHON'
import glob, io, json, os, re, subprocess, sys, tempfile

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
        "WHERE c.table_schema = database() GROUP BY c.table_name, t.table_type;" )
    d = {}
    for riga in out.split( '\n' ):
        if riga.count( '\t' ) >= 2:
            nome, tipo, colonne = riga.split( '\t', 2 )
            d[ nome ] = ( 'vista' if tipo == 'VIEW' else 'tabella', colonne.split( ',' ) )
    return d

print( 'ricostruzione dello schema dai patch' )
print( '  profilo %s, database vero: %s su %s' % ( stato, VERO[ 'db' ], VERO.get( 'address' ) ) )
print( '  banco di prova: %s su %s' % ( banco_db, BANCO.get( 'address' ) ) )

rc, _, err = sql( BANCO, None, 'DROP DATABASE IF EXISTS `%s`; CREATE DATABASE `%s` '
                  'DEFAULT CHARACTER SET utf8;' % ( banco_db, banco_db ) )
if rc != 0:
    print( '  ERRORE: non riesco a creare il database di prova: %s' % err.strip()[:300] )
    print( '  ( serve un utente con CREATE DATABASE: usare --server per indicarne un altro )' )
    sys.exit( 1 )

# i patch, nell'ordine: prima lo standard, poi il progetto
files = sorted( glob.glob( os.path.join( docroot, '_usr/_database/_patch/*.sql' ) ) ) \
      + sorted( glob.glob( os.path.join( docroot,  'usr/database/patch/*.sql' ) ) )
if not files:
    print( '  ERRORE: nessun file di patch trovato' ); sys.exit( 1 )

def blocchi( percorso ):
    """Spezza un file di patch come fa il task _mysql.patch.php: le righe si accumulano fino al
    marcatore di livello successivo ( "-- | 070000002900" ) e ogni blocco vale UNA query. E' il
    motivo per cui questi file non hanno DELIMITER: le funzioni con i punti e virgola interni
    non sono mai passate da un client che spezzi sul punto e virgola. Dare il file in pasto a
    `mysql` produce infatti centinaia di errori fasulli ( "Undeclared variable", "END IF" )."""
    fuori, corrente = [], []
    for riga in io.open( percorso, encoding = 'utf-8', errors = 'replace' ):
        if riga.strip()[:4] == '-- |':
            if ''.join( corrente ).strip():
                fuori.append( ''.join( corrente ) )
            corrente = []
        else:
            corrente.append( riga )
    if ''.join( corrente ).strip():
        fuori.append( ''.join( corrente ) )
    return [ b for b in fuori if [ l for l in b.split( '\n' ) if l.strip() and not l.strip().startswith( '--' ) ] ]

errori = 0
print( '\napplicazione dei patch ( %d file )' % len( files ) )
env = dict( os.environ, MYSQL_PWD = BANCO.get( 'password' ) or '' )
for f in files:
    parti = blocchi( f )
    # Il delimitatore serve SOLO ai blocchi con un corpo composto ( funzioni, procedure,
    # trigger ): la' i punti e virgola interni spezzerebbero lo statement. Gli altri si
    # scrivono come sono - avvolgerli tutti fa fallire quelli che portano un commento in
    # coda al punto e virgola.
    pezzi = []
    for b in parti:
        b = b.strip()
        composto = re.search( r'\b(FUNCTION|PROCEDURE|TRIGGER)\b', b, re.I ) and re.search( r'\bBEGIN\b', b, re.I )
        if composto:
            corpo = b[:-1] if b.endswith( ';' ) else b
            pezzi.append( 'DELIMITER $$\n%s$$\nDELIMITER ;\n' % corpo )
        else:
            pezzi.append( b if b.endswith( ';' ) else b + ';' )
    with tempfile.NamedTemporaryFile( mode = 'w', suffix = '.sql', delete = False, encoding = 'utf-8' ) as t:
        t.write( '\n'.join( pezzi ) )
        tmp = t.name
    try:
        r = subprocess.run( cli( BANCO, banco_db, [ '--force' ] ), stdin = open( tmp ),
                            env = env, capture_output = True, text = True )
    finally:
        os.unlink( tmp )
    righe = [ l for l in r.stderr.split( '\n' ) if l.startswith( 'ERROR' ) ]
    print( '  %-46s %3d blocchi, %s' % ( os.path.basename( f ), len( parti ),
                                         'OK' if not righe else '%d errori' % len( righe ) ) )
    for l in righe[:8]:
        print( '      %s' % l[:200] )
    if len( righe ) > 8:
        print( '      ... e altri %d' % ( len( righe ) - 8 ) )
    errori += len( righe )

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
    sql( BANCO, None, 'DROP DATABASE IF EXISTS `%s`;' % banco_db )

print( '\nesito: %d errori nei patch, %d oggetti non dichiarati, %d divergenti'
       % ( errori, len( solo_db ), len( diverse ) ) )
sys.exit( 1 if ( errori or diverse ) else 0 )
PYTHON
