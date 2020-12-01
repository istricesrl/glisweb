#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## prendo il nome del repository
GITNAME=$( basename $(git remote get-url origin) )

## se sto lavorando sul framework
if [ -n "$( echo $GITNAME | grep 'glisweb' )" ]; then

    echo "stai lavorando sul framework, utilizza git per rimanere aggiornato"

else

    echo "stai lavorando su $GITNAME, aggiorno il framework"

fi
