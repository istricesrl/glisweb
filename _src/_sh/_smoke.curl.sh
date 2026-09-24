#!/bin/bash

## SMOKE TEST DELLA WEB APP VIA CURL
#
# helper per verificare che il sito risponda, che il login funzioni e che pagine specifiche
# rendano contenuti attesi. pensato per uso non interattivo (chiamate ripetute, output
# parseabile) — niente `clear`, niente prompt.
#
# uso:
#   _src/_sh/_smoke.curl.sh init                       azzera il cookie jar
#   _src/_sh/_smoke.curl.sh login                      POST a $SMOKE_LOGIN_PATH con
#                                                      $TEST_USER e $TEST_PASS
#   _src/_sh/_smoke.curl.sh logout                     GET /logout.it-IT.html, azzera jar
#   _src/_sh/_smoke.curl.sh get <path>                 GET <path>, stampa status + body
#   _src/_sh/_smoke.curl.sh post <path> <data>         POST <path> con --data <data>
#   _src/_sh/_smoke.curl.sh status <path>              stampa solo il codice HTTP
#   _src/_sh/_smoke.curl.sh check <path> <regex>       exit 0 se body matcha <regex>
#
# variabili d'ambiente:
#   SMOKE_BASE_URL    default: https://glisdev.istricesrl.com
#   SMOKE_LOGIN_PATH  default: /login.it-IT.html
#   TEST_USER         richiesta da `login`
#   TEST_PASS         richiesta da `login`
#   SMOKE_VERBOSE     se "1", aggiunge -v a curl
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1
cd $RL || exit 1

## configurazione
BASE_URL="${SMOKE_BASE_URL:-https://glisdev.istricesrl.com}"
LOGIN_PATH="${SMOKE_LOGIN_PATH:-/login.it-IT.html}"
JAR="var/tmp/smoke-cookies.txt"

## opzioni curl base
CURL_OPTS=(--silent --show-error --location --max-time 30)
if [ "$SMOKE_VERBOSE" = "1" ]; then
    CURL_OPTS+=(--verbose)
fi

## assicura la directory del cookie jar
mkdir -p "$(dirname "$JAR")"

## --- helper ---

# stampa errore su stderr ed esce
die() { echo "smoke: $*" >&2; exit 1; }

# esegue curl con cookie jar persistente, stampa il body, ritorna exit code curl
_curl_run() {
    curl "${CURL_OPTS[@]}" --cookie "$JAR" --cookie-jar "$JAR" "$@"
}

## --- comandi ---

cmd="${1:-}"
case "$cmd" in

    init)
        rm -f "$JAR"
        : > "$JAR"
        echo "smoke: cookie jar reset → $JAR"
        ;;

    login)
        [ -n "$TEST_USER" ] || die "TEST_USER non valorizzata"
        [ -n "$TEST_PASS" ] || die "TEST_PASS non valorizzata"
        body="$(_curl_run \
            --data-urlencode "__login__[user]=$TEST_USER" \
            --data-urlencode "__login__[pasw]=$TEST_PASS" \
            "$BASE_URL$LOGIN_PATH")" || die "curl login fallito"
        # se il body finale contiene ancora il campo password, il login non è andato
        if echo "$body" | grep -q 'name="__login__\[pasw\]"'; then
            echo "smoke: login FAILED for $TEST_USER" >&2
            exit 2
        fi
        echo "smoke: login OK for $TEST_USER"
        ;;

    logout)
        _curl_run "$BASE_URL/logout.it-IT.html" > /dev/null || true
        rm -f "$JAR"
        echo "smoke: logout done, cookie jar removed"
        ;;

    get)
        path="${2:-}"
        [ -n "$path" ] || die "uso: get <path>"
        code="$(_curl_run --output /tmp/smoke.body.$$ \
            --write-out '%{http_code}' "$BASE_URL$path")" || die "curl get fallito"
        echo "HTTP $code"
        cat /tmp/smoke.body.$$
        rm -f /tmp/smoke.body.$$
        ;;

    post)
        path="${2:-}"
        data="${3:-}"
        [ -n "$path" ] || die "uso: post <path> <data>"
        code="$(_curl_run --output /tmp/smoke.body.$$ \
            --write-out '%{http_code}' \
            --data "$data" "$BASE_URL$path")" || die "curl post fallito"
        echo "HTTP $code"
        cat /tmp/smoke.body.$$
        rm -f /tmp/smoke.body.$$
        ;;

    status)
        path="${2:-}"
        [ -n "$path" ] || die "uso: status <path>"
        # niente --location: voglio sapere il primo status, non quello finale
        opts=(--silent --show-error --max-time 30)
        [ "$SMOKE_VERBOSE" = "1" ] && opts+=(--verbose)
        code="$(curl "${opts[@]}" --cookie "$JAR" --cookie-jar "$JAR" \
            --output /dev/null --write-out '%{http_code}' "$BASE_URL$path")" \
            || die "curl status fallito"
        echo "$code"
        ;;

    check)
        path="${2:-}"
        regex="${3:-}"
        [ -n "$path" ] && [ -n "$regex" ] || die "uso: check <path> <regex>"
        body="$(_curl_run "$BASE_URL$path")" || die "curl check fallito"
        if echo "$body" | grep -qE "$regex"; then
            echo "OK   $path matches /$regex/"
            exit 0
        else
            echo "FAIL $path does not match /$regex/" >&2
            exit 1
        fi
        ;;

    ""|-h|--help|help)
        sed -n '3,28p' "$0"
        ;;

    *)
        die "comando sconosciuto: $cmd (usa --help)"
        ;;

esac
