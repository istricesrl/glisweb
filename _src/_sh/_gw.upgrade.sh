#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## pulizia schermo
clear

## prendo il nome del repository
if [[ -d "./.git" ]]; then
    GITNAME=$( basename $(git remote get-url origin) )
fi

## se sto lavorando sul framework
if [ -n "$( echo $GITNAME | grep 'glisweb' )" ]; then

    echo "stai lavorando sul framework ($GITNAME), utilizza git per rimanere aggiornato"
    echo
    echo "NOTA: potresti ricevere questo messaggio anche se sei su un repository custom che"
    echo "però contiene 'glisweb' nel nome; rinomina il tuo repository affinché non contenga"
    echo "la parola riservata 'glisweb' nel nome"

else

    # output
    if [[ -n "$GITNAME" ]]; then
        echo "stai lavorando su $GITNAME, aggiorno il framework"
    fi

    # se è specificata una branch di aggiornamento
    if [[ -n "$1" ]]; then

        # faccio il backup della cartella corrente
        rm -rf ../backup.tar.gz
        tar -cvzf ../backup.tar.gz --exclude='var/log/*' --exclude='var/cache/*' .

        # branch da scaricare
        BRANCH=$1

        # scarico Glisweb
        wget https://github.com/istricesrl/glisweb/archive/$BRANCH.zip

        # pulisco il nome del file zip dai prefissi
        BRANCHZIP=$( echo $BRANCH | sed -e "s/^feature\///" )
        BRANCHZIP=$( echo $BRANCHZIP | sed -e "s/^hotfix\///" )

        # pulisco il nome della cartella dai prefissi
        BRANCHDIR=${BRANCH////-}

        # scompatto Glisweb
        unzip -qq ./$BRANCHZIP.zip

        # elimino il vecchio framework
        rm -rf ./_*

        # installo la nuova versione
        cp -rf ./glisweb-$BRANCHDIR/{.[!.],}* ./

        # elimino la vecchia cartella
        rm -rf ./glisweb-$BRANCHDIR
        rm -rf ./$BRANCHZIP.zip

        # installo il .gitignore se è presente un repository .git
        if [ -f ./_usr/_deploy/_git/.gitignore -a -d ./.git ]; then
            cp -f ./_usr/_deploy/_git/.gitignore ./.gitignore
        fi

        # aggiorno composer
        composer update -n

        ## permessi
        ./_src/_sh/_lamp.permissions.reset.sh

        ## pulizia
        clear

        ## conferma
        # TODO verificare davvero che sia andato tutto bene
        echo "aggiornamento del framework effettuato con successo"

    else

        # sinossi
        echo "utilizzo: $0 <branch>"

    fi

fi
