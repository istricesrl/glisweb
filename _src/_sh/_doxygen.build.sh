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

## pulizia vecchia documentazione
rm -rf _usr/_docs/_html/*
rm -rf _usr/_docs/_pdf/*

## controllo cartelle
mkdir -p etc/doxygen/
mkdir -p _usr/_docs/_html
mkdir -p _usr/_docs/_pdf

## pacchetti richiesti
apt-get install doxygen
apt-get install texlive-latex-base texlive-latex-extra
apt-get install texlive-lang-italian

## cambio parametri
sed "s|%DIR%|$(pwd)|g" _etc/_doxygen/_doxygen.conf > etc/doxygen/doxygen.conf

## build della documentazione
doxygen etc/doxygen/doxygen.conf

## build del PDF
cd _usr/_docs/_pdf/ && make

# TODO documentare
# questo è un ottimo posto dove documentare come il framework gestisce la documentazione
