---
name: glisweb
description: Bootstrap, configurazione e uso quotidiano di progetti basati sul framework PHP glisweb. Attivare quando si rileva _src/_config.php + _etc/_claude/_claude.framework.md nella cwd, quando l'utente chiede di "creare/inizializzare un progetto glisweb", "scaricare il framework glisweb", "aggiungere CLAUDE.md a un progetto glisweb", oppure quando si lavora in una directory con cartelle _src/, _mod/, _usr/ con convenzione underscore-prefix tipica di glisweb.
---

# Skill `glisweb`

Aiuta Claude a riconoscere, inizializzare e usare correttamente un progetto basato sul framework PHP **glisweb**.

## 1. Come capire il contesto

Prima di qualsiasi azione, controlla cosa esiste nella cwd (oppure nel `--target` indicato dall'utente):

| Check | Significato |
|---|---|
| `_src/_config.php` presente | Il framework è già clonato qui. |
| `_etc/_claude/_claude.framework.md` presente | Versione aggiornata del framework con istruzioni per Claude. **Leggilo subito**: contiene le regole operative complete. |
| `CLAUDE.md` presente nella root | Il progetto cliente è già stato inizializzato. La prima riga dovrebbe contenere `@_etc/_claude/_claude.framework.md`. |
| `src/config.yaml` presente | Configurazione del progetto cliente già scritta. |

Da questi quattro segnali decidi la modalità:

- Mancano `CLAUDE.md` e/o `src/config.yaml`, ma `_src/_config.php` c'è → **modalità A — Bootstrap**.
- Tutto presente → **modalità B — Operatività**.
- Manca `_src/_config.php` → **non sei in un progetto glisweb**. Fermati, chiedi conferma all'utente prima di
  procedere.

## 2. Modalità A — Bootstrap nuovo progetto

Lo script `bootstrap.sh` nella stessa cartella di questa skill crea la struttura minima di un progetto cliente:
cartelle `src/`, `mod/`, `var/` e copia i template `CLAUDE.md`, `src/config.yaml`. È idempotente — esecuzioni
ripetute non rompono nulla.

```bash
# Bootstrap nella cwd
bash .claude/skills/glisweb/bootstrap.sh

# Su un target specifico
bash .claude/skills/glisweb/bootstrap.sh --target /var/www/nuovosito.example

# Forzare la sovrascrittura dei file template esistenti
bash .claude/skills/glisweb/bootstrap.sh --force

# Copiare anche shadow.yaml (NON committarlo dopo)
bash .claude/skills/glisweb/bootstrap.sh --with-shadow
```

Step eseguiti dallo script (in ordine):

1. Verifica che `_src/_config.php` esista nel target. Se manca, esce con messaggio "framework non clonato qui".
2. Avvisa se `_etc/_claude/_claude.framework.md` manca (framework obsoleto) ma non blocca.
3. Crea cartelle: `src/{config,lib,twig}`, `mod/`, `var/{log/latest,cache,tmp}`.
4. Copia `CLAUDE.md.template` → `CLAUDE.md` con `{{PROJECT_NAME}}` sostituito dal `basename` del target.
5. Copia `config.yaml.template` → `src/config.yaml` con la stessa sostituzione.
6. Se `--with-shadow`: copia `shadow.yaml.example` → `src/shadow.yaml`.
7. Se UID 0: esegue `_src/_sh/_lamp.permissions.open.sh` (permessi sviluppo).
8. Stampa i prossimi passi suggeriti (`composer update`, edita `src/shadow.yaml`, `_lamp.permissions.secure.sh`).

Dopo il bootstrap, **proponi all'utente** di:

- editare `src/config.yaml` per impostare domini reali e nome database
- creare `src/shadow.yaml` con le credenziali reali (mai committarlo)
- eseguire `composer update` dalla root del progetto
- in produzione, eseguire `sudo _src/_sh/_lamp.permissions.secure.sh`

## 3. Modalità B — Operatività su progetto esistente

**Prima azione obbligatoria**: leggi `_etc/_claude/_claude.framework.md` se non già caricato in sessione (il
`CLAUDE.md` del progetto dovrebbe già fare `@_etc/_claude/_claude.framework.md`, quindi spesso è già in
contesto). Quel file contiene tutto il manuale operativo. Questa skill **non duplica** quei contenuti, li
richiama.

Riferimenti tipici a `_claude.framework.md`:

- "Regola fondamentale: non rompere mai i file standard" → hard link, `stat` pre/post, `resync.sh`
- "Come trovare le credenziali del database" → ordine config.yaml/shadow.yaml/json
- "Architettura in sintesi" → runlevel 000–900, array `$cf`/`$ct`/`$cx`
- "Log e debug" → `var/log/latest/*.latest.log`
- "Verifica di feature/fix via interfaccia web" → `_src/_sh/_smoke.curl.sh`

Se quel file non è presente nel framework che stai usando, fallback su `READ.md` nella root del framework e
ispeziona direttamente `_src/_config.php` per il bootstrap.

## 4. Mappa rapida task → file

| Cosa vuoi fare | Dove agire |
|---|---|
| Cambiare credenziali DB | `src/shadow.yaml` (mai `config.yaml`) |
| Aggiungere/modificare un runlevel custom | `src/config/NNN.factory.php` |
| Override di una libreria standard | `src/lib/<nome>.php` (replace), `.add.php` (append) |
| Override di un template Twig | `src/twig/<nome>.twig` |
| Attivare un modulo standard | creare la cartella `mod/<nome>/` corrispondente a `_mod/_<nome>/` |
| Smoke test di una pagina | `_src/_sh/_smoke.curl.sh status <url>` |
| Aggiornare dipendenze Composer | `composer update` (dalla root del progetto) |
| Ricostruire la documentazione Doxygen | `_src/_sh/_doxygen.build.sh` |
| Vedere l'ultima richiesta HTTP | `var/log/latest/run.latest.log` |
| Vedere le query MySQL dell'ultima richiesta | `var/log/latest/mysql.latest.log` |

## 5. Anti-pattern da evitare assolutamente

- **Non modificare mai un file `_*` senza prima un `stat` e dopo un `stat` di verifica.** Il framework potrebbe
  essere hard-linked con un'altra istanza (oldstable). Vedi sezione hard link in `_claude.framework.md`.
- **Non committare `shadow.*` files.** Contengono credenziali. Sono già coperti dal `.gitignore` del framework
  e dovrebbero esserlo anche dal `.gitignore` del progetto cliente.
- **Non mettere credenziali in `config.yaml`.** Quel file è committato — usa `shadow.yaml` per ogni cosa
  sensibile.
- **Non rinominare/spostare i file `_*` del framework.** Servono al kernel per l'auto-discovery dei custom.
- **Non duplicare le regole del framework** in `CLAUDE.md` del progetto: limitati a override e contesto
  progetto-specifico, lascia il manuale operativo a `_claude.framework.md`.

## 6. Coesistenza con `CLAUDE.md` del progetto

Il template `CLAUDE.md.template` (copiato dal bootstrap) ha come prima riga:

```markdown
@_etc/_claude/_claude.framework.md
```

Questo significa che `_claude.framework.md` viene caricato automaticamente da Claude Code quando apre il
progetto cliente. Se sei in una sessione con `CLAUDE.md` già attivo, il file framework è già in contesto:
**non richiamarlo né rileggerlo**, basta consultarlo per riferimento. Se stai facendo bootstrap di un nuovo
progetto, il `CLAUDE.md` non esiste ancora — in quel caso leggi `_claude.framework.md` manualmente con `Read`.

## 7. Note sulla skill stessa

- Questa skill è distribuita **dentro al repository del framework** (cartella `.claude/skills/glisweb/`). È
  l'unica cartella senza prefisso underscore che è versionata di proposito — deroga consapevole alla regola
  "no underscore = custom = gitignored".
- Modifiche alla skill vanno fatte solo nel repo del framework, mai dal progetto cliente: in alcuni deploy il
  framework è hard-linked con altre istanze e una Edit dal cliente potrebbe rompere gli inode (vedi
  `_claude.framework.md` sezione hard link).
- Per testare la skill end-to-end: `mkdir /tmp/test-glisweb && cd /tmp/test-glisweb && git clone <repo> .` poi
  `bash .claude/skills/glisweb/bootstrap.sh` e verifica struttura creata + idempotenza.
