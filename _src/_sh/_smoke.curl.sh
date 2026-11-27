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
#   _src/_sh/_smoke.curl.sh sorveglianza [<url base>]  giro completo per la sorveglianza dei deploy:
#                                                      sito, login, pagina di gestione e contenuto,
#                                                      una riga OK/KO per controllo, exit 0 o 1
#
# variabili d'ambiente:
#   SMOKE_BASE_URL    obbligatoria ( per sorveglianza basta l'argomento ): niente default
#   SMOKE_LOGIN_PATH  default: /login.it-IT.html ( p.es. /admin.it-IT.html dove la login sta li' )
#   SMOKE_LOGIN_MARKER regex ( grep -E ) che la pagina dopo il login deve contenere, default: name="__logout__"
#   TEST_USER         richiesta da `login`
#   TEST_PASS         richiesta da `login`
#   SMOKE_VERBOSE     se "1", aggiunge -v a curl
#
# configurazione di `sorveglianza` ( src/config.* e src/shadow.*, json o yaml, shadow vince ):
#   smoke.account.username   l'account di prova, che non sia di roots
#   smoke.account.password   SOLO in shadow: se la trova in config lo script si ferma
#   smoke.page               il percorso di una pagina di gestione che legge dal database
#   smoke.pattern            l'espressione regolare ( grep -E ) che il contenuto deve contenere
#

## livelli per la root del sito
RL="../../"

## directory corrente
cd $(dirname "$0") || exit 1
cd $RL || exit 1

## configurazione
#
# Fino al 17/11/2026 la base aveva come default glisdev: lanciato su un altro deploy senza
# SMOKE_BASE_URL lo script interrogava il sito sbagliato e rispondeva OK in silenzio. Adesso
# la base o la si dice, o lo script si ferma ( il controllo e' in ogni comando, sotto ).
BASE_URL="${SMOKE_BASE_URL:-}"
LOGIN_PATH="${SMOKE_LOGIN_PATH:-/login.it-IT.html}"
LOGIN_MARKER="${SMOKE_LOGIN_MARKER:-name=\"__logout__\"}"
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

## la base serve a tutti i comandi che parlano col sito; sorveglianza la accetta anche come argomento
if [ "$cmd" = "sorveglianza" ] && [ -n "${2:-}" ]; then
    BASE_URL="$2"
fi
BASE_URL="${BASE_URL%/}"
case "$cmd" in
    ""|-h|--help|help|init) ;;
    sorveglianza)
        if [ -z "$BASE_URL" ]; then
            echo "KO   base       URL di base mancante: passala come argomento o in SMOKE_BASE_URL"
            exit 1
        fi
        ;;
    *)
        [ -n "$BASE_URL" ] || die "SMOKE_BASE_URL non valorizzata ( p.es. SMOKE_BASE_URL=https://<sito> )"
        ;;
esac

