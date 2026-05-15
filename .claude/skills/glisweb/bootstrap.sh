#!/usr/bin/env bash
#
# bootstrap.sh — inizializza un nuovo progetto cliente basato sul framework glisweb
#
# Uso:
#   bash bootstrap.sh                          # bootstrap nella cwd
#   bash bootstrap.sh --target <path>          # bootstrap su una directory specifica
#   bash bootstrap.sh --name <nome>            # override esplicito del nome progetto
#                                              # (default: basename del target, oppure
#                                              # basename del parent se il target è "dev")
#   bash bootstrap.sh --force                  # sovrascrive i template esistenti
#   bash bootstrap.sh --with-shadow            # copia anche shadow.yaml.example
#   bash bootstrap.sh --help                   # mostra questo help
#
# Exit code:
#   0 — successo (anche con [SKIP] per idempotenza)
#   1 — errore generico (target inesistente, --name non valido, opzione sconosciuta)
#   2 — framework glisweb non rilevato nel target
#
# Lo script è idempotente: rilanciandolo non rompe nulla, salta i file già presenti.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATES_DIR="$SCRIPT_DIR/templates"

TARGET="$(pwd)"
NAME_OVERRIDE=""
FORCE=0
WITH_SHADOW=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            TARGET="$2"
            shift 2
            ;;
        --name)
            NAME_OVERRIDE="$2"
            shift 2
            ;;
        --force)
            FORCE=1
            shift
            ;;
        --with-shadow)
            WITH_SHADOW=1
            shift
            ;;
        --help|-h)
            sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
            exit 0
            ;;
        *)
            echo "Opzione non riconosciuta: $1" >&2
            echo "Usa --help per l'elenco." >&2
            exit 1
            ;;
    esac
done

# Pre-check 0: il target deve esistere
if [[ ! -d "$TARGET" ]]; then
    echo "ERRORE: la directory target '$TARGET' non esiste o non è una directory." >&2
    echo "       Crea la directory e clona il framework prima di rilanciare." >&2
    exit 1
fi

cd "$TARGET"
TARGET="$(pwd)"   # canonicalizza il path

# Determina PROJECT_NAME:
#   1. se --name è esplicito, usa quello (dopo aver validato i caratteri)
#   2. altrimenti basename del target
#   3. se il basename è "dev" (convenzione glisweb: <sito>/dev/, valido anche per Cloud Panel
#      /home/{utente}/htdocs/{sito}/dev/), usa basename del parent
if [[ -n "$NAME_OVERRIDE" ]]; then
    if [[ "$NAME_OVERRIDE" == *"|"* ]]; then
        echo "ERRORE: --name non può contenere il carattere '|' (delimitatore sed)." >&2
        exit 1
    fi
    PROJECT_NAME="$NAME_OVERRIDE"
else
    PROJECT_NAME="$(basename "$TARGET")"
    if [[ "$PROJECT_NAME" == "dev" ]]; then
        PARENT_NAME="$(basename "$(dirname "$TARGET")")"
        echo "[INFO] basename del target è 'dev' — uso il nome del parent: $PARENT_NAME"
        PROJECT_NAME="$PARENT_NAME"
    fi
fi

echo "==> Bootstrap progetto glisweb in: $TARGET"
echo "    PROJECT_NAME = $PROJECT_NAME"
echo "    (se sbagliato, rilancia con --name <nome-corretto>)"
echo

# 1. Pre-check: il framework deve essere clonato qui
if [[ ! -f "_src/_config.php" ]]; then
    echo "ERRORE: _src/_config.php non trovato in $TARGET" >&2
    echo "       Il framework glisweb non sembra clonato qui. Esegui prima:" >&2
    echo "       git clone <repo-glisweb> $TARGET" >&2
    exit 2
fi
echo "[OK] framework glisweb rilevato (_src/_config.php presente)"

# 2. Verifica composer.json (sanità del clone del framework)
if [[ ! -f "composer.json" ]]; then
    echo "[WARN] composer.json non trovato — clone del framework potenzialmente incompleto"
else
    echo "[OK] composer.json presente"
fi

