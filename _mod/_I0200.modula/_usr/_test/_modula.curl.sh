#!/bin/bash

## COLLAUDO DEL WMS MODULA VIA CURL
#
# chiama a mano, una per una, le funzioni del WebService del WMS Modula ( protocollo 1.11, WMS in
# modalita' server ), senza fare il bootstrap del framework: serve per il collaudo in sede col tecnico,
# quando URL e credenziali arrivano sul momento e non stanno ancora nel config.json del deploy.
# ogni comando stampa il codice HTTP e la risposta, indentata se e' JSON.
#
# uso:
#   _modula.curl.sh token                          chiede il token Bearer e lo salva
#   _modula.curl.sh articolo <codice> [des] [umi]  manda un articolo a $MODULA_JOB_ARTICOLI
#   _modula.curl.sh ordine <P|V> <codice> [qta]    manda un ordine di una riga a $MODULA_JOB_ORDINI
#   _modula.curl.sh annulla <ordine>               manda l'ordine con ORD_OPERAZIONE = D
#   _modula.curl.sh esiti                          legge il prossimo pacchetto da $MODULA_JOB_ESITI
#   _modula.curl.sh giacenze                       legge il prossimo pacchetto da $MODULA_JOB_GIACENZE
#   _modula.curl.sh ack <guid> [job]               conferma il pacchetto ( default: job degli esiti )
#   _modula.curl.sh post <job> <file.json>         manda un corpo qualsiasi a un job di import
#   _modula.curl.sh giro <codice>                  token, articolo, ordine P e V, esiti, giacenze
#
# variabili d'ambiente:
#   MODULA_URL              indirizzo di base del WMS, senza la barra finale ( richiesta )
#   MODULA_USER             utente del servizio ( richiesta )
#   MODULA_PASS             password del servizio ( richiesta )
#   MODULA_AUTH             bearer ( default ) oppure basic
#   MODULA_JOB_ARTICOLI     default: CFG-IMP-ARTICOLI
#   MODULA_JOB_ORDINI       default: CFG-IMP-ORDINI
#   MODULA_JOB_ESITI        default: CFG-EXP-ORDINI
#   MODULA_JOB_GIACENZE     default: CFG-EXP-GIACENZE
#   MODULA_VERBOSE          se "1", aggiunge -v a curl
#
# le quantita' vanno al WMS come testo con la virgola e tre decimali ( "1,000" ): lo script le converte.
# i campi sono quelli del protocollo 1.11; il comando post
# serve per provare un tracciato diverso senza toccare lo script.
#

## livelli per la root del sito
RL="../../../../"

## percorso assoluto dello script, per richiamarlo dopo il cd
SELF="$(readlink -f "$0")"

## directory corrente
cd $(dirname "$0") || exit 1
cd $RL || exit 1

## configurazione
URL="${MODULA_URL%/}"
AUTH="${MODULA_AUTH:-bearer}"
JOB_ARTICOLI="${MODULA_JOB_ARTICOLI:-CFG-IMP-ARTICOLI}"
JOB_ORDINI="${MODULA_JOB_ORDINI:-CFG-IMP-ORDINI}"
JOB_ESITI="${MODULA_JOB_ESITI:-CFG-EXP-ORDINI}"
JOB_GIACENZE="${MODULA_JOB_GIACENZE:-CFG-EXP-GIACENZE}"
TOKEN="var/tmp/modula-token.txt"

## opzioni curl base
CURL_OPTS=(--silent --show-error --max-time 30)
if [ "$MODULA_VERBOSE" = "1" ]; then
    CURL_OPTS+=(--verbose)
fi

## assicura la directory del token
mkdir -p "$(dirname "$TOKEN")"

## --- helper ---

# stampa errore su stderr ed esce
die() { echo "modula: $*" >&2; exit 1; }

# controlla le variabili obbligatorie
need_env() {
    [ -n "$URL" ] || die "MODULA_URL non impostata"
    [ -n "$MODULA_USER" ] || die "MODULA_USER non impostata"
    [ -n "$MODULA_PASS" ] || die "MODULA_PASS non impostata"
}

# quantita' numerica -> testo del WMS ( 2 -> "2,000" )
qta() { LC_ALL=C printf '%.3f' "${1:-1}" | tr '.' ','; }

# stampa codice HTTP e corpo, il corpo indentato se e' JSON
show() {
    local body="$1" code="$2"
    echo "HTTP $code"
    if [ -n "$body" ]; then
        echo "$body" | python3 -m json.tool 2>/dev/null || echo "$body"
    fi
}

