#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella
# di installazione!
RL="../../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## cambio permessi (verboso)
# find . -type d		-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 775 {} \;
# find . -type f		-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 664 {} \;
# find . -name '*.sh'	-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 775 {} \;

## cambio permessi (silenzioso)
find . -type d		-not \( -path ".git" -prune \) -exec chmod 775 {} \;
find . -type f		-not \( -path ".git" -prune \) -exec chmod 664 {} \;
find . -name '*.sh'	-not \( -path ".git" -prune \) -exec chmod 775 {} \;

## cambio proprietario
sudo chown -R www-data:www-data *

## TODO
# fare una modalità "paranoia" in cui:
# - il server web può solo leggere a parte quelle due o tre cartelle dove deve scrivere
# - le cartelle .git .github e il file .gitignore sono di proprietà di root
# - valutare altre restrizioni
#