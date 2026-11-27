#!/bin/bash

## questo script controlla che un commit che tocca il codice porti anche i suoi test
#
# regola di Fabio del 28/10/2026: ogni sviluppo nasce col suo test, e la lista dei test da scrivere
# si deve accorciare, non allungare. Una regola scritta e basta si dimentica; questa la applicano
# due controlli che usano questo script:
#
# - l'hook .githooks/commit-msg, che rifiuta il commit prima che esista ( glisweb e glisdev );
# - bin/chiusura.py della skill glisweb, che guarda i commit del giorno su qualunque deploy,
#   anche dove l'hook non c'e', e li segnala come bloccanti prima della chiusura
#
# e' codice un file .php, .twig, .html, .js, .sh o .sql sotto _src/, src/, _mod/<m>/_src/ o
# mod/<m>/src/, escluse le librerie esterne; e' un test un file sotto _usr/_test/, usr/test/,
# _usr/_examples/, usr/examples/ o le stesse cartelle dentro un modulo
#
# chi non puo' scrivere il test lo dichiara nel messaggio di commit con una riga
#
#   Senza-test: <motivo, almeno qualche parola>
#
# e apre la voce nel TODO.md, area test automatici: il commit passa, ma il debito e' scritto
#
# uso:
#
#   _test.guardia.sh --staged <file del messaggio>    i file in stage ( dall'hook commit-msg )
#   _test.guardia.sh --commit <hash>                  un commit gia' fatto ( da chiusura.py )
#
# esce con 0 se il commit e' in regola, con 1 se tocca il codice senza test e senza dichiararlo,
# e in quel caso stampa i file di codice toccati
#

## codice e test
CODICE='^(_src|src|_mod/[^/]+/_src|mod/[^/]+/src)/.*\.(php|twig|html|js|sh|sql)$'
ESTERNE='/_?lib/_?ext/'
TEST='^(_mod/[^/]+/|mod/[^/]+/)?(_usr/_test|usr/test|_usr/_examples|usr/examples)/'
DEROGA='^Senza-test:[[:space:]]*[^[:space:]].{8,}'

## file e messaggio
case "$1" in
    --staged)
        FILE="$( git diff --cached --name-only --diff-filter=ACMR )"
        MSG="$( sed '/^#/d' "$2" )"
        ;;
    --commit)
        FILE="$( git diff-tree --no-commit-id --name-only -r --diff-filter=ACMR "$2" )"
        MSG="$( git log -1 --format=%B "$2" )"
        ;;
    *)
        echo "uso: $0 --staged <file del messaggio> | --commit <hash>" >&2
        exit 2
        ;;
esac

## verifica
TOCCATO="$( echo "$FILE" | grep -E "$CODICE" | grep -vE "$ESTERNE" )"

if [ -z "$TOCCATO" ]; then
    exit 0
fi

if [ -n "$( echo "$FILE" | grep -E "$TEST" )" ]; then
    exit 0
fi

if [ -n "$( echo "$MSG" | grep -iE "$DEROGA" )" ]; then
    exit 0
fi

echo "$TOCCATO"
exit 1
