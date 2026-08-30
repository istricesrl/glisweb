---
name: glisweb
description: Bootstrap, configurazione e uso quotidiano di progetti basati sul framework PHP glisweb. Attivare quando si rileva _src/_config.php + _etc/_claude/_claude.framework.md nella cwd, quando l'utente chiede di "creare/inizializzare un progetto glisweb", "scaricare il framework glisweb", "aggiungere CLAUDE.md a un progetto glisweb", oppure quando si lavora in una directory con cartelle _src/, _mod/, _usr/ con convenzione underscore-prefix tipica di glisweb. Attivare anche prima di toccare src/config.yaml o src/config.json, di aggiungere una chiave di configurazione o un runlevel custom, o di gestire un valore che cambia fra DEV/TEST/PROD: la sezione "Configurazione multi-ambiente" contiene la convenzione profiles/profile e la coppia di runlevel N0/N5. Attivare inoltre prima di toccare il TODO.md o il burndown.md di un progetto, e quando l'utente parla di "todo", "cose da fare", "backlog", "task aperti", "avanzamento" o "burndown": i quattro marcatori ([ ] da fare, [?] da approfondire, [v] fatta, [x] scartata) e le regole di scrittura da cui dipendono i conteggi stanno nella sezione "Cose da fare" di _etc/_claude/_claude.framework.md. Attivare sempre prima di scrivere codice nuovo — una libreria, un modulo, un runlevel, un template, una query, uno script: vale la REGOLA D'ORO in cima al file, non si inventa niente se nel framework esiste già un pattern simile, lo si riusa. Attivare infine prima di creare un backup o una copia di sicurezza di un file di progetto: i backup non vanno mai dentro la document root ma in <progetto>/var/<identificativo>/, e un nome tipo file.php.bak.<data> aggira il FilesMatch del .htaccess ed espone il sorgente.
---

# Skill `glisweb`

Aiuta Claude a riconoscere, inizializzare e usare correttamente un progetto basato sul framework PHP **glisweb**.

## ⚠ REGOLA D'ORO DEL PROGETTO: non inventare, riusa i pattern esistenti

**Non si inventa MAI niente se nel framework c'è già implementato qualcosa di simile.** La coerenza interna
del progetto è ESSENZIALE e i pattern di sviluppo devono RIPETERSI IL PIÙ POSSIBILE: si riusano i pattern
esistenti, oppure — se c'è davvero da creare qualcosa di nuovo — lo si fa **a partire da quelli**, rispettando
lo stile e la struttura del resto del codice.

Viene prima di ogni altra regola operativa di questo file, e vale per tutto: nomi, forma dei file, ordine dei
runlevel, firme delle funzioni, struttura dei template, formattazione, commenti, messaggi di log.

**Prima di scrivere una riga nuova, cerca il precedente.** È un passo obbligatorio, non un'ottimizzazione:

```bash
# c'è già una libreria/funzione che fa una cosa simile?
grep -rn "<parola chiave>" _src/_lib/ _mod/ src/ mod/ | head -30

# come si chiama e com'è fatto qualcosa dello stesso tipo?
ls _src/_lib/ _src/_config/ _mod/ _src/_twig/
```

Poi apri **due o tre esempi esistenti dello stesso tipo** e copiane la forma. Gli esempi canonici per i casi
più frequenti sono già citati in questo file: la coppia `N0`/`N5` per un namespace di configurazione (§4.2),
la tabella overrides per estendere una libreria standard (§5), `_mod/_<nome>/` per un modulo.

**La forma dell'esistente comanda, anche quando non ti piace.** Se il framework usa `array( … )` non scrivi
`[ … ]`; se usa uno spazio dentro le parentesi lo usi anche tu; se i file di un certo tipo si chiamano in un
certo modo, il tuo si chiama così. Una soluzione più elegante ma diversa dalle altre venti è **peggiore** di
una identica alle altre venti: il costo di leggere e manutenere venti varianti di uno stesso pattern supera
qualsiasi guadagno locale.

**Cosa vale come "qualcosa di simile".** Non deve fare la stessa cosa, deve essere dello **stesso tipo**: un
altro runlevel, un'altra libreria di quel gruppo, un altro modulo, un'altra pagina, un altro script di `_sh/`,
un altro job. Se non trovi nulla di simile, quasi sempre significa che non hai cercato abbastanza — è raro che
un'esigenza sia davvero senza precedenti in questo framework.

