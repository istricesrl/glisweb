#!/bin/bash

## SCRIPT PER IL CONTROLLO DELLO STATO DELLA DOCUMENTAZIONE
#
# questo script verifica che la documentazione non si sia scollata dal codice, e riporta
# soltanto cio' su cui si puo' agire
#
#   _docs.check.sh                elenco leggibile dei rilievi ( tace se non ce ne sono )
#   _docs.check.sh --todo         li scrive nel formato delle voci di TODO.md
#   _docs.check.sh --metriche     stampa anche le metriche di copertura, che non sono rilievi
#   _docs.check.sh --copertura    inventario: ogni file standard e DOVE e' documentato
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
# REGOLA sulla linea: si documenta la linea NUOVA e non il legacy, che convive di proposito per
# lasciare migrare un progetto un pezzo per volta. I due si riconoscono dal nome, senza guardare
# dentro i file: un modulo della linea nuova ha il codice a CINQUE caratteri ( _CT000.contatti )
# contro i quattro del legacy ( _4000.catalogo ), e un template nuovo sta in _src/_tpl/ e usa
# Twig contro i .html di _src/_templates/. Contare anche il legacy non e' prudenza: e' un muro
# che non scende mai, e un numero che non scende smette di essere letto.
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
COPERTURA=0
ONLY=""
while [ $# -gt 0 ]; do
    case "$1" in
        --todo)      TODO=1 ;;
        --metriche)  METRICHE=1 ;;
        --copertura) COPERTURA=1 ;;
        --only)      shift; ONLY="$1" ;;
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

