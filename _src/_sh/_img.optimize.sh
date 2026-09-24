#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## pacchetti
apt-get install jpegoptim pngcrush optipng

## scalo le bandiere
#for i in $(ls "_src/_img/_flags/"); do
#    mogrify -resize 40x30 "_src/_img/_flags/$i" &>/dev/null
#done

## ottimizzo le immagini jpg
find . -iname "*.jpg" -o -iname "*.jpeg" | while read i; do
    jpegoptim --totals --all-progressive --strip-all -m80 "$i"
done

## ottimizzo le immagini png
find . -iname "*.png" | while read i; do
    pngcrush -reduce -brute -q "$i" "${i%.png}.opt.png"
    mv "${i%.png}.opt.png" "$i"
    optipng -o7 -preserve "$i"
done

## fine elaborazione
exit
