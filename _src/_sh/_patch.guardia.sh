#!/bin/bash

## questo script controlla che un commit che cambia lo schema nei file base porti anche la sua patch datata
#
# regola di Fabio del 04/11/2026: i file base _0N0000999999.*.sql sono il canone per i database nuovi, ma
# ai database gia' installati non arrivano mai, perche' i loro marcatori stanno sotto il livello di
# qualunque database esistente; quello che ci arriva sono le patch datate _AAAAMMGGHHMM.*.sql. Dal canone
# del 04/10/2026 ( 622c1907a ) al 04/11 146 commit hanno toccato i file base e solo 12 portavano una
# patch: sui database creati prima del 04/10 mancavano cosi' 87 colonne e tabelle, e 91 viste del canone
# non si potevano creare ( var/20261104-viste-canone-deploy/ nel deploy glisweb ). La applicano, come la
# guardia dei test ( _test.guardia.sh ):
#
# - l'hook .githooks/commit-msg, che rifiuta il commit prima che esista ( glisweb e glisdev );
# - il workflow .github/workflows/guardia-patch.yml, che ripassa su GitHub ogni commit arrivato
#
# e' schema un file base delle tabelle, degli indici o dei vincoli ( _010000999999.tables.sql,
# _030000999999.indexes.sql, _060000999999.constraints.sql ); viste, report, procedure, dati e acl
# no: le viste dal 26/10/2026 non vanno nelle patch ( capitolo 300, le viste vivono nei file base ); e'
# una patch un file _usr/_database/_patch/_AAAAMMGGHHMM.*.sql aggiunto, modificato o tolto ( tolto
# e' l'assorbimento di un rilascio, che sposta le patch nei file base; per questo --no-renames: con le
# rinomine attive git puo' leggere una patch tolta e un file base cambiato come una rinomina, e la patch
# non comparirebbe )
#
# chi cambia un file base senza cambiare lo schema ( un commento, una formattazione, la correzione di
# un file base per allinearlo a una patch che c'e' gia' ) lo dichiara nel messaggio con una riga
#
#   Senza-patch: <motivo, almeno qualche parola>
#
# uso:
#
#   _patch.guardia.sh --staged <file del messaggio>    i file in stage ( dall'hook commit-msg )
#   _patch.guardia.sh --commit <hash>                  un commit gia' fatto ( dal workflow )
#
# esce con 0 se il commit e' in regola, con 1 se cambia lo schema senza patch e senza dichiararlo,
# e in quel caso stampa i file base toccati
#

## schema e patch
SCHEMA='^_usr/_database/_patch/_0[136]0000999999\.[a-z]+\.sql$'
PATCH='^_usr/_database/_patch/_20[0-9]{10}\.[^/]+\.sql$'
DEROGA='^Senza-patch:[[:space:]]*[^[:space:]].{8,}'

## file e messaggio
case "$1" in
    --staged)
        FILE="$( git diff --cached --name-only --no-renames --diff-filter=ACMRD )"
        MSG="$( sed '/^#/d' "$2" )"
        ;;
    --commit)
        FILE="$( git diff-tree --no-commit-id --name-only -r --no-renames --diff-filter=ACMRD "$2" )"
        MSG="$( git log -1 --format=%B "$2" )"
        ;;
    *)
        echo "uso: $0 --staged <file del messaggio> | --commit <hash>" >&2
        exit 2
        ;;
esac

## verifica
TOCCATO="$( echo "$FILE" | grep -E "$SCHEMA" )"

if [ -z "$TOCCATO" ]; then
    exit 0
fi

if [ -n "$( echo "$FILE" | grep -E "$PATCH" )" ]; then
    exit 0
fi

if [ -n "$( echo "$MSG" | grep -iE "$DEROGA" )" ]; then
    exit 0
fi

echo "$TOCCATO"
exit 1
