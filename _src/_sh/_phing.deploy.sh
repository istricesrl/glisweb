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

## aggiungo una newline al file se non c'è già
sed -i '$a\' ../WORK.md

## registro dei deploy
echo "$( date "+%Y-%m-%d %H:%M" ) DEPLOY TRAMITE PHING" >> ../WORK.md
echo "=====================================" >> ../WORK.md
echo "Questa è una registrazione automatica di deploy ($1) effettuata dallo script $0" >> ../WORK.md
echo >> ../WORK.md

## avvio deploy
if [ -n "$1" ]; then
    phing -f ./_usr/_deploy/_phing/_build.xml -propertyfile ./usr/deploy/phing/$1.properties
else
    echo "$0 stage"
fi
