# Glis Framework — istruzioni per Claude Code

Questo file fornisce a Claude Code le conoscenze operative necessarie per lavorare su un progetto basato sul framework Glis.
Viene distribuito con il framework e deve essere importato esplicitamente nel `CLAUDE.md` del progetto:

```markdown
@_etc/_claude/_claude.framework.md
```

Le istruzioni specifiche del progetto vanno nel `CLAUDE.md` del progetto, **dopo** questa riga di import, così
sovrascrivono eventualmente ciò che è definito qui.

---

## REGOLA D'ORO: non inventare, riusa i pattern esistenti

**Non si inventa MAI niente se nel framework c'è già implementato qualcosa di simile.** La coerenza interna del
progetto è ESSENZIALE e i pattern di sviluppo devono RIPETERSI IL PIÙ POSSIBILE: si riusano i pattern esistenti,
oppure — se c'è davvero da creare qualcosa di nuovo — lo si fa **a partire da quelli**, rispettando lo stile e la
struttura del resto del codice.

**Vale da tutt'e due i lati**: quando si sviluppa il framework e quando si sviluppa un progetto che lo usa.
E il motivo non è estetico, e non è nemmeno solo il costo di manutenzione. Glisweb è facile da imparare e da
usare **perché ripete il più possibile schemi concettuali che chi sviluppa ha già appreso**: chi ha capito un
runlevel li ha capiti tutti, chi ha scritto una macro sa scrivere la successiva, chi ha attivato un modulo sa
attivarli tutti. Ogni soluzione nuova introdotta senza necessità toglie esattamente questa proprietà, e la
toglie a tutti quelli che verranno dopo, non solo a chi l'ha scritta.

Viene prima di ogni altra regola di questo file e vale per tutto: nomi, forma dei file, ordine dei runlevel,
firme delle funzioni, struttura dei template, formattazione, commenti, messaggi di log.

**Cercare il precedente è un passo obbligatorio, non un'ottimizzazione.** Prima di scrivere una riga nuova:

```bash
grep -rn "<parola chiave>" _src/_lib/ _mod/ src/ mod/ | head -30   # esiste già qualcosa che fa una cosa simile?
ls _src/_lib/ _src/_config/ _mod/ _src/_twig/                      # com'è fatto e come si chiama il suo tipo?
```

Poi si aprono **due o tre esempi esistenti dello stesso tipo** e se ne copia la forma. "Simile" non vuol dire che
faccia la stessa cosa: vuol dire che è dello **stesso tipo** — un altro runlevel, un'altra libreria di quel gruppo,
un altro modulo, un'altra pagina, un altro script di `_src/_sh/`, un altro job. Se non si trova niente di simile,
quasi sempre vuol dire che non si è cercato abbastanza: è raro che un'esigenza sia senza precedenti qui dentro.

**La forma dell'esistente comanda, anche quando non piace.** Se il framework usa `array( … )` non si scrive
`[ … ]`; se mette gli spazi dentro le parentesi si mettono; se i file di un certo tipo si chiamano in un certo
modo, il nuovo si chiama così. Una soluzione più elegante ma diversa dalle altre venti è **peggiore** di una
identica alle altre venti — leggere e manutenere venti varianti dello stesso pattern costa più di qualunque
guadagno locale.

**Se un pattern esistente non regge**, non si devia in silenzio: lo si dice all'utente, si spiega perché, e si
propone la variante minima che se ne discosta. Introdurre una soluzione nuova o modificare il canone
dev'essere una **scelta consapevole ed espressamente autorizzata**: la deroga si chiede e si ottiene,
non è un effetto collaterale.

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

## Il materiale di progetto sta in `var/`, mai dentro la document root

La document root è `<progetto>/dev/`, e **dentro ci sta il sito, nient'altro**. Non ci va nessun materiale di
progetto: né copie di sicurezza prima di una modifica, né gli allegati arrivati dal cliente, né i documenti di
specifiche, né export, dump, tracciati, screenshot, analisi, appunti, prove, scarti. **Nemmeno in `dev/var/`**,
che è comunque sotto la document root.

