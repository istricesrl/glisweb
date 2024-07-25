#!/bin/bash

## pulizia schermo
clear

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0")

## funzioni
. ./_lib/_functions.sh

## verifica utente root
check-root

## argomenti
check-args $@

# TODO implementare --hard per fare il deploy senza backup remoto nei casi lftp scp e gcloud, senza --hard non fare nulla

## se lo script è stato chiamato senza argomenti
if [ -n "$PNOARGS" ]; then

    echo "utilizzo: $0 target [opzioni]"
    echo "opzioni:"
    echo "  --version   il tipo di incremento di versione (major, minor, patch)"
    echo "esempi:"
    echo "  $0 test"
    echo "  $0 test --increment patch"
    echo "  $0 prod --increment minor"
    exit 1

else

    ## passo alla cartella del deploy
    cd $RL

    ## leggo dal file properties
    . ./etc/deploy/$1.properties

    ## informazioni
    echo "lavoro su: $(pwd)"
    echo "progetto: ${PRJ_NAME}"
    echo "deploy su: $1"

    ## cartella sorgente
    if [ -n "$SRC_FOLDER" -a -n "$SRC_STAGE" ]; then

        # percorso sorgente
        SRC_PATH="$SRC_FOLDER/$SRC_STAGE"

        # informazioni
        echo "cartella sorgente: $SRC_PATH"

        # se la cartella sorgente non esiste
        if [ ! -d "$SRC_PATH" ]; then

            # informazioni
            echo "cartella sorgente non esistente, impossibile effettuare il deploy"

            # uscita
            exit 1

        fi

    else

        # informazioni
        echo "informazioni sulla sorgente mancanti, impossibile effettuare il deploy"

        # uscita
        exit 1

    fi

    ## cartella destinazione
    if [ -n "$DST_FOLDER" -a -n "$DST_STAGE" ]; then

        # percorso destinazione
        DST_PATH="$DST_FOLDER/$DST_STAGE"

        # informazioni
        echo "cartella destinazione: $DST_PATH"

    else

        # informazioni
        echo "informazioni sulla destinazione mancanti, impossibile effettuare il deploy"

        # uscita
        exit 1

    fi

    ## registro il deploy
    if [ -f "../TODO.md" ]; then

        ## aggiungo una newline al file se non c'è già
        sed -i '$a\' ../TODO.md

        ## registro dei deploy
        echo "$( date "+%Y-%m-%d %H:%M" ) DEPLOY TRAMITE SCRIPT" >> ../TODO.md
        echo "======================================" >> ../TODO.md
        echo "Questa è una registrazione automatica di deploy ($1) effettuata dallo script $0" >> ../TODO.md
        echo >> ../TODO.md

    fi

    ## leggo la versione corrente
    if [ -f ./etc/version.conf ]; then

        # leggo la versione
        VERSION=$(cat ./etc/version.conf | tr -d '\n')

    else

        VERSION="0.0.0"

    fi

    # informazioni
    echo "versione corrente: $VERSION"

    ## incremento versione
    case "$PVALINCREMENT" in

        "major")
            PVALINCREMENTNUM=0
            ;;
        "minor")
            PVALINCREMENTNUM=1
            ;;
        "patch")
            PVALINCREMENTNUM=2
            ;;

    esac

    # incremento
    if [ -n "$PVALINCREMENTNUM" ]; then

        # incremento
        VERSION=$(increment-version $VERSION $PVALINCREMENTNUM)

        # informazioni
        echo "nuova versione: $VERSION"

        # imposto la versione
        echo $VERSION > ./etc/version.conf

    else

        # informazioni
        echo "deploy senza incremento di versione"

    fi

    ## checkout sulla branch di cui fare il deploy
    if [ -n "$GIT_BRANCH" ]; then

        # informazioni
        echo "checkout su: $GIT_BRANCH"

        # checkout
        cd $SRC_PATH
        git checkout $GIT_BRANCH

        # commit
        git add .
        git commit -m "distribuzione della versione $VERSION"
        git tag -a "v$VERSION" -m "versione $VERSION"
        git push --follow-tags

    fi

    ## host di destinazione
    if [ -n "$DST_HOST" ]; then

        # informazioni
        echo "deploy remoto su: $DST_HOST"

    else

        # comando di copia
        DST_CMD="rsync"

        # informazioni
        echo "deploy locale"

    fi

    ## deploy
    case "$DST_CMD" in

        "lftp")

            # se sono settati i parametri per l'accesso
            if [ -n "$FTP_USER" -a -n "$FTP_PASSWORD" ]; then

                ## file e cartelle da escludere dal deploy
                for i in $SET_EXCLUDE; do
                    EXCLUDE="$EXCLUDE --exclude $i"
                done

                # informazioni
                echo "accesso FTP: $FTP_USER"
                echo "ATTENZIONE! questo tipo di deploy non supporta il backup remoto prima del deploy"

                # comando
                CMD="lftp -e \"mirror $EXCLUDE -R $SRC_PATH $DST_PATH; quit\" -u $FTP_USER,$FTP_PASSWORD $DST_HOST"

                # informazioni
                echo "comando: $CMD"

                # deploy
                # $CMD

            else

                # informazioni
                echo "parametri di accesso FTP mancanti, impossibile effettuare il deploy"

                # uscita
                exit 1

            fi

            ;;

        "scp")

            # se sono settati i parametri per l'accesso
            if [ -n "$SSH_USER" -a -n "$SSH_PRIVATE" -a -n "$SSH_PUBLIC" ]; then

                # informazioni
                echo "accesso SSH: $SSH_USER"
                echo "ATTENZIONE! questo tipo di deploy non supporta il backup remoto prima del deploy"
                echo "ATTENZIONE! questo tipo di deploy non supporta l'esclusione dei file e delle cartelle dal deploy"

                # comando
                CMD="ssh -i $SSH_PRIVATE $SSH_USER@$DST_HOST $DST_PATH/_src/_sh/_backup.run.sh"

                # informazioni
                echo "comando: $CMD"

                # backup
                # $CMD

                # comando
                CMD="scp -r $SRC_PATH $SSH_USER@$DST_HOST:$DST_PATH"

                # informazioni
                echo "comando: $CMD"

                # deploy
                # $CMD

            else

                # informazioni
                echo "parametri di accesso SSH mancanti, impossibile effettuare il deploy"

                # uscita
                exit 1

            fi

            ;;

        "rsync")

            ## file e cartelle da escludere dal deploy
            for i in $SET_EXCLUDE; do
                EXCLUDE="$EXCLUDE --exclude '$i'"
            done

            ## host di destinazione
            if [ -n "$DST_HOST" -a -n "$SSH_USER" -a -n "$SSH_PRIVATE" -a -n "$SSH_PUBLIC" ]; then

                # comando
                CMD="ssh -i $SSH_PRIVATE $SSH_USER@$DST_HOST $DST_PATH/_src/_sh/_backup.run.sh"

                # informazioni
                echo "comando: $CMD"

                # backup
                $CMD

                # comando
                CMD="rsync $EXCLUDE -avuz --delete -e ssh $SRC_PATH/ $SSH_USER@$DST_HOST:$DST_PATH"

                # aggiungo una newline al file se non c'è già
                sed -i '$a\' ../TODO.md

                # registro dei deploy
                echo "$CMD" >> ../TODO.md

                # informazioni
                echo "comando: $CMD"

                # deploy
                $CMD

                # comando per composer update
                CMD="ssh -i $SSH_PRIVATE $SSH_USER@$DST_HOST $DST_PATH/_src/_sh/_composer.update.sh --hard"

                # aggiornamento di composer
                $CMD

            else

                # comando
                CMD="$DST_PATH/_src/_sh/_backup.run.sh"

                # informazioni
                echo "comando: $CMD"

                # backup
                # $CMD

                # comando
                CMD="rsync -avz --delete $EXCLUDE $SRC_PATH/ $DST_PATH"

                # informazioni
                echo "comando: $CMD"

                # deploy
                # $CMD

            fi

            ;;

        "gcloud")

            # se sono settati i parametri per l'accesso
            if [ -n "$GCP_INSTANCE" -a -n "$GCP_PROJECT" -a -n "$GCP_ZONE" ]; then

                # informazioni
                echo "deploy GCP su: $GCP_ZONE/$GCP_PROJECT"
                echo "ATTENZIONE! questo tipo di deploy non supporta il backup remoto prima del deploy"
                echo "ATTENZIONE! questo tipo di deploy non supporta l'esclusione dei file e delle cartelle dal deploy"

                # comando
                CMD="gcloud compute scp --recurse $SRC_PATH $GCP_INSTANCE:$DST_PATH --project $GCP_PROJECT --zone $GCP_ZONE"

                # informazioni
                echo "comando: $CMD"

                # deploy
                # $CMD

            else

                # informazioni
                echo "parametri di accesso Google Cloud mancanti, impossibile effettuare il deploy"

                # uscita
                exit 1

            fi

            ;;

        *)

            # informazioni
            echo "comando di deploy non riconosciuto"

            ;;

    esac

fi

## uscita
exit 0
