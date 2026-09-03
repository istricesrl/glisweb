#!/bin/bash

## BACKUP NOTTURNO DEL SITO ( codice + database ) E PULIZIA
#
# Pensato per essere lanciato da cron, senza interazione. Fa le tre cose che oggi
# non fa nessuno:
#
#   1. il DUMP DEL DATABASE del profilo corrente. _backup.run.sh salva soltanto il
#      codice ( ed esclude var/ ), e _mysql.export.sh e' interattivo, quindi da cron
#      non si puo' usare: senza questo script il database non ha alcuna copia.
#   2. il tar del codice, richiamando _backup.run.sh, che resta l'unico posto dove
#      e' scritto che cosa va escluso.
#   3. la ROTAZIONE di entrambi e la pulizia dei log applicativi, che crescono senza
#      limite ( su un'installazione osservata: 6,1 GB in var/log, di cui 3,6 di soli
#      log dei task ).
#
# I backup NON vanno mai dentro la document root: finiscono un livello sopra, accanto
# a quelli di _backup.run.sh. Il modo e' 640 ( umask 027 ): dentro ci sono il sorgente
# del sito e i dati, e su una macchina con piu' utenti 644 vorrebbe dire darli a tutti.
#
# uso: _backup.nightly.sh <STATO> [ giorni_di_retention ] [ --senza-codice ]
#      ( STATO: DEV | TEST | PROD, default retention: 7 )
#
# --senza-codice salta il tar del sorgente: serve dove il tar lo fa gia' qualcun altro
# ( su web03 lo produce _gw.upgrade.sh a ogni aggiornamento notturno ).
#
# Lo STATO va detto: in cron non c'e' alcuna richiesta HTTP, quindi la regola del bootstrap
# ( ricavare SITE_STATUS dall'HTTP_HOST ) qui non si puo' applicare, e l'hostname della
# macchina non coincide con l'host del sito ( web03 serve bernispa.istricesrl.com ). Meglio
# dirlo che indovinarlo: un profilo sbagliato salverebbe il database di un altro ambiente.
#
# NOTA sulle credenziali: si leggono da src/shadow.json e src/config.json, cioe' dalla
# stessa configurazione che usa il framework, e la password non passa mai dalla riga di
# comando ( niente -p in chiaro nella lista dei processi ): si passa a mysqldump con
# MYSQL_PWD. Il profilo si sceglie con la stessa regola del bootstrap: si guarda quale
# stato in `sites` dichiara l'host di questa macchina.

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")

## libreria di funzioni
. ./_lib/_functions.sh

## servono i privilegi di root: si scrive fuori dalla document root e si legge shadow.json
check-root

## dalla cartella degli script alla document root
cd $RL

## la document root ( .../dev ) e la cartella che la contiene, dove vanno i backup
SUB=$( basename $( pwd ) )
DOCROOT=$( pwd )
cd ..
DEST=$( pwd )

## stato dell'ambiente e giorni di retention
STATO=$1
RETENTION=${2:-7}
SENZA_CODICE=$3

if [ -z "$STATO" ]; then
    echo "uso: $( basename $0 ) <DEV|TEST|PROD> [ giorni_di_retention ]"
    exit 1
fi

## i backup non devono essere leggibili da chiunque abbia una shell
umask 027

echo "backup notturno di $DOCROOT ( stato $STATO, retention ${RETENTION}gg )"

## ------------------------------------------------------------------
## 1. dump del database
## ------------------------------------------------------------------

STAMP=$( date +%Y%m%d%H%M%S )

python3 - "$DOCROOT" "$DEST" "$STAMP" "$STATO" <<'PYTHON'
import json, os, subprocess, sys, gzip

docroot, dest, stamp, stato = sys.argv[1], sys.argv[2], sys.argv[3], sys.argv[4]

def carica( nome ):
    p = os.path.join( docroot, 'src', nome )
    try:
        return json.load( open( p ) )
    except Exception:
        return {}

cf = carica( 'config.json' )
sh = carica( 'shadow.json' )

# fusione minima, come fa il framework: shadow vince su config
servers = dict( cf.get( 'mysql', {} ).get( 'servers', {} ) )
for k, v in sh.get( 'mysql', {} ).get( 'servers', {} ).items():
    servers.setdefault( k, {} ).update( v )

