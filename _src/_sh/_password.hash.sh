#!/bin/bash

# genera l'hash di una password per i file di configurazione ( auth.accounts.<utente>.password )
#
# uso: _password.hash.sh [password]
#
# Senza argomenti genera una password casuale con pwgen. L'hash si calcola con password_hash() di PHP,
# lo stesso algoritmo che il framework usa per le password salvate nel database ( vedi passwordHash() in
# _src/_lib/_cryptography.tools.php ); fino al 24/09/2026 questo script produceva un hash MD5, che il
# framework continua ad accettare ma che la pagina di status segnala come da rigenerare.
#
# L'hash contiene il carattere $: nei file YAML va scritto fra virgolette, nella shell fra apici.
#

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## rimozione tag
if [ -n "$1" ]; then
    PASS="$1"
else
    PASS="$(pwgen -nyc 16 1)"
fi

## calcolo hash
HASH="$(php -r 'echo password_hash( $argv[1], PASSWORD_DEFAULT );' -- "$PASS")"

## output
echo "password: $PASS"
echo "hash: $HASH"
