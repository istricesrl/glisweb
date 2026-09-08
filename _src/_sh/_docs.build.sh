#!/bin/bash

## SCRIPT PER LA GENERAZIONE DELLE PAGINE STATICHE DELLA DOCUMENTAZIONE
#
# questo script compone i sorgenti markdown della documentazione e ne produce le pagine HTML
# statiche pubblicate sotto usr/pages/ e, dove richiesto, sotto _usr/_pages/
#
#   _docs.build.sh --user         manuale utente del progetto        -> usr/pages/manual/
#   _docs.build.sh --dev          manuale sviluppatore del progetto  -> usr/pages/manual/
#   _docs.build.sh --quickstart   quickstart del progetto            -> usr/pages/quickstart/
#   _docs.build.sh --standard     documentazione dello standard      -> _usr/_pages/    (vedi NOTA)
#   _docs.build.sh --all          tutte le precedenti
#   _docs.build.sh --dry-run      elenca cosa genererebbe, non scrive niente
#
# NOTA lo script NON esegue "clear": viene invocato in coda a _gw.upgrade.sh e da cron, dove
# ripulire lo schermo cancellerebbe l'output di chi lo ha chiamato
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

## verifica delle opzioni
if [ $# -eq 0 ]; then
    echo "nessuna opzione: uso $(basename "$0") [--user] [--dev] [--quickstart] [--standard] [--all] [--dry-run]" >&2
    exit 1
fi

## generazione
php ./_src/_sh/_lib/_docs.build.php "$@"
DOCS_EXIT_CODE=$?

if [ $DOCS_EXIT_CODE -ne 0 ]; then
    echo "generazione della documentazione fallita (codice $DOCS_EXIT_CODE)" >&2
    exit $DOCS_EXIT_CODE
fi

## permessi sui file generati
#
# _lamp.permissions.secure.sh gira PRIMA della generazione dentro _gw.upgrade.sh, quindi i file
# appena scritti nascerebbero con l'umask di root e Apache non li leggerebbe
for i in ./usr/pages/manual ./usr/pages/quickstart ./_usr/_pages; do
    if [ -d "$i" ]; then
        chown -R root:www-data "$i" 2>/dev/null
        find "$i" -type d -exec chmod 750 {} + 2>/dev/null
        find "$i" -type f -exec chmod 640 {} + 2>/dev/null
    fi
done

## codice di uscita
exit 0

## NOTA
#
# la documentazione dello standard si genera SOLO dove esiste var/docs.build.conf, cioe' sui deploy
# del framework: sui progetti cliente quei file finirebbero fra i disallineamenti che _gw.upgrade.sh
# raccoglie ogni notte, e verrebbero comunque cancellati dal suo "rm -rf ./_*"
#
# per approfondire vedi _usr/_docs/READ.md, sezione sulla documentazione
#
