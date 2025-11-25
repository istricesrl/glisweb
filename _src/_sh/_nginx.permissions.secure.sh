#!/bin/bash

# TODO documentare
# questo script è un buon posto dove mettere la documentazione su come GlisWeb gestisce i permessi
#

## pulizia schermo
clear

## livelli per la $NGINXUSER del sito
# NOTA questo script deve girare nella cartella SUPERIORE a quella di installazione!
RL="../../"
RP="../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## passo alla cartella del deploy
cd $RL

## ricaavo il nome del deploy
SUB=$( basename $( pwd ) )

## passo alla cartella principale
cd $RP

## informazioni
echo "lavoro su: $(pwd)"

## utente nginx
if [ -f "nginxuser.conf" ]; then
    NGINXUSER=$( cat nginxuser.conf | tr -d '[:space:]' )
    echo "utente NGINX rilevato: $NGINXUSER"

    ## utente FTP
    if [ -f "ftpuser.conf" ]; then
        FTPUSER=$( cat ftpuser.conf | tr -d '[:space:]' )
        echo "utente FTP rilevato: $FTPUSER"
    else
        FTPUSER="$NGINXUSER"
    fi

    ## cambio proprietario
    chown -R $NGINXUSER:$NGINXUSER ./$SUB/

    chown -R $FTPUSER:$NGINXUSER ./$SUB/src/templates
    chown -R $FTPUSER:$NGINXUSER ./$SUB/src/tpl
    chown -R $NGINXUSER:$NGINXUSER ./$SUB/tmp
    chown -R $FTPUSER:$NGINXUSER ./$SUB/var
    chown -R $NGINXUSER:$NGINXUSER ./$SUB/var/cache

    ## cartella .git
    if [ -d ".git" ]; then
        chown -R $NGINXUSER:$NGINXUSER ./$SUB/.git
    fi

    ## cartella .github
    if [ -d ".github" ]; then
        chown -R $NGINXUSER:$NGINXUSER ./$SUB/.github
    fi

    ## informazioni
    echo "impostati proprietari e gruppi, modifico i permessi"

    ## cambio permessi (silenzioso)
    find ./$SUB/                    -type d         -not \( -path ".git" -prune \)      -exec chmod 550 {} \;
    find ./$SUB/                    -type f         -not \( -path ".git" -prune \)      -exec chmod 640 {} \;
    find ./$SUB/                    -name '*.sh'    -not \( -path ".git" -prune \)      -exec chmod 550 {} \;

    # permessi aggiuntivi per le cartelle
    find ./$SUB/.git/hooks          -type f                                             -exec chmod ug+x {} \;
    find ./$SUB/src/tpl             -type d                                             -exec chmod 770 {} \;
    find ./$SUB/tmp                 -type d                                             -exec chmod 770 {} \;
    find ./$SUB/var                 -type d                                             -exec chmod 770 {} \;

    find ./$SUB/src/tpl             -type f                                             -exec chmod 660 {} \;
    find ./$SUB/mod/*/src/tpl       -type f                                             -exec chmod 660 {} \;
    find ./$SUB/tmp                 -type f                                             -exec chmod 660 {} \;
    find ./$SUB/var                 -type f                                             -exec chmod 660 {} \;

    # informazioni
    echo "permessi modificati"

else

    echo "file nginxuser.conf mancante, utilizzare 'echo <user> > nginxuser.conf' nella cartella superiore alla document root"

fi
