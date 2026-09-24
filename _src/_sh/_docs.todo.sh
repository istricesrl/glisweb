#!/bin/bash

## SCRIPT PER LA CODA DEL LAVORO DI DOCUMENTAZIONE
#
# questo script elenca i file su cui c'e' da scrivere: e' la CODA da cui si pesca. Il suo gemello
# _docs.check.sh e' un'altra cosa e non va confuso: quello controlla che la documentazione che
# c'e' sia coerente col codice, questo dice quale documentazione non c'e' ancora.
#
#   _docs.todo.sh                 i file marcati 'TODO documentare'
#   _docs.todo.sh --mai-visti     i .php senza marcatore e senza nemmeno un docblock
#   _docs.todo.sh --legacy        include i moduli legacy, esclusi per default
#   _docs.todo.sh --conta         solo i numeri, per area
#
# codice di uscita: 0 se non c'e' niente da fare, 1 se c'e' lavoro, 2 in caso di errore
#
# NOTA sui 'gia' documentati', che qui NON esistono piu'. Lo script da cui questo discende
# ( da-documentare.sh, fuori dal framework ) stampava due elenchi: i file marcati e "GIA'
# DOCUMENTATI", cioe' tutti gli altri. Quel secondo elenco e' falso, e in modo pericoloso:
# l'assenza del marcatore non dice che il file sia documentato, dice solo che nessuno ci ha
# messo il marcatore. _src/_lib/_soap.tools.php non ha un marcatore ne' un solo docblock, ed e'
# vuoto: l'originale lo dava per fatto. E' lo stesso difetto che sui moduli legacy fa sembrare
# documentati 1389 file che nessuno ha mai aperto.
#
# Per questo gli stati sono TRE e non due, e il terzo e' quello che prima non si vedeva:
#
#   marcato            qualcuno l'ha guardato e ha detto che va documentato   -> coda vera
#   con docblock       qualcosa c'e'                                          -> non si elenca
#   niente dei due     nessuno l'ha mai guardato                              -> --mai-visti
#
# Il terzo si riconosce solo sui .php, dove '/**' e' un segnale univoco. Su .sh, .twig e .conf
# un commento in testa puo' essere qualunque cosa, quindi li' non si indovina.
#
# REGOLA sul perimetro: si guarda SOLO dentro la document root, e solo le cartelle standard.
# Si esclude _usr/_docs perche' e' la documentazione, non il codice da documentare — e ci vive
# la reference Doxygen generata, che da sola porta 3037 marcatori che non sono lavoro di nessuno.
#
# REGOLA sulla linea: i moduli legacy restano fuori per default, come in _docs.check.sh. Si
# riconoscono dal codice a quattro caratteri contro i cinque della linea nuova.
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## funzioni
. ./_lib/_functions.sh

## directory di lavoro
cd $RL || exit 1

## opzioni
MAIVISTI=0
LEGACY=0
CONTA=0
while [ $# -gt 0 ]; do
    case "$1" in
        --mai-visti) MAIVISTI=1 ;;
        --legacy)    LEGACY=1 ;;
        --conta)     CONTA=1 ;;
        *)           echo "opzione non riconosciuta: $1" >&2; exit 2 ;;
    esac
    shift
done

## i file candidati: le cartelle standard, al netto di cio' che non e' codice da documentare
#
# i moduli si elencano uno per uno invece di passare _mod intero, perche' e' l'unico modo di
# tenerne fuori i legacy senza filtrare i percorsi a valle con una grep fragile
candidati() {

    local radici=( ./_src ./_etc ./_usr )
    local m cod

    for m in ./_mod/*/; do
        [ -d "$m" ] || continue
        cod="$( basename "$m" )"; cod="${cod#_}"; cod="${cod%%.*}"
        if [ ${#cod} -eq 5 ] || [ $LEGACY -eq 1 ]; then
            radici+=( "$m" )
        fi
    done

    find "${radici[@]}" -type f \
        -not -path "*/_src/_lib/_ext/*" \
        -not -path "*/_usr/_docs/*" \
        -not -path "*/_usr/_examples/*" \
        -not -path "*/_usr/_test/*" \
        -not -path "*/_etc/_dictionaries/*" \
        2> /dev/null | sort
}

## l'elenco richiesto
if [ $MAIVISTI -eq 1 ]; then

    ELENCO="$( candidati | while IFS= read -r f; do
        case "$f" in *.php) ;; *) continue ;; esac
        grep -q 'TODO documentare' "$f" && continue
        grep -q '/\*\*'            "$f" && continue
        echo "${f#.}"
    done )"
    TITOLO="mai guardati ( ne' marcatore ne' docblock )"

else

    ELENCO="$( candidati | while IFS= read -r f; do
        grep -q 'TODO documentare' "$f" && echo "${f#.}"
    done )"
    TITOLO="da documentare"

fi

N=$( echo "$ELENCO" | grep -c . )

## esito
#
# il conteggio si spezza per estensione, e non e' un vezzo: la metrica 'TODO core' e
# 'TODO moduli' di _docs.check.sh conta i soli .php, quindi il totale di qui e' piu' alto e
# senza questa riga sembrerebbero due misure in disaccordo. Spezzato, si vede che tornano.
if [ $CONTA -eq 1 ]; then
    printf '%s: %s file\n' "$TITOLO" "$N"
    [ "$N" -gt 0 ] && echo "$ELENCO" | sed 's/.*\.//' | sort | uniq -c | sort -rn \
        | while read -r c e; do printf '  %-6s %s\n' "$e" "$c"; done
else
    [ "$N" -gt 0 ] && echo "$ELENCO"
fi

[ "$N" -gt 0 ] && exit 1

exit 0
