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
# LE TRE TRAPPOLE, TUTTE PAGATE IL 2026-09-20
#
# Sono venute fuori facendo a mano i due scatti del capitolo di athena, e valgono su qualunque
# deploy, non solo qui. Fino a che non erano risolte questo script non fotografava niente:
#
# 1. IL LOGIN COL POST DEL FORM LO RIFIUTA L'ANTI-SPAM. Dove reCAPTCHA v3 e' configurato, una
#    POST di __login__[user]/__login__[pasw] senza token finisce in var/log/auth.err con
#    "check anti spam al login fallito per token non ricevuto", e la sessione non si apre. La
#    via che funziona e' HTTP Basic: _src/_config/_210.auth.php intercetta PHP_AUTH_USER /
#    PHP_AUTH_PW, definisce LOGIN_VIA_HTTP_HEADER e su quella costante il controllo anti-spam
#    viene saltato ( "check anti spam al login saltato per login via HTTP header" ). Le
#    credenziali si mandano quindi con --user, su OGNI richiesta e non solo sul login: il
#    login via header e' stateless, non rigenera l'id di sessione, e ripeterlo costa niente
#    mentre rende lo scatto immune a una sessione scaduta a meta' giro.
#
# 2. CHROMIUM BLOCCA I FONT DELLE ICONE. La pagina si fotografa da file://, quindi tutto cio'
#    che il <base href> fa scaricare dal sito e' cross-origin, e sui @font-face vale CORS: le
#    icone escono tutte a quadratino. Si spegne con --disable-web-security, che chromium
#    accetta solo insieme a un --user-data-dir suo ( per questo se ne crea uno usa-e-getta
#    dentro la cartella temporanea dello scatto ).
#
# 3. IL PANNELLO DEL CONSENSO AI COOKIE COPRE LA MASCHERA. Finche' il consenso non e' espresso
#    l'overlay di _inc/_cookie.overlay.twig torna su ogni pagina, ed e' esattamente quello che
#    si vede nella figura. Si dichiara una volta sola sul cookie jar, prima di scaricare le
#    pagine: vedi il blocco "consenso ai cookie" piu' sotto.
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
#
# Gli alberi sono gli stessi che compone _src/_cli/_docs.build.php: i capitoli di _usr/_docs,
# i READ.md/USER.md dei moduli e quelli dei template. Senza _src/_tpl e src/tpl qui dentro gli
# unici scatti dichiarati oggi — i quattro del capitolo di athena — non li vedrebbe nessuno.
SORGENTI=$( find ./_usr/_docs ./_mod ./mod ./usr/docs ./_src/_tpl ./src/tpl -name '*.md' 2> /dev/null )
[ -n "$SORGENTI" ] || { echo "nessun sorgente markdown, niente da fare"; exit 0; }

DICHIARAZIONI=$( grep -h -oE '^<!--[[:space:]]*@shot:[[:space:]]*[^>]+-->' $SORGENTI 2> /dev/null \
                 | sed -E 's/^<!--[[:space:]]*@shot:[[:space:]]*//; s/[[:space:]]*-->$//' | sort -u )

[ -n "$DICHIARAZIONI" ] || { echo "nessuno scatto dichiarato, niente da fare"; exit 0; }

## il piu' recente fra i file che compongono una maschera: se e' piu' nuovo dello scatto,
## lo scatto ritrae una versione che non esiste piu'
RECENTE=$( find ./_src/_tpl ./_src/_twig ./_src/_templates ./_src/_css ./_src/_js \
                ./_mod ./mod ./src -type f \( -name '*.twig' -o -name '*.html' -o -name '*.css' -o -name '*.php' \) \
                -newer ./_etc/_current.release -print 2> /dev/null | head -1 )