# 3. Verifica presenza del manuale per Claude (warning, non bloccante)
if [[ ! -f "_etc/_claude/_claude.framework.md" ]]; then
    echo "[WARN] _etc/_claude/_claude.framework.md mancante: framework potenzialmente obsoleto."
    echo "       Considera un aggiornamento del clone del framework prima di procedere."
else
    echo "[OK] manuale Claude del framework presente"
fi

# 4. Crea cartelle custom (idempotente)
create_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        echo "[SKIP] cartella $dir/ già presente"
    else
        mkdir -p "$dir"
        echo "[OK]   cartella $dir/ creata"
    fi
}

create_dir "src/config"
create_dir "src/lib"
create_dir "src/twig"
create_dir "mod"
create_dir "var/log/latest"
create_dir "var/cache"
create_dir "var/tmp"

# 5-7. Copia template con sostituzione placeholder
# Usa | come delimitatore sed (i nomi progetto possono contenere /, . ma non |, che è
# bloccato dal check su --name).
copy_template() {
    local src="$1"
    local dst="$2"
    local label="$3"

    if [[ ! -f "$src" ]]; then
        echo "[WARN] template mancante: $src — skip $label"
        return
    fi

    # Salva lo stato di esistenza prima della scrittura, così il messaggio è accurato
    # anche con --force su un file che non esisteva ancora.
    local existed=0
    [[ -f "$dst" ]] && existed=1

    if [[ $existed -eq 1 && $FORCE -eq 0 ]]; then
        echo "[SKIP] $label già presente ($dst). Usa --force per sovrascrivere."
        return
    fi

    sed "s|{{PROJECT_NAME}}|$PROJECT_NAME|g" "$src" > "$dst"

    if [[ $existed -eq 1 ]]; then
        echo "[OK]   $label sovrascritto ($dst)"
    else
        echo "[OK]   $label creato ($dst)"
    fi
}

copy_template "$TEMPLATES_DIR/CLAUDE.md.template"   "CLAUDE.md"        "CLAUDE.md"
copy_template "$TEMPLATES_DIR/config.yaml.template" "src/config.yaml"  "src/config.yaml"

if [[ $WITH_SHADOW -eq 1 ]]; then
    copy_template "$TEMPLATES_DIR/shadow.yaml.example" "src/shadow.yaml" "src/shadow.yaml"
    echo "[WARN] src/shadow.yaml contiene placeholder CHANGE_ME — non committarlo."
fi

# 8. Permessi var/ (solo se siamo root)
if [[ $(id -u) -eq 0 ]]; then
    if [[ -x "_src/_sh/_lamp.permissions.open.sh" ]]; then
        echo "[..]   imposto permessi di sviluppo via _lamp.permissions.open.sh"
        _src/_sh/_lamp.permissions.open.sh >/dev/null 2>&1 && \
            echo "[OK]   permessi var/ impostati" || \
            echo "[WARN] _lamp.permissions.open.sh ha riportato errori (output soppresso)"
    else
        echo "[WARN] _src/_sh/_lamp.permissions.open.sh non eseguibile o assente — salto permessi"
    fi
else
    echo "[INFO] non root: salto impostazione permessi var/ (esegui sudo _src/_sh/_lamp.permissions.open.sh)"
fi

# 9. Riepilogo prossimi passi
cat <<EOF

==> Bootstrap completato in: $TARGET

I path che seguono sono relativi alla document root del progetto. Se non ci sei già:
    cd "$TARGET"

Prossimi passi suggeriti:

  1. Edita src/config.yaml e imposta i domini reali (PROD/TEST/DEV) e il nome del database.
  2. Crea src/shadow.yaml con le credenziali reali (NON committarlo). Per partire da un esempio:
       bash .claude/skills/glisweb/bootstrap.sh --with-shadow
  3. Installa le dipendenze:
       composer update
  4. In produzione, imposta i permessi sicuri:
       sudo _src/_sh/_lamp.permissions.secure.sh
  5. Verifica che tutto funzioni con uno smoke test:
       _src/_sh/_smoke.curl.sh init && _src/_sh/_smoke.curl.sh status /

Manuale operativo completo: _etc/_claude/_claude.framework.md
EOF
