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

## prendo il nome del repository e capisco se e' un repository del framework
#
# Fix 2026-09-09: fino a qui la guardia guardava SOLO il nome del remote e cercava la stringa
# 'glisweb'. Bastava quindi che un repository del framework si chiamasse diversamente perche' la
# guardia non lo intercettasse: glisdev e glistest hanno tutt'e due il remote 'glisdev.git', e su
# quei due lo script sarebbe partito, avrebbe fatto `rm -rf ./_*` sul sorgente del framework e
# avrebbe spezzato la condivisione di inode con glisweb. L'unica cosa che li proteggeva era che
# non hanno update.branch.conf e quindi il cron notturno li salta: una protezione per omissione,
# che sarebbe caduta al primo lancio a mano.
#
# Il controllo che regge davvero e' il secondo, e guarda il CONTENUTO invece del nome: su un
# repository del framework i file standard sono versionati, perche' sono il sorgente; su un
# deploy cliente arrivano dallo zip e il .gitignore ( che viene da _usr/_deploy/_git/ ) li
# esclude con `_*/`. Verificato su tutti i deploy della macchina: 1 sui tre repository del
# framework, 0 sui cinque deploy cliente. Non si aggira rinominando un remote.
FRAMEWORK=""

if [[ -d "./.git" ]]; then

    for r in $( git remote ); do
        GITNAME="$GITNAME "$( basename $(git remote get-url $r) )
    done

    if [ -n "$( git ls-files -- _src/_config.php 2>/dev/null )" ]; then
        FRAMEWORK="1"
    fi

fi

## se sto lavorando sul framework
if [ -n "$FRAMEWORK" ] || [ -n "$( echo $GITNAME | grep 'glisweb' )" ]; then

    echo "stai lavorando sul framework ($GITNAME), utilizza git per rimanere aggiornato"
    echo

    if [ -n "$FRAMEWORK" ]; then
        echo "i file standard _* sono versionati in questo repository, quindi ne è il sorgente:"
        echo "aggiornarlo da uno zip cancellerebbe il lavoro non ancora pubblicato e, dove i file"
        echo "sono hard-linked con un altro deploy del framework, spezzerebbe la condivisione"
    else
        echo "NOTA: potresti ricevere questo messaggio anche se sei su un repository custom che"
        echo "però contiene 'glisweb' nel nome; rinomina il tuo repository affinché non contenga"
        echo "la parola riservata 'glisweb' nel nome"
    fi

else

    # output
    if [[ -n "$GITNAME" ]]; then
        echo "stai lavorando su $GITNAME, aggiorno il framework"
    fi

    # se è specificata una branch di aggiornamento
    if [[ -n "$1" ]]; then

        cartellaDisallineamenti="../$DISALLINEAMENTI_SUBDIR/$( date '+%Y%m%d%H%M%S' )/"

        echo "inizio il backup"

        EXCLUDE=".git .github _src/_lib/_ext _usr/_docs/_html _usr/_docs/_pdf tmp var"
        for i in $EXCLUDE; do
            EXC="$EXC --exclude=./$i"
        done

        # faccio il backup della cartella corrente
        #
        # I backup non stanno piu' sparsi nella root del progetto ma in ../$BACKUP_SUBDIR/:
        # il mkdir -p serve al primo giro dopo il cambio di layout, quando la sottocartella
        # ancora non esiste e senza di lui il tar fallirebbe.
        BACKUPFILE="../$BACKUP_SUBDIR/backup.$( date '+%Y%m%d%H%M%S' ).tar.gz"

        mkdir -p "../$BACKUP_SUBDIR"

        tar $EXC -czf "$BACKUPFILE" .

        # Il backup e' l'UNICA copia di cio' che il `rm -rf ./_*` piu' sotto distrugge: se non
        # c'e', ci si ferma prima di distruggere, come per il download fallito.
        #
        # NOTA non si guarda l'uscita di tar: su un sito vivo vale 1 anche solo perche' un file
        # e' cambiato mentre lo leggeva, e un aggiornamento che si rifiuta di partire ogni notte
        # per un warning e' peggio del problema. Si guarda il risultato, come per lo zip.
        if [ ! -s "$BACKUPFILE" ]; then
            echo "ERRORE: backup $BACKUPFILE assente o vuoto, il framework NON viene toccato"
            exit 1
        fi

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

        # pulisco il nome del file zip dai prefissi
        BRANCHZIP=$( echo $BRANCH | sed -e "s/^feature\///" )
        BRANCHZIP=$( echo $BRANCHZIP | sed -e "s/^hotfix\///" )

        # pulisco il nome della cartella dai prefissi
        BRANCHDIR=${BRANCH////-}

        # residui di un tentativo precedente andato male: se restassero, i controlli qui sotto
        # li scambierebbero per il risultato di questo giro e darebbero via libera al rm -rf
        rm -rf ./glisweb-$BRANCHDIR
        rm -f ./$BRANCHZIP.zip

        # scarico Glisweb
        #
        # ATTENZIONE: da qui alla riga del rm -rf ./_* non si distrugge ancora niente, ed e'
        # l'unico momento in cui ci si puo' ancora fermare. Fino al 2026-09-09 non ci si fermava:
        # ne' il wget ne' l'unzip erano controllati, e il rm -rf ./_* partiva comunque. Bastava
        # che GitHub non rispondesse, o che il branch fosse scritto male, per radere al suolo il
        # framework di un deploy e lasciarlo senza niente da rimetterci sopra: il cp subito dopo
        # non aveva nessuna sorgente da cui copiare. Sotto cron, di notte, in silenzio.
        #
        # Ogni controllo qui sotto esce PRIMA del rm -rf, quindi il deploy resta esattamente
        # com'era e riprova al giro successivo.
        if ! wget https://github.com/istricesrl/glisweb/archive/$BRANCH.zip; then
            echo "ERRORE: scaricamento di $BRANCH.zip fallito, il framework NON viene toccato"
            exit 1
        fi

        if [ ! -s ./$BRANCHZIP.zip ]; then
            echo "ERRORE: ./$BRANCHZIP.zip assente o vuoto dopo il download, il framework NON viene toccato"
            exit 1
        fi

        # scompatto Glisweb
        if ! unzip -qq ./$BRANCHZIP.zip; then
            echo "ERRORE: scompattamento di ./$BRANCHZIP.zip fallito, il framework NON viene toccato"
            exit 1
        fi

        # controllo che sia davvero un framework e non una pagina di errore rinominata .zip:
        # _src/_config.php e' il bootstrap, senza quello non c'e' niente da installare
        if [ ! -f ./glisweb-$BRANCHDIR/_src/_config.php ]; then
            echo "ERRORE: ./glisweb-$BRANCHDIR/ non contiene _src/_config.php, non sembra una"
            echo "        distribuzione del framework. Il framework NON viene toccato"
            exit 1
        fi

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
