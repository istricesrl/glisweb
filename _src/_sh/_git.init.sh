#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## se non esiste già una directory .git
if [ ! -d "./.git" ]; then

    ## output
    echo "procedo con l'inizializzazione"

    ## inizializzazione
    git init

    ## copio il file .gitignore
    cp _usr/_config/_git/.gitignore.dev .gitignore

    ## aggiungo i file
    git add .

    ## effettuo il commit iniziale
    git commit -a -m "commit iniziale"

    ## creo la branch di develop
    git branch develop

    ## richiesta remoto
    if [ -z "$1" ]; then
        echo "inserisci il comando per connettere il repository remoto (puoi fare copiaincolla da source.cloud.google.com), ad esempio:"
        echo "ssh://<USER>@<DOMAIN>:2022/p/<NOME-PROGETTO>/r/<NOME-REPOSITORY>"
        echo -n "inserisci: "
        read REMOTE
    else
        REMOTE=$1
    fi

    # aggiungo il remoto
    git remote add google $REMOTE

    ## push su remoto
    git push --all google

else

    ## output
    echo "repository git già presente"

fi

## report
echo "repository remoti collegati:"
git remote -v

echo

echo "branch attive: "
git branch -v

echo

git status
