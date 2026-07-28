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

else

    echo "calcolo i disallineamenti rispetto alla versione installata del framework"

    # NOTA: ./_* copre solo le cartelle con underscore; l'aggiornamento sovrascrive anche
    # i dotfile e i file di root del framework, che vanno quindi controllati esplicitamente.
    # Esclusi .gitignore e .githooks: sui deploy client sono legittimamente diversi dal
    # framework (il .gitignore arriva da _usr/_deploy/_git/).
    for f in $( find ./_* ./.claude ./.github ./.htaccess ./composer.json -newer ./var/latest.upgrade.conf 2>/dev/null ); do
        if [ -f $f ]; then
            echo "$f è disallineato"
            mkdir -p ../disallineamenti.$( date '+%Y%m%d%H%M%S' )/
            cp --parents $f ../disallineamenti.$( date '+%Y%m%d%H%M%S' )/
        fi
    done

fi
