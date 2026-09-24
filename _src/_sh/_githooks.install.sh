#!/bin/bash

## questo script attiva sulla copia di lavoro corrente i git hook versionati in /.githooks/
#
# gli hook servono a chi sviluppa il framework (glisdev e glisweb), non ai progetti che lo
# usano: nei progetti cliente questo script non va lanciato
#
# ci sono due ragioni per cui gli hook versionati non partono da soli, e questo script le
# copre tutte e due: core.hooksPath è configurazione locale del clone e non viaggia col
# repository, quindi va impostata una volta per ogni copia di lavoro; e git salta in silenzio
# gli hook privi del bit di esecuzione, che _lamp.permissions.secure.sh riporta a 640 insieme
# al resto dell'albero
#
# NOTA per vedere lo stato senza modificare niente, lanciare questo script con --check
#

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## verifica utente root
check-root

## directory di lavoro
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## verifica del repository
if [ ! -d ".git" ]; then
    echo "$(pwd) non è la radice di un repository git"
    exit 1
fi

## azione
case "$1" in

    "--check")
        echo "core.hooksPath: $( git config --get core.hooksPath || echo "non impostato" )"
    ;;

    *)
        git config core.hooksPath .githooks
        echo "core.hooksPath impostato a .githooks"
        chmod ug+x .githooks/pre-commit .githooks/commit-msg .githooks/post-commit
        echo "bit di esecuzione ripristinato sugli hook"
    ;;

esac

## stato degli hook
ls -l .githooks/

## NOTA
#
# per disattivare gli hook su questa copia di lavoro: git config --unset core.hooksPath
#
