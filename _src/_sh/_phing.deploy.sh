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
sed -i.bak '$a\' ../TODO.md

## registro dei deploy
echo >> ../TODO.md
echo "$( date "+%Y-%m-%d %H:%M" ) DEPLOY TRAMITE PHING" >> ../TODO.md
echo "=====================================" >> ../TODO.md
echo "Questa è una registrazione automatica di deploy ($1) effettuata dallo script $0" >> ../TODO.md
echo >> ../TODO.md

## debug
exit 0

## avvio deploy
if [ -n "$1" ]; then
    phing -f ./_usr/_deploy/_phing/_build.xml -propertyfile ./usr/deploy/phing/$1.properties
else
    echo "$0 stage"
fi
