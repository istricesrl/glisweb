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
propone la variante minima che se ne discosta. La deroga è una decisione, non un effetto collaterale.

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

## Backup: mai dentro la document root

La document root è `<progetto>/dev/`. **Nessun backup ci va dentro**, nemmeno in `dev/var/`: né copie di
sicurezza prima di una modifica, né file di appoggio, né scarti. Vanno in **`<progetto>/var/<identificativo>/`**,
un livello sopra la document root, col nome originale del file (l'identificativo è la data, o `data-motivo`).

Rusco da non lasciare mai in giro: `*.bak`, `*.old`, `*.orig`, `*.save`, `*~`, `nome.php.bak.<data>`.

Non è ordine, è sicurezza. Il `.htaccess` nega le estensioni pericolose con un `FilesMatch` **ancorato alla
fine del nome**, quindi `pagina.php.bak.20260827` non fa match e Apache lo serve in chiaro. Verificato:
`zz.test.php.bak` → 403, `zz.test.php.bak.20260827` → **200 col contenuto**. Proprio la convenzione di
mettere la data in fondo, che sembra più ordinata, è quella che aggira la protezione.

## Cose da fare: `TODO.md`, `DONE.md` e `CHAT.md`

Nella **root del deploy** (il livello che contiene `dev/`) vivono tre file di stato, più il
`burndown.md` che è generato. Fanno tre lavori diversi e hanno tre tempi di vita diversi: tenerli
separati non è ordine estetico, è la condizione perché restino leggibili.

| file | cosa contiene | come si scrive |
|---|---|---|
| `TODO.md` | **solo lavoro aperto**: `[ ]` e `[?]` | si aggiunge in fondo, e si **pota** quando una voce chiude |
| `DONE.md` | l'archivio del fatto: `[v]`, `[x]` e le cronache di come è andata | append, non si rilegge: si consulta con `grep` |
| `CHAT.md` | lo **stato attuale** della conversazione col cliente | si **riscrive**: non è un diario, è una fotografia di adesso |

La regola che tiene insieme le tre: **una cosa sta in un file solo.** Quando un lavoro finisce esce
dal `TODO.md` e entra nel `DONE.md`; quando una domanda al cliente ha risposta esce dal `CHAT.md` e
la decisione entra nel `DONE.md`. Se la stessa riga sta in due file, il prossimo che legge non sa
quale delle due è vera.

### Perché i tre file esistono

Un `TODO.md` che contiene anche il fatto e anche le conversazioni cresce di migliaia di righe in
poche settimane, e a quel punto **nessuno lo rilegge**: le informazioni vecchie di due giorni
diventano invisibili. Da lì nascono i due errori tipici, che si sono visti tutti e due nello stesso
giorno l'8 settembre 2026:

- si chiede al cliente una cosa **a cui aveva già risposto**, e la risposta era scritta più su
  nello stesso file — al cliente arriva il messaggio che quello che dice non viene registrato;
- si dà per "ancora da dire" una cosa **già detta** su un altro canale, perché nel file era scritta
  con parole diverse da quelle usate parlandogli.

### I quattro marcatori

| marcatore | significato | stato | dove vive |
|---|---|---|---|
| `- [ ]` | da fare | aperta | `TODO.md` |
| `- [?]` | da fare, ma prima serve un approfondimento | aperta | `TODO.md` |
| `- [v]` | fatta | chiusa | `DONE.md` |
| `- [x]` | scartata, tenuta solo per memoria storica | chiusa | `DONE.md` |

`[ ]` e `[?]` contano entrambe nel residuo. **Non esistono altri marcatori**: se ne incontri uno
diverso (`[y]`, `[X]`, `[-]`, …) è un errore, normalizzalo a uno dei quattro invece di inventare
uno stato nuovo.

Li conta [avanzamenti-todo](https://github.com/the-linux-nerd/avanzamenti-todo) con espressioni
**ancorate a inizio riga**: le aperte le cerca in `TODO.md`, le chiuse in `TODO.md` **e** in
`DONE.md`, e le somma. Le regole di scrittura che seguono non sono questioni di stile: se non le
rispetti i conteggi sbagliano in silenzio, e te ne accorgi settimane dopo guardando una curva che
non torna.

### Come si scrive una voce

- una voce per riga, che **inizia a colonna 1** con `- ` seguito dal marcatore e da uno spazio;
- niente indentazione: una sotto-voce rientrata non viene contata;
- il `- ` iniziale non è facoltativo — una riga che inizia direttamente con `[ ]` sfugge al conteggio;
- se devi **citare** un marcatore dentro una frase o un esempio, non metterlo a inizio riga, o verrà
  contato come una cosa da fare.

### `TODO.md`: come si aggiorna

- le voci si raggruppano in sezioni datate, con l'intestazione `AAAA-MM-GG [HH:MM] TITOLO`
  sottolineata da `=`; le voci nuove vanno in fondo, in una sezione con la data di oggi;
- quando un lavoro finisce si cambia il marcatore in `[v]` e **si sposta la voce in `DONE.md`**,
  con la sua sezione se la sezione è chiusa per intero. Non si cancella niente: si trasloca;
- quando un lavoro si abbandona, `[x]`, stessa strada;
- **una sezione senza più voci aperte non ha motivo di restare qui**: va spostata intera;
- niente domande al cliente nel `TODO.md`. Le domande stanno in `CHAT.md`, e qui resta semmai il
  lavoro che dipende dalla risposta;
- una riga `SAL PIANIFICATA <data>` viene raccolta nel cruscotto `/root/avanzamenti.sh` fra le
  prossime scadenze.

### `DONE.md`: l'archivio

Stessa forma del `TODO.md` — sezioni datate, stessi marcatori — ma **non si legge dall'inizio**: è
il posto dove si va a cercare *come era andata* una certa cosa. Ci finiscono anche i blocchi
narrativi che spiegano una diagnosi, una decisione o una migrazione: sono la memoria del progetto,
e sono esattamente ciò che rende illeggibile il `TODO.md` se restano lì.

Non si riscrive e non si riordina: si aggiunge in fondo. Se cresce troppo lo si spezza per anno
(`DONE.2026.md`), mai per argomento.

### `CHAT.md`: lo stato della conversazione col cliente

**È il file da leggere prima di scrivere al cliente**, sempre, anche per un messaggio di una riga.
Un progetto ha di norma un interlocutore solo; se ne ha più d'uno si trattano come uno (sono in
copia sulla stessa mail), e le persone si nominano dentro le voci.

Non è un diario e non è un log: contiene **soltanto ciò che è vero adesso**. Struttura fissa:

```markdown
# Conversazione con <interlocutore> — <progetto>

Ultimo contatto: mail 05/09, WhatsApp 08/09 11:22, telefono 07/09 (12 minuti).

## Aspetta lui — cosa gli abbiamo chiesto
  - [ ] <domanda>, chiesta il <data> per <canale>

## Aspettiamo noi — cosa ha chiesto lui
  - [ ] <richiesta>, arrivata il <data>

## Da dirgli alla prossima occasione
  - [ ] <cosa fatta che lui non sa ancora>

## Ultimi scambi, in breve
- <data> — <cosa si è detto, due righe>
```

Regole, e sono quelle che evitano le figuracce:

- **quando una domanda ha risposta, si toglie da qui**: la risposta diventa una voce di lavoro nel
  `TODO.md` o una decisione nel `DONE.md`. Una domanda che resta scritta dopo la risposta è una
  trappola, perché il prossimo che legge la rifà;
- **le telefonate si scrivono qui il giorno stesso**, con durata e decisioni: una chiamata non
  trascritta è un buco nero e produce esattamente l'errore di richiedere il già detto;
- **si annota il canale e la data di ogni contatto**: serve a sapere se una cosa è stata detta a
  voce o per iscritto, e con quali parole;
- prima di scrivere "da chiedere a <cliente>" da qualunque parte, **si cerca qui e nel `DONE.md`**
  se la risposta esiste già;
- il tono delle voci è quello che si userebbe col cliente: niente nomi di tabelle, niente
  dettagli interni. Quelli stanno nel `TODO.md`.


## Documentazione: `READ.md`, `USER.md` e le quickstart

**La documentazione segue la stessa legge del codice: standard e custom allo stesso percorso, al netto
degli underscore.** Se non c'è simmetria, la documentazione custom non si trova e non si compone.

Vale su **due livelli**, e sono due perché documentano due cose diverse:

| cosa si documenta | standard | custom |
|---|---|---|
| il **deploy** (framework o progetto) | `_usr/_docs/READ.md` e `USER.md` | `usr/docs/READ.md` e `USER.md` |
| un **componente** (modulo, template) | `_mod/_4000.catalogo/READ.md` e `USER.md` | `mod/4000.catalogo/READ.md` e `USER.md` |
| le **quickstart** | `_usr/_docs/_quickstart/*.md` | `usr/docs/quickstart/*.md` |

`READ.md` è il manuale **sviluppatore**, `USER.md` quello **utente**. I moduli non hanno un
`_usr/_docs/` proprio: replicano solo `_src/`, e la coppia nella radice del componente è già la
convenzione viva (`_mod/_CT000.contatti/READ.md`, `_src/_tpl/_athena/READ.md`).

Le **quickstart hanno collocazione propria a ogni livello** — sorgente, output e URL — e non
confluiscono nei manuali: il loro scopo è far partire, non coprire. Sono quattro documenti in tutto:
quickstart e manuale, per sviluppatore e per utente, più la reference Doxygen generata dai docblock,
che è **dichiaratamente lavoro in corso** e porta in testa la copertura misurata.

### ⚠ Il `READ.md` della root del deploy non è documentazione

Un livello **sopra** la document root vive un `READ.md` che contiene gli **accessi** del progetto: CMS,
SSH, database. Non è sorgente di documentazione, non va scansionato, non va pubblicato, non va citato.
Non confonderlo con `dev/READ.md`, che è il manuale sviluppatore del framework: sono due file diversi
con lo stesso nome a due livelli diversi. Tutti i percorsi della generazione sono relativi alla
document root e `docsBuildPath()` aborta se uno risolve fuori.

### I marcatori

Due tipi, entrambi markdown valido, entrambi invisibili sia al conteggio delle sezioni `### <path>` di
`READ.md` sia al conteggio `^- [` del burndown.

**Metadato di sezione**, sulla riga subito dopo il titolo, per filtrare:

```markdown
### chiusura di una lista di prelievo
<!-- @pubblico: operatore, amministratore -->
<!-- @linea: stable -->
<!-- @pagina: app.chiusura.ddt -->
```

Vocabolario chiuso: `@pubblico` (`operatore`, `amministratore`, `sviluppatore`), `@linea` (`stable`,
`unstable`), `@pagina`, `@modulo`. Un metadato assente non restringe nulla: si dichiara solo ciò che
esclude. Scartando una sezione si scartano anche le sue sottosezioni.

**Callout inline**, per il lettore, ed è il modo in cui si segnalano le **divergenze fra le due linee**
senza duplicare il documento:

```markdown
> **solo unstable** — il pulsante di duplicazione esiste solo sulla linea di sviluppo.
> **attenzione** — l'annullamento di un documento fiscale non è reversibile.
```

Vocabolario chiuso: `solo stable`, `solo unstable`, `solo operatori`, `solo amministratori`,
`solo sviluppatori`, `nota`, `attenzione`, `esempio`. Fuori vocabolario resta una citazione leggibile.

Gli **screenshot** si dichiarano accanto all'immagine, mai in un elenco separato — così uno scatto
dichiarato e mai mostrato, o mostrato e mai dichiarato, è impossibile:

```markdown
![elenco dei prelievi](shot/prelievi.elenco.png)
<!-- @shot: prelievi.elenco | /prelievi | 1440x900 | #main | 3000 -->
```

### La generazione

`_src/_sh/_docs.build.sh` (`--user --dev --quickstart --standard --all --dry-run`) compone i sorgenti e
scrive le pagine; la conversione sta in `_src/_lib/_docs.tools.php`, l'orchestrazione in
`_src/_sh/_lib/_docs.build.php`. Tre cose non sono dettagli implementativi ma vincoli:

- **l'entry point non fa il bootstrap del framework.** Da CLI `_src/_config.php` trascinerebbe sessione,
  header, memcache e MySQL, e un errore in un runlevel bloccherebbe la generazione proprio mentre gira
  dentro `_gw.upgrade.sh`. Per lo stesso motivo `docsMarkdown2Html()` ritorna `false` invece di
  provocare un fatal quando `league/commonmark` non c'è.
- **sui deploy cliente si genera solo dentro `usr/`, mai sotto `_*`.** Un file generato là finirebbe fra
  i disallineamenti che `_gw.upgrade.sh` raccoglie ogni notte (il suo `find ./_* -newer` non ha prune) e
  verrebbe comunque cancellato dal suo `rm -rf ./_*`. La documentazione dello standard e la reference
  API si generano **solo dove esiste `var/docs.build.conf`**.
- **la protezione è dentro la generazione ed è fail-closed.** La documentazione di progetto descrive le
  personalizzazioni del cliente e non può essere pubblica: senza `etc/secret/.htpasswd` non si genera
  nulla. Serve perché `AuthUserFile` vuole un percorso **assoluto**, che cambia fra DEV, TEST e PROD: la
  riga viene riallineata a ogni giro e il resto del `.htaccess` non viene mai toccato. Un target su cui
  quel file non fosse mai arrivato servirebbe le personalizzazioni in chiaro, in silenzio.

Due inciampi già pagati: **`/manual/` senza nome file dà 404**, perché la regola di accesso diretto del
`.htaccess` richiede un file (`-f`), quindi si linka sempre `index.html`; e i `.md` sono negati via HTTP
dal `FilesMatch`, quindi si pubblica sempre `.html`.

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

### Bootstrap: migrazione BS4 -> BS5 a metà (stato al 2026-09-01)

Il framework è **in mezzo al guado** fra Bootstrap 4 e Bootstrap 5, e i due mondi convivono. La
versione la dichiara **ogni template** in `etc/template.yaml`/`template.conf` (`css.external`/
`js.external`), non è globale. Prima di toccare classi Bootstrap in un file, **guarda che versione
carica il template che lo usa**: convertire le classi di un template ancora su BS4 lo rompe, perché
i nomi BS5 (`ms-`, `me-`, `text-end`, `btn-close`, `g-0`) in BS4 non esistono, e viceversa.

**Due sistemi di templating, e non tutti i deploy hanno entrambi.** Il sistema nuovo vive in
`_src/_tpl/`, quello vecchio in `_src/_templates/`, e convivono di proposito: è così che un progetto
migra dal vecchio al nuovo un template per volta, invece che in un colpo solo. La linea **stable**
(`glisweb`) li ha tutti e due, ed è per questo che la migrazione di un progetto si fa **restando su
stable**; la linea **latest** (`glisdev`) ha **solo** `_src/_tpl/` e non ha né `_src/_templates/` né
`_src/_html/` né `_src/_tpl/_arianna`. Prima di cercare uno di quei percorsi, verifica che esista nel
deploy su cui stai lavorando: l'elenco qui sotto descrive stable, che è il deploy che li contiene tutti.

Stato dei **template di pagina** standard:

- **già su BS5** (`bootstrap@5.3.2`): `_src/_tpl/_athena`, `_src/_tpl/_cassandra`, `_src/_tpl/_minerva`,
  `_src/_templates/_minerva`. Su questi la conversione del markup residuo BS4 è **corretta e sicura**
  (le classi BS4 rimaste erano no-op silenziosi). Fatta il 2026-09-01.
- **ancora su BS4** (`bootstrap/4.5.2`): tutti gli altri (`_src/_tpl/_arianna`, `_lydia`, e quasi tutto
  `_src/_templates/_*`: arianna, athena, caterina, eleonora, hellen, julia, lucia, lucrezia, monica,
  olga, sabina, sylvia, vladyslava, yana). Migrarli **non è un rinomina-e-vai**: serve bumpare la
  versione a BS5 *e* convertire tutto il markup *e* rifare il collaudo visivo del template, uno per uno.

Tabella di conversione (BS4 morto in BS5 -> BS5): `ml-*`/`mr-*`->`ms-*`/`me-*`, `pl-*`/`pr-*`->`ps-*`/`pe-*`,
`text-left`/`text-right`->`text-start`/`text-end`, `no-gutters`->`g-0`, `float-left`/`float-right`->
`float-start`/`float-end`, `font-weight-*`->`fw-*`, `.close`->`.btn-close`, `.badge-X`->`.text-bg-X`,
`.media`/`.media-body`->flex utilities, `data-toggle`/`data-target`/`data-dismiss`->`data-bs-*`.

Due trappole imparate convertendo:
- **`form-row` NON si tocca**: è morto in BS5, ma nel markup sta sempre come `class="form-row row"`
  (`row` porta il flex, quindi funziona), e dei CSS di progetto ci **agganciano selettori**
  (es. `.form-row.row.d-flex`). Rimuoverlo per "pulizia" rompe quei selettori senza guadagno.
- **il livello condiviso è congelato**: gli include comuni `_src/_twig/` e `_src/_html/`, e i template
  di modulo `_mod/*/_src/_templates/`, sono usati da **tutti** i progetti insieme, quindi da template
  sia BS4 sia BS5. Lì le classi BS4 **non si possono convertire** finché esiste anche un solo template
  di pagina su BS4: è questo che tiene ferma la migrazione. Si sblocca solo quando **tutti** i template
  di pagina sono passati a BS5; allora si migrano in blocco condivisi e moduli.

I **tooltip** in BS5 (`data-bs-toggle="tooltip"`) vanno **inizializzati via JS**: il solo attributo non
li accende (il `title` nativo del browser sì). Nei template non sono inizializzati, quindi la conversione
degli attributi è corretta ma non "accende" i tooltip da sola.

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

---

## Job in background: come si scrive uno che non si pianta

Un **job** è un lavoro lungo spezzato in iterazioni. A differenza di un **task**, che gira e risponde subito a
chi l'ha chiamato, un job vive in una riga della tabella `job` e viene fatto avanzare da qualcun altro, una
iterazione per volta. Chi lo ha lanciato non vede l'errore: vede una barra che si muove, o che non si muove.
Per questo un job scritto male non dà fastidio — sparisce, e ci si accorge del problema giorni dopo.

Il file di un job sta in `src/api/job/<nome>.php` (`_src/_api/_job/_<nome>.php` per gli standard, o sotto
`mod/<modulo>/src/api/job/`) e viene incluso con `require` da due motori diversi:

| chi lo fa avanzare | quando | limite di tempo |
|---|---|---|
| `_src/_api/_job.php` | il browser chiama `/job/<id>` ogni 3 secondi, per i job con `se_foreground = 1` | quello di Apache (`max_execution_time`, tipicamente **30 s**) |
| `_src/_api/_cron.php` | a ogni passata, `iterazioni` volte di fila, per i job **non** in foreground | nessuno (PHP da riga di comando), ma c'è il tetto `cron.durata_massima` |

Entrambi mettono un **lock** (`job.token`), includono il file, e alla fine risalvano `job.workspace` — che è
l'unico posto dove lo stato di lavoro sopravvive fra un'iterazione e l'altra — azzerando il token. **Se
l'iterazione muore a metà, quell'UPDATE finale non viene mai eseguita:** il workspace resta indietro e il lock
resta appeso. È la premessa di tutto quello che segue.

### Le colonne che contano, e cosa vogliono dire davvero

| colonna | significato |
|---|---|
| `corrente` / `totale` | **avanzamento**: quante unità di lavoro sono state fatte su quante. Servono a disegnare la barra. |
| `timestamp_completamento` | **fine**: il job è finito. È l'unica cosa che lo dice. |
| `token` | lock: chi ci sta lavorando adesso. |
| `se_foreground` | 1 = lo fa avanzare il browser, il cron lo ignora. |

L'errore da cui nasce tutta questa sezione è confondere le prime due righe della tabella: **`corrente >= totale`
non vuol dire "completato"**, vuol dire "l'ultima unità di lavoro è stata fatta". La chiusura — il file da
produrre, la mail da mandare, il `timestamp_completamento` da scrivere — viene dopo, e può non riuscire.

### Lo scheletro giusto

È quello che usano già i job di importazione (`_src/_api/_job/_anagrafica.importazione.php`,
`_src/_api/_job/_comuni.importazione.php` e i loro fratelli nei moduli). Il modello commentato è
`_src/_api/_job/_test.job.php`.

```php
if( defined( 'CRON_RUNNING' ) || defined( 'JOB_RUNNING' ) ) {

    // 1. il job è davvero finito: non si fa niente. Notare il ">" e non il ">="
    if( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

        $status['info'][] = 'iterazione a vuoto su job completato';

    } elseif( /* requisiti formali: manca un parametro nel workspace, ... */ ) {

        $status['err'][] = '...';

    } else {

        // 2. avvio oppure avanzamento del contatore, in memoria
        if( empty( $job['corrente'] ) ) {
            // ... si calcola $job['totale'] ...
            $job['corrente'] = 1;
        } else {
            $job['corrente']++;
        }

        // 3. chiusura: un'iterazione TUTTA SUA, alternativa al lavoro
        if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

            // ... risultato, notifiche ...
            // UPDATE job SET timestamp_completamento = ? WHERE id = ?

        } else {

            // 4. il lavoro di questa iterazione
            $widx = $job['corrente'] - 1;
            // ...

            // 5. ULTIMA cosa: salvare l'avanzamento
            // UPDATE job SET totale = ?, corrente = ? WHERE id = ?

        }

    }

}
```

Il punto non ovvio è **perché la chiusura sta in un ramo alternativo al lavoro invece che in coda**. Perché
`corrente` viene salvato a database soltanto in fondo al ramo del lavoro (punto 5): finché la chiusura non
riesce, a database resta l'avanzamento precedente, e l'iterazione successiva ricalcola `corrente` in memoria,
rientra nel ramo di chiusura e **ritenta**. Il job si ripara da solo.

Vale la pena sapere che il primo ramo — quello dell'"iterazione a vuoto" — in condizioni normali non scatta
quasi mai: a chiudere il rubinetto è il motore, che seleziona soltanto i job con `timestamp_completamento IS
NULL` (`_src/_api/_job.php`, `_src/_api/_cron.php`). Quel ramo è una rete di sicurezza per il caso in cui il job
venga incluso lo stesso, non il meccanismo che ferma il lavoro: non caricarlo di responsabilità che non ha, ed
è esattamente per questo che scriverci `>=` fa danno.

### I due difetti, che sono simmetrici

**Il job che non finisce mai più.** Si ottiene salvando l'avanzamento *prima* della chiusura e usando `>=` nel
guard iniziale. Se la chiusura muore in mezzo, a database resta `corrente = totale` con
`timestamp_completamento` a NULL: da lì in avanti ogni iterazione entra nel primo ramo, dichiara "job
completato" e non fa niente. Il lavoro è fermo a un passo dalla fine e **non lo sblocca nessuno** — né il
browser, né il cron, né azzerare il token di lock a mano. Successo davvero, il 07/09/2026, a un'esportazione
di 26.000 anagrafiche: la chiusura conteneva una `UPDATE` con un join non indicizzato che sfondava i 30 secondi
di Apache, e il job è rimasto piantato a 71 iterazioni su 71.

**Il job che non finisce e basta.** È il rischio opposto, e ci si casca "riparando" il primo: se la chiusura può
essere ritentata all'infinito e fallisce sempre, il cron riprende il job a ogni passata per sempre, in silenzio.
Contro questo il framework ha una guardia in `_src/_api/_cron.php`: un job che viene preso in carico e non fa
avanzare `corrente` per `cron.stalli_massimi` passate (default 30, mezz'ora di cron al minuto) viene **chiuso
d'ufficio** con un log di errore. Il contatore vive in `workspace.__stalli__`, si scrive *prima* di lavorare —
così regge anche se il job muore dentro il `require` — e si azzera appena `corrente` avanza.

### Regole pratiche

- Nel guard iniziale si scrive `>`, **mai** `>=` e mai `==`. Un uguale non è una guardia, è una coincidenza:
  se per qualunque motivo il contatore scavalca il totale, non chiude più niente.
- L'`UPDATE` dell'avanzamento è l'**ultima** istruzione del ramo di lavoro: è la riga che dichiara riuscita
  l'iterazione. Anticiparla vuol dire perdere il diritto di rifarla.
- La chiusura dev'essere **idempotente**: può essere eseguita più volte.
- La chiusura dev'essere **breve**. Il lavoro pesante va spalmato sulle iterazioni — è il motivo per cui i job
  esistono. Una chiusura che dura più del tempo massimo di una richiesta viene uccisa a metà ogni volta. Se
  proprio non se ne può fare a meno, darle un `set_time_limit()` suo, e ricordare che in foreground quel tempo
  è un browser che aspetta.
- Prima di aggiungere una query alla chiusura, guardarne l'`EXPLAIN`. Un join fra due colonne avvolte in
  `LOWER( TRIM( ... ) )` non usa indici da nessuna delle due parti, e su decine di migliaia di righe diventa un
  prodotto cartesiano. Il difetto resta invisibile finché una delle tabelle è vuota.
- Il `result` che il driver mostra a fine barra (`d.result` in `main.js`) va scritto in
  `$job['workspace']['result']`, non solo in `$status`: il workspace è l'unica cosa che il motore risalva.

### Quando un job è piantato

```bash
# stato
SELECT id, nome, corrente, totale, se_foreground, token, timestamp_completamento FROM job WHERE id = <id>;

# lock appeso: lo azzera anche il cron da solo dopo 10 minuti (_src/_api/_cron.php)
UPDATE job SET token = NULL WHERE id = <id>;

# provocare un'iterazione senza aspettare il cron
curl "https://<host>/job/<id>"
```

Se dopo lo sblocco il job continua a rispondere "iterazione a vuoto", il difetto è quello del guard `>=`: il
lavoro c'è tutto, manca solo la chiusura, e va corretto il codice del job prima che riparta. I log delle
iterazioni stanno in `var/log/job/<id>/` e `var/log/job/<id>.log`; l'ultima iterazione che *non* compare lì è
quella in cui il job è morto.

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