## i sorgenti della documentazione, tutti
#
# Le sezioni "### <percorso>" non stanno piu' in un file solo: dal travaso del 16/09/2026 il
# manuale e' fatto di capitoli ( _usr/_docs/_read/ ), e la documentazione di un modulo o di un
# template vive NEL modulo o NEL template. Cercare in un file solo direbbe che manca tutto.
#
# Vale la coppia standard/custom di sempre, e vale la REGOLA sulla linea: niente legacy.
sorgenti_doc() {
    ls -1 ./_usr/_docs/READ.md ./_usr/_docs/USER.md ./usr/docs/READ.md ./usr/docs/USER.md \
          ./_usr/_docs/_read/*.md ./_usr/_docs/_user/*.md ./_usr/_docs/_quickstart/*.md \
          ./usr/docs/read/*.md    ./usr/docs/user/*.md    ./usr/docs/quickstart/*.md \
          ./_src/_tpl/*/READ.md   ./_src/_tpl/*/USER.md \
          ./src/tpl/*/READ.md     ./src/tpl/*/USER.md \
          2> /dev/null
    # i moduli: solo la linea nuova, che si riconosce dal codice a cinque caratteri
    for m in ./_mod/*/ ./mod/*/; do
        [ -d "$m" ] || continue
        cod="$( basename "$m" )"; cod="${cod#_}"; cod="${cod%%.*}"
        [ ${#cod} -eq 5 ] || continue
        ls -1 "$m"READ.md "$m"USER.md 2> /dev/null
    done
    # il manuale in radice, finche' esiste: prima del travaso era l'unico sorgente
    [ -f ./READ.md ] && echo ./READ.md
    return 0
}

# espande l'intestazione di una sezione nei percorsi che dichiara
#
# Un'intestazione puo' descrivere piu' file ( "/a, /b e /c" ): contarne uno solo lasciava gli
# altri fra i non documentati pur essendo documentati nella stessa riga.
espandi_percorsi() {
    echo "$1" | sed 's/,/ /g; s/ e / /g' | tr ' ' '\n' | grep '^/' | sed 's/[[:space:]]*$//'
}

## mappa percorso -> sorgente che lo documenta, e i percorsi documentati in piu' di un posto
declare -A DOVE
declare -A DOPPI

while IFS= read -r f; do
    while IFS= read -r r; do
        case "$r" in *'<'*) continue ;; esac
        while IFS= read -r p; do
            [ -n "$p" ] || continue
            if [ -n "${DOVE[$p]}" ] && [ "${DOVE[$p]}" != "${f#./}" ]; then
                DOPPI[$p]="${DOVE[$p]} e ${f#./}"
            else
                DOVE[$p]="${f#./}"
            fi
        done < <( espandi_percorsi "${r#\#\#\# }" )
    done < <( grep '^### /' "$f" 2> /dev/null )
done < <( sorgenti_doc )

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

## l'insieme dei file standard che vanno documentati uno per uno
#
# Si escludono i template e gli asset, che non si descrivono file per file, e il vendor di
# composer, che non e' nostro.
da_documentare() {
    find ./_src ./_etc ./_usr -type f \
        -not -path "./_src/_tpl/*"      -not -path "./_src/_twig/*" \
        -not -path "./_src/_templates/*" -not -path "./_src/_lib/_ext/*" \
        -not -path "./_src/_js/*"        -not -path "./_src/_img/*" \
        -not -path "./_usr/_docs/*"      -not -path "./_usr/_test/*" \
        -not -path "./_usr/_examples/*"  -not -path "./_usr/_pages/*" \
        -not -path "./_etc/_dictionaries/*" | sort
}

## ------------------------------------------------------------------ 1. copertura della reference
#
# ogni file standard deve avere la sua sezione "### <percorso>", in QUALUNQUE sorgente della
# documentazione: il capitolo del manuale, il READ.md del suo modulo, quello del suo template.
if attiva read-md; then

    MANCANTI=$( while IFS= read -r f; do
        [ -n "${DOVE[${f#.}]}" ] || echo "${f#.}"
    done < <( da_documentare ) )

    N=$( echo "$MANCANTI" | grep -c . )
    [ "$N" -gt 0 ] && echo "$MANCANTI" | sed 's/^/manca la sezione di documentazione per /' \
        | emetti read-md "$N" "file standard senza una sezione nella documentazione"

fi

## ------------------------------------------------------------------ 2. sezioni orfane
#
# il controllo inverso: una sezione che descrive un file che non esiste piu' e' documentazione
# che mente, ed e' il residuo tipico di una rinomina
if attiva read-md-orfane; then

    ORFANE=$( for p in "${!DOVE[@]}"; do
        [ -e ".$p" ] || echo "$p ( ${DOVE[$p]} )"
    done | sort )

    N=$( echo "$ORFANE" | grep -c . )
    [ "$N" -gt 0 ] && echo "$ORFANE" | sed 's/^/sezione senza il file corrispondente: /' \
        | emetti read-md-orfane "$N" "sezioni che descrivono file inesistenti"

fi

## ------------------------------------------------------------------ 2b. sezioni in doppio
#
# la regola dei file di progetto vale anche qui: una cosa sta in un posto solo. Lo stesso file
# descritto in due sorgenti produce due verita' che divergono al primo aggiornamento, e chi
# legge non sa quale delle due vale.
if attiva read-md-doppie; then

    DOPPIE=$( for p in "${!DOPPI[@]}"; do echo "$p documentato in ${DOPPI[$p]}"; done | sort )

    N=$( echo "$DOPPIE" | grep -c . )
    [ "$N" -gt 0 ] && echo "$DOPPIE" | sed 's/^/in doppio: /' \
        | emetti read-md-doppie "$N" "file descritti in piu' di un sorgente di documentazione"

fi

## ------------------------------------------------------------------ 3. manuali dei moduli
#
# si controllano i moduli della LINEA NUOVA, riconosciuti dal codice a cinque caratteri.
#
# Il criterio di prima erano i moduli ATTIVI, letti da src/config.json, e misurava l'insieme
# esattamente sbagliato: qui i quaranta attivi sono tutti e quaranta legacy, quindi il rilievo
# chiedeva di documentare quaranta moduli che nessuno documentera' mai e taceva sui ventisei
# nuovi, che sono quelli che contano. "Attivo" dice quali moduli servono a QUESTO deploy;
# "nuovo" dice quali il framework mantiene, e la documentazione segue il secondo.
#
# Il criterio e' il nome e non la presenza sull'altro deploy di sviluppo, che pure oggi
# coincide quasi: dev'essere leggibile da un deploy cliente, dove l'altro deploy non esiste.
# Regge da solo, ed e' verificabile con un segnale indipendente: nessuno dei cinquantatre
# moduli a quattro caratteri usa _src/_tpl/, e lo usano ventiquattro dei ventisei a cinque.
MODULI=$( ls -d ./_mod/_?????.*/ 2> /dev/null | sed 's|^\./_mod/_||; s|/$||' )

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
    [ "$N" -gt 0 ] && echo "$SENZA" | sed "s|^|manca $tipo.md al modulo |" \
        | emetti "$cat_" "$N" "moduli della linea nuova senza $tipo.md"