Tutto questo vive in **`<progetto>/var/<sottocartella parlante>/`**, un livello **sopra** la document root, coi
file che tengono il **nome originale**:

```
<progetto>/
├── var/
│   ├── 20260827-pulizia-composer/    <- copia di sicurezza prima di una modifica
│   │   └── composer.json             <- nome originale, non composer.json.bak
│   ├── 20260914-specifiche-listini/
│   │   ├── listini.xlsx              <- l'allegato come è arrivato dal cliente
│   │   └── analisi.md                <- l'analisi lunga a cui rimanda la voce del TODO
│   └── fatturazione-elettronica/     <- nome tematico, quando la cosa non ha una data
└── dev/                              <- document root: qui dentro solo il sito
```

**⚠ Il nome della sottocartella è quello che rende la regola utile.** `var/roba/`, `var/tmp2/`, `var/varie/`
sono rusco quanto un file lasciato nella document root: la cartella deve dire a chi legge fra sei mesi cosa c'è
dentro senza doverla aprire. Data (`20260827-<motivo>`), argomento, o tutt'e due.

E vale sempre la regola del nome: **l'identificativo va nel nome della cartella, non appiccicato dopo
l'estensione vera**. Non `config.json.bak.20260910`, ma `20260910-<motivo>/config.json` — su Linux troppe cose
decidono guardando l'estensione finale, e un suffisso datato la nasconde (vedi sotto).

Rusco da non lasciare mai in giro, ovunque nell'albero: `*.bak`, `*.old`, `*.orig`, `*.save`, `*~`,
`nome.php.bak.<data>`. Se ne trovi, **spostali** in `<progetto>/var/<sottocartella>/`, non lasciarli dove sono.

Da non confondere con **`<progetto>/backups/`**, che è l'archivio degli automatismi: ci scrivono
`_gw.upgrade.sh` (il `tar` prima di ogni aggiornamento) e `_backup.nightly.sh` (i dump del database), e
lo pota `/etc/cron.daily/pulizia-backup-siti` a 5 giorni. Non metterci copie fatte a mano: sparirebbero
dopo cinque giorni senza che nessuno lo dica. Le tue vanno in `<progetto>/var/<identificativo>/`, che
nessun cron tocca.

Non è ordine, è sicurezza, e per due motivi distinti.

Il primo: quello che sta nella document root **Apache lo serve**. Un `.xlsx` di listini, un PDF di specifiche,
un export di anagrafiche non fanno match col `FilesMatch` delle estensioni pericolose — vengono serviti a
chiunque ne indovini l'URL, e i motori li indicizzano. Materiale del cliente pubblicato per sbaglio, senza che
nessuno se ne accorga.

Il secondo: il `FilesMatch` è **ancorato alla fine del nome**, quindi `pagina.php.bak.20260827` non fa match e
Apache lo serve in chiaro. Verificato: `zz.test.php.bak` → 403, `zz.test.php.bak.20260827` → **200 col
contenuto**. Proprio la convenzione di mettere la data in fondo, che sembra più ordinata, è quella che aggira
la protezione.

C'è anche un terzo motivo, che non è di sicurezza ma costa lo stesso: `_gw.upgrade.sh` confronta l'albero `_*`
coi file dello standard e raccoglie ogni notte i disallineamenti. Un file di appoggio lasciato lì dentro ci
finisce in mezzo tutte le notti, e il suo `rm -rf ./_*` prima o poi se lo porta via senza dirlo a nessuno.

## Il contesto costa: si lavora parsimoniosi

Ogni richiesta rilegge **tutto** il contesto accumulato, quindi il costo di una sessione cresce **col
quadrato della sua lunghezza**, e i file di istruzioni ( questo, il `CLAUDE.md` di progetto, quello
globale ) si pagano **a ogni chiamata**. Claude Code avvisa sopra i **150k caratteri** complessivi. Le
regole per esteso, con le misure che le motivano, stanno nella skill `glisweb`
( `.claude/skills/glisweb/riferimenti/contesto.md` ). L'essenziale:

