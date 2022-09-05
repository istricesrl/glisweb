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

## converto i jpg in webp
find ./var -iname "*.jpg" | while read i; do
    if [[ ! -f "${i%.jpg}.webp" || "$i" -nt "${i%.jpg}.webp" ]]; then
	    cwebp -q 85 "$i" -o "${i%.jpg}.webp"
    else
	    echo "skipped $i"
    fi
done

## converto i png in webp
find ./var -iname "*.png" | while read i; do
    if [[ ! -f "${i%.png}.webp" || "$i" -nt "${i%.png}.webp" ]]; then
	    cwebp -q 85 "$i" -o "${i%.png}.webp"
    else
	    echo "skipped $i"
    fi
done

## fine elaborazione
exit
