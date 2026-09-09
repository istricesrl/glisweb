#!/bin/bash

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## passo alla cartella del deploy
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

    # una sola data per tutta l'esecuzione: prima veniva ricalcolata dentro il ciclo, una volta
    # per il mkdir e una per il cp, e a cavallo del secondo i file finivano in una cartella
    # diversa da quella appena creata
    cartellaDisallineamenti="../disallineamenti.$( date '+%Y%m%d%H%M%S' )/"

    # il manifest lo scrive _gw.upgrade.sh alla fine di ogni aggiornamento: qui si puo' solo
    # leggere, perche' questo script non installa niente e quindi non ha nessuna versione di
    # riferimento da fotografare. Se manca NON si ripiega sul confronto per data: il ripiego ha
    # senso dentro _gw.upgrade.sh, che il manifest lo scrive subito dopo, mentre qui lascerebbe
    # credere di aver guardato bene quando non si e' guardato niente — ed e' esattamente il modo
    # in cui finora le modifiche non promosse sparivano senza che nessuno se ne accorgesse
    disallineamenti-manifest-controlla

    case $? in

        0)
            disallineamenti-raccogli "$( disallineamenti-elenca )" "$cartellaDisallineamenti"
            ;;

        2)
            echo "il manifest $DISALLINEAMENTI_MANIFEST c'è ma non riesco a leggerlo"
            echo "lo scrive root con umask 027: rilancia questo script come root"
            exit 1
            ;;

        *)
            echo "il manifest $DISALLINEAMENTI_MANIFEST non c'è"
            echo "questo deploy non è ancora stato aggiornato da quando il framework ha cominciato"
            echo "a scriverlo: lancia _src/_sh/_gw.upgrade.sh <branch>, oppure aspetta"
            echo "l'aggiornamento notturno. Il manifest viene scritto alla fine dell'aggiornamento,"
            echo "e da lì in poi questo script funziona."
            exit 1
            ;;

    esac

fi
