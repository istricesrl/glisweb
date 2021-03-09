#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")
cd $RL

## informazioni
echo "lavoro su: $(pwd)"

## prendo il nome del repository
GITNAME=$( basename $(git remote get-url origin) )

## se sto lavorando sul framework
if [ -n "$( echo $GITNAME | grep 'glisweb' )" ]; then

    echo "stai lavorando sul framework ($GITNAME), utilizza git per rimanere aggiornato"
    echo
    echo "NOTA: potresti ricevere questo messaggio anche se sei su un repository custom che"
    echo "però contiene 'glisweb' nel nome; rinomina il tuo repository affinché non contenga"
    echo "la parola riservata 'glisweb' nel nome"

else

    # output
    echo "stai lavorando su $GITNAME, aggiorno il framework"

    # se è specificata una branch di aggiornamento
    if [[ -z $1 ]]; then
        BRANCH=master
    else
        BRANCH=$1
    fi

    # scarico Glisweb
    wget https://github.com/istricesrl/glisweb/archive/$BRANCH.zip

    # pulisco il nome del file zip dai prefissi
    BRANCHZIP=$( echo $BRANCH | sed -e "s/^feature\///" )
    BRANCHZIP=$( echo $BRANCHZIP | sed -e "s/^hotfix\///" )

    # pulisco il nome della cartella dai prefissi
    BRANCHDIR=${BRANCH////-}

    # scompatto Glisweb
    unzip ./$BRANCHZIP.zip

    # elimino il vecchio framework
    rm -rf ./_*

    # installo la nuova versione
    mv -f ./glisweb-$BRANCHDIR/{.,}* ./$1

    # elimino la vecchia cartella
    rm -rf ./glisweb-$BRANCHDIR
    rm -rf ./$BRANCHZIP.zip

    # installo il .gitignore se è presente un repository .git
    if [ -f ./_usr/_deploy/_git/.gitignore -a -d ./.git ]; then
        cp ./_usr/_deploy/_git/.gitignore ./.gitignore
    fi

    # aggiorno composer
    composer update

fi