case "$cmd" in

    init)
        rm -f "$JAR"
        : > "$JAR"
        echo "smoke: cookie jar reset → $JAR"
        ;;

    login)
        [ -n "$TEST_USER" ] || die "TEST_USER non valorizzata"
        [ -n "$TEST_PASS" ] || die "TEST_PASS non valorizzata"
        out="$(_curl_run --write-out '\n%{http_code}' \
            --data-urlencode "__login__[user]=$TEST_USER" \
            --data-urlencode "__login__[pasw]=$TEST_PASS" \
            "$BASE_URL$LOGIN_PATH")" || die "curl login fallito"
        code="${out##*$'\n'}"
        body="${out%$'\n'*}"
        # fino al 24/11/2026 bastava l'assenza del campo password, e una login in 404 risultava riuscita
        # ( BERNISPA ed eurosnodi ): ora servono il 200 e un marcatore della pagina autenticata
        if [ "$code" != "200" ]; then
            echo "smoke: login FAILED for $TEST_USER ( HTTP $code da $LOGIN_PATH: e' il percorso della login? vedi SMOKE_LOGIN_PATH )" >&2
            exit 2
        fi
        # se il body finale contiene ancora il campo password, il login non è andato
        if echo "$body" | grep -q 'name="__login__\[pasw\]"'; then
            echo "smoke: login FAILED for $TEST_USER" >&2
            exit 2
        fi
        # niente marcatore, niente pagina autenticata
        if ! echo "$body" | grep -qE "$LOGIN_MARKER"; then
            echo "smoke: login FAILED for $TEST_USER ( la pagina non contiene $LOGIN_MARKER: vedi SMOKE_LOGIN_MARKER )" >&2
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

    sorveglianza)

        # Il livello 3 della sorveglianza dei deploy: non basta che il sito risponda, deve
        # far entrare un utente e mostrargli dati letti dal database. Ogni controllo stampa una
        # riga OK/KO; al primo KO ci si ferma, perche' i controlli dopo dipendono da quello.
        #
        # Il login e' HTTP Basic e non il POST del form, per lo stesso motivo di _docs.shots.sh:
        # dove reCAPTCHA e' configurato il POST senza token lo rifiuta l'anti-spam, mentre il
        # login via header ( LOGIN_VIA_HTTP_HEADER in _src/_config/_210.auth.php ) lo salta, ed
        # e' stateless: non apre una sessione nuova a ogni giro. Le credenziali arrivano a curl
        # dallo standard input ( --config - ) e non dalla riga di comando, dove ps le mostrerebbe.

        ## la base deve avere il protocollo, altrimenti curl ne inventa uno
        case "$BASE_URL" in
            http://*|https://*) ;;
            *) echo "KO   base       $BASE_URL senza protocollo"; exit 1 ;;
        esac

        ## configurazione: stessa fusione minima di _mysql.upgrade.sh, json e yaml, shadow vince;
        ## i valori tornano separati da NUL, cosi' una password con spazi o virgolette non si rompe
        CONF=()
        while IFS= read -r -d '' v; do CONF+=( "$v" ); done < <( php -r '
            function carica( $base ) {
                $r = array();
                $j = ( is_readable( $base . ".json" ) ) ? json_decode( file_get_contents( $base . ".json" ), true ) : NULL;
                if( is_array( $j ) ) { $r = array_replace_recursive( $r, $j ); }
                $y = ( is_readable( $base . ".yaml" ) && function_exists( "yaml_parse_file" ) ) ? yaml_parse_file( $base . ".yaml" ) : NULL;
                if( is_array( $y ) ) { $r = array_replace_recursive( $r, $y ); }
                return $r;
            }
            $c = carica( "src/config" );
            $k = array_replace_recursive( $c, carica( "src/shadow" ) )["smoke"] ?? array();
            $e = ( ! empty( $c["smoke"]["account"]["password"] ) ) ? "password-in-config" : "ok";
            foreach( array( $e, $k["account"]["username"] ?? "", $k["account"]["password"] ?? "", $k["page"] ?? "", $k["pattern"] ?? "" ) as $v ) {
                echo $v, "\0";
            }
        ' 2> /dev/null )
        if [ ${#CONF[@]} -ne 5 ]; then
            echo "KO   config     lettura di src/config e src/shadow fallita"
            exit 1
        fi
        if [ "${CONF[0]}" != "ok" ]; then
            echo "KO   config     smoke.account.password sta in src/config: va spostata in src/shadow"
            exit 1
        fi
        MANCANO=""
        [ -n "${CONF[1]}" ] || MANCANO="$MANCANO smoke.account.username"
        [ -n "${CONF[2]}" ] || MANCANO="$MANCANO smoke.account.password"
        [ -n "${CONF[3]}" ] || MANCANO="$MANCANO smoke.page"
        [ -n "${CONF[4]}" ] || MANCANO="$MANCANO smoke.pattern"
        if [ -n "$MANCANO" ]; then
            echo "KO   config     mancano:$MANCANO"
            exit 1
        fi
        PAGE="/${CONF[3]#/}"
        PATTERN="${CONF[4]}"
        echo "OK   config     smoke.* completo"

        ## il sito, senza login
        code="$(curl --silent --location --max-time 30 --output /dev/null \
            --write-out '%{http_code}' "$BASE_URL/" 2> /dev/null)"
        if [ "$code" != "200" ]; then
            echo "KO   sito       $BASE_URL/ HTTP ${code:-000}"
            exit 1
        fi
        echo "OK   sito       $BASE_URL/ HTTP 200"

        ## la pagina di gestione, con le credenziali; il corpo in un temporaneo privato, perche'
        ## contiene dati del database
        BODY="$(mktemp)" || die "mktemp fallito"
        trap 'rm -f "$BODY"' EXIT
        esc() { local s="${1//\\/\\\\}"; printf '%s' "${s//\"/\\\"}"; }
        code="$(printf 'user = "%s:%s"\n' "$(esc "${CONF[1]}")" "$(esc "${CONF[2]}")" \
            | curl --silent --location --max-time 30 --globoff --config - \
                --output "$BODY" --write-out '%{http_code}' "$BASE_URL$PAGE" 2> /dev/null)"

        ## login: se torna il form, o un rifiuto, le credenziali non sono passate
        if [ "$code" = "401" ] || [ "$code" = "403" ] || grep -q 'name="__login__\[pasw\]"' "$BODY"; then
            echo "KO   login      $PAGE risponde col login ( HTTP ${code:-000} ): account rifiutato o senza accesso"
            exit 1
        fi
        echo "OK   login      account di prova accettato"

        if [ "$code" != "200" ]; then
            echo "KO   pagina     $PAGE HTTP ${code:-000}"
            exit 1
        fi
        echo "OK   pagina     $PAGE HTTP 200, $(wc -c < "$BODY") byte"

        if ! grep -qE -- "$PATTERN" "$BODY"; then
            echo "KO   contenuto  /$PATTERN/ non trovato in $PAGE"
            exit 1
        fi
        echo "OK   contenuto  /$PATTERN/ trovato"
        exit 0
        ;;

    ""|-h|--help|help)
        sed -n '3,/^$/p' "$0"
        ;;

    *)
        die "comando sconosciuto: $cmd (usa --help)"
        ;;

esac