- **i file di istruzioni restano snelli.** Il `CLAUDE.md` di progetto tiene **regole e trappole**, non
  trattazioni: una sezione di dominio che supera un paio di migliaia di caratteri va in
  `<progetto>/var/personalizzazioni/<area>.md`, rimandata dal §4 del `READ.md`; una procedura va in
  `var/procedure/`. **Non si ripete** nel `CLAUDE.md` di progetto niente di ciò che dicono questo file o
  la skill;
- **un turno vale il contesto intero**: i comandi indipendenti in una chiamata sola; le catene meccaniche
  in uno script che stampa **il risultato**, non i dati grezzi; lo script che serve più volte in
  `.claude/bin/`. Non si scrive uno script quando bisogna **guardare** un risultato per decidere;
- **si legge stretto**: `grep`, `sed -n`, `head`, `--short`, `--stat`. Il `TODO.md` con `todo.py`, il
  `DONE.md` con `grep`, il `READ.md` per sezione. Non si rilegge un file appena scritto;
- **il ramo si scrive, non si segue**: una cosa nuova che non blocca il lavoro in corso va nel
  `TODO.md`, e in conversazione resta `annotato: <cosa>`;
- **il punto fermo lo dichiara Claude, ed è un obbligo, non una cortesia** ( Fabio, 23/09/2026:
  *"voglio SEMPRE essere avvisato quando posso fare /clear e quando devo fare /compact"* ):
  - **fronte chiuso** — quando il lavoro appena finito è chiuso e quello dopo non c'entra, si propone il
    `/clear` **di propria iniziativa**, nella risposta che chiude il lavoro, a qualunque livello di
    contesto: non si aspetta che l'utente chieda "posso fare clear?";
  - **sopra 120k** ( la statusline stampa `ctx <n>k` ) si **può** chiudere; **sopra 180k** si **deve**
    intervenire e si dice quale: **`/clear`** se il fronte è chiuso, **`/compact`** se è a metà. Non si
    arriva a 250k sperando che finisca prima. Dopo screenshot o dump voluminosi, e prima di cambiare
    progetto, è il momento buono;
  - **prima di proporlo il punto va scritto dove va** ( `TODO.md`, `CHAT.md`, `DONE.md`, il commit );
  - **la domanda si pone con la diagnosi**, non col messaggio grezzo dell'hook: *"siamo a 210k, questo
    fronte è chiuso — `/clear`"* oppure *"siamo a 210k e siamo a metà di X — `/compact` e proseguiamo"*.
    Quando l'hook `Stop` segnala la soglia, si riporta in chiaro;
- **testo prima dello screenshot**, sempre, e la regola si ripete nel prompt degli agenti. Gli agenti
  hanno **sempre** il `model` esplicito, `sonnet` per la raccolta.

Niente di tutto questo giustifica lavorare peggio: **lo stesso lavoro, impacchettato meglio**.

## I cinque file di un progetto: `CLAUDE.md`, `READ.md`, `TODO.md`, `DONE.md`, `CHAT.md`

Vivono nella **root del deploy** ( il livello che contiene `dev/` ), più il `burndown.md` che è generato.
**Quella root non è versionata, di proposito**: ci stanno le credenziali in chiaro, quindi non si propone
di metterla sotto git. ⚠ **Il regolamento completo — marcatori, flag, lock e sezioni del `CHAT.md`,
concorrenza, formato vecchio da riorganizzare — sta in `.claude/skills/glisweb/riferimenti/cinque-file.md`,
e va letto prima di scrivere in uno di questi file** se non lo si è già fatto nella sessione.

