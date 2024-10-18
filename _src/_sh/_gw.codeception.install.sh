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

## directory per i test
TESTDIR="usr/test/"

# file di configurazione
FILECONF=$TESTDIR"codeception.yml"

## inizializzo codeception
if [ ! -d "$TESTDIR" ]; then

    # creo la cartella
    mkdir -p $TESTDIR

    # blocco l'accesso
    echo "order deny,allow" > $TESTDIR".htaccess"
    echo "deny from all" >> $TESTDIR".htaccess"
    echo "allow from localhost" >> $TESTDIR".htaccess"

    # inizializzo Codeception
    php _src/_lib/_ext/bin/codecept bootstrap $TESTDIR

    # scrittura del file di configurazione
    echo "paths:" > $FILECONF
    echo "    tests: tests" >> $FILECONF
    echo "    output: tests/_output" >> $FILECONF
    echo "    data: tests/_data" >> $FILECONF
    echo "    log: tests/_log" >> $FILECONF
    echo "    support: tests/_support" >> $FILECONF
    echo "    envs: tests/_envs" >> $FILECONF
    echo "actor_suffix: Tester" >> $FILECONF
    echo "extensions:" >> $FILECONF
    echo "    enabled:" >> $FILECONF
    echo "        - Codeception\Extension\RunFailed" >> $FILECONF
    echo "" >> $FILECONF

    # creo i test
    php _src/_lib/_ext/bin/codecept generate:cest acceptance Status -c $FILECONF

fi

# NOTE
# per generare un nuovo test utilizzare:
# php _src/_lib/_ext/bin/codecept generate:cest <tipo> <Nome> -c usr/test/codeception.yml
# il codice all'interno dei test va scritto tenendo presente la documentazione https://codeception.com/

