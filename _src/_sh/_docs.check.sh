#!/bin/bash

## SCRIPT PER IL CONTROLLO DELLO STATO DELLA DOCUMENTAZIONE
#
# questo script verifica che la documentazione non si sia scollata dal codice, e riporta
# soltanto cio' su cui si puo' agire
#
#   _docs.check.sh                elenco leggibile dei rilievi ( tace se non ce ne sono )
#   _docs.check.sh --todo         li scrive nel formato delle voci di TODO.md
#   _docs.check.sh --metriche     stampa anche le metriche di copertura, che non sono rilievi
#   _docs.check.sh --only <cat>   limita a una categoria
#
# codice di uscita: 0 se non c'e' niente da segnalare, 1 se ci sono rilievi, 2 in caso di errore
#
# REGOLA sul rumore: una categoria con piu' di SOGLIA rilievi emette UNA sola voce aggregata,
# e il testo della voce NON contiene il numero. Serve perche' /etc/cron.daily/controllo-documentazione
# deduplica sul testo: una voce che cambia ogni notte verrebbe riaperta ogni notte.
#
# REGOLA sul perimetro: si guarda SOLO dentro la document root. Un livello sopra vive il READ.md
# del deploy, che contiene gli accessi del progetto e non e' documentazione.
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## funzioni
. ./_lib/_functions.sh

## directory di lavoro
cd $RL || exit 1

BASE="$(pwd)"

## opzioni
TODO=0
METRICHE=0
ONLY=""
while [ $# -gt 0 ]; do
    case "$1" in
        --todo)     TODO=1 ;;
        --metriche) METRICHE=1 ;;
        --only)     shift; ONLY="$1" ;;
        *)          echo "opzione non riconosciuta: $1" >&2; exit 2 ;;
    esac
    shift
done

SOGLIA=10

## i rilievi si accumulano su file e non in una variabile: emetti() li produce dentro una
## pipeline, cioe' in una subshell, e un contatore incrementato li' non tornerebbe mai al
## processo padre. E' il motivo per cui il codice di uscita sarebbe sempre stato 0.
ELENCO="$( mktemp )"
trap 'rm -f "$ELENCO"' EXIT

## il manuale sviluppatore: in _usr/_docs/ dopo il riordino, in radice prima
READMD="./_usr/_docs/READ.md"
[ -f "$READMD" ] || READMD="./READ.md"

# emette un rilievo
#   $1 categoria   $2 testo ( stabile: niente numeri, niente date )
rilievo() {
    if [ $TODO -eq 1 ]; then
        echo "- [ ] doc/$1: $2" >> "$ELENCO"
    else
        printf '  %-14s %s\n' "$1" "$2" >> "$ELENCO"
    fi
}

# decide fra voci singole e voce aggregata
#   $1 categoria   $2 numero di casi   $3 testo aggregato   poi i testi singoli su stdin
emetti() {
    local cat="$1" n="$2" agg="$3"
    if [ "$n" -gt $SOGLIA ]; then
        cat > /dev/null
        rilievo "$cat" "$agg"
    else
        while IFS= read -r r; do [ -n "$r" ] && rilievo "$cat" "$r"; done
    fi
}

attiva() { [ -z "$ONLY" ] || [ "$ONLY" = "$1" ]; }

## ------------------------------------------------------------------ 1. copertura di READ.md
#
# ogni file standard deve avere la sua sezione "### <percorso>". Si escludono i template e gli
# asset, che non si descrivono file per file, e il vendor di composer, che non e' nostro.
if attiva read-md && [ -f "$READMD" ]; then

    declare -A SEZIONI
    while IFS= read -r r; do SEZIONI["${r#\#\#\# }"]=1; done < <( grep '^### ' "$READMD" )

    MANCANTI=$( while IFS= read -r f; do
        [ -n "${SEZIONI[${f#.}]}" ] || echo "${f#.}"
    done < <( find ./_src ./_etc ./_usr -type f \
        -not -path "./_src/_tpl/*"      -not -path "./_src/_twig/*" \
        -not -path "./_src/_templates/*" -not -path "./_src/_lib/_ext/*" \
        -not -path "./_src/_js/*"        -not -path "./_src/_img/*" \
        -not -path "./_usr/_docs/*"      -not -path "./_usr/_test/*" \
        -not -path "./_usr/_examples/*"  -not -path "./_usr/_pages/*" \
        -not -path "./_etc/_dictionaries/*" | sort ) )

    N=$( echo "$MANCANTI" | grep -c . )
    [ "$N" -gt 0 ] && echo "$MANCANTI" | sed 's/^/manca la sezione in READ.md per /' \
        | emetti read-md "$N" "file standard senza una sezione in READ.md"