# chiamata al WMS con l'autenticazione del profilo: <metodo> <percorso> [corpo JSON]
call() {
    local metodo="$1" percorso="$2" corpo="$3" out code auth=()
    if [ "$AUTH" = "basic" ]; then
        auth=(--user "$MODULA_USER:$MODULA_PASS")
    else
        [ -s "$TOKEN" ] || get_token >/dev/null || die "token non ottenuto"
        auth=(--header "Authorization: Bearer $(cat "$TOKEN")")
    fi
    if [ -n "$corpo" ]; then
        out=$(curl "${CURL_OPTS[@]}" "${auth[@]}" -X "$metodo" --header "Content-Type: application/json" \
            --data-binary "$corpo" -w '\n%{http_code}' "$URL$percorso")
    else
        out=$(curl "${CURL_OPTS[@]}" "${auth[@]}" -X "$metodo" -w '\n%{http_code}' "$URL$percorso")
    fi
    code="${out##*$'\n'}"
    # token scaduto: se ne chiede uno nuovo e si riprova una volta
    if [ "$code" = "401" ] && [ "$AUTH" != "basic" ] && [ -z "$RIPROVA" ]; then
        rm -f "$TOKEN"
        RIPROVA=1 call "$@"
        return
    fi
    show "${out%$'\n'*}" "$code"
}

# chiede il token Bearer e lo salva in $TOKEN
get_token() {
    local out code
    out=$(curl "${CURL_OPTS[@]}" -X POST --data-urlencode "grant_type=password" \
        --data-urlencode "username=$MODULA_USER" --data-urlencode "password=$MODULA_PASS" \
        -w '\n%{http_code}' "$URL/token")
    code="${out##*$'\n'}"
    out="${out%$'\n'*}"
    if [ "$code" != "200" ]; then
        show "$out" "$code"
        return 1
    fi
    echo "$out" | python3 -c 'import sys, json; print( json.load( sys.stdin )["access_token"] )' > "$TOKEN" 2>/dev/null \
        || { show "$out" "$code"; rm -f "$TOKEN"; return 1; }
    chmod 600 "$TOKEN"
    echo "HTTP $code"
    echo "token salvato in $TOKEN, scadenza: $(echo "$out" | python3 -c 'import sys, json; print( json.load( sys.stdin ).get( "expires_in", "?" ) )')"
}

# corpo di un ordine di una riga: <operazione> <tipo> <ordine> <codice> <qta>
ordine_json() {
    cat <<EOF
{
    "IMP_ORDINI": [ { "ORD_OPERAZIONE": "$1", "ORD_ORDINE": "$3", "ORD_DES": "COLLAUDO-$3", "ORD_TIPOOP": "$2" } ],
    "IMP_ORDINI_RIGHE": [ { "RIG_ORDINE": "$3", "RIG_ARTICOLO": "$4", "RIG_QTAR": "$(qta "$5")", "RIG_HOSTINF": "${3}01" } ]
}
EOF
}

## --- comandi ---

cmd="${1:-}"
shift || true

case "$cmd" in

    token)
        need_env
        get_token
        ;;

    articolo)
        need_env
        [ -n "$1" ] || die "uso: articolo <codice> [descrizione] [umi]"
        call POST "/api/jobs/$JOB_ARTICOLI" "{ \"IMP_ARTICOLI\": [ { \"ART_OPERAZIONE\": \"I\", \"ART_ARTICOLO\": \"$1\", \"ART_DES\": \"${2:-ARTICOLO DI COLLAUDO}\", \"ART_UMI\": \"${3:-PZ}\" } ] }"
        ;;

    ordine)
        need_env
        [[ "$1" =~ ^[PV]$ ]] && [ -n "$2" ] || die "uso: ordine <P|V> <codice articolo> [qta]"
        ORDINE="$(date +%Y%m%d%H%M%S%N | cut -c1-17)"
        echo "ordine $ORDINE ( $1 )"
        call POST "/api/jobs/$JOB_ORDINI" "$(ordine_json I "$1" "$ORDINE" "$2" "${3:-1}")"
        ;;

    annulla)
        need_env
        [ -n "$1" ] || die "uso: annulla <ordine>"
        call POST "/api/jobs/$JOB_ORDINI" "{ \"IMP_ORDINI\": [ { \"ORD_OPERAZIONE\": \"D\", \"ORD_ORDINE\": \"$1\" } ], \"IMP_ORDINI_RIGHE\": [] }"
        ;;

    esiti)
        need_env
        call GET "/api/jobs/$JOB_ESITI"
        ;;

    giacenze)
        need_env
        call GET "/api/jobs/$JOB_GIACENZE"
        ;;

    ack)
        need_env
        [ -n "$1" ] || die "uso: ack <guid> [job]"
        call POST "/api/jobs/${2:-$JOB_ESITI}/ack" "{ \"GUID\": \"$1\" }"
        ;;

    post)
        need_env
        [ -n "$1" ] && [ -f "$2" ] || die "uso: post <job> <file.json>"
        call POST "/api/jobs/$1" "$(cat "$2")"
        ;;

    giro)
        need_env
        [ -n "$1" ] || die "uso: giro <codice articolo>"
        for passo in "token" "articolo $1" "ordine P $1" "ordine V $1" "esiti" "giacenze"; do
            echo "== $passo"
            "$SELF" $passo
            echo
        done
        echo "gli esiti e le giacenze si confermano con: $SELF ack <GUID> [job]"
        ;;

    *)
        sed -n '3,33p' "$SELF" | sed 's/^# \{0,1\}//'
        exit 1
        ;;

esac
