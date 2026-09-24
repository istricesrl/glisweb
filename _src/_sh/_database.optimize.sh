#!/bin/bash

## RECUPERO DELLO SPAZIO SPRECATO DALLE TABELLE INNODB
#
# InnoDB non restituisce al filesystem lo spazio delle righe cancellate: resta dentro il file
# della tabella e lo riusa solo quella tabella. Dopo una cancellazione massiva un file puo' quindi
# restare grande il doppio di cio' che contiene, per sempre. Non e' un errore, non compare in
# nessun log, e nessuno se ne accorge finche' il disco non finisce.
#
# Osservato il 2026-09-10 su un deploy in esercizio: `__report_lezioni_corsi__` con 377 MB di dati
# e 373 di spazio vuoto ( meta' del file ), `todo` con 104 contro 79. In tutto 452 MB su una
# macchina con 3,9 GB di RAM che ospita dieci deploy.
#
# COSA FA: `OPTIMIZE TABLE` sulle tabelle che superano le soglie, una per volta, riportando prima
# e dopo. Su InnoDB `OPTIMIZE` e' una RICOSTRUZIONE della tabella, quindi:
#
#   - costa I/O quanto la tabella e' grande, e su un disco condiviso si sente;
#   - tiene un lock esclusivo nei momenti iniziale e finale, brevi ma reali;
#   - non ha alcun senso ripeterlo se non c'e' niente da recuperare.
#
# PER QUESTO NON VA IN CRON. Il giro periodico e' il task `_database.frammentazione.check.php`, che
# guarda e basta e scrive nel log quando vale la pena; questo script si lancia a mano, quando quel
# log lo dice e quando la macchina e' tranquilla. E' la stessa divisione fra chi guarda e chi
# ripara che il framework usa gia' con `_folders.check.sh` e `_database.rebuild.check.sh`.
#
# uso: _database.optimize.sh <STATO> [ --soglia-mb N ] [ --soglia-perc N ]
#                                    [ --tabella NOME ] [ --elenca ] [ --si ] [ --anche-di-giorno ]
#
#   STATO             DEV | TEST | PROD
#   --soglia-mb       spazio libero minimo perche' una tabella sia candidata ( default 50 )
#   --soglia-perc     e insieme quota minima del file ( default 25 )
#   --tabella NOME    una sola tabella, ignorando le soglie
#   --elenca          mostra le candidate e non fa niente ( e' anche il default senza --si )
#   --si              esegue davvero, senza chiedere conferma
#   --anche-di-giorno esegue anche fra le 8 e le 20, che di norma e' rifiutato
#
# Lo STATO va detto, come in _backup.nightly.sh: in shell non c'e' alcuna richiesta HTTP, quindi la
# regola del bootstrap ( ricavare SITE_STATUS dall'HTTP_HOST ) non si puo' applicare. Meglio dirlo
# che indovinarlo: qui si riscrivono tabelle, e sbagliare ambiente non e' un dettaglio.
#
# LA FINESTRA ORARIA NON E' UN VEZZO. Il 2026-09-10, su questa stessa macchina, un confronto
# integrale fra due viste ha portato il load da 2,2 a 5,1 su 2 core per un paio di minuti, con gli
# utenti dentro. Una ricostruzione da 377 MB pesa di piu'. Fuori orario si fa e non se ne accorge
# nessuno; di giorno si vede, e allora bisogna volerlo dire esplicitamente.
#
# NOTA sulle credenziali: si leggono da src/shadow.json e src/config.json, cioe' dalla stessa fonte
# del framework, con shadow che vince su config. Stesso schema di _backup.nightly.sh.

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## libreria di funzioni
. ./_lib/_functions.sh

## servono i privilegi di root: si legge shadow.json
check-root

## dalla cartella degli script alla document root
cd $RL || exit 1
DOCROOT=$( pwd )

## argomenti
STATO=""
SOGLIA_MB=50
SOGLIA_PERC=25
TABELLA=""
ESEGUI=0
ANCHE_DI_GIORNO=0

while [ $# -gt 0 ]; do
    case "$1" in
        --soglia-mb)       SOGLIA_MB="$2"; shift 2 ;;
        --soglia-perc)     SOGLIA_PERC="$2"; shift 2 ;;
        --tabella)         TABELLA="$2"; shift 2 ;;
        --elenca)          ESEGUI=0; shift ;;
        --si)              ESEGUI=1; shift ;;
        --anche-di-giorno) ANCHE_DI_GIORNO=1; shift ;;
        *)                 [ -z "$STATO" ] && STATO="$1"; shift ;;
    esac
done

if [ -z "$STATO" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ --soglia-mb N ] [ --soglia-perc N ] [ --tabella NOME ] [ --si ] [ --anche-di-giorno ]"
    exit 1
fi

## la finestra oraria: di giorno si rifiuta, a meno che non lo si chieda apposta
ORA=$( date +%H )
if [ "$ESEGUI" = "1" ] && [ "$ANCHE_DI_GIORNO" = "0" ] && [ "$ORA" -ge 8 ] && [ "$ORA" -lt 20 ]; then
    echo "sono le $ORA: una ricostruzione di tabelle in orario di lavoro si sente sugli utenti."
    echo "rilancia fuori orario, oppure aggiungi --anche-di-giorno se sai quello che fai."
    exit 1
