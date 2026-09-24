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

## pacchetti
apt-get install webp

## cartelle
for f in var src; do

    ## converto i jpg in webp
    find ./$f -iname "*.jpg" | while read i; do
        if [[ ! -f "${i%.*}.webp" || "$i" -nt "${i%.*}.webp" ]]; then
            cwebp -q 85 "$i" -o "${i%.*}.webp"
        else
            echo "skipped $i"
        fi
    done

    ## converto i png in webp
    find ./$f -iname "*.png" | while read i; do
        if [[ ! -f "${i%.*}.webp" || "$i" -nt "${i%.*}.webp" ]]; then
            cwebp -q 85 "$i" -o "${i%.*}.webp"
        else
            echo "skipped $i"
        fi
    done

done

## fine elaborazione
exit
