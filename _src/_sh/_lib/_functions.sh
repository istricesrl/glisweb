#!/bin/bash

function check-root() {
    if [ ! $(id -u) = 0 ]; then
        echo "devi essere root per eseguire questo script"
        exit 1
    else
        echo "verifica utente root OK"
    fi
}

function check-args() {

    if [ $# -eq 0 ]; then
        PNOARGS=1
        return
    fi

    options=$(getopt -o bhr --long soft,hard,nolog,nobackup,major,minor,patch,increment:,test: -- "$@")

    echo "valuto: $options"

    eval set -- "$options"

    while true; do

        case "$1" in
            -b)
                PARGB=1
                ;;
            -h)
                PARGH=1
                ;;
            -r)
                PARGR=1
                ;;
            --soft)
                PARGSOFT=1
                ;;
            --hard)
                PARGHARD=1
                ;;
            --nolog)
                PARGNOLOG=1
                ;;
            --nobackup)
                PARGNOBACKUP=1
                ;;
            --major)
                PARGINCREMENT=1
                PVALINCREMENT="major"
                ;;
            --minor)
                PARGINCREMENT=1
                PVALINCREMENT="minor"
                ;;
            --patch)
                PARGINCREMENT=1
                PVALINCREMENT="patch"
                ;;
            --increment)
                shift;
                PARGINCREMENT=1
                PVALINCREMENT=$1
                ;;
            --test)
                shift;
                PARGTEST=1
                PVALTEST=$1
                ;;
            --)
                shift
                break
                ;;
        esac

        shift

    done

}

