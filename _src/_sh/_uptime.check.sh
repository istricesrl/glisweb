#!/bin/bash

## SCRIPT PER IL CONTROLLO DI UPTIME DEI SITI
#
# fa un giro del controllo di uptime: lo lancia ogni minuto il timer systemd installato da
# _uptime.install.sh, e a mano serve per provare
#
#   _uptime.check.sh                  un giro: controlli, registro, DOWNTIME.md, avvisi
#   _uptime.check.sh --secco          controlla e stampa, senza scrivere e senza avvisare
#   _uptime.check.sh --prova-avviso   manda una mail di prova agli indirizzi avvisa.noi
#
# la configurazione del cluster sta in /etc/glisweb/uptime.yaml; il dettaglio e' nel capitolo
# 125.uptime del manuale sviluppatore
#
# NOTA lo script NON esegue "clear" e non stampa niente quando va tutto bene: gira ogni minuto,
# e quello che scrive finisce nel journal
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## directory di lavoro
cd $RL || exit 1

## giro
php ./_src/_cli/_uptime.check.php "$@"
