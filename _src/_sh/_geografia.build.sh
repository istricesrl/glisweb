#!/bin/bash

## SCRIPT PER L'ALLINEAMENTO E LA PUBBLICAZIONE DEI DATI GEOGRAFICI STANDARD
#
# questo script allinea la tabella dei comuni all'elenco ufficiale ISTAT e rigenera i quattro CSV
# che i deploy scaricano da dataserver.istricesrl.com
#
#   _geografia.build.sh --istat       allinea la tabella comuni all'elenco ISTAT
#   _geografia.build.sh --export      rigenera i CSV in var/geografia/
#   _geografia.build.sh --all         tutte e due
#   _geografia.build.sh --dry-run     mostra cosa farebbe, non scrive e non esegue niente
#
# NOTA lo script NON esegue "clear": puo' essere invocato da cron, dove ripulire lo schermo
# cancellerebbe l'output di chi lo ha chiamato
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
    echo "nessuna opzione: uso $(basename "$0") [--istat] [--export] [--all] [--dry-run]" >&2
    exit 1
fi

## SOLO DOVE IL FRAMEWORK SI SVILUPPA
#
# comuni, provincie, regioni e stati sono TABELLE STANDARD: il loro contenuto e' parte del
# framework e i deploy non possono modificarlo, il che vuol dire che questo script non ha nessun
# motivo di girare su un progetto cliente e ne avrebbe parecchi per fare danno.
#
# Il marcatore sta in var/ e non in etc/ per lo stesso motivo di var/docs.build.conf: etc/ viene
# deployato, quindi un marcatore creato qui accenderebbe lo script anche altrove. var/ e' escluso
# dal deploy e ignorato da git.
if [ ! -f ./var/geografia.build.conf ]; then
    echo "var/geografia.build.conf assente: questo script gira solo dove si sviluppa il framework," >&2
    echo "perche' i dati geografici sono tabelle standard e i deploy non li modificano." >&2
    echo "Per abilitarlo qui: touch var/geografia.build.conf" >&2
    exit 1
fi

## esecuzione
php ./_src/_sh/_lib/_geografia.build.php "$@"
GEO_EXIT_CODE=$?

if [ $GEO_EXIT_CODE -ne 0 ]; then
    echo "generazione dei dati geografici fallita (codice $GEO_EXIT_CODE)" >&2
    exit $GEO_EXIT_CODE
fi

## permessi sui file generati
if [ -d ./var/geografia ]; then
    chown -R root:www-data ./var/geografia 2>/dev/null
    find ./var/geografia -type d -exec chmod 750 {} + 2>/dev/null
    find ./var/geografia -type f -exec chmod 640 {} + 2>/dev/null
fi

## codice di uscita
exit 0

## NOTA SULLA PUBBLICAZIONE
#
# lo script si ferma ai file in var/geografia/: il caricamento su web02 resta a mano, di proposito.
# Copiarli in automatico vorrebbe dire mettere qui dentro un host e una chiave di accesso a un'altra
# macchina, e la pubblicazione dei dati standard e' una decisione, non un effetto collaterale di una
# rigenerazione.
#
# La destinazione e' /var/www/dataserver.istricesrl.com/dev/geografia/ su web02, e il READ.md di
# quel deploy spiega il formato e la verifica.
#
