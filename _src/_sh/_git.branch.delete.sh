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

## pulizia repository
if [ -n "$1" ]; then
    git branch -d "$1"
    git push origin --delete "$1"
else
    echo "$0 <branchName>"
fi