**Se un pattern esistente non va bene**, non deviare in silenzio: dillo all'utente, spiega perché il pattern
non regge in quel caso e proponi la variante minima che se ne discosta. La deroga è una decisione, non un
effetto collaterale.

## Cose da fare

Il backlog di un progetto sta in `TODO.md` nella root del deploy, il `burndown.md` accanto è generato e non
si tocca a mano. I marcatori validi sono quattro — `- [ ]` da fare, `- [?]` da approfondire, `- [v]` fatta,
`- [x]` scartata — e i conteggi sono ancorati a inizio riga, quindi il `- ` iniziale e l'assenza di
indentazione non sono dettagli stilistici. La regola completa sta nella sezione **"Cose da fare"** di
`_etc/_claude/_claude.framework.md`, che è la fonte autorevole: leggila prima di modificare un `TODO.md`.

## ⚠ Regola fondamentale: governance cliente vs upstream

Esistono **due ruoli distinti** per i progetti glisweb, e il workflow per modificare il framework è
profondamente diverso fra i due:

| Ruolo | Cosa è | Dove |
|---|---|---|
| **Progetto cliente** (usa il framework) | La stragrande maggioranza dei progetti. Le `_*` sono framework standard, NON si modificano direttamente. Le modifiche custom vanno in `src/`, `mod/`, `var/`. | Tutto tranne i due path qui sotto. |
| **Progetto upstream** (sviluppa il framework) | Solo `glisweb.istricesrl.it` (composer `istricesrl/glisweb`) e `glisdev.istricesrl.com`. Qui le `_*` SONO il sorgente principale e si modificano direttamente. | `/var/www/glisweb.istricesrl.it/` e `/var/www/glisdev.istricesrl.com/`. |

### Perché glisweb e glisdev condividono gli inode

I due deploy upstream **non sono due copie**: la gran parte dei loro file è lo **stesso file**, condiviso
via hard link. `glisdev.istricesrl.com` è la versione instabile su cui si lavora, `glisweb.istricesrl.it`
quella distribuita. I link esistono per impedire che le due divergano in un **fork involontario**: una
modifica fatta da una parte è già dall'altra, perché è lo stesso file su disco.

La regola di cosa si condivide segue la solita convenzione dell'underscore: **le cartelle di framework
(`_src/`, `_mod/`, `_etc/`, `_usr/`) sono condivise**, quelle di istanza (`src/`, `mod/`, `etc/`, `usr/`,
`var/`, `tmp/`) no, insieme a `composer.lock`, `.gitignore`, `_etc/_current.version`,
`_etc/_current.release`, `_src/_lib/_ext`, `_usr/_docs/_html|_pdf`, `_usr/_examples`, `_usr/_test`. Dentro
l'area condivisa resta un pugno di file deliberatamente forkati, quelli su cui il lavoro in corso è
divergente. Al 2026-08-27: **1115 file condivisi, 13 forkati**.

### Gli strumenti per il lavoro in parallelo

Stanno nella root di `glisdev.istricesrl.com` e si lanciano da lì. **Sono questi gli strumenti da usare:
non scriverne altri.**

| comando | cosa fa |
|---|---|
| `./sync-glisweb.sh` | inventario. Scrive `sync-glisweb.log` con l'elenco dei file **non** condivisi (`find -links 1`, più una lista di esclusioni) e di quelli condivisi. È il modo per accorgersi di un link rotto |
| `./sync-add.sh <path>` | aggiunge un singolo file all'insieme condiviso, linkandolo da glisweb |
| `./sync-tpl.sh` · `./sync-mod.sh <modulo>` · `./sync-bkg.sh` · `./sync-flags.sh` | `sync-add` in blocco su interi sottoalberi (template, un modulo, immagini di sfondo, bandiere) |
| `./resync.sh` | riporta in sincronia i file elencati in `resync.txt` facendo vincere la versione di **glisdev**: la sposta su glisweb e rilinka |
| `./resync-da-glisweb.sh` | stessa lista, ma fa vincere **glisweb**: cancella la copia di glisdev e rilinka |

Il flusso è: si forka un file semplicemente modificandolo in modo che perda il link, ci si lavora, e quando
è pronto lo si mette in `resync.txt` e si lancia lo script che fa vincere il lato giusto.

