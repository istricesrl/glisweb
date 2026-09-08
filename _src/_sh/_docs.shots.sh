#!/bin/bash

## SCRIPT PER LA CATTURA DEGLI SCREENSHOT DELLA DOCUMENTAZIONE
#
# questo script rigenera le immagini delle maschere citate nei sorgenti della documentazione,
# fotografando le pagine reali dell'applicazione
#
#   _docs.shots.sh                 rigenera solo gli scatti scaduti
#   _docs.shots.sh --force         rigenera tutto
#   _docs.shots.sh --dry-run       elenca cosa rigenererebbe, non scrive
#   _docs.shots.sh --only <id>     un solo scatto
#
# ambiente:
#   DOCS_USER, DOCS_PASS   credenziali dell'utente con cui fotografare le maschere
#   DOCS_HOST              host da fotografare, default $( hostname -f ) del sito corrente
#
# COME SI DICHIARA UNO SCATTO
#
# La dichiarazione sta ACCANTO all'immagine che lo mostra, nel sorgente markdown:
#
#   ![elenco dei prelievi](shot/prelievi.elenco.png)
#   <!-- @shot: prelievi.elenco | /prelievi | 1440x900 | #main | 3000 -->
#
# campi: id | percorso | larghezzaXaltezza | selettore atteso ( facoltativo ) | attesa in ms
#
# Tenere dichiarazione e uso nello stesso punto e' cio' che rende impossibile uno scatto
# dichiarato e mai mostrato, o mostrato e mai dichiarato: _docs.check.sh lo verifica.
#
# PERCHE' NON C'E' UN ENDPOINT DI AUTOLOGIN
#
# Le maschere da fotografare stanno dietro autenticazione, e chromium headless non sa ricevere
# un cookie dalla riga di comando. La via ovvia sarebbe un task che apre la sessione e
# reindirizza, ma dal 2026-09-05 i task richiedono gia' una sessione ( checkTaskPrivilege ),
# quindi quel task dovrebbe SCAVALCARE l'autenticazione — e verrebbe spedito a ogni progetto
# cliente. Non vale il rischio per delle figure.
#
# Si fa invece cosi': la pagina si scarica autenticata con _smoke.curl.sh, che il framework ha
# gia' e che tiene il suo cookie jar; le si inietta un <base href> verso il sito, cosi' CSS,
# font e immagini continuano a caricarsi; e si fotografa il file locale. Nessuna credenziale
# passa da chromium e nessun endpoint nuovo viene esposto.
#
# GLI SCATTI SI GENERANO SU DEV E SI VERSIONANO
#
# I PNG entrano nel repository come qualunque altro sorgente: sui progetti cliente chromium non
# c'e' e le maschere hanno i dati del cliente dentro. Chi rigenera lo fa qui, e il risultato
# viaggia come file.
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## funzioni
. ./_lib/_functions.sh

## directory di lavoro
cd $RL || exit 1

## informazioni
echo "lavoro su: $(pwd)"

## opzioni
FORZA=0
SECCO=0
SOLO=""
while [ $# -gt 0 ]; do
    case "$1" in
        --force)   FORZA=1 ;;
        --dry-run) SECCO=1 ;;
        --only)    shift; SOLO="$1" ;;
        *)         echo "opzione non riconosciuta: $1" >&2; exit 2 ;;
    esac
    shift
done

## dipendenze
CHROME=""
for c in chromium chromium-browser google-chrome; do
    command -v "$c" > /dev/null && { CHROME="$c"; break; }
done

if [ -z "$CHROME" ]; then
    echo "chromium non installato: gli screenshot si rigenerano solo dove c'e' un browser" >&2
    exit 1
fi

if [ -z "${DOCS_USER:-}" ] || [ -z "${DOCS_PASS:-}" ]; then
    echo "servono DOCS_USER e DOCS_PASS: sono le credenziali con cui fotografare le maschere" >&2
    exit 1
fi

HOST="${DOCS_HOST:-$( grep -oE 'https?://[^"]+' ./etc/docs.host.conf 2>/dev/null | head -1 )}"
if [ -z "$HOST" ]; then
    echo "host da fotografare non dichiarato: usare DOCS_HOST oppure etc/docs.host.conf" >&2
    exit 1
fi

## raccolta delle dichiarazioni dai sorgenti della documentazione
SORGENTI=$( find ./_usr/_docs ./_mod ./mod ./usr/docs -name '*.md' 2> /dev/null )
[ -n "$SORGENTI" ] || { echo "nessun sorgente markdown, niente da fare"; exit 0; }

DICHIARAZIONI=$( grep -h -oE '^<!--[[:space:]]*@shot:[[:space:]]*[^>]+-->' $SORGENTI 2> /dev/null \
                 | sed -E 's/^<!--[[:space:]]*@shot:[[:space:]]*//; s/[[:space:]]*-->$//' | sort -u )

[ -n "$DICHIARAZIONI" ] || { echo "nessuno scatto dichiarato, niente da fare"; exit 0; }

## il piu' recente fra i file che compongono una maschera: se e' piu' nuovo dello scatto,
## lo scatto ritrae una versione che non esiste piu'
RECENTE=$( find ./_src/_tpl ./_src/_twig ./_src/_templates ./_src/_css ./_src/_js \
                ./_mod ./mod ./src -type f \( -name '*.twig' -o -name '*.html' -o -name '*.css' -o -name '*.php' \) \
                -newer ./_etc/_current.release -print 2> /dev/null | head -1 )

