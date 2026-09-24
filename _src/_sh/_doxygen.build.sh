#!/bin/bash

## SCRIPT PER LA BUILD DELLA REFERENCE DEL CODICE
#
# questo script genera con Doxygen la reference delle API a partire dai commenti nel codice,
# in HTML sotto _usr/_docs/_html e, se richiesto, in PDF sotto _usr/_docs/_pdf
#
#   _doxygen.build.sh            genera la reference in HTML
#   _doxygen.build.sh --pdf      genera anche il PDF ( LaTeX, lungo e fragile )
#
# La build e' RIPETIBILE: cancella l'output e lo rigenera da zero, quindi si rilancia ogni
# volta che si aggiunge o si modifica documentazione. E' invece opt-in: gira solo dove esiste
# var/docs.build.conf, cioe' sui deploy del framework. Sui progetti cliente non serve, costerebbe
# CPU alle 06:25 e il suo output finirebbe fra i disallineamenti raccolti da _gw.upgrade.sh.
#
# NOTA lo script NON esegue "clear" e NON installa pacchetti: e' pensato per girare anche da
# cron, dove ripulire lo schermo cancella l'output di chi lo ha chiamato e un apt-get senza -y
# resta appeso a un prompt che nessuno vedra' mai
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## funzioni
. ./_lib/_functions.sh

## directory di lavoro
cd $RL || exit 1

## informazioni
echo "lavoro su: $(pwd)"

## opzioni
PDF=0
for i in "$@"; do
    case "$i" in
        --pdf) PDF=1 ;;
        *)     echo "opzione non riconosciuta: $i" >&2; exit 1 ;;
    esac
done

## la reference si genera solo dove e' stata richiesta esplicitamente
if [ ! -f ./var/docs.build.conf ]; then
    echo "var/docs.build.conf assente: non genero la reference su questa installazione"
    echo "per abilitarla: touch var/docs.build.conf"
    exit 0
fi

## dipendenze
if ! command -v doxygen > /dev/null; then
    echo "doxygen non installato: apt-get install -y doxygen" >&2
    exit 1
fi

if [ $PDF -eq 1 ] && ! command -v pdflatex > /dev/null; then
    echo "pdflatex non installato: apt-get install -y texlive-latex-base texlive-latex-extra texlive-lang-italian" >&2
    exit 1
fi

## pulizia della build precedente
rm -rf ./_usr/_docs/_html
rm -rf ./_usr/_docs/_pdf

## cartelle
mkdir -p ./etc/doxygen ./_usr/_docs/_html ./_usr/_docs/_pdf ./var/log

## configurazione: il percorso assoluto e la versione dello standard si sostituiscono qui,
## perche' il Doxyfile e' standard e deve restare uguale su ogni installazione
VERSION="$( cat ./_etc/_current.version 2> /dev/null )"
sed -e "s|%DIR%|$(pwd)|g" -e "s|%VERSION%|${VERSION}|g" \
    ./_etc/_doxygen/_doxygen.conf > ./etc/doxygen/doxygen.conf

## build della reference
#
# nice e ionice perche' su una macchina condivisa questa e' la cosa meno urgente che ci gira
echo "genero la reference..."
nice -n 19 ionice -c3 doxygen ./etc/doxygen/doxygen.conf
DOXYGEN_EXIT_CODE=$?

if [ $DOXYGEN_EXIT_CODE -ne 0 ]; then
    echo "doxygen ha fallito (codice $DOXYGEN_EXIT_CODE), vedi var/log/doxygen.warn.log" >&2
    exit $DOXYGEN_EXIT_CODE
fi

if [ ! -f ./_usr/_docs/_html/index.html ]; then
    echo "doxygen non ha prodotto _usr/_docs/_html/index.html" >&2
    exit 1
fi

## build del PDF
if [ $PDF -eq 1 ]; then
    echo "genero il PDF..."
    ( cd ./_usr/_docs/_pdf/ && timeout 1800 nice -n 19 make > ../../../var/log/doxygen.latex.log 2>&1 )
    if [ ! -f ./_usr/_docs/_pdf/refman.pdf ]; then
        echo "il PDF non e' stato prodotto, vedi var/log/doxygen.latex.log" >&2
    fi
fi

## permessi
#
# mirati sulle sole cartelle prodotte: _lamp.permissions.secure.sh gira sull'intera document
# root ed e' lo script che apre e chiude la finestra di offline del deploy, non va invocato qui
chown -R root:www-data ./_usr/_docs/_html ./_usr/_docs/_pdf
find ./_usr/_docs/_html ./_usr/_docs/_pdf -type d -exec chmod 750 {} +
find ./_usr/_docs/_html ./_usr/_docs/_pdf -type f -exec chmod 640 {} +

## riepilogo
echo "reference generata: $( find ./_usr/_docs/_html -type f | wc -l ) file, $( du -sh ./_usr/_docs/_html | cut -f1 )"
echo "avvisi: $( wc -l < ./var/log/doxygen.warn.log 2> /dev/null || echo 0 )"

exit 0

## NOTA
#
# la reference e' pubblicata su /docs/ e /docs/pdf dalle regole del .htaccess, ma solo dove
# esiste var/docs.public.conf: senza, le due rotte rispondono 403. Il pannello informazioni di
# Athena mostra i due link solo se i file esistono davvero, quindi finche' questa build non
# gira le voci non compaiono affatto.
#
# per approfondire vedi la sezione sulla documentazione in _etc/_claude/_claude.framework.md
#
