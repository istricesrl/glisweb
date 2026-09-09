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
# si fa solo se il file properties dichiara DEPLOY_URL, altrimenti si ricorda all'operatore di
# lanciarlo a mano. Non si prova a indovinare l'host dal config.json: e' un JSON con i profili
# per ambiente, e leggerlo dalla shell sarebbe piu' fragile del problema che risolve.
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
    if [ -n "$DEPLOY_URL" ]; then

        echo "svuoto la cache dei contenuti: $DEPLOY_URL/task/memcache.clean"

        if curl -s -f -o /dev/null --max-time 60 "$DEPLOY_URL/task/memcache.clean"; then
            echo "cache dei contenuti svuotata"
        else
            echo "ATTENZIONE: chiamata a $DEPLOY_URL/task/memcache.clean fallita, lanciarla a mano dal browser"
        fi

    else

        echo "ATTENZIONE: DEPLOY_URL non indicato nel file properties, la cache dei contenuti in memcache NON e' stata svuotata"
        echo "            lanciare a mano /task/memcache.clean sul sito di destinazione"

    fi

}
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
