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
    echo "  --increment   il tipo di incremento di versione (major, minor, patch)"
    echo "esempi:"
    echo "  $0 test"
    echo "  $0 test --increment patch"
    echo "  $0 prod --increment minor"
    exit 1

else

    ## passo alla cartella del deploy
    cd $RL

    ## informazioni
    echo "lavoro su: $(pwd)"

    ## leggo dal file properties
    . ./etc/deploy/$1.properties

    ## informazioni
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
            echo "cartella sorgente ($SRC_PATH) non esistente, impossibile effettuare il deploy"

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
    if [ -z "$PARGNOLOG" ]; then

        ## aggiungo una newline al file se non c'è già
        sed -i -e '$a\' ../DEPLOY.md

        ## registro dei deploy
        echo "$( date "+%Y-%m-%d %H:%M" ) DEPLOY TRAMITE SCRIPT" >> ../DEPLOY.md
        echo "======================================" >> ../DEPLOY.md
        echo "Questa è una registrazione automatica di deploy ($1) effettuata dallo script $0" >> ../DEPLOY.md
        echo >> ../DEPLOY.md

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

    ## scp e gcloud passano da rsync via ssh
    #
    # Fino al 21/10/2026 i rami scp e gcloud stampavano il comando senza eseguirlo, e scp -r avrebbe
    # comunque copiato la cartella DENTRO la destinazione invece di sostituirne il contenuto. Tutti e
    # due vogliono una shell sulla destinazione, quindi possono usare il ramo rsync remoto, che ha la
    # copia per il rollback, le patch del database, il controllo e il rollback: un ramo solo, invece di
    # tre copie piu' povere. Per gcloud, `gcloud compute config-ssh` scrive in ~/.ssh/config l'alias
    # <istanza>.<zona>.<progetto> con la chiave di gcloud, e da li' ssh e rsync funzionano come verso
    # qualunque host. Va fatto prima del controllo qui sotto, che senza DST_HOST ripiega sul locale
    case "$DST_CMD" in
        "scp")
            echo "scp: la copia si fa con rsync via ssh"
            DST_CMD="rsync"
        ;;
        "gcloud")
            if [ -z "$GCP_INSTANCE" -o -z "$GCP_PROJECT" -o -z "$GCP_ZONE" ]; then
                echo "parametri di accesso Google Cloud mancanti, impossibile effettuare il deploy"
                exit 1
            fi
            if ! gcloud compute config-ssh --project "$GCP_PROJECT" --quiet > /dev/null; then
                echo "ERRORE: gcloud compute config-ssh non riuscito, impossibile effettuare il deploy"
                exit 1
            fi
            echo "gcloud: la copia si fa con rsync via ssh verso $GCP_INSTANCE.$GCP_ZONE.$GCP_PROJECT"
            DST_HOST="$GCP_INSTANCE.$GCP_ZONE.$GCP_PROJECT"
            SSH_PRIVATE="${SSH_PRIVATE:-$HOME/.ssh/google_compute_engine}"
            SSH_PUBLIC="${SSH_PUBLIC:-$HOME/.ssh/google_compute_engine.pub}"
            SSH_USER="${SSH_USER:-$( whoami )}"
            DST_CMD="rsync"
        ;;
    esac

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

    ## profilo del database della destinazione, per le patch
    # dal file properties ( DST_PROFILE ), altrimenti dallo stadio: stable e' PROD, test e' TEST
    if [ -z "$DST_PROFILE" ]; then
        case "$DST_STAGE" in
            "stable") DST_PROFILE="PROD" ;;
            "test") DST_PROFILE="TEST" ;;
        esac
    fi

    ## deploy
    case "$DST_CMD" in

        "lftp")

            # se sono settati i parametri per l'accesso
            if [ -n "$FTP_USER" -a -n "$FTP_PASSWORD" -a -n "$DST_HOST" ]; then

                # Fino al 21/10/2026 questo ramo stampava il comando senza eseguirlo. Ora segue lo schema
                # del ramo rsync per quanto l'FTP lo consente: non c'e' una shell sulla destinazione,
                # quindi la copia per il rollback si scarica in locale, le patch del database le applica
                # il task /task/mysql.patch del sito via HTTP, e le cache si svuotano con lftp e col task
                if ! command -v lftp > /dev/null; then
                    echo "ERRORE: lftp non e' installato su questa macchina, impossibile effettuare il deploy"
                    exit 1
                fi

                ## file e cartelle da escludere dal deploy
                # come glob e non come --exclude, che in lftp e' un'espressione regolare: "var" avrebbe
                # escluso anche _src/_lib/_variabili.php. Ogni voce vale sia come file sia come cartella
                for i in $SET_EXCLUDE usr/pages/test _usr/_pages/_test; do
                    EXCLUDE="$EXCLUDE --exclude-glob ${i%/} --exclude-glob ${i%/}/"
                done

                # informazioni
                echo "accesso FTP: $FTP_USER@$DST_HOST"

                # copia della destinazione per il rollback, scaricata in locale
                SNAPSHOT="$( dirname "$SRC_PATH" )/var/$( date '+%Y%m%d%H%M%S' )-deploy-$DST_STAGE"
                mkdir -p "$SNAPSHOT"
                if ! deploy-lftp "mirror $EXCLUDE $DST_PATH $SNAPSHOT"; then
                    echo "ATTENZIONE: copia della destinazione non riuscita, un rollback andrebbe fatto a mano"
                    SNAPSHOT=""
                fi
                echo "copia per il rollback: ${SNAPSHOT:-NON RIUSCITA}"

                # registro dei deploy
                echo "lftp mirror -R $EXCLUDE $SRC_PATH $DST_PATH" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # deploy
                if ! deploy-lftp "mirror -R $EXCLUDE $SRC_PATH $DST_PATH"; then
                    echo "ERRORE: deploy su $DST_HOST fallito, i file NON sono stati copiati o lo sono stati solo in parte"
                    exit 1
                fi

                # cache su filesystem della destinazione; una cartella gia' vuota non e' un errore
                deploy-lftp "glob -a rm -r -f $DST_PATH/var/cache/*" > /dev/null 2>&1

                # patch del database via HTTP e controllo; senza credenziali le patch non si applicano
                # e lo si dice ( esito 2 ), con un errore si torna indietro
                deploy-task-http "mysql.patch"
                ESITO_PATCH=$?
                if [ $ESITO_PATCH -eq 1 ] || ! deploy-check ""; then
                    if [ -n "$SNAPSHOT" ] && deploy-lftp "mirror -R $EXCLUDE $SNAPSHOT $DST_PATH"; then
                        echo "ERRORE: deploy su $DST_HOST annullato, la destinazione e' tornata alla versione precedente"
                    else
                        echo "ERRORE: deploy su $DST_HOST fallito e rollback non riuscito, la destinazione va sistemata a mano"
                    fi
                    exit 1
                fi

                # cache dei contenuti
                deploy-task-http "memcache.clean?deploy=1"

                echo "deploy completato su $DST_HOST"

            else

                # informazioni
                echo "parametri di accesso FTP mancanti ( FTP_USER, FTP_PASSWORD, DST_HOST ), impossibile effettuare il deploy"

                # uscita
                exit 1

            fi
            ;;
        "rsync")

            ## file e cartelle da escludere dal deploy
            for i in $SET_EXCLUDE; do
                EXCLUDE="$EXCLUDE --exclude $i"
            done

            ## esito dei test automatici
            # appartiene alla macchina dove i test sono girati ( _codeception.run.sh ): copiato altrove
            # mostrerebbe sul target l'esito di un altro ambiente, quindi non viaggia mai
            EXCLUDE="$EXCLUDE --exclude usr/pages/test/ --exclude _usr/_pages/_test/"

            ## un host senza i parametri SSH e' un errore, non un deploy locale
            # fino al 21/10/2026 il ramo locale qui sotto si prendeva anche quando DST_HOST c'era ma mancava
            # uno dei parametri SSH: si copiava in locale, su questa macchina, nel percorso che era della
            # destinazione remota
            if [ -n "$DST_HOST" ] && [ -z "$SSH_USER" -o -z "$SSH_PRIVATE" -o -z "$SSH_PUBLIC" ]; then
                echo "parametri di accesso SSH mancanti ( SSH_USER, SSH_PRIVATE, SSH_PUBLIC ) per $DST_HOST, impossibile effettuare il deploy"
                exit 1
            fi

            ## host di destinazione
            if [ -n "$DST_HOST" -a -n "$SSH_USER" -a -n "$SSH_PRIVATE" -a -n "$SSH_PUBLIC" ]; then

                # porta di destinazione
                if [ -n "$DST_PORT" ]; then
                    RPORT="--port=$DST_PORT"
                    SPORT="-p $DST_PORT"
                else
                    RPORT=""
                    SPORT=""
                fi

                # utente per gli script che sul target richiedono i privilegi di root
                # (apertura e chiusura dei permessi): se non è indicato nel file properties
                # si usa l'utente del deploy
                if [ -z "$SSH_ADMIN" ]; then
                    SSH_ADMIN="$SSH_USER"
                fi

                # comando
                CMD="ssh $SPORT -i $SSH_PRIVATE $SSH_USER@$DST_HOST $DST_PATH/_src/_sh/_backup.run.sh"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # backup
                # $CMD

                # comando
                CMD="ssh $SPORT -i $SSH_PRIVATE $SSH_ADMIN@$DST_HOST $DST_PATH/_src/_sh/_lamp.permissions.open.sh"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # aggiornamento dei permessi
                $CMD

                # se i permessi non si aprono l'rsync scrive su cartelle in sola lettura e non copia
                # nulla: non è fatale di per sé (potrebbero essere già aperti) ma va detto
                if [ $? -ne 0 ]; then
                    echo "ATTENZIONE: apertura dei permessi su $DST_HOST fallita (utente $SSH_ADMIN): se il deploy non copia i file è questo il motivo"
                fi

                # copia della destinazione per il rollback, prima di sovrascriverla
                SNAPSHOT=$( deploy-snapshot "$DST_PATH" "ssh $SPORT -i $SSH_PRIVATE $SSH_ADMIN@$DST_HOST" "$EXCLUDE" )
                echo "copia per il rollback: ${SNAPSHOT:-NON RIUSCITA, un rollback andrebbe fatto a mano}"

                # niente -u: con -u un file piu' recente sul target ( un ritocco a caldo ) viene saltato
                # in silenzio anche se diverso, e il deploy si dichiara riuscito lasciando sul target una
                # versione che non e' quella di DEV ( il 01/10/2026 ha lasciato www2 in fatal ); il
                # --checksum basta a non ricopiare i file identici
                # comando
                CMD="rsync $EXCLUDE -avz --checksum --delete -e \"ssh $SPORT -i $SSH_PRIVATE\" $SRC_PATH/ $SSH_USER@$DST_HOST:$DST_PATH"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # deploy
                rsync $EXCLUDE -avz --checksum --delete -e "ssh $SPORT -i $SSH_PRIVATE" $SRC_PATH/ $SSH_USER@$DST_HOST:$DST_PATH >> ../DEPLOY.md

                # esito del deploy
                RSYNC_STATUS=$?

                # comando per composer update
                CMD="ssh $SPORT -i $SSH_PRIVATE $SSH_USER@$DST_HOST $DST_PATH/_src/_sh/_composer.update.sh --hard"

                # registro dei deploy
                echo >> ../DEPLOY.md
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # aggiornamento di composer
                # $CMD

                # comando
                CMD="ssh $SPORT -i $SSH_PRIVATE $SSH_ADMIN@$DST_HOST $DST_PATH/_src/_sh/_lamp.permissions.secure.sh"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # aggiornamento dei permessi
                $CMD

                # i permessi vanno richiusi sempre, anche se il deploy è fallito: se non ci si
                # riesce il target resta scrivibile dal gruppo e la cosa va urlata
                if [ $? -ne 0 ]; then
                    echo "ERRORE: chiusura dei permessi su $DST_HOST fallita (utente $SSH_ADMIN): il target è rimasto con i permessi aperti, intervenire a mano con _lamp.permissions.secure.sh"
                    exit 1
                fi

                # se il deploy è fallito lo dico e esco con errore: prima si finiva sempre con
                # esito positivo anche quando rsync non aveva copiato nulla
                if [ $RSYNC_STATUS -ne 0 ]; then
                    echo "ERRORE: deploy su $DST_HOST fallito (rsync esito $RSYNC_STATUS), i file NON sono stati copiati o lo sono stati solo in parte"
                    exit 1
                fi

                # protezioni Basic auth della destinazione
                deploy-realign-protections "$DST_PATH" "ssh $SPORT -i $SSH_PRIVATE $SSH_USER@$DST_HOST"

                # invalidazione delle cache della destinazione
                deploy-invalidate-caches "$DST_PATH" "ssh $SPORT -i $SSH_PRIVATE $SSH_USER@$DST_HOST"

                # patch del database della destinazione e controllo: se uno dei due fallisce si torna
                # al codice di prima, che gira anche sul database aggiornato ( patch compatibili all'indietro )
                if ! deploy-mysql-patch "$DST_PATH" "ssh $SPORT -i $SSH_PRIVATE $SSH_ADMIN@$DST_HOST" "$DST_PROFILE" || ! deploy-check "ssh $SPORT -i $SSH_PRIVATE $SSH_USER@$DST_HOST"; then
                    deploy-rollback "$DST_PATH" "ssh $SPORT -i $SSH_PRIVATE $SSH_ADMIN@$DST_HOST" "$SNAPSHOT" "$EXCLUDE"
                    echo "ERRORE: deploy su $DST_HOST annullato, la destinazione e' tornata alla versione precedente ( profilo del database: ${DST_PROFILE:-nessuno}, si dichiara con DST_PROFILE )"
                    exit 1
                fi

                # informazioni
                echo "deploy completato su $DST_HOST"

            else

                # Fix 2026-09-02: il deploy LOCALE ora esegue davvero, come quello remoto.
                #
                # Fin qui questo ramo — quello che si prende quando sorgente e destinazione sono
                # sulla stessa macchina, cioe' senza DST_HOST — stampava i comandi e li lasciava
                # commentati. Lo script terminava con "exit 0" senza aver copiato niente, quindi
                # sembrava funzionare: chi lo lanciava restava convinto di aver fatto il deploy.
                # Il ramo remoto (ssh) qui sopra era invece completo da tempo, e da li' e' preso
                # lo schema: backup, permessi aperti, rsync, permessi richiusi, controllo esito.
                #
                # I permessi vanno aperti prima e richiusi dopo per lo stesso motivo del ramo
                # remoto: con i permessi sicuri le cartelle di destinazione sono in sola lettura
                # e rsync non copia nulla, fallendo in modo poco evidente.

                # backup della destinazione prima di sovrascriverla
                CMD="$DST_PATH/_src/_sh/_backup.run.sh"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # backup
                if [ -x "$DST_PATH/_src/_sh/_backup.run.sh" ]; then
                    $CMD
                else
                    echo "ATTENZIONE: $DST_PATH/_src/_sh/_backup.run.sh non disponibile, deploy senza backup della destinazione"
                fi

                # comando
                CMD="$DST_PATH/_src/_sh/_lamp.permissions.open.sh"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # apertura dei permessi
                $CMD

                # se i permessi non si aprono l'rsync scrive su cartelle in sola lettura e non
                # copia nulla: non e' fatale di per se' (potrebbero essere gia' aperti) ma va detto
                if [ $? -ne 0 ]; then
                    echo "ATTENZIONE: apertura dei permessi su $DST_PATH fallita: se il deploy non copia i file e' questo il motivo"
                fi

                # copia della destinazione per il rollback, prima di sovrascriverla
                SNAPSHOT=$( deploy-snapshot "$DST_PATH" "" "$EXCLUDE" )
                echo "copia per il rollback: ${SNAPSHOT:-NON RIUSCITA, un rollback andrebbe fatto a mano}"

                # niente -u: con -u un file piu' recente sul target ( un ritocco a caldo ) viene saltato
                # in silenzio anche se diverso, e il deploy si dichiara riuscito lasciando sul target una
                # versione che non e' quella di DEV ( il 01/10/2026 ha lasciato www2 in fatal ); il
                # --checksum basta a non ricopiare i file identici
                # comando
                CMD="rsync $EXCLUDE -avz --checksum --delete $SRC_PATH/ $DST_PATH"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # deploy
                rsync $EXCLUDE -avz --checksum --delete $SRC_PATH/ $DST_PATH >> ../DEPLOY.md

                # esito del deploy
                RSYNC_STATUS=$?

                # comando
                CMD="$DST_PATH/_src/_sh/_lamp.permissions.secure.sh"

                # registro dei deploy
                echo "$CMD" >> ../DEPLOY.md
                echo >> ../DEPLOY.md

                # informazioni
                echo "comando: $CMD"

                # chiusura dei permessi
                $CMD

                # i permessi vanno richiusi sempre, anche se il deploy e' fallito: se non ci si
                # riesce la destinazione resta scrivibile dal gruppo e la cosa va urlata
                if [ $? -ne 0 ]; then
                    echo "ERRORE: chiusura dei permessi su $DST_PATH fallita: la destinazione e' rimasta con i permessi aperti, intervenire a mano con _lamp.permissions.secure.sh"
                    exit 1
                fi

                # se il deploy e' fallito lo dico e esco con errore
                if [ $RSYNC_STATUS -ne 0 ]; then
                    echo "ERRORE: deploy su $DST_PATH fallito (rsync esito $RSYNC_STATUS), i file NON sono stati copiati o lo sono stati solo in parte"
                    exit 1
                fi

                # protezioni Basic auth della destinazione
                deploy-realign-protections "$DST_PATH"

                # invalidazione delle cache della destinazione
                deploy-invalidate-caches "$DST_PATH"

                # patch del database della destinazione e controllo: se uno dei due fallisce si torna
                # al codice di prima, che gira anche sul database aggiornato ( patch compatibili all'indietro )
                if ! deploy-mysql-patch "$DST_PATH" "" "$DST_PROFILE" || ! deploy-check ""; then
                    deploy-rollback "$DST_PATH" "" "$SNAPSHOT" "$EXCLUDE"
                    echo "ERRORE: deploy su $DST_PATH annullato, la destinazione e' tornata alla versione precedente ( profilo del database: ${DST_PROFILE:-nessuno}, si dichiara con DST_PROFILE )"
                    exit 1
                fi

                # informazioni
                echo "deploy completato su $DST_PATH"

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
