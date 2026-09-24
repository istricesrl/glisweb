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

## se ho la password
if [ -n "$1" ]; then

## se la cartella non esiste
if [ ! -d ./etc/secret/$1/ ]; then

    ## creo la cartella
    mkdir -p ./etc/secret/$1/

    ## genero la chiave privata
    # openssl genrsa -aes256 -passout pass:$1 -out ./etc/secret/dkim.private 2048
    openssl genrsa -out ./etc/secret/$1/dkim.private.pem 2048

    ## esporto la chiave pubblica
    openssl rsa -in ./etc/secret/$1/dkim.private.pem -pubout -outform der 2>/dev/null | openssl base64 -A > ./etc/secret/$1/dkim.public.pem

else

    echo "il certificato per $1 esiste già"

fi

## output
clear

## informazioni
echo "valore del record TXT glisweb._domainkey.$1. -> v=DKIM1;p=$(cat ./etc/secret/$1/dkim.public.pem)"

else

echo "$0 dominio [password]"

fi
