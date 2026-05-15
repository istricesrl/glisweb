# Glis Framework — istruzioni per Claude Code

Questo file fornisce a Claude Code le conoscenze operative necessarie per lavorare su un progetto basato sul framework Glis.
Viene distribuito con il framework e deve essere importato esplicitamente nel `CLAUDE.md` del progetto:

```markdown
@_etc/_claude/_claude.framework.md
```

Le istruzioni specifiche del progetto vanno nel `CLAUDE.md` del progetto, **dopo** questa riga di import, così
sovrascrivono eventualmente ciò che è definito qui.

---

## Regola fondamentale: non rompere mai i file standard

I file e le cartelle il cui nome inizia con `_` sono **file standard del framework** — non vanno mai modificati
direttamente. Potrebbero essere hard link condivisi con altre istanze del framework: modificarli con operazioni che
sostituiscono l'inode (es. `cp` in sovrascrittura, `sed -i`, write-to-temp + rename) rompe silenziosamente la
condivisione.

**Regole operative:**

- Prima di modificare qualsiasi file `_*`, fare `stat <file>` e annotare `Inode:` e `Links:`. Se `Links: > 1`, il file
  è hard-linked con un'altra istanza del framework (es. oldstable).
- I tool **Edit** e **Write** di Claude Code in genere scrivono in-place, ma è stato osservato che in alcuni
  ambienti spezzano comunque l'hard link (cambia l'inode). Quindi **subito dopo ogni Edit/Write** su un file
  `_*` rifare `stat` e confrontare l'inode con quello pre-modifica: se è cambiato, l'hard link è rotto e va
  riparato.
