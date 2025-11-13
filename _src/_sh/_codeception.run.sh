#!/bin/bash

## SCRIPT PER L'ESECUZIONE DEI TEST DI ACCETTAZIONE
#
# questo script esegue i test di accettazione del framework
#
# per eseguire i test è sufficiente lanciare questo file
# 

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1
cd $RL || exit 1

## permessi temporanei
chmod ug+x _src/_lib/_ext/codeception/codeception/codecept 

## creazione acceptance test
_src/_lib/_ext/codeception/codeception/codecept run acceptance -c _usr/_test/codeception.yml --no-colors --steps
CODECEPTION_EXIT_CODE=$?

## permessi temporanei
chmod ug-x _src/_lib/_ext/codeception/codeception/codecept 

# TODO documentare
# qui spiegare come vengono eseguiti i test

## codice di uscita
exit $CODECEPTION_EXIT_CODE

## NOTA
#
# per eseguire i test è sufficiente lanciare questo file
# per approfondire vedi _usr/_docs/_dox/_test.dox
#
# per approfondire vedi anche https://codeception.com/docs/AcceptanceTests
#
