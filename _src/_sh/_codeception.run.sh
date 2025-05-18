#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## permessi temporanei
chmod ug+x _src/_lib/_ext/codeception/codeception/codecept 

## creazione acceptance test
_src/_lib/_ext/codeception/codeception/codecept run acceptance -c _usr/_test/codeception.yml

## permessi temporanei
chmod ug-x _src/_lib/_ext/codeception/codeception/codecept 

# TODO documentare
# qui spiegare come vengono eseguiti i test

# NOTA
# per eseguire i test è sufficiente lanciare questo file
# per approfondire vedi _usr/_docs/_test.dox
#
# per approfondire vedi anche https://codeception.com/docs/AcceptanceTests
#
