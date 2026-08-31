#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## directory per i test
TESTDIR="usr/test/"

# file di configurazione
FILECONF=$TESTDIR"codeception.yml"

## eseguo i test
if [ "$1" == "quiet" ]; then

    # modalità silenziosa
    php _src/_lib/_ext/codeception/codeception/codecept run --ansi --quiet -c $FILECONF &> /dev/null

    # output
    echo -n $?

else

    ## informazioni
    echo "lavoro su: $(pwd)"

    # modalità verbosa
    php _src/_lib/_ext/codeception/codeception/codecept run --steps -c $FILECONF

fi

# NOTE
# per generare un nuovo test utilizzare:
# php _src/_lib/_ext/bin/codecept generate:cest <tipo> <Nome> -c usr/test/codeception.yml
# il codice all'interno dei test va scritto tenendo presente la documentazione https://codeception.com/