done

## ------------------------------------------------------------------ 4. manuali dei template
#
# si documentano i template NUOVI, quelli a Twig sotto _src/_tpl/. I diciassette sotto
# _src/_templates/ sono il sistema vecchio a .html e restano fuori: i due convivono di
# proposito, perche' un progetto migri un template per volta invece che in un colpo solo, ma
# scrivere il manuale di cio' che si sta lasciando e' lavoro che nasce gia' da buttare.
#
# Un template senza nemmeno un .twig e' un guscio ( oggi arianna, demetra e sarah ): non si
# segnala. Chiedere il manuale di una cartella vuota manda a documentare il nulla, e la
# domanda vera su un guscio non e' "gli manca il manuale" ma "ha ancora senso che esista".
# Se il guscio diventa un template, il rilievo compare da solo.
TEMPLATE=$( for t in ./_src/_tpl/_*/; do
    [ -d "$t" ] || continue
    [ -n "$( find "$t" -name '*.twig' -print -quit 2> /dev/null )" ] || continue
    n="$( basename "$t" )"
    echo "${n#_}"
done )

for tipo in READ USER; do

    cat_=$( echo "template-$tipo" | tr 'A-Z' 'a-z' )
    attiva "$cat_" || continue

    SENZA=$( echo "$TEMPLATE" | while IFS= read -r t; do
        [ -n "$t" ] || continue
        [ -f "./src/tpl/$t/$tipo.md" ] && continue
        [ -f "./_src/_tpl/_$t/$tipo.md" ] && continue
        echo "$t"
    done )

    N=$( echo "$SENZA" | grep -c . )
    [ "$N" -gt 0 ] && echo "$SENZA" | sed "s|^|manca $tipo.md al template |" \
        | emetti "$cat_" "$N" "template nuovi senza $tipo.md"

done

## ------------------------------------------------------------------ 5. vocabolario dei marcatori
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