## autenticazione: HTTP Basic, su ogni richiesta
#
# Il login si fa qui e non con _smoke.curl.sh, che pure conosce una ricetta simile, per due
# motivi: quello script ha come default un host CABLATO ( glisdev ) e su un altro progetto
# interrogherebbe il sito sbagliato in silenzio; e il suo `get` antepone la riga di stato al
# corpo, quindi non e' un downloader.
#
# La ricetta pero' non e' la sua: il POST di __login__[user]/__login__[pasw] lo rifiuta
# l'anti-spam ( trappola 1 in testa al file ), quindi le credenziali viaggiano in HTTP Basic
# con --user, su ogni richiesta. Il cookie jar resta, ma non serve piu' a tenere la sessione:
# serve a tenere il consenso ai cookie.
JAR="./var/tmp/docs-shots-cookies.txt"
mkdir -p ./var/tmp && rm -f "$JAR"

# --globoff perche' gli indirizzi delle maschere sono pieni di parentesi quadre ( i filtri di
# una vista si scrivono __view__[<id>][__search__]=... ) e senza di lui curl le legge come un
# intervallo da espandere e non scarica niente
CURL=( curl --silent --show-error --location --insecure --max-time 30 --globoff \
       --user "$DOCS_USER:$DOCS_PASS" --cookie "$JAR" --cookie-jar "$JAR" )
LOGIN_PATH="${DOCS_LOGIN_PATH:-/admin}"

## consenso ai cookie: senza, l'overlay copre ogni maschera
#
# Quali cookie di terze parti dichiari il deploy non si sa da qui, e cambia da progetto a
# progetto: si leggono dal markup dell'overlay i campi __cookie__[<nome>][value] e si rimanda
# la stessa richiesta dichiarando "non autorizzo". La risposta setta il cookie `privacy`
# ( _src/_config/_065.privacy.php ) nel jar, e da li' in avanti l'overlay non compare piu'.
# Il "no" e' anche la risposta giusta per una figura: la pagina fotografata non deve caricare
# gli analytics di nessuno.
if [ $SECCO -eq 0 ]; then

    PAGINA=$( mktemp )
    "${CURL[@]}" --output "$PAGINA" "$HOST$LOGIN_PATH"

    CONSENSI=()
    while read -r NOME; do

        [ -n "$NOME" ] || continue

        ## owner e tipo stanno negli hidden accanto al campo del valore: si leggono di li'
        ## invece di darli per scontati, perche' il giorno che l'overlay chiedera' anche per
        ## i cookie propri questo continuera' a funzionare
        OWNER=$( grep -oE "__cookie__\[$NOME\]\[owner\]\"[^>]*value=\"[^\"]+\"" "$PAGINA" \
                 | sed -E 's/.*value="([^"]+)".*/\1/' | head -1 )
        TIPO=$( grep -oE "__cookie__\[$NOME\]\[type\]\"[^>]*value=\"[^\"]+\"" "$PAGINA" \
                | sed -E 's/.*value="([^"]+)".*/\1/' | head -1 )

        CONSENSI+=( --data-urlencode "__cookie__[$NOME][value]=no" \
                    --data-urlencode "__cookie__[$NOME][owner]=${OWNER:-terzi}" \
                    --data-urlencode "__cookie__[$NOME][type]=${TIPO:-analitici}" )

    done < <( grep -oE 'name="__cookie__\[[^]]+\]\[value\]"' "$PAGINA" \
              | sed -E 's/.*__cookie__\[([^]]+)\].*/\1/' | sort -u )

    if [ ${#CONSENSI[@]} -gt 0 ]; then
        echo "consenso dichiarato per $(( ${#CONSENSI[@]} / 3 )) cookie di terze parti"
        "${CURL[@]}" --output /dev/null "${CONSENSI[@]}" "$HOST$LOGIN_PATH"
    fi

    rm -f "$PAGINA"

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
    grep -ql "@shot:[[:space:]]*$ID" ./usr/docs/*.md ./usr/docs/*/*.md ./mod/*/*.md ./src/tpl/*/*.md 2> /dev/null \
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

    ## --disable-web-security: dalla pagina locale tutto cio' che il <base href> fa scaricare
    ## dal sito e' cross-origin, e sui @font-face CORS vale davvero — senza, ogni icona esce a
    ## quadratino. Chromium lo accetta solo con un profilo tutto suo, che muore col TMP
    "$CHROME" --headless=new --disable-gpu --no-sandbox --hide-scrollbars \
              --disable-web-security --user-data-dir="$TMP/chrome" \
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
