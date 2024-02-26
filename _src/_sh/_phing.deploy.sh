#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## pacchetti
apt-get install -y phing rsync

## informazioni
echo "lavoro su: $(pwd)"

## avvio deploy
if [ -n "$1" ]; then
    phing -f ./_usr/_deploy/_phing/_build.xml -propertyfile ./usr/deploy/phing/$1.properties
else
    echo "$0 stage"
fi