fi

## ------------------------------------------------------------------ 2. sezioni orfane
#
# il controllo inverso: una sezione che descrive un file che non esiste piu' e' documentazione
# che mente, ed e' il residuo tipico di una rinomina
if attiva read-md-orfane && [ -f "$READMD" ]; then

    ORFANE=$( grep '^### /' "$READMD" | sed 's/^### //' | while IFS= read -r p; do
        # un'intestazione con segnaposto ( _<dictionary>.<lang>-<country>.conf ) descrive una
        # famiglia di file, non un file: non c'e' niente da verificare
        case "$p" in *'<'*) continue ;; esac
        # le intestazioni multi-file hanno la forma "/a, /b e /c": si controlla il primo, e la
        # virgola va tolta o il percorso non esiste mai
        primo="${p%% *}"
        primo="${primo%,}"
        [ -e ".$primo" ] || echo "$p"
    done )

    N=$( echo "$ORFANE" | grep -c . )
    [ "$N" -gt 0 ] && echo "$ORFANE" | sed 's/^/sezione di READ.md senza il file corrispondente: /' \
        | emetti read-md-orfane "$N" "sezioni di READ.md che descrivono file inesistenti"

fi

## ------------------------------------------------------------------ 3. manuali dei moduli
#
# si controllano i moduli ATTIVI, non tutti: documentare un modulo che nessuno ha acceso non
# serve a nessuno, e il conteggio su tutti e 79 sarebbe un muro invece di una curva
MODULI=$( php -r '
    $p = "src/config.json";
    if( ! file_exists( $p ) ) exit;
    $c = json_decode( file_get_contents( $p ), true );
    if( isset( $c["mods"]["active"]["array"] ) )
        foreach( $c["mods"]["active"]["array"] as $m ) echo $m . "\n";
' 2> /dev/null )

for tipo in READ USER; do

    cat_=$( echo "modulo-$tipo" | tr 'A-Z' 'a-z' )
    attiva "$cat_" || continue

    SENZA=$( echo "$MODULI" | while IFS= read -r m; do
        [ -n "$m" ] || continue
        [ -f "./mod/$m/$tipo.md" ] && continue
        [ -f "./_mod/_$m/$tipo.md" ] && continue
        echo "$m"
    done )

    N=$( echo "$SENZA" | grep -c . )
    [ "$N" -gt 0 ] && echo "$SENZA" | sed "s|^|manca $tipo.md al modulo attivo |" \
        | emetti "$cat_" "$N" "moduli attivi senza $tipo.md"

done

## ------------------------------------------------------------------ 4. vocabolario dei marcatori
#
# i marcatori hanno un vocabolario chiuso: un refuso non produce un errore, produce una
# sezione che non viene mai filtrata o un callout che resta una citazione qualunque
if attiva marcatori; then

    SORGENTI=$( find ./_usr/_docs ./_mod ./mod ./usr/docs -name '*.md' -not -path '*/_legacy/*' 2> /dev/null )

    if [ -n "$SORGENTI" ]; then

        FUORI=$( grep -hoE '^<!--[[:space:]]*@[a-z]+:' $SORGENTI 2> /dev/null \
            | sed -E 's/^<!--[[:space:]]*@([a-z]+):/\1/' | sort -u \
            | grep -vxE 'pubblico|linea|pagina|modulo|shot' )

        # NON si segnala ogni citazione con un grassetto in testa: "> **Nota bene** — ..." e'
        # prosa legittima, e vietarla sarebbe una regola contro chi scrive. Si segnalano solo
        # le forme che un callout lo volevano essere di sicuro, cioe' quelle che iniziano per
        # "solo " senza essere nel vocabolario: "> **solo stabile**" e' un refuso, e senza
        # questo controllo resterebbe una citazione grigia che nessuno nota.
        FUORI="$FUORI
$( grep -hoiE '^> \*\*solo [^*]+\*\*' $SORGENTI 2> /dev/null \
            | sed -E 's/^> \*\*(.*)\*\*/\1/' | sort -u \
            | grep -vixE 'solo stable|solo unstable|solo operatori|solo amministratori|solo sviluppatori' )"

        N=$( echo "$FUORI" | grep -c . )
        [ "$N" -gt 0 ] && echo "$FUORI" | grep . | sed 's/^/marcatore fuori vocabolario: /' \
            | emetti marcatori "$N" "marcatori fuori dal vocabolario nei sorgenti della documentazione"

    fi

fi

## ------------------------------------------------------------------ 5. screenshot
#
# ogni immagine deve avere la sua dichiarazione e viceversa: e' il controllo che rende
# impossibile uno scatto orfano o una dichiarazione senza uso
if attiva screenshot; then

    SORGENTI=$( find ./_usr/_docs ./_mod ./mod ./usr/docs -name '*.md' -not -path '*/_legacy/*' 2> /dev/null )

    if [ -n "$SORGENTI" ]; then

        USATI=$( grep -hoE '!\[[^]]*\]\(shot/[^)]+\.png\)' $SORGENTI 2> /dev/null \
            | sed -E 's|.*\(shot/(.*)\.png\)|\1|' | sort -u )
        DICHIARATI=$( grep -hoE '^<!--[[:space:]]*@shot:[[:space:]]*[^|]+' $SORGENTI 2> /dev/null \
            | sed -E 's/^<!--[[:space:]]*@shot:[[:space:]]*//' | sed 's/[[:space:]]*$//' | sort -u )

        SBILANCIATI=$( comm -3 <( echo "$USATI" ) <( echo "$DICHIARATI" ) | tr -d '\t' | grep . )
        N=$( echo "$SBILANCIATI" | grep -c . )
        [ "$N" -gt 0 ] && echo "$SBILANCIATI" | sed 's/^/screenshot usato ma non dichiarato, o viceversa: /' \
            | emetti screenshot "$N" "screenshot con dichiarazione e uso disallineati"

    fi

fi

## ------------------------------------------------------------------ 6. protezione del manuale
#
# il manuale di progetto descrive le personalizzazioni del cliente: se la protezione non c'e',
# le sta servendo in chiaro a chiunque
if attiva protezione && [ -d ./usr/pages/manual ]; then
    if [ ! -f ./usr/pages/manual/.htaccess ]; then
        rilievo protezione "il manuale di progetto e' pubblicato senza .htaccess di protezione"
    elif ! grep -q 'Require valid-user' ./usr/pages/manual/.htaccess; then
        rilievo protezione "il .htaccess del manuale di progetto non richiede autenticazione"
    fi
fi

## ------------------------------------------------------------------ 7. legacy da travasare
if attiva legacy && [ -d ./_usr/_docs/_legacy ]; then
    N=$( find ./_usr/_docs/_legacy -name '*.dox' | wc -l )
    [ "$N" -gt 0 ] && rilievo legacy "restano .dox in _usr/_docs/_legacy da travasare nei READ.md e USER.md"
fi

## ------------------------------------------------------------------ 8. sorgente piu' recente
#
# CLAUDE.md e' scritto per un agente e non e' documentazione, ma e' la sorgente da cui si
# scrive il manuale sviluppatore del progetto: se e' piu' recente, il manuale e' indietro
if attiva sorgente && [ -f ../CLAUDE.md ] && [ -f ./usr/docs/READ.md ]; then
    [ ../CLAUDE.md -nt ./usr/docs/READ.md ] && \
        rilievo sorgente "CLAUDE.md e' piu' recente del manuale sviluppatore che ne discende"
fi

## ------------------------------------------------------------------ 9. metriche
#
# non sono rilievi e non diventano voci: sono numeri che si guardano per capire se il debito
# scende. Una voce per ciascuno verrebbe riaperta a ogni variazione.
if [ $METRICHE -eq 1 ] && [ $TODO -eq 0 ]; then

    {
    echo
    echo "  metriche"

    for d in _src/_lib _src/_api _src/_config _src/_inc; do
        [ -d "./$d" ] || continue
        TOT=$( find "./$d" -name '*.php' -not -path '*/_ext/*' | wc -l )
        CON=$( grep -rl '@file' "./$d" --include='*.php' 2> /dev/null | wc -l )
        printf '    %-14s @file %s su %s file\n' "$d" "$CON" "$TOT"
    done

    TD=$( grep -rl 'TODO documentare' ./_src ./_mod --include='*.php' 2> /dev/null \
          | grep -v '/_ext/' | wc -l )
    printf '    %-14s %s file\n' "TODO documentare" "$TD"

    if [ -f ./var/log/doxygen.warn.log ]; then
        printf '    %-14s %s\n' "avvisi doxygen" "$( wc -l < ./var/log/doxygen.warn.log )"
    fi
    } >> "$ELENCO"

fi

## esito
cat "$ELENCO"

if [ ! -s "$ELENCO" ]; then
    exit 0
fi

exit 1
