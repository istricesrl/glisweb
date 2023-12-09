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

## utente FTP
if [ -f "ftpuser.conf" ]; then
    FTPUSER=$( cat ftpuser.conf | tr -d '[:space:]' )
    echo "utente FTP rilevato: $FTPUSER"
else
    FTPUSER="www-data"
fi

## cambio permessi (verboso)
# find . -type d		-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 775 {} \;
# find . -type f		-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 664 {} \;
# find . -name '*.sh'	-not \( -path ".git" -prune \)		-exec echo {} \; -exec chmod 775 {} \;

## cambio permessi (silenzioso)
find . -type d		-not \( -path ".git" -prune \) -exec chmod 755 {} \;
find . -type f		-not \( -path ".git" -prune \) -exec chmod 664 {} \;
find . -name '*.sh'	-not \( -path ".git" -prune \) -exec chmod 775 {} \;

## cambio proprietario
sudo chown -R root:www-data *
find . -name 'templates'    -exec chown -R $FTPUSER:www-data {} \;
find . -name 'tmp'          -exec chown -R www-data:www-data {} \;
find . -name 'var'          -exec chown -R $FTPUSER:www-data {} \;

# permessi aggiuntivi
find . -name 'templates'	-exec chmod -R 775 {} \;
find . -name 'var'	        -exec chmod -R 775 {} \;

## cartella .git
if [ -d ".git" ]; then
    sudo chown -R root:root .git
fi

## cartella .github
if [ -d ".github" ]; then
    sudo chown -R root:root .github
fi

## TODO
# fare una modalità "paranoia" in cui:
# - il server web può solo leggere a parte quelle due o tre cartelle dove deve scrivere
# - le cartelle .git .github e il file .gitignore sono di proprietà di root
# - valutare altre restrizioni
#