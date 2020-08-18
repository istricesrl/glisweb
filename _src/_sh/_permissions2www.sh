#!/bin/bash

## livelli per la root del sito
RL="../../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## cambio permessi
chmod -R 775 *

## cambio proprietario
chown -R www-data:www-data *
