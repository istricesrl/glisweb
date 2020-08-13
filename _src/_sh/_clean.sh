#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## elimino i log
if [ -d ./var/log ]; then
    if [ "$1" == "hard" ]; then
	rm -rf ./var/log/*
    else
	rm -f ./var/log/*.log
    fi
fi

## elimino le cache
if [ -d ./var/cache ]; then
    rm -rf ./var/cache/*
fi

## elimino i file temporanei
if [ -d ./tmp ]; then
    rm -rf ./tmp/*
fi