- **Riparare un hard link rotto** quando il progetto ha uno script `resync.sh` nella cartella esterna del deploy
  (modello tipico, vedi p.es. `/var/www/glisdev.istricesrl.com/`):
  1. aggiungere il path al file `resync.txt` con prefisso `./dev/` (uno per riga)
  2. eseguire `./resync.sh` dalla cartella esterna (fa `mv` da progetto-corrente a progetto-gemello, poi `ln`
     di ritorno → propaga il contenuto attuale e ricrea l'hard link)
  3. eseguire `sudo _src/_sh/_lamp.permissions.secure.sh` per ripristinare owner/group/permessi
  4. ri-verificare con `stat` che entrambe le copie abbiano `Links: 2` e **stesso inode**
- Esiste solitamente anche `resync-da-glisweb.sh` (o equivalente) che fa l'inverso: scarta le modifiche locali e
  riallinea al progetto gemello. Usarlo solo se è esplicitamente quello che si vuole.
- Lo script diagnostico `sync-glisweb.sh` (o equivalente) elenca in un log i file con `Links: 1` (utile per
  scoprire altri hard link rotti che andrebbero riparati).
- Per ripristinare solo i permessi: `_src/_sh/_lamp.permissions.secure.sh` (produzione) o
  `_src/_sh/_lamp.permissions.open.sh` (sviluppo).

Per personalizzare un file standard, creare il corrispondente senza underscore iniziale:

| File standard | File custom (sostituisce) | File custom (aggiunge dopo) |
|---|---|---|
| `_src/_lib/_example.php` | `src/lib/example.php` o `src/lib/example.alt.php` | `src/lib/example.add.php` |
| `_src/_config/_100.factory.php` | `src/config/100.factory.php` | — |

`_src/_config.php` rileva e carica i file custom automaticamente tramite `path2custom()` e `glob2custom()`.

---

## Come trovare le credenziali del database (e degli altri servizi)

Le credenziali non sono in un unico file: il bootstrap le assembla leggendo più file in sequenza e fondendoli con
`array_replace_recursive()`. L'ultimo file letto vince in caso di chiavi duplicate.

**Ordine di lettura dei file di configurazione** (prima vince il file letto per ultimo — "last wins"):

Prima i YAML, poi i JSON; all'interno di ciascun gruppo, prima `ext/` poi `src/`, prima `config.*` poi `shadow.*`:

| Priorità | File | Note |
|---|---|---|
| 8 — minima | `src/config/ext/config.yaml` | default di estensione |
| 7 | `src/config/ext/shadow.yaml` | git-ignored |
| 6 | `src/config.yaml` | config principale |
| 5 | `src/shadow.yaml` | git-ignored |
| 4 | `src/config/ext/config.json` | |
| 3 | `src/config/ext/shadow.json` | git-ignored |
| 2 | `src/config.json` | |
| 1 — massima | `src/shadow.json` | git-ignored |

I file shadow non sono versionati: esistono solo in produzione/staging. Per trovare le credenziali di un progetto
leggere nell'ordine di priorità decrescente: `src/shadow.json` → `src/config.json` → `src/shadow.yaml` →
`src/config.yaml`. La stessa logica vale per i moduli: `mod/<nome>/src/config.yaml` +
`mod/<nome>/src/shadow.yaml`.

La struttura YAML per MySQL è sempre:

```yaml
mysql:
  servers:
    <nome_server>:
      address: "..."
      port: "3306"
      username: "..."
      password: "..."
      db: "..."
  profiles:
    DEV:
      servers:
        - "<nome_server>"
```

**Profilo attivo (`SITE_STATUS`):** la costante `SITE_STATUS` vale `DEV`, `TEST` o `PROD` ed è determinata
automaticamente dal bootstrap confrontando l'`HTTP_HOST` della richiesta con i domini configurati in
`$cf['sites']`. Non va impostata manualmente.

---

## Architettura in sintesi

```
HTTP request → .htaccess → _src/_api/*.php → _src/_config.php (bootstrap)
                                                      ↓
                                           librerie + runlevel
                                                      ↓
                                       macro → template Twig → output
```

### Array globali principali

| Array | Contenuto |
|---|---|
| `$cf` | Tutta la configurazione interna del framework; non esposto ai template. |
| `$ct` | Sottoinsieme di `$cf` passato a Twig; popolato dai runlevel. |
| `$cx` | Configurazione letta dai file JSON/YAML; unita in `$cf` via `array_replace_recursive()`. |

### Runlevel (`_src/_config/_NNN.factory.php`)

| Range | Dominio |
|---|---|
| 000 | inizializzazione framework e deploy |
| 100 | sorgenti dati (MySQL, Redis, Memcached, FTP) |
| 200 | autenticazione, utente corrente, permessi |
| 300 | routing pagine |
| 400 | riscrittura URL |
| 500 | servizi esterni (SMTP, ecc.) |
| 600 | integrazioni piattaforme terze |
| 700 | import/export/elaborazione dati |
| 900 | sitemap, privacy, debug |

I file dei moduli vengono caricati dopo quelli base ad ogni passata di runlevel.

### API (`_src/_api/`)

| File | Scopo |
|---|---|
| `_pages.php` | rendering pagine HTML (entry point principale) |
| `_download.php` | download file |
| `_upload.php` | upload file |
| `_rest.php` | risposte REST |
| `_cron.php` | esecuzione cron job |
| `_job.php` | job in background |
| `_user.php` | azioni account utente |

### Librerie (`_src/_lib/`)

Convenzione di nome `_<nome>.<tipo>.php`:
- **tools** — utility standalone, senza dipendenze da `$cf`/`$ct`
- **utils** — dipendono da `$cf`/`$ct`

Le librerie esterne (Composer) si trovano in `_src/_lib/_ext/`, non in `vendor/`.

### Template e i18n

- Template Twig standard in `_src/_twig/`, custom in `src/twig/`.
- Macro Twig in `_src/_twig/_lib/`, sempre importate con prefisso fisso: `cms`, `frm`, `nav`, `prv`, `trn`.
- Traduzioni in `_etc/_dictionaries/_generic.<lang>-<COUNTRY>.conf`, esposte ai template come `$ct['tr']`.

### Caching locale di CSS e JS esterni

Le risorse remote dichiarate in `page.css.external` e `page.js.external` (file `etc/template.yaml` o
`etc/template.conf` del template) vengono cachate automaticamente su filesystem dal framework durante il
rendering della pagina (`_src/_api/_pages.php`):

- Path locale: `var/cache/css/<host>/<path>` e `var/cache/js/<host>/<path>` (creati on-demand alla prima
  richiesta della pagina, con permessi `www-data:www-data` se la dir esiste già; per i CSS vengono cachate
  anche le risorse riferite via `url(...)` — font, immagini).
- Lo URL cachato viene spostato in `page.css.cached` (multilivello per media) o `page.js.cached` (flat) e
  rimosso da `external`. I template `_inc/_page.head.twig` e `_inc/_page.close.twig` emettono i tag
  `<link>` / `<script defer>` puntando alla copia locale (`{{ site.root }}{{ ... }}`).
- Le URL contenenti marker Twig (`{{`, `{%`, `{#`) non vengono cachate (per i JS sono pre-renderizzate
  runtime via `include(template_from_string(...))`, p.es. recaptcha con site key dinamica) e restano in
  `external`.
- **Nessun TTL o refresh automatico**: per aggiornare/invalidare una risorsa si cancella manualmente il
  file in `var/cache/css/` o `var/cache/js/`, oppure si usa una URL versionata (`bootstrap@5.3.2/...`).

### Moduli (`_mod/` e `mod/`)

Un modulo `_mod/_XXXXX.name/` è attivo solo se esiste la directory corrispondente in `mod/`. Ogni modulo replica
la struttura base (`_src/_config/`, `_src/_lib/`, ecc.) e i suoi file vengono caricati dopo quelli base.

---

## Log e debug

I file di log si trovano in `var/log/`. Per il debug rapido i più utili sono i "latest":

| File | Contenuto |
|---|---|
| `var/log/latest/run.latest.log` | log dell'ultima richiesta HTTP |
| `var/log/latest/mysql.latest.log` | query MySQL dell'ultima richiesta |
| `var/log/latest/cron.latest.log` | ultimo cron job eseguito |

Le sottocartelle `var/log/mysql/`, `var/log/cron/`, `var/log/job/`, `var/log/slow/` contengono i log storici
con rotazione (default: mensile in DEV, configurabile via `$cf['debug']['log']['rotation']`).

Il livello di log è configurabile per profilo in `src/config.yaml` sotto la chiave `debug.DEV.log.lvl`
(valori 0–7 secondo le costanti syslog PHP: 7 = LOG_DEBUG, 3 = LOG_ERR).

---

## Comandi utili

```bash
# Dipendenze Composer (da eseguire dalla document root del progetto)
composer update

# Aggiornamento con script del framework (richiede root)
_src/_sh/_composer.update.sh --soft   # composer update semplice
_src/_sh/_composer.update.sh --hard   # azzera vendor e riesegue

# Test di accettazione (Codeception)
_src/_sh/_codeception.run.sh

# Build documentazione Doxygen
_src/_sh/_doxygen.build.sh

# Setup LAMP da zero (Debian/Ubuntu, come root)
_src/_sh/_lamp.setup.sh
```

---

## Verifica di feature/fix via interfaccia web

Per verificare che una feature funzioni o che una fix sia andata a buon fine, oltre a leggere il codice è disponibile
lo script `_src/_sh/_smoke.curl.sh` che fa smoke test della web app via `curl` con cookie jar persistente. Utile per
controllare status code e pattern nell'HTML su pagine pubbliche e su area riservata.

**Login flow del framework** (utile da sapere quando si scrivono test o si debuggano problemi di auth):

- Il form di login non usa CSRF token: bastano i campi POST `__login__[user]` e `__login__[pasw]` (la password viene
  hashmata in MD5 lato backend).
- URL di login per default: `/login.it-IT.html` (la pagina è dinamica, server-renderizzata da `_src/_api/_pages.php`).
- Il backend confronta contro `$cf['auth']['accounts']` (config) o la vista MySQL `account_view` (fallback).
- A login riuscito viene popolato `$_SESSION['account']`; il cookie di sessione è il `PHPSESSID` standard di PHP, con
  `cookie_secure=1` (richiede HTTPS) e `cookie_httponly=1`. Storage sessioni: Redis → Memcached → file system.
- File rilevanti: `_src/_config/_210.auth.php` (logica di autenticazione), `_src/_config/_050.session.php`
  (configurazione sessione), `_src/_api/_user.php` (endpoint REST per login JSON).

Per usare lo script servono `TEST_USER` e `TEST_PASS` come variabili d'ambiente (mai committarle in
`config.yaml`/`shadow.yaml` se non già previsto dal progetto). Il cookie jar finisce in `var/tmp/` (path già coperto
dal `.gitignore` del framework).