| file | risponde a | come si scrive |
|---|---|---|
| `CLAUDE.md` | **come ci si deve comportare qui**: regole e trappole | stabile, **snello** ( vedi sopra ) |
| `READ.md` | **cosa serve sapere per metterci le mani**: sette voci — descrizione, credenziali, architettura e deploy, **mappa delle personalizzazioni**, FAQ, problemi frequenti, procedure | il fatto e il rimando; la trattazione in `var/` |
| `TODO.md` | **cosa c'è da fare** | per **aree**, una riga per compito, tre flag; si pota |
| `DONE.md` | **cosa è successo e perché** | un capitolo per giornata, in append; si consulta con `grep` |
| `CHAT.md` | **come siamo messi col cliente** | una sezione per destinatario, `## lock` in fondo; si riscrive per sezione, mai intero |

Le regole che contano di più:

1. **una cosa sta in un file solo**;
2. **il `READ.md` si legge prima di chiedere e si scrive quando si scopre**, nello stesso turno: una
   domanda su macchine, database o deploy è un buco nel READ, non una domanda per Fabio;
3. **prima di scrivere al cliente si legge il `CHAT.md`**, e prima di scrivere "da chiedere a X" si cerca
   in `CHAT.md` e `DONE.md` se la risposta c'è già. Le telefonate si trascrivono il giorno stesso;
4. **non sei l'unico che scrive**: si rilegge subito prima di scrivere, si modifica il meno possibile, la
   sostituzione si ancora al testo sostituito. Il `CHAT.md` si scrive col lock;
5. **i marcatori sono cinque**: `[ ]` da fare e nel carico, `[=]` in attesa di un altro ( con **chi** e
   **da quando** ), `[?]` sospesa, `[v]` fatta, `[x]` scartata. Le ultime due vivono nel `DONE.md`, `[=]`
   e `[?]` non contano nel carico. La voce comincia a colonna 1 con `- `, e dopo il marcatore porta i tre
   flag urgente/rilevante/impattante, `(!-!)`;
6. **chiudere una voce sono tre gesti**: marcatore, trasloco nel `DONE.md` col perché, e — se il cliente
   la vede o l'aspettava — la stessa riga nel `CHAT.md` in `### Da dirgli alla prossima occasione`, il
   giorno stesso.

## Documentazione: `READ.md`, `USER.md` e le quickstart

**La documentazione segue la legge del codice: standard e custom allo stesso percorso, al netto degli
underscore.** Il dettaglio — composizione dei manuali, sezioni *template* e *moduli*, versione stampabile
e PDF, marcatori `@pubblico`/`@linea`/`@shot`, vincoli della generazione — sta in
`.claude/skills/glisweb/riferimenti/documentazione.md`: **leggerlo prima di toccare documentazione o
generatore**.

| cosa si documenta | standard | custom |
|---|---|---|
| il **deploy** | `_usr/_docs/READ.md` e `USER.md` | `usr/docs/READ.md` e `USER.md` |
| un **componente** | `_mod/_4000.catalogo/READ.md` e `USER.md` | `mod/4000.catalogo/READ.md` e `USER.md` |
| le **quickstart** | `_usr/_docs/_quickstart/*.md` | `usr/docs/quickstart/*.md` |

- `READ.md` è il manuale **sviluppatore**, `USER.md` quello **utente**;
- la documentazione di progetto è **solo correttiva, sostitutiva o additiva**: un capitolo entra nel
  manuale di progetto solo se esiste il suo sorgente custom, e un deploy senza personalizzazioni
  documentate non ha manuale di progetto. Quella dello standard è pubblica ( `/_manual/` ), quella di
  progetto sta dietro Basic auth ( `/manual/` ) ed è **fail-closed** senza `etc/secret/.htpasswd`;
- **l'attivazione di un modulo non si documenta**;
- ⚠ **il `READ.md` della root del deploy non è documentazione**: contiene gli accessi, non si scansiona,
  non si pubblica, non si cita, non si versiona;
- si genera con `_src/_sh/_docs.build.sh`, che **non fa il bootstrap del framework** e sui deploy cliente
  scrive solo dentro `usr/`, mai sotto `_*`.

## Commenti al codice