### Come si rompono i link senza accorgersene

Git non modifica i file sul posto: li sostituisce. Un `git checkout`, `merge`, `reset --hard`, `pull` o
`stash` che tocchi un file condiviso ne crea uno nuovo e **spezza il link**, in silenzio. Lo stesso fa
`sed -i`, che scrive un temporaneo e rinomina (verificato). Un editor che tronca e riscrive lo stesso
inode invece va bene.

Quindi:

1. modificare i file **sul posto**;
2. per aggiornare un branch remoto quando è un fast-forward, spingere il ref senza toccare la working
   copy — `git push origin <branch>:<destinazione>` invece di `checkout` + `merge` + `push`;
3. **dopo qualunque operazione git su questi due deploy, lanciare `./sync-glisweb.sh`** e confrontare
   l'elenco dei non condivisi con quello che ci si aspetta; se un file è finito lì per sbaglio,
   rimetterlo in sincronia con `resync.sh` o `resync-da-glisweb.sh`.

**Dai progetti cliente è VIETATO modificare direttamente glisweb o glisdev** (file, git, hard link,
permessi, qualsiasi cosa). Anche se si ha accesso SSH/filesystem ai deploy upstream — non si fa.

Se da un progetto cliente serve correggere il framework standard, il workflow è:

1. **Modificare localmente** nel progetto cliente. Per quasi tutti i casi: creare un override custom senza
   underscore (es. `src/lib/example.php` per estendere `_src/_lib/_example.php`, vedi tabella overrides nel
   manuale framework). Per fix urgenti che toccano davvero un file `_*`, modificarlo *nel progetto cliente
   stesso*, lì localmente.
2. **Sincronizzazione notturna**: un job notturno raccoglie le divergenze del progetto cliente rispetto al
   framework standard e genera un *disallineamento* che confluisce in `glisweb.istricesrl.it`.
3. **Valutazione**: su `glisweb` un manutentore del framework valuta il disallineamento. Se la modifica è
   generalizzabile, entra nel codice standard del framework; altrimenti resta una customizzazione del solo
   progetto cliente (e va consolidata in `src/`/`mod/` del cliente).
4. **Redistribuzione**: le modifiche accettate vengono committate nel framework e ridistribuite ai
   progetti cliente al successivo aggiornamento (`composer update` + `_src/_sh/_gw.upgrade.sh` o
   equivalente).

**Anti-pattern da NON fare mai, da un progetto cliente:**

- SSH/edit/git su `/var/www/glisweb.istricesrl.it/` o `/var/www/glisdev.istricesrl.com/` per "anticipare"
  un fix che vorresti veder ridistribuito. Bypassi la valutazione, e rischi di propagare modifiche non
  validate a tutti gli altri progetti cliente.
- Aprire PR o push diretti verso i repo upstream del framework "perché ho una fix urgente". Il canale
  corretto è comunque il disallineamento — i manutentori del framework hanno strumenti per fast-track.
- Toccare gli hard link fra `glisweb` e `glisdev` da un progetto cliente. La gestione degli hard link è
  competenza esclusiva dei manutentori upstream.

**Come capire in che ruolo sei:**

```bash
# Sei nel progetto upstream se composer name è quello del framework
grep -q '"name": "istricesrl/glisweb"' composer.json && echo "UPSTREAM" || echo "CLIENTE"

# In alternativa, controlla il path della cwd:
pwd | grep -qE '/var/www/(glisweb\.istricesrl\.it|glisdev\.istricesrl\.com)' \
  && echo "UPSTREAM" || echo "CLIENTE"
```

Se il check dice **CLIENTE**, applica questa regola in modo assoluto: nessuna modifica all'upstream, per
nessun motivo. Se dice **UPSTREAM**, vedi sezione "Modalità B — Operatività" e il manuale framework per
le specificità della valutazione disallineamenti e del rispetto degli hard link fra glisweb e glisdev.

## ⚠ Regola fondamentale: nessun backup dentro la document root

La document root di un progetto è `<progetto>/dev/` (o il ramo deployato). **Non ci va mai un backup**:
né una copia di sicurezza prima di una modifica, né un file di appoggio, né uno scarto — e nemmeno dentro
`dev/var/`, che è comunque sotto la document root.