## login una volta sola, poi si riusa il cookie jar
#
# Il login si fa qui e non con _smoke.curl.sh, che pure conosce la stessa ricetta, per due
# motivi: quello script ha come default un host CABLATO ( glisdev ) e su un altro progetto
# interrogherebbe il sito sbagliato in silenzio; e il suo `get` antepone la riga di stato al
# corpo, quindi non e' un downloader. La ricetta e' comunque la sua: POST di __login__[user] e
# __login__[pasw], nessun token CSRF, cookie jar in var/tmp.
JAR="./var/tmp/docs-shots-cookies.txt"
mkdir -p ./var/tmp && rm -f "$JAR"

CURL=( curl --silent --show-error --location --insecure --max-time 30 --cookie "$JAR" --cookie-jar "$JAR" )
LOGIN_PATH="${DOCS_LOGIN_PATH:-/admin}"

if [ $SECCO -eq 0 ]; then

    "${CURL[@]}" --output /dev/null "$HOST$LOGIN_PATH"

    "${CURL[@]}" --output /dev/null \
        --data-urlencode "__login__[user]=$DOCS_USER" \
        --data-urlencode "__login__[pasw]=$DOCS_PASS" \
        "$HOST$LOGIN_PATH"

fi

FATTI=0
SALTATI=0
FALLITI=0

echo "$DICHIARAZIONI" | while IFS='|' read -r ID PERCORSO DIM SELETTORE ATTESA; do

    ID=$( echo "$ID" | tr -d '[:space:]' )
    PERCORSO=$( echo "$PERCORSO" | tr -d '[:space:]' )
    DIM=$( echo "${DIM:-1440x900}" | tr -d '[:space:]' )
    ATTESA=$( echo "${ATTESA:-3000}" | tr -d '[:space:]' )

    [ -n "$ID" ] || continue
    [ -z "$SOLO" ] || [ "$SOLO" = "$ID" ] || continue

    ## lo scatto dello standard sta sotto _usr, quello di progetto sotto usr
    DEST="./_usr/_docs/_shot/$ID.png"
    grep -ql "@shot:[[:space:]]*$ID" ./usr/docs/*.md ./usr/docs/*/*.md ./mod/*/*.md 2> /dev/null \
        && DEST="./usr/docs/shot/$ID.png"

    ## serve rigenerare?
    if [ $FORZA -eq 0 ] && [ -f "$DEST" ]; then
        SCADUTO=0
        [ -n "$RECENTE" ] && [ "$RECENTE" -nt "$DEST" ] && SCADUTO=1
        for s in $SORGENTI; do
            grep -q "@shot:[[:space:]]*$ID" "$s" 2> /dev/null && [ "$s" -nt "$DEST" ] && SCADUTO=1
        done
        [ -n "$( find "$DEST" -mtime +90 2> /dev/null )" ] && SCADUTO=1
        if [ $SCADUTO -eq 0 ]; then
            echo "  invariato $ID"
            continue
        fi
    fi

    if [ $SECCO -eq 1 ]; then
        echo "  [prova] $ID -> $DEST  ( $HOST$PERCORSO, $DIM )"
        continue
    fi

    mkdir -p "$( dirname "$DEST" )"

    ## la pagina si scarica autenticata, poi si fotografa in locale
    TMP=$( mktemp -d )
    if ! "${CURL[@]}" --output "$TMP/p.html" "$HOST$PERCORSO" 2> /dev/null; then
        echo "  FALLITO   $ID: non ho potuto scaricare $PERCORSO" >&2
        rm -rf "$TMP"; continue
    fi

    ## senza <base href> il file locale non trova ne' CSS ne' font ne' immagini
    sed -i "0,/<head>/s|<head>|<head><base href=\"$HOST/\">|" "$TMP/p.html"

    ## un selettore atteso e' la prova che la pagina e' quella giusta e non un login
    if [ -n "$( echo "$SELETTORE" | tr -d '[:space:]' )" ]; then
        SEL=$( echo "$SELETTORE" | tr -d '[:space:]' | sed 's/^#//' )
        if ! grep -q "id=\"$SEL\"\|class=\"[^\"]*$SEL" "$TMP/p.html"; then
            echo "  FALLITO   $ID: la pagina scaricata non contiene $SELETTORE ( sessione scaduta? )" >&2
            rm -rf "$TMP"; continue
        fi
    fi

    "$CHROME" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
              --window-size="${DIM/x/,}" --virtual-time-budget="$ATTESA" \
              --screenshot="$TMP/s.png" "file://$TMP/p.html" > /dev/null 2>&1

    if [ ! -s "$TMP/s.png" ]; then
        echo "  FALLITO   $ID: chromium non ha prodotto l'immagine" >&2
        rm -rf "$TMP"; continue
    fi

    mv "$TMP/s.png" "$DEST"
    chown root:www-data "$DEST" 2> /dev/null
    chmod 640 "$DEST"
    rm -rf "$TMP"

    echo "  generato  $ID -> $DEST ( $( stat -c %s "$DEST" ) byte )"

done

## la sessione non serve piu': il cookie jar contiene un PHPSESSID valido e non va lasciato in giro
[ $SECCO -eq 0 ] && rm -f "$JAR"

exit 0

## NOTA
#
# _docs.check.sh verifica che ogni immagine citata abbia la sua dichiarazione e viceversa, e
# segnala gli scatti piu' vecchi della maschera che ritraggono. Vedi la sezione sulla
# documentazione in _etc/_claude/_claude.framework.md
#
