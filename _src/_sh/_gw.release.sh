#!/bin/bash
## RILASCIO DI LIVELLO PATCH DEL FRAMEWORK ( X.Y.z -> X.Y.z+1 )
#
# Il framework segue gitflow ( deciso il 21/10/2026 ): develop e' l'integrazione, master riceve solo
# le release e ogni merge su master porta un tag X.Y.z. Una release di livello patch nasce da develop
# dopo un giro di test verde: questo script fa tutto il giro, nell'ordine, e si ferma al primo
# problema senza aver pubblicato niente.
#
#   1. la copia di lavoro deve essere pulita e allineata a origin/develop: si rilascia esattamente
#      il commit che si e' provato;
#   2. tutte le suite di test ( _codeception.run.sh tutte ): se una fallisce non si rilascia;
#   3. in un clone separato, in <progetto>/var/<data>-release-X.Y.z/: release branch da quel commit,
#      _etc/_current.release e _etc/_current.version aggiornate, merge --no-ff in master, tag X.Y.z,
#      merge --no-ff di ritorno in develop;
#   4. push atomico di master, develop e del tag, solo se nel frattempo nessuno ha spinto altro;
#   5. la copia di lavoro si allinea con un pull --ff-only, e il clone si cancella.
#
# Il clone separato non e' un dettaglio: checkout e merge sostituiscono i file invece di scriverli
# sul posto, e nella copia di lavoro romperebbero gli hard link con glisdev.
#
# Le release minori e maggiori NON passano da qui: si fanno a mano, con la release branch, perche'
# assorbono le patch del database nei file base e aggiornano _etc/_current.schema ( capitolo 300 ).
#
# uso: _gw.release.sh [ --si ]
#
#   senza --si dice quale release farebbe e da quale commit, e si ferma prima dei test

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1

## libreria di funzioni
. ./_lib/_functions.sh

## dalla cartella degli script alla document root
cd $RL || exit 1
DOCROOT=$( pwd )

## argomenti
ESEGUI=""
[ "$1" = "--si" ] && ESEGUI="1"

## solo sul repository del framework, cioe' dove i file _* sono versionati
if ! git -C "$DOCROOT" ls-files --error-unmatch -- _src/_config.php > /dev/null 2>&1; then
    echo "ERRORE: $DOCROOT non e' il repository del framework, qui non si rilascia"
    exit 1
fi

## 1. copia di lavoro pulita e allineata a origin/develop
git -C "$DOCROOT" fetch -q origin || exit 1
if [ "$( git -C "$DOCROOT" rev-parse --abbrev-ref HEAD )" != "develop" ]; then
    echo "ERRORE: la copia di lavoro non e' su develop"
    exit 1
fi
if [ -n "$( git -C "$DOCROOT" status --porcelain --untracked-files=no )" ]; then
    echo "ERRORE: ci sono modifiche non committate, si rilascia solo quello che e' su origin/develop"
    exit 1
fi
if [ "$( git -C "$DOCROOT" rev-parse HEAD )" != "$( git -C "$DOCROOT" rev-parse origin/develop )" ]; then
    echo "ERRORE: la copia di lavoro non coincide con origin/develop ( rev-list: $( git -C "$DOCROOT" rev-list --left-right --count HEAD...origin/develop ) )"
    exit 1
fi

## la release nuova: si incrementa il livello patch di quella su origin/master
ATTUALE=$( git -C "$DOCROOT" show origin/master:_etc/_current.release | tr -d '[:space:]' )
if ! [[ "$ATTUALE" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "ERRORE: release su origin/master illeggibile: '$ATTUALE'"
    exit 1
fi
NUOVA="${ATTUALE%.*}.$(( ${ATTUALE##*.} + 1 ))"
COMMIT=$( git -C "$DOCROOT" rev-parse --short HEAD )
if git -C "$DOCROOT" rev-parse -q --verify "refs/tags/$NUOVA" > /dev/null; then
    echo "ERRORE: il tag $NUOVA esiste gia'"
    exit 1
fi

echo "release $ATTUALE -> $NUOVA dal commit $COMMIT di develop"

if [ -z "$ESEGUI" ]; then
    echo "prova a vuoto: con --si si lanciano i test e, se passano, si rilascia"
    exit 0
fi

## 2. test
if ! ./_src/_sh/_codeception.run.sh tutte; then
    echo "ERRORE: i test non sono verdi, la release $NUOVA NON si fa"
    exit 1
fi

## 3. clone separato
CLONE="$( dirname "$DOCROOT" )/var/$( date '+%Y%m%d%H%M%S' )-release-$NUOVA"
mkdir -p "$( dirname "$CLONE" )"
G="git -C $CLONE -c core.hooksPath=/dev/null"

git clone -q -b develop "$DOCROOT" "$CLONE" || exit 1
$G remote set-url origin "$( git -C "$DOCROOT" remote get-url origin )" || exit 1
$G fetch -q origin || exit 1

$G checkout -q -b "release/$NUOVA" "$COMMIT" || exit 1
echo "$NUOVA" > "$CLONE/_etc/_current.release"
date '+%Y%m%d%H%M%S' > "$CLONE/_etc/_current.version"
$G commit -q -am "release $NUOVA" || exit 1

$G checkout -q -B master origin/master || exit 1
$G merge -q --no-ff --no-edit -m "release $NUOVA" "release/$NUOVA" || exit 1
$G tag -a "$NUOVA" -m "release $NUOVA" || exit 1

$G checkout -q -B develop origin/develop || exit 1
$G merge -q --no-ff --no-edit -m "release $NUOVA: ritorno in develop" "release/$NUOVA" || exit 1

## 4. push, solo se origin non si e' mosso mentre giravano i test
$G fetch -q origin || exit 1
if ! $G merge-base --is-ancestor origin/develop develop || ! $G merge-base --is-ancestor origin/master master; then
    echo "ERRORE: develop o master sono andati avanti su origin durante il rilascio, la release $NUOVA NON e' pubblicata"
    echo "        il lavoro fatto resta in $CLONE"
    exit 1
fi
$G push -q --atomic origin master develop "$NUOVA" || exit 1

## 5. copia di lavoro allineata, clone tolto
git -C "$DOCROOT" pull -q --ff-only || echo "ATTENZIONE: pull della copia di lavoro non riuscito, farlo a mano"
rm -rf "$CLONE"

echo "release $NUOVA pubblicata: tag su master, develop allineato"
