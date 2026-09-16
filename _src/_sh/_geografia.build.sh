#!/bin/bash

## SCRIPT PER L'ALLINEAMENTO E LA PUBBLICAZIONE DEI DATI GEOGRAFICI STANDARD
#
# questo script allinea la tabella dei comuni all'elenco ufficiale ISTAT e rigenera i quattro CSV
# che i deploy scaricano da dataserver.istricesrl.com
#
#   _geografia.build.sh --istat       allinea la tabella comuni all'elenco ISTAT
#   _geografia.build.sh --export      rigenera i CSV sotto usr/pages/, da dove il dataserver se
#                                     li viene a prendere
#   _geografia.build.sh --all         tutte e due
#   _geografia.build.sh --dry-run     mostra cosa farebbe, non scrive e non esegue niente
#   _geografia.build.sh --forza       applica anche oltre la soglia dell'allineamento automatico
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
    echo "nessuna opzione: uso $(basename "$0") [--istat] [--export] [--all] [--dry-run] [--forza]" >&2
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
php ./_src/_cli/_geografia.build.php "$@"
GEO_EXIT_CODE=$?

if [ $GEO_EXIT_CODE -ne 0 ]; then
    echo "generazione dei dati geografici fallita (codice $GEO_EXIT_CODE)" >&2
    exit $GEO_EXIT_CODE
fi

## permessi sui file generati
#
# i file nascono con l'umask di root, e Apache non li leggerebbe: senza questo blocco la
# pubblicazione risponderebbe 403 invece di servire il CSV
for i in ./usr/pages/geografia ./var/geografia; do
    if [ -d "$i" ]; then
        chown -R root:www-data "$i" 2>/dev/null
        find "$i" -type d -exec chmod 750 {} + 2>/dev/null
        find "$i" -type f -exec chmod 640 {} + 2>/dev/null
    fi
done

## codice di uscita
exit 0

## NOTA SULLA PUBBLICAZIONE, E SULLA SUA DIREZIONE
#
# lo script si ferma a scrivere sotto usr/pages/, che il .htaccess serve ad accesso diretto: da li'
# i file sono raggiungibili via HTTP, ed e' IL DATASERVER a venirseli a prendere con un suo cron.
#
# La direzione conta. Se fosse il framework a spingere sul dataserver dovrebbe portarsi dentro
# l'indirizzo e una chiave di accesso di un'altra macchina, e pubblicare diventerebbe l'effetto
# collaterale di una rigenerazione invece che una decisione di chi pubblica. Cosi' invece qui non
# c'e' nessuna credenziale: questa macchina produce e mette a disposizione, il dataserver decide
# quando prendere, controlla quello che ha preso e pubblica.
#
# Il READ.md del dataserver spiega il formato dei file e la verifica che dice se sono buoni.
#
