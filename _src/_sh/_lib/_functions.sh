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
