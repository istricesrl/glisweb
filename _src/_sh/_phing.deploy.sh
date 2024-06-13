#!/bin/bash

## SCRIPT DI DEPLOY
#
# Questo script utilizza Phing (http://www.phing.info/) per effettuare il deploy del progetto corrente sulla destinazione
# desiderata. Per configurare le destinazioni (è possibile crearne un numero arbitrario) è sufficiente creare un file per ognuna
# di esse nella cartella ./usr/deploy/phing/ con estensione .properties. Il nome del file senza estensione sarà il nome con
# cui questo script identificherà ogni specifica destinazione.
#
# Per creare il file di configurazione della destinazione si può partire dal file di esempio _usr/_examples/_phing/build.properties
# e modificarlo in base alle proprie necessità seguendo le indicazioni dei commenti.
#

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
sed -i '$a\' ../TODO.md

## registro dei deploy
echo "$( date "+%Y-%m-%d %H:%M" ) DEPLOY TRAMITE PHING" >> ../TODO.md
echo "=====================================" >> ../TODO.md
echo "Questa è una registrazione automatica di deploy ($1) effettuata dallo script $0" >> ../TODO.md
echo >> ../TODO.md

## avvio deploy
if [ -n "$1" ]; then
    phing -f ./_usr/_deploy/_phing/_build.xml -propertyfile ./usr/deploy/phing/$1.properties
else
    echo "$0 stage"
fi