## ------------------------------------------------------------------ 6. vocabolario dei marcatori dello schema
#
# lo schema si documenta da se', con commenti '--', e in testa a ogni tabella quattro campi ne
# dichiarano la natura: tipologia, rango, struttura, funzione. I primi tre hanno un vocabolario
# chiuso; 'funzione' e' prosa libera e non si controlla.
#
# E' lo stesso controllo della sezione precedente, puntato su un altro file, e per lo stesso
# motivo: un valore fuori vocabolario non produce nessun errore, produce una tabella classificata
# in un modo che non esiste, e nessuno se ne accorge finche' qualcuno non prova a raggruppare.
#
# Al 15/09/2026 erano sette marcatori alla deriva su sei tabelle, sopravvissuti perche' questi
# commenti non li leggeva niente, ne' la catena della documentazione ne' un controllo. Due erano
# i campi tipologia e rango SCAMBIATI sulla stessa tabella: un errore che rileggendo non si vede,
# perche' i due valori sono plausibili tutt'e due, e che un elenco di valori ammessi trova subito.
#
# Si segnala il VALORE e non la tabella che lo porta, come nella sezione precedente: uno stesso
# termine alla deriva e' una decisione sola di vocabolario, anche quando compare su piu' tabelle,
# e la tabella e' comunque a un grep di distanza.
if attiva schema; then

    # standard e custom allo stesso percorso al netto degli underscore, come per tutto il resto.
    # Da non confondere con usr/database/, che accanto ospita gli snapshot datati delle
    # migrazioni: quelli sono dump, non sorgenti, e marcatori non ne portano.
    SCHEMA=$( ls ./_usr/_database/_patch/*.sql ./usr/database/patch/*.sql 2> /dev/null )

    if [ -n "$SCHEMA" ]; then

        FUORI=$( {
            grep -hoE '^-- tipologia: .*' $SCHEMA 2> /dev/null \
                | grep -vxE '^-- tipologia: tabella (gestita|standard|assistita|di supporto)$'
            grep -hoE '^-- rango: .*' $SCHEMA 2> /dev/null \
                | grep -vxE '^-- rango: tabella (principale|secondaria|di relazione)$'
            grep -hoE '^-- struttura: .*' $SCHEMA 2> /dev/null \
                | grep -vxE '^-- struttura: tabella (base|ricorsiva)$'
        } | sed 's/^-- //' | sort -u )

        N=$( echo "$FUORI" | grep -c . )
        [ "$N" -gt 0 ] && echo "$FUORI" | sed 's/^/marcatore dello schema fuori vocabolario: /' \
            | emetti schema "$N" "marcatori fuori vocabolario nei commenti dello schema"

    fi

fi

## ------------------------------------------------------------------ 7. screenshot
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

## ------------------------------------------------------------------ 8. protezione del manuale
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

## ------------------------------------------------------------------ 9. legacy da travasare
if attiva legacy && [ -d ./_usr/_docs/_legacy ]; then
    N=$( find ./_usr/_docs/_legacy -name '*.dox' | wc -l )
    [ "$N" -gt 0 ] && rilievo legacy "restano .dox in _usr/_docs/_legacy da travasare nei READ.md e USER.md"
fi

## ------------------------------------------------------------------ 10. sorgente piu' recente
#
# CLAUDE.md e' scritto per un agente e non e' documentazione, ma e' la sorgente da cui si
# scrive il manuale sviluppatore del progetto: se e' piu' recente, il manuale e' indietro
if attiva sorgente && [ -f ../CLAUDE.md ] && [ -f ./usr/docs/READ.md ]; then
    [ ../CLAUDE.md -nt ./usr/docs/READ.md ] && \
        rilievo sorgente "CLAUDE.md e' piu' recente del manuale sviluppatore che ne discende"
fi

## ------------------------------------------------------------------ 11. metriche
#
# non sono rilievi e non diventano voci: sono numeri che si guardano per capire se il debito
# scende. Una voce per ciascuno verrebbe riaperta a ogni variazione.
if [ $METRICHE -eq 1 ] && [ $TODO -eq 0 ]; then

    {
    echo
    echo "  metriche"

    for d in _src/_lib _src/_api _src/_config _src/_inc; do
        [ -d "./$d" ] || continue
        # il vendor di composer va escluso da ENTRAMBI i conteggi: escluderlo solo dal
        # totale confrontava insiemi diversi e produceva numeri piu' alti del vero
        TOT=$( find "./$d" -name '*.php' -not -path '*/_ext/*' | wc -l )
        CON=$( grep -rl '@file' "./$d" --include='*.php' --exclude-dir='_ext' 2> /dev/null | wc -l )
        printf '    %-14s @file %s su %s file\n' "$d" "$CON" "$TOT"
    done

    # 'TODO documentare' spezzato per area. In un numero solo faceva 482, e la gran parte erano
    # moduli legacy che non si documentano: un totale che comprende cio' che non si fara' mai
    # non misura il debito, lo nasconde, e chi lo guarda smette di guardarlo perche' non scende
    # mai. Spezzato, la riga che deve scendere si vede, e le altre due dicono solo quanto e'
    # grande la parte di cui non ci si occupa.
    #
    # La lista vuota va intercettata: grep -rl senza directory legge lo standard input. Da cron
    # lo stdin e' /dev/null e tornerebbe zero per caso, ma lanciato a mano dal terminale lo
    # script resterebbe li' fermo senza dire perche'.
    td() {
        [ $# -gt 0 ] || { echo 0; return; }
        grep -rl 'TODO documentare' "$@" --include='*.php' 2> /dev/null | grep -v '/_ext/' | wc -l
    }

    NUOVI=()
    LEGACY=()
    for m in ./_mod/*/; do
        [ -d "$m" ] || continue
        cod="$( basename "$m" )"; cod="${cod#_}"; cod="${cod%%.*}"
        if [ ${#cod} -eq 5 ]; then NUOVI+=( "$m" ); else LEGACY+=( "$m" ); fi
    done

    # quanto dello schema dichiara la propria natura. Non e' un rilievo: le tabelle senza i
    # marcatori sono una coda che si accorcia lavorando, non un elenco su cui agire una per una.
    SCHEMA=$( ls ./_usr/_database/_patch/*.sql ./usr/database/patch/*.sql 2> /dev/null )
    if [ -n "$SCHEMA" ]; then
        TAB=$( grep -hE '^CREATE TABLE' $SCHEMA 2> /dev/null | wc -l )
        MAR=$( grep -hE '^-- tipologia: ' $SCHEMA 2> /dev/null | wc -l )
        printf '    %-14s %s su %s tabelle\n' "schema" "$MAR" "$TAB"
    fi

    printf '    %-14s %s file\n' "TODO core"      "$( td ./_src )"
    printf '    %-14s %s file\n' "TODO moduli"    "$( td "${NUOVI[@]}" )"
    printf '    %-14s %s file\n' "TODO legacy"    "$( td "${LEGACY[@]}" )"

    if [ -f ./var/log/doxygen.warn.log ]; then
        printf '    %-14s %s\n' "avvisi doxygen" "$( wc -l < ./var/log/doxygen.warn.log )"
    fi
    } >> "$ELENCO"

fi

## ------------------------------------------------------------------ 12. inventario di copertura
#
# non e' un rilievo ed esce fuori da $ELENCO, cosi' non cambia il codice di uscita: e' l'elenco
# per esteso di dove ogni file e' documentato. Serve quando si travasa o si riordina, perche' il
# rilievo aggregato dice QUANTI file non sono coperti e non QUALI, ne' dove stanno gli altri.
if [ $COPERTURA -eq 1 ] && [ $TODO -eq 0 ]; then

    echo "  copertura: file standard e sorgente che lo documenta"
    echo

    COP=0
    SCO=0

    while IFS= read -r f; do
        p="${f#.}"
        if [ -n "${DOVE[$p]}" ]; then
            COP=$(( COP + 1 ))
            printf '    %-58s %s\n' "$p" "${DOVE[$p]}"
        else
            SCO=$(( SCO + 1 ))
            printf '    %-58s %s\n' "$p" "NON DOCUMENTATO"
        fi
    done < <( da_documentare )

    echo
    printf '    %s documentati, %s no, su %s file\n' "$COP" "$SCO" "$(( COP + SCO ))"
    printf '    sorgenti letti: %s\n' "$( sorgenti_doc | wc -l )"
    echo

fi

## esito
cat "$ELENCO"

if [ ! -s "$ELENCO" ]; then
    exit 0
fi

exit 1