# il profilo dichiara quali server usare per questo stato
nomi = ( cf.get( 'mysql', {} ).get( 'profiles', {} ).get( stato, {} ) or {} ).get( 'servers' ) or []
if isinstance( nomi, str ): nomi = [ nomi ]
if not nomi:
    print( '  ERRORE: nessun server dichiarato in mysql.profiles.%s' % stato )
    sys.exit( 1 )

fatti = 0
for nome in nomi:
    s = servers.get( nome ) or {}
    db   = s.get( 'db' )
    if not db: continue
    addr = s.get( 'address' ) or '127.0.0.1'
    port = str( s.get( 'port' ) or 3306 )
    out  = os.path.join( dest, 'backup.db.%s.%s.sql.gz' % ( db, stamp ) )
    env  = dict( os.environ, MYSQL_PWD = s.get( 'password' ) or '' )
    base = [ 'mysqldump', '-h', addr, '-P', port, '-u', s.get( 'username' ) or 'root',
             '--opt', '--single-transaction', '--default-character-set=utf8mb4' ]
    print( '  dump di %s da %s -> %s' % ( db, addr, os.path.basename( out ) ) )

    # Prima con le routine, poi senza. L'utente applicativo non sempre ha il privilegio di
    # leggerle ( su mysql03: "bernispa has insufficient privileges to SHOW CREATE FUNCTION" ):
    # in quel caso si salvano comunque i dati, dicendolo, invece di non salvare niente.
    esito, err = 1, ''
    for routine in ( [ '--routines', '--events' ], [] ):
        cmd = base + routine + [ db ]
        with gzip.open( out, 'wb' ) as f:
            p = subprocess.Popen( cmd, stdout = subprocess.PIPE, stderr = subprocess.PIPE, env = env )
            for blocco in iter( lambda: p.stdout.read( 1 << 20 ), b'' ):
                f.write( blocco )
            err = p.stderr.read().decode( 'utf-8', 'replace' )
            p.wait()
        esito = p.returncode
        if esito == 0:
            if not routine:
                print( '  NOTA: routine e eventi NON inclusi ( privilegi insufficienti ); le definizioni stanno nei patch' )
            break
    if esito != 0:
        os.unlink( out )
        print( '  ERRORE nel dump di %s: %s' % ( db, err.strip()[:300] ) )
        continue
    os.chmod( out, 0o640 )
    print( '  fatto: %.1f MB' % ( os.path.getsize( out ) / 1048576.0 ) )
    fatti += 1

if not fatti:
    print( '  ATTENZIONE: nessun database salvato' )
    sys.exit( 1 )
PYTHON

DUMP_OK=$?

## ------------------------------------------------------------------
## 2. tar del codice, con le esclusioni di _backup.run.sh
## ------------------------------------------------------------------

if [ "$SENZA_CODICE" = "--senza-codice" ]; then
    echo "  codice: saltato ( --senza-codice )"
else
    "$DOCROOT/_src/_sh/_backup.run.sh" > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  codice: $( ls -1t $DEST/backup.*.tar.gz 2>/dev/null | head -1 | xargs -r basename )"
    else
        echo "  ERRORE nel backup del codice"
    fi
fi

## ------------------------------------------------------------------
## 3. rotazione dei backup e pulizia dei log applicativi
## ------------------------------------------------------------------

find "$DEST" -maxdepth 1 -type f -name 'backup.db.*.sql.gz' -mtime +${RETENTION} -delete
find "$DEST" -maxdepth 1 -type f -name 'backup.*.tar.gz'    -mtime +${RETENTION} -delete

## i log del framework: stessa regola di /etc/cron.daily/manutenzione-siti su web03
if [ -d "$DOCROOT/var/log/" ]; then
    PRIMA=$( du -sm "$DOCROOT/var/log/" | cut -f1 )
    find "$DOCROOT/var/log/" -type f -mtime +${RETENTION} -delete
    find "$DOCROOT/var/log/" -type d -empty -delete
    DOPO=$( du -sm "$DOCROOT/var/log/" 2>/dev/null | cut -f1 )
    echo "  log: ${PRIMA:-0} MB -> ${DOPO:-0} MB"
fi

echo "backup notturno concluso"

exit $DUMP_OK
