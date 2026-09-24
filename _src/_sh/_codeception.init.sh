#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## bootstrap di codeception
_src/_lib/_ext/codeception/codeception/codecept bootstrap _usr/_test/

## creazione acceptance test
_src/_lib/_ext/codeception/codeception/codecept generate:cest acceptance core -c _usr/_test/codeception.yml
_src/_lib/_ext/codeception/codeception/codecept generate:cest acceptance apcuTools -c _usr/_test/codeception.yml
_src/_lib/_ext/codeception/codeception/codecept generate:cest acceptance filesystemTools -c _usr/_test/codeception.yml

## _usr/_test/acceptance.suite.yml
# actor: AcceptanceTester
# modules:
#     enabled:
#         - PhpBrowser:
#             url: https://glisdev.istricesrl.com
#         - \Helper\Acceptance
# step_decorators: ~

# TODO documentare
# questo script è un buon posto dove mettere la documentazione su come GlisWeb utilizza Codeception