I commenti seguono il canone dei file già documentati: in italiano, testata `/** … */` con titolo in
minuscolo e sezioni sottolineate, docblock di funzione con `@param`/`@return` allineati, etichette `//`
canoniche nelle macro ( `// tabella gestita`, `// macro di default`… ). Il commento dice **perché**, e
un commit di documentazione **non cambia il codice**. La guida completa, coi modelli per tipo di file:
`.claude/skills/glisweb/riferimenti/commenti.md` — **leggerla prima di commentare o di sciogliere un
`TODO documentare`**.

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

### Le definizioni delle pagine stanno in cache, e modificarle non basta

L'array delle pagine — quello che nasce dai file `_src/_inc/_pages/*.php`, dai loro corrispettivi custom
e dal database — **non viene ricostruito a ogni richiesta**: `_src/_config/_300.pages.php` lo legge da
memcache (`CONTENTS_PAGES_KEY`, insieme ad albero, indice, reverse e shortcut) e lo rigenera solo se la
cache manca o se `CONTENTS_PAGES_UPDATED` è più recente di `CONTENTS_PAGES_CACHED`.

La conseguenza pratica è che **si modifica un file di definizione pagine e non cambia niente**: nessun
errore, nessun avviso, la pagina continua a rispondere con la definizione vecchia. Non è opcache — quella
rivalida i timestamp e dopo pochi secondi ricompila da sola — ed è per questo che ci si perde tempo: ogni
altra modifica al framework (il CSS di un template, uno snippet Twig, una libreria) si vede subito, e
solo questa no. Il 2026-09-15 ha nascosto per una decina di minuti una correzione di una riga.

Per farli rileggere: `/task/memcache.clean` (vuole il privilegio `GESTIONE_CACHE`), con `?deploy=1` se
il deploy ospita più siti — le chiavi sono seedate per sito e il default svuota solo quello corrente.
Vale per tutto ciò che finisce nell'array delle pagine: `menu`, `auth.groups`, `template`, `macro`.

### Librerie (`_src/_lib/`)

Convenzione di nome `_<nome>.<tipo>.php`:
- **tools** — utility standalone, senza dipendenze da `$cf`/`$ct`
- **utils** — dipendono da `$cf`/`$ct`

Le librerie esterne (Composer) si trovano in `_src/_lib/_ext/`, non in `vendor/`.

### Template e i18n

- Template Twig standard in `_src/_twig/`, custom in `src/twig/`.
- Macro Twig in `_src/_twig/_lib/`, sempre importate con prefisso fisso: `cms`, `frm`, `nav`, `prv`, `trn`.
- Traduzioni in `_etc/_dictionaries/_generic.<lang>-<COUNTRY>.conf`, esposte ai template come `$ct['tr']`.

### Bootstrap: migrazione BS4 -> BS5 a metà

La versione di Bootstrap la dichiara **ogni template** ( `etc/template.yaml`/`template.conf` ), non è
globale: **guardarla prima di toccare classi Bootstrap**, perché convertire un template ancora su BS4 lo
rompe. Su BS5: `_src/_tpl/_athena`, `_cassandra`, `_minerva` e `_src/_templates/_minerva`; gli altri sono
ancora BS4. Il livello condiviso ( `_src/_twig/`, `_src/_html/`, template di modulo ) è **congelato**
finché esiste una pagina BS4. Due trappole: `form-row` **non si tocca**, e `order-*` in BS5 si ferma a
5 ( un `order-12` rimasto non dà errore, smette solo di ordinare ). La linea latest non ha
`_src/_templates/`. Tabella di conversione e dettagli: `.claude/skills/glisweb/riferimenti/migrazioni.md`.

### Validazione dei form lato client (`_src/_js/_lib/_form.js`)

Oltre all'attributo HTML5 `required`, il framework mette a disposizione tre attributi che esprimono vincoli
**fra campi diversi**. Sono tutti gestiti in `_src/_js/_lib/_form.js` (caricato via `js.internal` del template)
e valgono per i tag `<input>`; il valore è sempre un elenco di **id** separati da virgola.