I backup vanno in **`<progetto>/var/<identificativo>/`**, un livello **sopra** la document root,
conservando il nome originale del file e, se serve a distinguerlo, il suo percorso relativo:

```
<progetto>/
├── var/
│   └── 20260827-pulizia/          <- identificativo: data, o data-motivo
│       └── composer.json          <- nome originale, non composer.json.bak
└── dev/                           <- document root: qui dentro niente backup
```

Sono da considerare rusco, ovunque nell'albero: `*.bak`, `*.old`, `*.orig`, `*.save`, `*~`,
`nome.php.bak.<data>`. Se ne trovi, spostali in `var/<identificativo>/` — non lasciarli dove sono.

**Perché non è una questione di ordine ma di sicurezza.** Il `.htaccess` del framework nega l'accesso alle
estensioni pericolose con un `FilesMatch` **ancorato alla fine del nome**:

```apache
<FilesMatch "(?i)\.(bak|blt|cfg|conf|config|...|sql|sqlite|swp|templ|trace|twig)$">
    Deny from all
</FilesMatch>
```

Un file chiamato `pagina.php.bak.20260827` finisce per `.20260827`, non fa match, e Apache lo serve in
chiaro: è codice sorgente pubblico. Verificato il 2026-08-27 su un deploy reale — `zz.test.php.bak`
risponde **403**, `zz.test.php.bak.20260827` risponde **200 con il contenuto**. La convenzione di
aggiungere la data in coda al nome, che sembra più ordinata, è proprio quella che aggira la protezione.

Dentro `dev/var/` il download API del framework para il colpo (`400 richiesta bloccata`), ma è una rete di
sicurezza, non un permesso: il posto giusto resta sopra la document root.

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

## 4. Configurazione multi-ambiente: `profiles` / `profile`

`_claude.framework.md` documenta l'**ordine di lettura** dei file di configurazione e la forma dei profili
MySQL. Qui c'è la convenzione per **scriverne di nuovi**, che è la parte che si sbaglia più spesso.

### 4.1 I file di configurazione sono artefatti di deploy

`src/config.yaml` / `src/config.json` vengono copiati **identici** su DEV, TEST e PROD. Ne segue una regola
senza eccezioni: **non possono contenere un valore che vale per un ambiente solo.** Un valore misurato su un
ambiente (un id, una soglia, un endpoint interno) messo lì nudo è un bug latente che esplode al primo deploy,
in silenzio e sull'ambiente sbagliato.

Quando un valore cambia da ambiente ad ambiente si mette sotto un ramo per ambiente — è quello che fanno già
`mysql`, `memcache`, `redis`, `google`, `microsoft`, `teamsystem`, `zucchetti`, `emailable`, `sites`:

```yaml
<ns>:
  profiles:
    DEV:  { ... }
    TEST: { ... }
    PROD: { ... }
```

Le chiavi sono i valori delle costanti `DEVELOPEMENT` / `TESTING` / `PRODUCTION` (`'DEV'` / `'TEST'` /
`'PROD'`, definite in `_src/_config/_000.debug.php`). Il ramo attivo si sceglie con `SITE_STATUS`.

### 4.2 La coppia di runlevel `N0` / `N5`

Un namespace a profili **non sta mai in un file solo**: sta in due runlevel accoppiati, con ruoli distinti.
Non è una convenzione estetica — è come il framework separa la dichiarazione dall'attivazione, e permette al
progetto di inserirsi in mezzo.

| File | Ruolo | Cosa contiene |
|---|---|---|
| `_NNN0.<nome>.php` | **dichiarazione** | solo i default, un ramo per profilo. Niente merge, niente link, niente logica |
| `_NNN5.<nome>.php` | **attivazione** | merge di `$cx`, collegamento a `$ct`, link al profilo corrente, e tutto ciò che *consuma* il profilo |

```php
// runlevel N0 — dichiarazione
$cf['<ns>']['profiles'][ DEVELOPEMENT ] =
$cf['<ns>']['profiles'][ TESTING ]      =
$cf['<ns>']['profiles'][ PRODUCTION ]   = array( /* default identici per tutti */ );

// runlevel N5 — attivazione
if( isset( $cx['<ns>'] ) ) {
    $cf['<ns>'] = array_replace_recursive( $cf['<ns>'], $cx['<ns>'] );
}
$ct['<ns>']            = &$cf['<ns>'];
$cf['<ns>']['profile'] = &$cf['<ns>']['profiles'][ SITE_STATUS ];
// ...e poi il consumo: in _125.mysql.php è la connessione ai server del profilo
```

