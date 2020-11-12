#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## pulizia repository
git rm -r --cached .
git add .
git commit -m ".gitignore fix $(date '+%Y-%m-%d %H:%M')"
