#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## rimozione tag
if [ -n "$1" ]; then

    git tag -d "$1"

    if [ -n "$2" ]; then

        git push --delete "$2" "$1"

    fi

else

    echo "$0 <tag> [remote]"

fi
