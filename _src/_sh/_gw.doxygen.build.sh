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

## pacchetti richiesti
apt-get install doxygen
apt-get install texlive-latex-base texlive-latex-extra
apt-get install texlive-lang-italian

## cartella configurazione custom
mkdir -p usr/docs/etc/

## cambio parametri
sed "s|%DIR%|$(pwd)|g" _usr/_docs/_etc/_doxygen.conf > usr/docs/etc/doxygen.conf

## build della documentazione
doxygen usr/docs/etc/doxygen.conf

## build del PDF
cd _usr/_docs/_build/latex/ && make
