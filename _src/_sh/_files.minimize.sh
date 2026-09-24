#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## pacchetti
apt-get install yui-compressor

## ottimizzo i CSS
find . -iname "*.css" -a -not -name "*.min.*" -a -not -wholename "*/_ext/*" -a -not -wholename "*/_docs/*" | while read i; do
    yui-compressor -o "${i%.css}.min.css" "$i"
done

## ottimizzo i Javascript
find . -iname "*.js" -a -not -name "*.min.*" -a -not -wholename "*/_ext/*" -a -not -wholename "*/_docs/*" | while read i; do
    yui-compressor -o "${i%.js}.min.js" "$i"
done

## fine elaborazione
exit
