#!/bin/bash

## questo file setta i permessi della document root in modalità aperta (installazione)
#
# NOTA dopo aver terminato l'installazione, eseguire _lamp.permission.secure.sh
#
# TODO documentare
# questo script è un buon posto dove mettere la documentazione su come GlisWeb gestisce i permessi
#

## pulizia schermo
clear

## livelli per la root del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella di installazione!
RL="../../"
RP="../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## verifica utente root
check-root

## passo alla cartella del deploy
cd $RL

## ricaavo il nome del deploy
SUB=$( basename $( pwd ) )

## passo alla cartella principale
cd $RP

## informazioni
echo "lavoro su: $(pwd)"

## cambio permessi (silenzioso)
#
# Le note sulle ottimizzazioni in _lamp.permissions.secure.sh valgono identiche qui: `-exec ... +`
# invece di `\;` per non forkare un chmod per file, e prune di `.git` e `var/log`. Vedi lì per il
# dettaglio del pattern di prune e del perché la vecchia clausola `-not \( -path ".git" -prune \)`
# non pruneva nulla.
#
# Inoltre i find girano su ./$SUB/ e NON su `.` (che è la cartella SUPERIORE all'installazione):
# la versione storica rastrellava l'intera cartella dei siti, quindi anche i deploy vicini e gli
# archivi di backup che vivono accanto alla document root — lavoro inutile e potenzialmente
# distruttivo, dato che poi secure.sh rimette a posto soltanto ./$SUB/.
#
# NOTA questo script apre i permessi della document root: finché non gira secure.sh il framework
# rileva la cartella di installazione come scrivibile e si rifiuta di servire le richieste
# ("la cartella di installazione è scrivibile, lanciare _lamp.permissions.secure.sh"), rispondendo
# in text/html senza gli header applicativi. Il sito è quindi OFFLINE per tutta la finestra tra
# open.sh e secure.sh: tenerla il più breve possibile non è un'ottimizzazione, è un requisito.

find ./$SUB/            \( -path "./$SUB/.git" -o -path "./$SUB/var/log" \) -prune  -o -type d      -exec chmod 775 {} +
find ./$SUB/            \( -path "./$SUB/.git" -o -path "./$SUB/var/log" \) -prune  -o -type f      -exec chmod 664 {} +
find ./$SUB/            \( -path "./$SUB/.git" -o -path "./$SUB/var/log" \) -prune  -o -name '*.sh' -exec chmod 775 {} +

## cambio proprietario
chown -R www-data:www-data ./$SUB/