increment-version() {
  local delimiter=.
  local array=($(echo "$1" | tr $delimiter '\n'))
  array[$2]=$((array[$2]+1))
  echo $(local IFS=$delimiter ; echo "${array[*]}")
}
#
# Riallinea le protezioni Basic auth di un deploy appena aggiornato.
#
# Fix 2026-10-13: le pagine protette del progetto ( usr/pages/manual/, usr/pages/quickstart/,
# usr/pages/test/ ) hanno un .htaccess con AuthUserFile, che vuole un percorso ASSOLUTO. Il file
# lo scrive _docs.build.sh sulla macchina dove gira, quindi porta il percorso di quella macchina,
# e il deploy lo copiava tale e quale: su www2, timbrature e gm Apache cercava le password nella
# document root di DEV, non le trovava e rispondeva 500 su tutto il manuale. Il file delle
# password ( etc/secret/.htpasswd ) invece viaggia gia' col deploy: e' solo il percorso che va
# rifatto sul target, ed e' quello che si fa qui, a ogni deploy, come per le cache.
#
# Si tocca la sola riga AuthUserFile, e solo se punta altrove: e' la stessa regola di
# docsBuildProtezione() in _src/_cli/_docs.build.php, che fa lo stesso quando genera.
#
# $1 percorso della document root di destinazione
# $2 prefisso di esecuzione remota, opzionale (es. "ssh -i chiave utente@host")
#
function deploy-realign-protections() {

    local DST="$1"
    local VIA="$2"

    if [ -z "$DST" ]; then
        echo "ATTENZIONE: riallineamento delle protezioni saltato, percorso di destinazione non indicato"
        return 1
    fi

    local SCRIPT='
        cd "$1" || exit 1
        for f in usr/pages/*/.htaccess; do
            [ -f "$f" ] && grep -q "^[[:space:]]*AuthUserFile" "$f" || continue
            grep -q "^AuthUserFile $1/etc/secret/.htpasswd$" "$f" && continue
            sed -i "s|^[[:space:]]*AuthUserFile[[:space:]].*\$|AuthUserFile $1/etc/secret/.htpasswd|" "$f"
            chown root:www-data "$f"; chmod 640 "$f"
            echo "protezione riallineata in $f"
        done
        [ -f etc/secret/.htpasswd ] || echo "ATTENZIONE: manca etc/secret/.htpasswd, le pagine protette restano chiuse"
    '

    if [ -n "$VIA" ]; then
        echo "$SCRIPT" | $VIA "bash -s -- '$DST'"
    else
        echo "$SCRIPT" | bash -s -- "$DST"
    fi

}
#
# Invalida le cache di un deploy appena aggiornato.
#
# Fix 2026-09-02: fino a qui _deploy.run.sh copiava i file e finiva. I file arrivavano davvero,
# ma le pagine servite restavano quelle di prima, perche' il framework tiene diversi livelli di
# cache che NON si invalidano da soli quando il sorgente cambia:
#
#   var/cache/twig    template compilati. Con `debug: false` e senza `auto_reload` Twig non
#                     ricontrolla mai la data del sorgente: compilato una volta, un template
#                     non si aggiorna piu'. E' il caso che ha fatto scoprire il problema —
#                     modifiche ai template copiate in produzione e rimaste invisibili per un
#                     giorno intero, senza nessun errore da nessuna parte
#   var/cache/pages   pagine renderizzate
#   var/cache/mysql   risultati di query
#   var/cache/css     risorse esterne scaricate e riscritte, senza TTL
#   var/cache/js      idem
#
# Si cancella `var/cache/` e basta: i log, lo spool dei pagamenti e le sitemap NON si toccano.
# E' la differenza con `_gw.clean.sh --soft`, che porta via anche quelli e su una produzione non
# va bene.
#
# La cache in memcache (contenuti e pagine, `$cf['contents']['pages']`) vive fuori dal
# filesystem e si svuota chiamando l'endpoint /task/memcache.clean del sito di destinazione:
# si fa solo se il file properties dichiara DST_URL con le credenziali DST_AUTH_USER e
# DST_AUTH_PASS, altrimenti si ricorda all'operatore di lanciarlo a mano. Non si prova a
# indovinare l'host dal config.json: e' un JSON con i profili per ambiente, e leggerlo dalla
# shell sarebbe piu' fragile del problema che risolve.
#
# $1 percorso della document root di destinazione
# $2 prefisso di esecuzione remota, opzionale (es. "ssh -i chiave utente@host")
#
function deploy-invalidate-caches() {

    local DST="$1"
    local VIA="$2"

    if [ -z "$DST" ]; then
        echo "ATTENZIONE: invalidazione delle cache saltata, percorso di destinazione non indicato"
        return 1
    fi

    echo "invalidazione delle cache su $DST"

    # cache su filesystem
    if [ -n "$VIA" ]; then
        $VIA "rm -rf $DST/var/cache/*"
    else
        rm -rf $DST/var/cache/*
    fi

    if [ $? -ne 0 ]; then
        echo "ATTENZIONE: pulizia di $DST/var/cache non riuscita: le pagine potrebbero continuare a essere servite dalla versione precedente"
    else
        echo "cache su filesystem svuotate ($DST/var/cache)"
    fi

    # cache in memcache
    #
    # AUTENTICAZIONE. Il task vuole il privilegio GESTIONE_CACHE dal 05/09/2026 e da anonimo
    # risponde 403: e' voluto, senza il controllo chiunque potrebbe svuotare in continuazione la
    # cache di una produzione. Ci si autentica quindi in HTTP Basic, che _src/_config/_210.auth.php
    # mappa gia' sul login normale (PHP_AUTH_USER/PHP_AUTH_PW): non serve una sessione, non serve
    # un cookie jar, e l'endpoint resta chiuso a chi passa di li'. Le credenziali stanno nel file
    # properties, che non viaggia mai (etc/deploy/ e' in SET_EXCLUDE) e custodisce gia' il percorso
    # della chiave SSH, cioe' un segreto piu' grosso di questo.
    #
    # PORTATA. Si chiama con ?deploy=1, cioe' TUTTI i siti del deploy. Ogni chiave e' prefissata da
    # un seed per sito e anche l'INDICE delle chiavi lo e', quindi senza il parametro si pulirebbe
    # il solo sito il cui host si e' chiamato e gli altri continuerebbero a servire la copia
    # precedente. Un deploy aggiorna tutti i siti insieme, quindi deve svuotarli tutti insieme.
    #
    # DA DOVE PARTE LA CHIAMATA. Dal TARGET, quando il target e' remoto: e' la stessa regola del
    # rm -rf qui sopra, e non e' pignoleria. Un target sulla rete interna del cliente (connor, che
    # si raggiunge solo saltando da un bastion) NON e' risolvibile dalla macchina che lancia il
    # deploy: una curl da qui fallirebbe sempre, e il deploy lo direbbe come se fosse un problema
    # di privilegi. Il target invece il proprio nome lo risolve.
    #
    # Le credenziali passano dallo standard input (curl -K -) e non da -u: sulla riga di comando
    # finirebbero nella lista dei processi del target per tutta la durata della chiamata.
    if [ -n "$DST_URL" ] && [ -n "$DST_AUTH_USER" ] && [ -n "$DST_AUTH_PASS" ]; then

        local CACHE_URL="$DST_URL/task/memcache.clean?deploy=1"

        echo "svuoto la cache dei contenuti: $CACHE_URL"

        if [ -n "$VIA" ]; then
            printf 'user = "%s:%s"\n' "$DST_AUTH_USER" "$DST_AUTH_PASS" | $VIA "curl -s -f -o /dev/null --max-time 60 -K - '$CACHE_URL'"
        else
            printf 'user = "%s:%s"\n' "$DST_AUTH_USER" "$DST_AUTH_PASS" | curl -s -f -o /dev/null --max-time 60 -K - "$CACHE_URL"
        fi

        if [ $? -eq 0 ]; then
            echo "cache dei contenuti svuotata"
        else
            echo "ATTENZIONE: chiamata a $CACHE_URL fallita, lanciarla a mano"
            echo "            un 403 vuol dire che l'account DST_AUTH_USER non ha il privilegio GESTIONE_CACHE"
        fi

    else

        echo "ATTENZIONE: DST_URL, DST_AUTH_USER o DST_AUTH_PASS non indicati nel file properties:"
        echo "            la cache dei contenuti in memcache NON e' stata svuotata"
        echo "            lanciare a mano /task/memcache.clean?deploy=1 sul sito di destinazione"

    fi

}
## layout degli archivi in /var/www/<progetto>/
#
# Backup e disallineamenti stanno fuori dalla document root ( che e' <progetto>/dev ) e da
# oggi ciascuno nella propria sottocartella, invece che sparsi nella root del progetto come
# file e cartelle datate. Li' si mescolavano a update.branch.conf, devuser.conf e al deploy
# stesso, e crescevano senza limite: i disallineamenti non li ruotava nessuno.
#
# ATTENZIONE questi due nomi sono un contratto con gli script di sistema di web03:
# /etc/cron.daily/pulizia-backup-siti e /etc/cron.daily/pulizia-disallineamenti-siti cercano
# esattamente queste sottocartelle. Cambiarli qui senza cambiarli anche li' vuol dire archivi
# che non vengono piu' ruotati, in silenzio.
#
# NOTA vale anche qui l'avvertenza del manifest qui sotto: _gw.upgrade.sh sorgente questa
# libreria PRIMA del `rm -rf ./_*`, quindi una modifica a queste variabili ha effetto solo
# dall'aggiornamento successivo a quello che la installa.
BACKUP_SUBDIR="backups"
DISALLINEAMENTI_SUBDIR="disallineamenti"

## manifest delle impronte dell'ultimo aggiornamento
#
# ATTENZIONE il numero nel nome e' la versione del FORMATO, cioe' dell'insieme di file che
# disallineamenti-elenco( ) enumera. Chi tocca quella funzione DEVE incrementare il numero.
#
# Il motivo non e' ovvio: _gw.upgrade.sh sorgente questa libreria in cima, poi fa `rm -rf ./_*`
# che la cancella e installa quella nuova, ma le funzioni restano in memoria nella versione
# VECCHIA. Quindi il manifest in fondo all'aggiornamento lo scrive l'enumerazione della versione
# precedente, mentre la notte dopo lo verifica quella nuova. Se le due enumerazioni non
# coincidono, ogni file entrato o uscito dall'insieme diventa un fantasma: quelli usciti
# risultano cancellati in locale, quelli entrati aggiunti in locale. Su cinque deploy, in
# silenzio, la notte dopo un rilascio.
#
# Cambiando il numero il manifest vecchio risulta assente, e l'assenza ha gia' un comportamento
# definito: avviso esplicito, ripiego sulle date per un giro solo, riscrittura in fondo.
DISALLINEAMENTI_MANIFEST="./var/latest.upgrade.1.sha256.conf"

## soglia oltre la quale la raccolta si ferma e lo dice
# se l'aggiornamento precedente si e' interrotto a meta' il manifest descrive un albero che non
# esiste piu', e il confronto trova disallineato mezzo framework. Oltre la soglia si spiega cosa
# e' successo invece di riempire la cartella: il tar di backup c'e' comunque, non si perde niente
DISALLINEAMENTI_SOGLIA=500
#
# Elenco dei file del framework installati su un deploy, separati da NUL.
#
# Fix 2026-09-09: e' la sola enumerazione dei file tracciati, e serve che sia UNA sola. Il
# manifest dei checksum e la sua verifica devono guardare esattamente lo stesso insieme: se le
# due liste divergessero anche di un file, ogni giro segnalerebbe differenze fantasma e in poco
# tempo nessuno guarderebbe piu' i disallineamenti.
#
# Restano fuori tre alberi che cambiano da soli e non sono disallineamenti di nessuno: il vendor
# _src/_lib/_ext ( lo riscrive composer a ogni aggiornamento ) e la documentazione generata in
# _usr/_docs/_html e _usr/_docs/_pdf. Sono gli stessi tre esclusi dal tar di backup in
# _gw.upgrade.sh, e vanno tenuti allineati con quello. Senza il prune i file tracciati sono
# 28.691, con il prune 4.519: il grosso e' rumore.
#
# I percorsi sono una whitelist e non tutto l'albero, perche' il deploy contiene anche src/,
# mod/ e var/, che sono del progetto e non del framework.
#
function disallineamenti-elenco() {

    find ./_* ./.claude ./.github ./.htaccess ./composer.json \
        \( -path './_src/_lib/_ext/*' -o -path './_usr/_docs/_html/*' -o -path './_usr/_docs/_pdf/*' \) -prune \
        -o -type f -print0 2>/dev/null

}
#
# Scrive il manifest dei checksum dell'albero appena installato.
#
# Fix 2026-09-09: prima la raccolta dei disallineamenti confrontava le DATE ( find -newer contro
# var/latest.upgrade.conf ) invece del contenuto. Una modifica anteriore all'ultimo aggiornamento
# e mai promossa a monte non veniva raccolta, e al giro successivo il rm -rf ./_* se la portava
# via senza lasciarne traccia da nessuna parte.
#
# Il caso peggiore non e' nemmeno quello: mv, cp -a e tar CONSERVANO l'mtime, quindi un file
# appena ripristinato da un backup risulta piu' vecchio del riferimento e sparisce dalla
# raccolta. La trappola scattava esattamente addosso a chi stava riparando un guasto.
#
# Il manifest fotografa l'albero subito dopo l'installazione, cosi' al giro dopo la domanda
# diventa "cosa ha cambiato QUESTO deploy da quando e' stato installato", che e' il significato
# esatto di disallineamento. Da non confondere col confronto contro la distribuzione nuova, che
# segnalerebbe anche i file cambiati solo a monte.
#
# Vive in var/ perche' li' non e' tracciato dalla whitelist qui sopra e quindi si esclude da se';
# l'estensione .conf lo mette fra quelle negate dal FilesMatch del .htaccess. Se un giorno si
# aggiungesse ./var ai percorsi tracciati andrebbe escluso a mano, o si autoinvaliderebbe a ogni
# scrittura.
#
# Si scrive prima in un temporaneo e poi si sposta con mv, che e' atomico: se l'aggiornamento si
# interrompe MENTRE lo si scrive non resta un manifest troncato, che la notte dopo dichiarerebbe
# cancellati tutti i file rimasti fuori. Resta quello vecchio, e di quel caso si accorge la soglia.
#
function disallineamenti-manifest() {

    disallineamenti-elenco | xargs -0 --no-run-if-empty sha256sum > "$DISALLINEAMENTI_MANIFEST.tmp" 2>/dev/null

    if [ ! -s "$DISALLINEAMENTI_MANIFEST.tmp" ]; then
        rm -f "$DISALLINEAMENTI_MANIFEST.tmp"
        echo "ATTENZIONE: il manifest dei disallineamenti sarebbe vuoto, non lo scrivo e tengo il precedente"
        return 1
    fi

    mv -f "$DISALLINEAMENTI_MANIFEST.tmp" "$DISALLINEAMENTI_MANIFEST"

    echo "manifest dei disallineamenti scritto in $DISALLINEAMENTI_MANIFEST ( $( wc -l < "$DISALLINEAMENTI_MANIFEST" ) file )"

}
#
# Dice se il manifest e' utilizzabile: 0 si', 1 assente, 2 c'e' ma non lo leggo.
#
# I due casi negativi vanno distinti. "Assente" e' normale al primo giro e su un deploy mai
# aggiornato. "Non lo leggo" invece capita a chi lancia _gw.disallineamenti.sh senza essere root:
# il manifest lo scrive root con umask 027 in var/, quindi nasce 0640. Senza distinguere, ogni
# file risulterebbe illeggibile e quindi cancellato in locale — un elenco di migliaia di
# cancellazioni inventate.
#
function disallineamenti-manifest-controlla() {

    if [ ! -f "$DISALLINEAMENTI_MANIFEST" ]; then
        return 1
    fi

    if [ ! -r "$DISALLINEAMENTI_MANIFEST" ]; then
        return 2
    fi

    return 0

}
#
# Elenca i file che divergono dal manifest: uno per riga, su stdout.
#
# Sono i modificati in locale e gli aggiunti in locale, che e' quello che va promosso a monte. I
# file CANCELLATI in locale non entrano nell'elenco: l'aggiornamento li rimette comunque, e non
# c'e' niente da promuovere.
#
# Tre cose non sono dettagli implementativi ma la ragione per cui la funzione e' scritta cosi':
#
# - LC_ALL=C davanti a sha256sum e davanti a comm. L'output di sha256sum -c e' TRADOTTO: in
#   italiano stampa "NON RIUSCITO" e non "FAILED", quindi senza forzare la locale il parsing non
#   troverebbe niente e fallirebbe in silenzio, cioe' rifarebbe il difetto che stiamo togliendo.
#   comm ha lo stesso problema al contrario: verifica l'ordinamento con la locale corrente, e se
#   non e' d'accordo con quella dei sort scrive l'errore su stderr ( che sotto cron si perde ) e
#   restituisce risultati sbagliati;
#
# - il $ in fondo a "s/: FAILED$//p". sha256sum -c usa ": FAILED" per un file modificato e
#   ": FAILED open or read" per uno sparito: senza l'ancoraggio i due casi si mescolerebbero;
#
# - i file aggiunti in locale NON compaiono nell'output di -c, che verifica solo cio' che il
#   manifest elenca. Vanno cercati a parte, confrontando le due liste di percorsi.
#
function disallineamenti-elenca() {

    local MANIFEST="$DISALLINEAMENTI_MANIFEST"

    # modificati rispetto al manifest
    LC_ALL=C sha256sum -c --quiet "$MANIFEST" 2>/dev/null | sed -n 's/: FAILED$//p'

    # aggiunti in locale: presenti sul disco ma non nel manifest
    LC_ALL=C comm -13 \
        <( cut -d' ' -f3- "$MANIFEST" | LC_ALL=C sort ) \
        <( disallineamenti-elenco | tr '\0' '\n' | LC_ALL=C sort )

}
#
# Raccoglie i file disallineati nella cartella indicata, e ne stampa il resoconto.
#
# La cartella si crea SEMPRE, anche a mano vuota: prima il mkdir stava dentro il ciclo, quindi la
# sua assenza voleva dire tanto "non c'era niente da promuovere" quanto "la raccolta non ha
# guardato". Sono due risposte diverse e nessuno poteva distinguerle; una cartella vuota invece
# e' una risposta.
#
# Sopra la soglia non si copia niente e si spiega perche'. Succede quando l'aggiornamento
# precedente si e' interrotto a meta' e il manifest descrive un albero che non esiste piu': in
# quel caso copiare mezzo framework non aiuta nessuno, e il tar di backup c'e' comunque.
#
# Si legge riga per riga e non con "for f in $( ... )", che spezzerebbe i nomi contenenti spazi in
# piu' percorsi inesistenti; il test [ -f ] li scarterebbe poi in silenzio, e un file come
# _mod/_1200.todo/_src/_templates/_athena/progetti.produzione.form.sprint copy.html non verrebbe
# raccolto mai.
#
# $1 elenco dei file disallineati, uno per riga
# $2 cartella dove copiarli
#
function disallineamenti-raccogli() {

    local OUT="$2"
    local ELENCO=""
    local TOTALE
    local f

    mkdir -p "$OUT"

    # si tiene solo cio' che esiste ed e' un file regolare: il ripiego per data emette anche le
    # directory, e un file cancellato in locale non si puo' copiare. Il filtro va fatto QUI e non
    # dentro il ciclo di copia, o il conteggio direbbe un numero e la cartella ne conterrebbe un
    # altro — ed e' il conteggio quello che si legge nel log del cron
    while IFS= read -r f; do
        if [ -f "$f" ]; then
            ELENCO="$ELENCO$f"$'\n'
        fi
    done < <( printf '%s\n' "$1" )

    TOTALE=$( printf '%s' "$ELENCO" | grep -c . )

    if [ "$TOTALE" -gt "$DISALLINEAMENTI_SOGLIA" ]; then

        echo "ATTENZIONE: $TOTALE disallineamenti, oltre la soglia di $DISALLINEAMENTI_SOGLIA: NON copio niente"
        echo "            di solito vuol dire che l'aggiornamento precedente si e' interrotto a meta' e il"
        echo "            manifest descrive un albero che non esiste piu'. Campione dei primi venti:"
        printf '%s' "$ELENCO" | head -20 | sed -e 's/^/            /'

        return 1

    fi

    printf '%s' "$ELENCO" | while IFS= read -r f; do
        echo "$f è disallineato"
        cp --parents "$f" "$OUT"
    done

    echo "disallineamenti: $TOTALE, raccolti in $OUT"

}

#
# Fotografa la destinazione di un deploy prima di sovrascriverla, per poterla rimettere com'era.
#
# Fix 2026-10-21: _backup.run.sh fa il tar della destinazione, ma nessuno lo usava per tornare
# indietro, e rimettere a mano un tar sopra una produzione rotta non e' un gesto da fare di corsa.
# Qui si fa una copia per hard link ( rsync --link-dest ): costa quasi niente in spazio e in tempo,
# e resta intatta anche dopo il deploy, perche' rsync non scrive i file sul posto ma li sostituisce.
# Si escludono le stesse cose del deploy ( $3 ), cosi' il rollback non tocca var/ e gli altri dati
# che il deploy non porta. La copia sta in <progetto>/var/<data>-deploy-<stadio>/, fuori dalla
# document root, e se ne tengono le ultime tre per stadio.
#
# $1 percorso della document root di destinazione
# $2 prefisso di esecuzione remota, opzionale (es. "ssh -i chiave utente@host")
# $3 le opzioni --exclude del deploy
#
# stampa il percorso della copia, vuoto se non e' riuscita
#
function deploy-snapshot() {

    local DST="$1"
    local VIA="$2"
    local EXC="$3"
    local SNAP="$( dirname "$DST" )/var/$( date '+%Y%m%d%H%M%S' )-deploy-$( basename "$DST" )"

    local SCRIPT='
        mkdir -p "$2" || exit 1
        rsync -a '"$EXC"' --link-dest="$1/" "$1/" "$2/" || exit 1
        ls -d "$( dirname "$2" )"/*-deploy-"$( basename "$1" )" | sort | head -n -3 | xargs -r rm -rf
    '

    if [ -n "$VIA" ]; then
        echo "$SCRIPT" | $VIA "bash -s -- '$DST' '$SNAP'" > /dev/null && echo "$SNAP"
    else
        echo "$SCRIPT" | bash -s -- "$DST" "$SNAP" > /dev/null && echo "$SNAP"
    fi

}

#
# Rimette una destinazione com'era nella copia fatta da deploy-snapshot().
#
# Si torna indietro col solo codice: le patch del database devono essere compatibili all'indietro
# ( si aggiunge in una release, si toglie in una successiva ), cosi' il codice di prima gira anche
# sul database appena aggiornato e non si perdono le scritture fatte nel frattempo. Il dump che
# _mysql.upgrade.sh fa prima delle patch resta nella cartella dei backup del progetto, per il caso
# di una patch fallita a meta', che si valuta a mano.
#
# $1 percorso della document root di destinazione
# $2 prefisso di esecuzione remota, opzionale
# $3 percorso della copia
# $4 le opzioni --exclude del deploy
#
function deploy-rollback() {

    local DST="$1"
    local VIA="$2"
    local SNAP="$3"
    local EXC="$4"

    if [ -z "$SNAP" ]; then
        echo "ERRORE: nessuna copia della destinazione da cui tornare indietro, $DST va sistemata a mano"
        return 1
    fi

    echo "rollback di $DST dalla copia $SNAP"

    local SCRIPT='
        "$1/_src/_sh/_lamp.permissions.open.sh" > /dev/null 2>&1
        rsync -a --delete '"$EXC"' "$2/" "$1/" || exit 1
        "$1/_src/_sh/_lamp.permissions.secure.sh" > /dev/null 2>&1
        rm -rf "$1"/var/cache/*
    '

    if [ -n "$VIA" ]; then
        echo "$SCRIPT" | $VIA "bash -s -- '$DST' '$SNAP'"
    else
        echo "$SCRIPT" | bash -s -- "$DST" "$SNAP"
    fi

}

#
# Applica le patch del database alla destinazione di un deploy.
#
# Fix 2026-10-21: il deploy portava in test o in produzione il codice di DEV, con le sue patch in
# _usr/_database/_patch/, ma non le applicava a nessuno: polmasi PROD era fermo a 202610121100 col
# DEV a 202610151208, cioe' codice nuovo su un database senza le sue colonne. Le applica qui
# _mysql.upgrade.sh della destinazione, col profilo della destinazione: legge la configurazione
# copiata, fa il dump prima, si ferma al primo errore e rifiuta i database anteriori al canone.
#
# $1 percorso della document root di destinazione
# $2 prefisso di esecuzione remota, opzionale ( con l'utente che puo' scrivere i dump )
# $3 profilo del database della destinazione ( TEST, PROD )
#
function deploy-mysql-patch() {

    local DST="$1"
    local VIA="$2"
    local PROF="$3"

    if [ -z "$PROF" ]; then
        echo "ATTENZIONE: profilo del database della destinazione non indicato ( DST_PROFILE ), patch NON applicate"
        return 0
    fi

    echo "patch del database su $DST, profilo $PROF"

    if [ -n "$VIA" ]; then
        $VIA "$DST/_src/_sh/_mysql.upgrade.sh $PROF --si"
    else
        "$DST/_src/_sh/_mysql.upgrade.sh" $PROF --si
    fi

}

#
# Controlla che la destinazione di un deploy risponda.
#
# Chiede la home di DST_URL dalla destinazione stessa, come fa deploy-invalidate-caches(), e fallisce
# su un errore del server ( 5xx ) o su nessuna risposta: un 404 o un redirect al login vogliono dire
# che il framework ha risposto. Senza DST_URL il controllo si salta e lo si
# dice: non si prova a indovinare l'host dal config.json. Sui deploy non girano i test automatici,
# che scrivono nel database e rifiutano la produzione: quelli girano prima, dove si sviluppa.
#
# $1 prefisso di esecuzione remota, opzionale
#
function deploy-check() {

    local VIA="$1"
    local CODE

    if [ -z "$DST_URL" ]; then
        echo "ATTENZIONE: DST_URL non dichiarato, controllo della destinazione saltato"
        return 0
    fi

    if [ -n "$VIA" ]; then
        CODE=$( $VIA "curl -s -o /dev/null -w '%{http_code}' --max-time 60 '$DST_URL/'" )
    else
        CODE=$( curl -s -o /dev/null -w '%{http_code}' --max-time 60 "$DST_URL/" )
    fi

    echo "controllo di $DST_URL/: HTTP $CODE"

    case "$CODE" in
        5??|000) return 1 ;;
        *) return 0 ;;
    esac

}

#
# Porta al canone del framework appena installato un database rimasto alla linea di release precedente.
#
# A ogni release minore o maggiore le patch datate della linea vecchia vengono assorbite nei file base
# e tolte ( capitolo 300 ): un database che non le aveva applicate tutte resta sotto il livello del
# canone, e mysqlPatchCheck() rifiuta di aggiornarlo. Le patch che gli mancano esistono ancora, nella
# release da cui la linea nuova e' partita: la seconda riga di _etc/_current.canon dice quale tag.
#
# Questa funzione legge il livello del database ( dalla prova a vuoto di _mysql.upgrade.sh ), e finche'
# sta sotto il canone risale la catena: scarica lo zip del tag di passaggio, ne legge il canone, e se
# serve passa al tag precedente ( al massimo cinque gradini ). Poi applica le patch partendo dal tag
# piu' vecchio, ciascuno col proprio _mysql.upgrade.sh e con la configurazione del deploy copiata
# accanto, e lascia al chiamante le patch della linea nuova. Le patch di progetto ( usr/database/patch/ )
# non viaggiano coi tag e si applicano dopo, con quelle della linea nuova.
#
# Lavora in <progetto>/var/<data>-gradino/: i tag scaricati si tolgono alla fine, i dump che
# _mysql.upgrade.sh fa prima di ogni gradino restano in <progetto>/var/<data>-gradino/backups/.
#
# Va lanciata dalla document root del deploy appena aggiornato.
#
# $1 profilo del database ( DEV, TEST, PROD )
# $2 repository da cui scaricare i tag ( glisweb, glisdev )
# $3 --prova per fermarsi alle prove a vuoto, senza applicare niente
#
# restituisce 0 se non serviva o se e' andato a buon fine, 1 se il gradino non si e' potuto fare
#
function gw-gradino() {

    local STATO="$1"
    local REPO="$2"
    local PROVA="$3"
    local LIVELLO CANONE TAG ZIP CARTELLA FILE
    local LAVORO="$( dirname "$( pwd )" )/var/$( date '+%Y%m%d%H%M%S' )-gradino"
    local CATENA=()
    local CANONI="./_etc/_current.canon"

    # livello del database, dalla prova a vuoto: senza livello leggibile ci pensa _mysql.upgrade.sh a dirlo
    LIVELLO=$( ./_src/_sh/_mysql.upgrade.sh $STATO 2>/dev/null | sed -n 's/.*livello di patch attuale: \([0-9]\{12\}\).*/\1/p' | head -1 )
    if [ -z "$LIVELLO" -o "$LIVELLO" = "000000000000" ]; then
        return 0
    fi

    # risalgo la catena dei canoni finche' il database non ci sta sopra
    while [ -f "$CANONI" ]; do

        CANONE=$( sed -n 1p "$CANONI" | tr -d '[:space:]' )
        if [ -z "$CANONE" ] || [[ ! "$LIVELLO" < "$CANONE" ]]; then
            break
        fi

        TAG=$( sed -n 2p "$CANONI" | tr -d '[:space:]' )
        if [ -z "$TAG" ]; then
            echo "ERRORE: il database e' al livello $LIVELLO, sotto il canone $CANONE, e il canone non dice da che release passare: va ricostruito"
            return 1
        fi

        if [ ${#CATENA[@]} -ge 5 ]; then
            echo "ERRORE: piu' di cinque gradini per arrivare al canone, il database va ricostruito"
            return 1
        fi

        echo "gradino: il database e' al livello $LIVELLO, sotto il canone $CANONE, passa prima dalla release $TAG"

        # scarico e scompatto il tag, con gli stessi controlli dell'aggiornamento
        mkdir -p "$LAVORO" || return 1
        ZIP="$LAVORO/$TAG.zip"
        if ! wget -q -O "$ZIP" "https://github.com/istricesrl/$REPO/archive/refs/tags/$TAG.zip" || [ ! -s "$ZIP" ]; then
            echo "ERRORE: scaricamento della release $TAG fallito"
            return 1
        fi
        if ! unzip -qq -o "$ZIP" -d "$LAVORO" || [ ! -f "$LAVORO/$REPO-$TAG/_src/_config.php" ]; then
            echo "ERRORE: la release $TAG scaricata non sembra una distribuzione del framework"
            return 1
        fi
        rm -f "$ZIP"

        CARTELLA="$LAVORO/$REPO-$TAG"
        CATENA=( "$CARTELLA" "${CATENA[@]}" )
        CANONI="$CARTELLA/_etc/_current.canon"

    done

    # niente da fare
    if [ ${#CATENA[@]} -eq 0 ]; then
        return 0
    fi

    # un gradino alla volta, dal piu' vecchio, con la configurazione del deploy
    for CARTELLA in "${CATENA[@]}"; do

        mkdir -p "$CARTELLA/src"
        for FILE in config.json shadow.json config.yaml shadow.yaml; do
            [ -f "./src/$FILE" ] && cp -a "./src/$FILE" "$CARTELLA/src/$FILE"
        done
        chmod +x "$CARTELLA"/_src/_sh/*.sh

        echo "gradino: patch della release $( basename "$CARTELLA" )"
        if [ "$PROVA" = "--prova" ]; then
            "$CARTELLA/_src/_sh/_mysql.upgrade.sh" $STATO
        elif ! "$CARTELLA/_src/_sh/_mysql.upgrade.sh" $STATO --si; then
            echo "ERRORE: gradino $( basename "$CARTELLA" ) non riuscito, il dump e' in $LAVORO/backups/"
            return 1
        fi

    done

    # tolgo i tag scaricati, che contengono anche la configurazione copiata; i dump restano
    for CARTELLA in "${CATENA[@]}"; do
        rm -rf "$CARTELLA"
    done
    rmdir "$LAVORO" 2> /dev/null

    echo "gradino completato, il database e' pronto per le patch della linea nuova"
    return 0

}
