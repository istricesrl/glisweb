#!/bin/bash

## SCRIPT PER L'INSTALLAZIONE DEGLI HOOK DI SVILUPPO DELLO STANDARD
#
# gli hook in .githooks/ sono versionati, ma core.hooksPath e' configurazione
# locale del clone e non viaggia col repository: va impostata una volta per
# ogni copia di lavoro, ed e' quello che fa questo script
#
# gli hook servono a chi sviluppa il framework (glisdev e glisweb), non ai
# progetti che lo usano: nei progetti cliente non va lanciato
#
# uso: bash .githooks/install.sh [--check]
#

## directory corrente
cd $( dirname "$0" )/.. || exit 1

## verifica che si sia dentro un repository
if [ ! -d .git ]; then
    echo "[ERRORE] $( pwd ) non e' la radice di un repository git"
    exit 1
fi

## sola verifica
if [ "$1" == "--check" ]; then
    echo "core.hooksPath: $( git config --get core.hooksPath || echo '(non impostato)' )"
    ls -l .githooks/
    exit 0
fi

## configurazione del percorso degli hook
git config core.hooksPath .githooks
echo "core.hooksPath impostato a .githooks"

## bit di esecuzione sulla copia di lavoro
# git salta in silenzio gli hook non eseguibili; il bit sta anche nell'index
# (100755) ma _lamp.permissions.secure.sh lo rimetterebbe a 640 sul filesystem
chmod ug+x .githooks/pre-commit .githooks/commit-msg .githooks/post-commit
echo "bit di esecuzione ripristinato sugli hook"

## verifica finale
ls -l .githooks/

exit 0

## NOTA
#
# per disinstallare: git config --unset core.hooksPath
#