Esempi da leggere prima di scriverne uno nuovo: `_120`/`_125` (mysql), `_040`/`_045` (cache), `_110`/`_115`
(google), `_160`/`_165` (microsoft), `_600`/`_605` (teamsystem, zucchetti, emailable).

**Da qui in poi il codice legge sempre da `$cf['<ns>']['profile']`**, mai da `$cf['<ns>']['<chiave>']`. Se
trovi codice che legge la seconda forma su un namespace a profili, è un bug: sta ignorando l'ambiente.

**Ordine di inclusione** (il loop dei runlevel in `_src/_config.php` fa `glob()` sui soli file standard, poi
`sort()`, e ricava la controparte custom con `path2custom()`):

```
_N0 standard  →  N0 custom  →  _N5 standard  →  N5 custom
```

Quando `_N5` fa il merge i default del progetto (dichiarati in `N0` custom) ci sono già, e un `N5` custom può
contare sul profilo già agganciato. **Servono i gemelli standard per entrambi**: un file in `src/config/`
senza `_src/_config/_<stesso nome>.php` non viene incluso mai, silenziosamente. Se il namespace è di progetto,
i due file standard esistono lo stesso e sono quasi vuoti — sono ganci.

Se i profili li dichiara il progetto e non lo standard (namespace project-specific), nel `_N5` standard
condiziona il link, o creerai un profilo vuoto per il solo effetto del riferimento:

```php
if( isset( $cf['<ns>']['profiles'][ SITE_STATUS ] ) ) {
    $cf['<ns>']['profile'] = &$cf['<ns>']['profiles'][ SITE_STATUS ];
}
```

### 4.3 I valori di lavoro non sono configurazione

Distinta dalla regola sui profili, e altrettanto importante: **quello che si ricalcola, si sposta o va
misurato sul database dell'ambiente non va nei file di configurazione.** Soglie, cutoff, cursori, ultimi id
lavorati, timestamp dell'ultima esecuzione: quella roba sta in **`var/spool/<qualcosa>/`**.

`var/` è escluso dal deploy, quindi il valore resta locale all'ambiente **per costruzione** — non serve
ricordarsi di non spedirlo, non c'è il modo di farlo. Nei file di configurazione restano solo gli
**interruttori** e i parametri stabili.

Forma tipica: un file per valore, con dentro il solo numero, letto nel runlevel `N5` (è consumo del profilo).
File assente o non parsabile = valore NULL = funzione ferma, che è la posizione sicura: su un ambiente nuovo
la cosa parte spenta senza che nessuno debba ricordarsene. Definisci la cartella come costante accanto alle
altre `DIR_VAR_SPOOL_*` in `_src/_config.php`, non con un `define()` inline nel runlevel.

**Euristica**: se per scrivere quel valore hai dovuto interrogare il database di quell'ambiente, non è
configurazione — è spool.

## 5. Mappa rapida task → file

| Cosa vuoi fare | Dove agire |
|---|---|
| Cambiare credenziali DB | `src/shadow.yaml` (mai `config.yaml`) |
| Aggiungere/modificare un runlevel custom | `src/config/NNN.<nome>.php` (serve il gemello standard `_src/_config/_NNN.<nome>.php`) |
| Aggiungere un namespace di configurazione a profili | coppia `N0`/`N5`, vedi §4.2 — mai un file solo |
| Valore che cambia da ambiente ad ambiente | ramo `profiles.<DEV\|TEST\|PROD>` in `config.yaml`/`config.json`, letto da `$cf['<ns>']['profile']` |
| Valore di lavoro (soglia, cutoff, cursore, ultimo id) | `var/spool/<qualcosa>/`, **mai** nei file di configurazione |
| Override di una libreria standard | `src/lib/<nome>.php` (replace), `.add.php` (append) |
| Override di un template Twig | `src/twig/<nome>.twig` |
| Attivare un modulo standard | creare la cartella `mod/<nome>/` corrispondente a `_mod/_<nome>/` |
| Smoke test di una pagina | `_src/_sh/_smoke.curl.sh status <url>` |
| Aggiornare dipendenze Composer | `composer update` (dalla root del progetto) |
| Ricostruire la documentazione Doxygen | `_src/_sh/_doxygen.build.sh` |
| Vedere l'ultima richiesta HTTP | `var/log/latest/run.latest.log` |
| Vedere le query MySQL dell'ultima richiesta | `var/log/latest/mysql.latest.log` |

