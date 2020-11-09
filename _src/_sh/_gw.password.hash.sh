#!/bin/bash

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
HASH="$(echo -n "$PASS" | md5sum  | awk '{print $1}')"

## output
echo "password: $PASS"
echo "hash: $HASH"
