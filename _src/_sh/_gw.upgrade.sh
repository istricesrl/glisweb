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
    for r in $( git remote ); do
        GITNAME="$GITNAME "$( basename $(git remote get-url $r) )
    done
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

        cartellaDisallineamenti="../disallineamenti.$( date '+%Y%m%d%H%M%S' )/"

        echo "inizio il backup"

        EXCLUDE=".git .github _src/_lib/_ext _usr/_docs/_html _usr/_docs/_pdf tmp var"
        for i in $EXCLUDE; do
            EXC="$EXC --exclude=./$i"
        done

        # faccio il backup della cartella corrente
        # rm -rf ../backup.tar.gz
        tar $EXC -czf ../backup.$( date '+%Y%m%d%H%M%S' ).tar.gz .

        # salvo i disallineamenti rispetto alla versione correntemente installata
        for f in $( find ./_* -newer ./var/latest.upgrade.conf ); do
            if [ -f $f ]; then
                echo "$f è disallineato"
                mkdir -p $cartellaDisallineamenti
                cp --parents $f $cartellaDisallineamenti
            fi
        done

        echo "backup completato"

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
        ./_src/_sh/_lamp.permissions.secure.sh

        ## salvo la data di aggiornamento
        echo $(date '+%Y-%m-%d %H:%M:%S' ) > ./var/latest.upgrade.conf

        ## pulizia
        clear

        ## conferma
        # TODO verificare davvero che sia andato tutto bene
        echo "aggiornamento del framework effettuato con successo"

        # se esistono disallineamenti da controllare
        if [ -d "$cartellaDisallineamenti" ]; then

            # elimino i disallineamenti già risolti
            for disallineamento in $( find $cartellaDisallineamenti -type f ); do

                # debug
                echo "faccio il diff di $disallineamento"
                echo "file originale: $( echo $disallineamento | sed -e "s@$cartellaDisallineamenti@@" )"

                # faccio il diff del file disallineato rispetto al file standard
                diff -u $( echo $disallineamento | sed -e "s@$cartellaDisallineamenti@@" ) $disallineamento > $disallineamento.diff

            done

        fi

    else

        # sinossi
        echo "utilizzo: $0 <branch>"

    fi

fi