fi

echo "tabelle InnoDB con spazio sprecato in $DOCROOT ( stato $STATO )"
if [ -n "$TABELLA" ]; then
    echo "  una sola tabella: $TABELLA"
else
    echo "  soglie: almeno ${SOGLIA_MB} MB liberi E almeno il ${SOGLIA_PERC}% del file"
fi
[ "$ESEGUI" = "1" ] && echo "  MODO: esecuzione" || echo "  MODO: solo elenco ( aggiungi --si per eseguire )"
echo

python3 - "$DOCROOT" "$STATO" "$SOGLIA_MB" "$SOGLIA_PERC" "$TABELLA" "$ESEGUI" <<'PYTHON'
import json, os, subprocess, sys

docroot, stato, soglia_mb, soglia_perc, tabella, esegui = sys.argv[1:7]
soglia_mb, soglia_perc, esegui = int( soglia_mb ), int( soglia_perc ), esegui == '1'

def carica( nome ):
    try:
        return json.load( open( os.path.join( docroot, 'src', nome ) ) )
    except Exception:
        return {}

cf = carica( 'config.json' )
sh = carica( 'shadow.json' )

# fusione minima, come fa il framework: shadow vince su config
servers = dict( cf.get( 'mysql', {} ).get( 'servers', {} ) )
for k, v in sh.get( 'mysql', {} ).get( 'servers', {} ).items():
    servers.setdefault( k, {} ).update( v )

nomi = ( cf.get( 'mysql', {} ).get( 'profiles', {} ).get( stato, {} ) or {} ).get( 'servers' ) or []
if isinstance( nomi, str ): nomi = [ nomi ]
if not nomi:
    print( '  ERRORE: nessun server dichiarato in mysql.profiles.%s' % stato )
    sys.exit( 1 )

def interroga( s, sql ):
    env  = dict( os.environ, MYSQL_PWD = s.get( 'password' ) or '' )
    base = [ 'mysql', '-h', s.get( 'address' ) or '127.0.0.1', '-P', str( s.get( 'port' ) or 3306 ),
             '-u', s.get( 'username' ) or 'root', '-N', '-B', s.get( 'db' ), '-e', sql ]
    r = subprocess.run( base, env = env, capture_output = True, text = True )
    if r.returncode != 0:
        print( '  ERRORE: %s' % r.stderr.strip().splitlines()[-1:] )
        return None
    return [ l.split( '\t' ) for l in r.stdout.strip().splitlines() if l.strip() ]

recuperato_totale = 0

for nome in nomi:

    s = servers.get( nome ) or {}
    if not s.get( 'db' ): continue

    print( '  database %s su %s' % ( s['db'], s.get( 'address' ) or '127.0.0.1' ) )

    if tabella:
        filtro = "AND table_name = '%s'" % tabella.replace( "'", "" )
    else:
        filtro = ( "AND data_free > %d "
                   "AND ( data_length + index_length + data_free ) > 0 "
                   "AND ( 100 * data_free / ( data_length + index_length + data_free ) ) >= %d"
                   % ( soglia_mb * 1048576, soglia_perc ) )

    righe = interroga( s,
        "SELECT table_name, "
        "round( ( data_length + index_length ) / 1048576 ), "
        "round( data_free / 1048576 ), "
        "round( 100 * data_free / ( data_length + index_length + data_free ) ) "
        "FROM information_schema.tables "
        "WHERE table_schema = database() AND engine = 'InnoDB' %s "
        "ORDER BY data_free DESC" % filtro )

    if righe is None: continue

    if not righe:
        print( '    nessuna tabella oltre le soglie: niente da recuperare' )
        continue

    for t, usato, libero, perc in righe:
        print( '    %-45s %6s MB usati, %6s MB liberi ( %s%% )' % ( t, usato, libero, perc ) )

    attesi = sum( int( r[2] ) for r in righe )
    print( '    ---> %d MB recuperabili su %d tabelle' % ( attesi, len( righe ) ) )

    if not esegui:
        print( '    ( solo elenco: niente e\' stato toccato )' )
        continue

    for t, usato, libero, perc in righe:
        print( '    ricostruisco %s ( %s MB )...' % ( t, usato ), flush = True )
        # OPTIMIZE TABLE su InnoDB e' un ALTER ... FORCE: MariaDB lo dice con una nota, non e' un errore
        esito = interroga( s, 'OPTIMIZE TABLE `%s`' % t.replace( '`', '' ) )
        if esito is None:
            print( '      FALLITA: la tabella resta com\'era' )
            continue
        dopo = interroga( s,
            "SELECT round( data_free / 1048576 ) FROM information_schema.tables "
            "WHERE table_schema = database() AND table_name = '%s'" % t.replace( "'", "" ) )
        libero_dopo = dopo[0][0] if dopo else '?'
        print( '      libero prima %s MB, dopo %s MB' % ( libero, libero_dopo ) )
        try:
            recuperato_totale += int( libero ) - int( libero_dopo )
        except Exception:
            pass

if esegui:
    print( '' )
    print( '  recuperati %d MB in tutto' % recuperato_totale )
PYTHON

echo
echo "fine"