## 6. Anti-pattern da evitare assolutamente

- **Non scrivere niente di nuovo senza aver prima cercato il precedente nel framework.** Una libreria, un
  runlevel, un modulo, un template o uno script inventati da zero mentre ne esistevano venti dello stesso tipo
  sono un errore anche se funzionano — vedi la REGOLA D'ORO in cima a questo file. Il sintomo è un file che non
  somiglia a nessuno dei suoi vicini: nome fuori convenzione, stile diverso, struttura diversa.
- **Da un progetto cliente, NON modificare mai direttamente `/var/www/glisweb.istricesrl.it/` o
  `/var/www/glisdev.istricesrl.com/`.** Le fix al framework vanno passate per il flusso disallineamenti —
  vedi la "Regola fondamentale" in cima a questo file.
- **Non modificare mai un file `_*` senza prima un `stat` e dopo un `stat` di verifica.** Il framework potrebbe
  essere hard-linked con un'altra istanza (oldstable). Vedi sezione hard link in `_claude.framework.md`.
- **Non committare `shadow.*` files.** Contengono credenziali. Sono già coperti dal `.gitignore` del framework
  e dovrebbero esserlo anche dal `.gitignore` del progetto cliente.
- **Non mettere credenziali in `config.yaml`.** Quel file è committato — usa `shadow.yaml` per ogni cosa
  sensibile.
- **Non mettere in `config.yaml`/`config.json` un valore valido per un ambiente solo.** Quei file si deployano
  identici ovunque: se il valore cambia fra DEV/TEST/PROD va sotto `profiles`, se è un valore di lavoro va in
  `var/spool/`. Vedi §4 — è l'errore più costoso perché non dà alcun segnale finché non deploy.
- **Non schiacciare dichiarazione e attivazione in un unico runlevel.** Un namespace a profili sta nella coppia
  `N0`/`N5`. Il sintomo tipico di averlo sbagliato è ritrovarsi un `define()` inline o un `if( !defined(...) )`
  dentro un file che dovrebbe solo dichiarare default.
- **Non leggere `$cf['<ns>']['<chiave>']` su un namespace a profili.** Si legge da `$cf['<ns>']['profile']`,
  altrimenti stai ignorando `SITE_STATUS` e leggendo l'ambiente sbagliato.
- **Non rinominare/spostare i file `_*` del framework.** Servono al kernel per l'auto-discovery dei custom.
- **Non duplicare le regole del framework** in `CLAUDE.md` del progetto: limitati a override e contesto
  progetto-specifico, lascia il manuale operativo a `_claude.framework.md`.

## 7. Coesistenza con `CLAUDE.md` del progetto

Il template `CLAUDE.md.template` (copiato dal bootstrap) ha come prima riga:

```markdown
@_etc/_claude/_claude.framework.md
```

Questo significa che `_claude.framework.md` viene caricato automaticamente da Claude Code quando apre il
progetto cliente. Se sei in una sessione con `CLAUDE.md` già attivo, il file framework è già in contesto:
**non richiamarlo né rileggerlo**, basta consultarlo per riferimento. Se stai facendo bootstrap di un nuovo
progetto, il `CLAUDE.md` non esiste ancora — in quel caso leggi `_claude.framework.md` manualmente con `Read`.

## 8. Note sulla skill stessa

- Questa skill è distribuita **dentro al repository del framework** (cartella `.claude/skills/glisweb/`). È
  l'unica cartella senza prefisso underscore che è versionata di proposito — deroga consapevole alla regola
  "no underscore = custom = gitignored".
- Modifiche alla skill vanno fatte solo nel repo del framework, mai dal progetto cliente: in alcuni deploy il
  framework è hard-linked con altre istanze e una Edit dal cliente potrebbe rompere gli inode (vedi
  `_claude.framework.md` sezione hard link).
- Per testare la skill end-to-end: `mkdir /tmp/test-glisweb && cd /tmp/test-glisweb && git clone <repo> .` poi
  `bash .claude/skills/glisweb/bootstrap.sh` e verifica struttura creata + idempotenza.
