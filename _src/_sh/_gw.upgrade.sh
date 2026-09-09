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
        #
        # NOTA: l'elenco dei percorsi tracciati sta in disallineamenti-elenco(), in
        # _src/_sh/_lib/_functions.sh, insieme al confronto. Copre le cartelle con underscore
        # piu' i dotfile e i file di root che il cp del framework qui sotto sovrascrive.
        # Restano fuori .gitignore e .githooks: il .gitignore lo riscrive comunque la riga
        # dedicata piu' sotto, prendendolo da _usr/_deploy/_git/.
        #
        disallineamenti-manifest-controlla

        case $? in

            0)
                disallineamenti-raccogli "$( disallineamenti-elenca )" "$cartellaDisallineamenti"
                ;;

            2)
                echo "ATTENZIONE: $DISALLINEAMENTI_MANIFEST c'è ma non riesco a leggerlo."
                echo "            Raccolta dei disallineamenti SALTATA: le modifiche locali di questo"
                echo "            deploy stanno per essere sovrascritte senza essere raccolte."
                mkdir -p $cartellaDisallineamenti
                ;;

            *)
                echo "ATTENZIONE: manifest dei checksum assente, è il primo aggiornamento da quando"
                echo "            la raccolta confronta il contenuto. Per questo giro ripiego sul"
                echo "            confronto per data, che NON vede le modifiche più vecchie"
                echo "            dell'ultimo aggiornamento. Il manifest viene scritto in fondo a"
                echo "            questo script, e dal prossimo giro il confronto sarà sul contenuto."

                # stesse esclusioni del confronto per contenuto: senza, il ripiego raccoglierebbe
                # anche il vendor riscritto da composer e la documentazione generata, che sono
                # 24.000 file su 28.000 e non sono disallineamenti di nessuno
                disallineamenti-raccogli "$( find ./_* ./.claude ./.github ./.htaccess ./composer.json \
                    \( -path './_src/_lib/_ext/*' -o -path './_usr/_docs/_html/*' -o -path './_usr/_docs/_pdf/*' \) -prune \
                    -o -newer ./var/latest.upgrade.conf -print 2>/dev/null )" "$cartellaDisallineamenti"
                ;;

        esac

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
        # NOTA: ./_* comprende anche il vendor _src/_lib/_ext (escluso dal backup):
        # lo metto da parte per non lasciare il sito senza dipendenze se composer fallisce
        if [ -d ./_src/_lib/_ext ]; then
            rm -rf ../_ext.prev
            cp -a ./_src/_lib/_ext ../_ext.prev
        fi
        rm -rf ./_*

        # installo la nuova versione
        cp -rf ./glisweb-$BRANCHDIR/{.[!.],}* ./

        # ripristino il vendor salvato (il rm -rf ./_* lo aveva eliminato): cosi'
        # l'autoload esiste gia' anche prima di lanciare composer
        if [ -d ../_ext.prev ]; then
            rm -rf ./_src/_lib/_ext
            mv ../_ext.prev ./_src/_lib/_ext
        fi

        # elimino la vecchia cartella
        rm -rf ./glisweb-$BRANCHDIR
        rm -rf ./$BRANCHZIP.zip

        # installo il .gitignore se è presente un repository .git
        if [ -f ./_usr/_deploy/_git/.gitignore -a -d ./.git ]; then
            cp -f ./_usr/_deploy/_git/.gitignore ./.gitignore
        fi

        # aggiorno composer (Composer 2); se fallisce mantengo il vendor precedente
        # gia' ripristinato sopra, cosi' il sito non resta mai senza dipendenze
        export COMPOSER_ALLOW_SUPERUSER=1
        if composer update -n; then
            echo "composer update ok"
        else
            echo "ATTENZIONE: composer update fallito, mantengo il vendor precedente"
        fi

        # verifica che l'autoload sia presente: se manca il framework non parte
        if [ ! -f ./_src/_lib/_ext/autoload.php ]; then
            echo "ERRORE: ./_src/_lib/_ext/autoload.php mancante dopo l'aggiornamento"
        fi

        ## permessi
        ./_src/_sh/_lamp.permissions.secure.sh

        ## salvo la data di aggiornamento
        echo $(date '+%Y-%m-%d %H:%M:%S' ) > ./var/latest.upgrade.conf

        ## fotografo l'albero appena installato, per la raccolta del prossimo giro
        # va fatto DOPO composer e DOPO i permessi, cosi' il manifest descrive il deploy come
        # sara' letto domani: un manifest scritto prima segnalerebbe come disallineato tutto
        # cio' che composer e lo script dei permessi toccano subito dopo
        disallineamenti-manifest

        ## pulizia
        clear

        ## conferma
        # la verifica di autoload qui sopra segnala eventuali fallimenti di composer
        echo "aggiornamento del framework effettuato con successo"

        # se esistono disallineamenti da controllare
        if [ -d "$cartellaDisallineamenti" ]; then

            # elimino i disallineamenti già risolti
            #
            # NOTA il -print0 letto con while, e non "for ... in $( find )": nei percorsi
            # tracciati c'è già un file con lo spazio nel nome ( in _mod/_1200.todo/ ), e col
            # word splitting il diff finirebbe su due percorsi inesistenti. È lo stesso difetto
            # che aveva la raccolta qui sopra: correggerne uno solo lascia il lavoro a metà.
            #
            # NOTA il "! -name '*.diff'": con la pipe find STREAMMA, quindi senza il filtro
            # ripescherebbe i .diff che questo stesso ciclo sta creando, e produrrebbe dei
            # .diff.diff. Col vecchio $( find ) non succedeva perché find completava prima che
            # il ciclo cominciasse.
            while IFS= read -r -d '' disallineamento; do

                # file corrispondente nella versione appena installata
                originale="${disallineamento#$cartellaDisallineamenti}"

                # debug
                echo "faccio il diff di $disallineamento"
                echo "file originale: $originale"

                if [ -f "$originale" ]; then

                    # faccio il diff del file disallineato rispetto al file standard
                    diff -u "$originale" "$disallineamento" > "$disallineamento.diff"

                else

                    # il file non esiste a monte: è un'aggiunta locale, non una modifica.
                    # NOTA senza questo ramo diff scriverebbe l'errore su stderr ( che sotto cron
                    # si perde ) e lascerebbe un .diff VUOTO, indistinguibile da "nessuna
                    # differenza": un file nuovo verrebbe scambiato per un disallineamento già
                    # risolto e non verrebbe mai promosso. Con /dev/null il file compare per
                    # intero come aggiunta.
                    echo "  NOTA: $originale non esiste a monte, è un file nuovo"
                    diff -u /dev/null "$disallineamento" > "$disallineamento.diff"

                fi

            done < <( find "$cartellaDisallineamenti" -type f ! -name '*.diff' -print0 )

        fi

    else

        # sinossi
        echo "utilizzo: $0 <branch>"

    fi

fi