| Attributo | Significato |
|---|---|
| `also-required` | se il campo è valorizzato, i campi elencati diventano `required` (e da `disabled` tornano attivi); se lo si svuota tornano opzionali e disabilitati |
| `required-equals` | i campi elencati devono avere tutti lo stesso valore, altrimenti `setCustomValidity( 'i campi non corrispondono' )` |
| `required-alternative` | i campi del gruppo sono obbligatori **in alternativa**: finché sono tutti vuoti restano tutti `required`, appena uno viene compilato il vincolo cade su tutto il gruppo |

`required-alternative` si dichiara su **ogni** campo del gruppo, elencando gli id degli altri, e i campi partono
`required` nel markup — così il vincolo regge anche a JavaScript spento (degrada in "obbligatori tutti", non in
"obbligatori nessuno"):

```html
<input type="number" id="numero_colli"  name="…[numero_colli]"  required required-alternative="numero_pallet">
<input type="number" id="numero_pallet" name="…[numero_pallet]" required required-alternative="numero_colli">
```

Tre cose da sapere:

- **servono gli `id`**: tutti e tre gli attributi risolvono i campi con `$( '#' + id )`, il `name` non basta.
- **è solo lato client.** Nessuno dei tre ha una controparte PHP: il backend deve comunque accettare (o
  rifiutare esplicitamente) la richiesta con i campi mancanti, perché una POST costruita a mano li scavalca.
- `required-alternative` ascolta `keyup change input` e non il solo `keyup` come gli altri due, perché su un
  campo `number` il valore cambia anche con lo spinner del browser, incollando o da lettore di barcode.

Attenzione al **caching del browser**: i JS interni sono emessi da `_inc/_page.close.twig` senza query di
versione, quindi dopo una modifica a `_form.js` i client già aperti continuano a usare la copia vecchia finché
non fanno un reload forzato.

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

**Un modulo può portarsi i propri snippet Twig** in `_mod/<modulo>/_src/_twig/`, con la stessa struttura del core
(`_inc/`, `_lib/`): il loader li aggiunge solo per i moduli **attivi**, e li aggiunge *dopo* quelli standard, quindi
a parità di nome vince lo snippet del core e un modulo non può scavalcarlo per sbaglio. È il posto giusto per il
markup che ha senso solo dove quel modulo c'è: se sta nel core, un deploy che non ha il modulo lo include lo stesso
e Twig si ferma con `Unable to find template`. Per lo stesso motivo, quando un template del core include qualcosa
che appartiene a un modulo, **la condizione dell'include va messa sull'esistenza del modulo** — che si riconosce
dalla sua chiave in `$ct`, popolata dal suo `_035.common.php` — e non su una configurazione che può essere presente
anche senza di lui.

### Le due generazioni dei moduli, e come si riconoscono

I moduli vecchi hanno `_mod/<modulo>/_src/_templates/` ( `.html` ), i nuovi `_mod/<modulo>/_src/_tpl/`
( `.twig` ): **la prova è la struttura, non il nome**, perché un prefisso di **una** lettera
( `_V300.immobiliari` ) è della generazione vecchia e solo quello di **due** ( `_AN000` ) è della nuova.
**Stesso nome non vuol dire stesso modulo** ( `_4000.catalogo` e `_04000.catalogo` condividono due macro
su ventuno ), e **latest non ha nessun modulo vecchio**: è la disponibilità dei moduli a decidere se un
deploy può passarci. Dettagli: `.claude/skills/glisweb/riferimenti/migrazioni.md`.

## Job in background: come si scrive uno che non si pianta

Un **job** è un lavoro lungo spezzato in iterazioni, fatto avanzare dal browser ( `_src/_api/_job.php`,
limite di Apache ) o dal cron ( `_src/_api/_cron.php` ); lo stato sopravvive solo in `job.workspace`, e se
un'iterazione muore a metà il workspace resta indietro. Scheletro commentato, i due difetti simmetrici,
il dataset e lo sblocco di un job piantato: `.claude/skills/glisweb/riferimenti/job.md` — **leggerlo
prima di scrivere o correggere un job**. Il modello è `_src/_api/_job/_test.job.php`. Le regole:

- nel guard iniziale **`>`, mai `>=`** né `==`: `corrente >= totale` non vuol dire completato;
- la **chiusura** sta in un ramo **alternativo** al lavoro, è **idempotente** e **breve** ( `EXPLAIN`
  prima di aggiungerci una query );
- l'`UPDATE` dell'avanzamento è l'**ultima** istruzione del ramo di lavoro;
- il `result` va in `$job['workspace']['result']`, non solo in `$status`;
- il dataset si salva con `jobDatasetScrivi()` e si rilegge con `jobDatasetLeggi()`, la chiusura chiama
  `jobDatasetPulisci()`; l'esito del salvataggio va nel `workspace`;
- **quello che un job scrive va moltiplicato per le iterazioni**: un log innocuo su una richiesta è un
  file da gigabyte su diecimila giri;
- dopo aver lanciato un job lungo **si guarda la prima passata** ( `workspace.status`, e
  `var/log/memcache.err` se usa un dataset ) prima di andarsene.

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

- Il form di login non usa CSRF token: bastano i campi POST `__login__[user]` e `__login__[pasw]` (la password in
  chiaro viene verificata lato backend con `passwordVerify()`, che accetta sia gli hash di `password_hash()` sia i
  vecchi MD5; al primo login riuscito un MD5 del database viene ricalcolato).
- URL di login per default: `/login.it-IT.html` (la pagina è dinamica, server-renderizzata da `_src/_api/_pages.php`).
- Il backend confronta contro `$cf['auth']['accounts']` (config) o la vista MySQL `account_view` (fallback).
- A login riuscito viene popolato `$_SESSION['account']`; il cookie di sessione è il `PHPSESSID` standard di PHP, con
  `cookie_secure=1` (richiede HTTPS), `cookie_httponly=1` e `cookie_samesite=Lax`. Storage sessioni: Redis → Memcached → file system.
- **Ai login interattivi l'id di sessione viene rigenerato** (`session_regenerate_id(true)`, anti session fixation): i dati
  di `$_SESSION` vengono mantenuti e `$_SESSION['id']` riallineato al nuovo id. I login **stateless** (JWT via `j`, API via
  `_user.php`, HTTP Basic) NON rigenerano l'id.
- File rilevanti: `_src/_config/_210.auth.php` (logica di autenticazione), `_src/_config/_050.session.php`
  (configurazione sessione), `_src/_api/_user.php` (endpoint REST per login JSON).

### Dati di sessione persistiti su DB e rigenerazione dell'id

Poiché l'id di sessione viene rigenerato al login, **non salvare il session id (`session_id()`) in una tabella** come
chiave di collegamento: dopo la rigenerazione la riga resterebbe orfana. La convenzione del framework è l'opposto —
**tenere in `$_SESSION` l'id dell'entità** (es. `$_SESSION['id_carrello']`), perché i dati di `$_SESSION` sopravvivono
alla rigenerazione e il legame regge senza alcun `UPDATE`. Il carrello "attivo", ad esempio, vive già in
`$_SESSION['carrello']`.

Se un progetto deve comunque mantenere su DB un riferimento al session id (o fondere un'entità anonima nell'account al
login), può agganciarsi alla rigenerazione creando una macro custom `src/inc/macro/session.regenerate.php` (oppure
`mod/<modulo>/src/inc/macro/session.regenerate.php`): viene inclusa subito dopo la rigenerazione e dispone di
`$cf['session']['regenerate']['old_id']` e `$cf['session']['regenerate']['new_id']` per ridirezionare
(`UPDATE ... SET id_sessione = <new> WHERE id_sessione = <old>`) o fondere i dati.

Per usare lo script servono `TEST_USER` e `TEST_PASS` come variabili d'ambiente (mai committarle in
`config.yaml`/`shadow.yaml` se non già previsto dal progetto). Il cookie jar finisce in `var/tmp/` (path già coperto
dal `.gitignore` del framework).
