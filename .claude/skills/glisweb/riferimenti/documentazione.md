# Documentazione: manuali, quickstart, generazione

*Riferimento della skill `glisweb`, letto **su richiesta**: non sta nel preambolo di ogni sessione.
Spostato il 24/09/2026 da `_etc/_claude/_claude.framework.md`, tale e quale. Il file del framework ne tiene l'essenziale e rimanda qui.*

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

### Come si compone un manuale: i capitoli, e le due sezioni

Un manuale nasce in quest'ordine: l'**introduzione** dal documento di deploy, i **capitoli
numerati** di `_usr/_docs/_read/` e `_usr/_docs/_user/` ( il numero serve solo a ordinare e non
finisce nel titolo ), e infine due **sezioni** — *template* e *moduli* — che nel menu sono
sottomenu a espansione e nell'indice due elenchi rientrati. Sono decine di capitoli: in fila con gli
altri coprirebbero l'indice.

⚠ **La testata di una sezione è il capitolo numerato che porta il nome della famiglia.**
`_usr/_docs/_read/155.template.md` e `_usr/_docs/_read/050.moduli.md` non restano in fila con gli
altri: diventano la voce da cui il sottomenu si apre, cioè la documentazione **generale** della
famiglia, e la loro pagina elenca in fondo i capitoli che raccoglie. Il vocabolario è chiuso —
`template` e `moduli`, `DOCS_FAMIGLIE` in `_src/_cli/_docs.build.php` — e chiamare la testata in un
altro modo la lascia in fila con gli altri capitoli, **senza errori e senza segnali**. La coppia
standard/custom qui si somma, come nell'introduzione.

⚠ **L'attivazione di un modulo non si documenta.** I manuali raccolgono i `READ.md` e gli
`USER.md` di **tutti** i moduli e di **tutti** i template dell'albero, accesi o spenti: qui si
documenta il framework, e per decidere se accendere un modulo bisogna prima poter leggere cosa fa.
Se un modulo sia attivo è una proprietà della singola installazione, e scritta nel capitolo sarebbe
sbagliata su ogni altro deploy oltre che inutile a chi studia il framework. Deciso da Fabio il
**21/09/2026**: fino a quel giorno il titolo del capitolo di un modulo spento portava un
` ( non attivo )`, ed è stato tolto da tutte e due i manuali.

I **rimandi agli altri documenti** in fondo al menu sono a loro volta due sezioni —
*documentazione progetto* e *documentazione framework* — col documento in cui ci si trova
segnato: un elenco unico obbligava a dire nel titolo di ciascuno a quale dei due piani
appartenesse.

Le **quickstart hanno collocazione propria a ogni livello** — sorgente, output e URL — e non
confluiscono nei manuali: il loro scopo è far partire, non coprire. I documenti sono la quickstart e
il manuale, per sviluppatore e per utente, più la reference Doxygen generata dai docblock, che è
**dichiaratamente lavoro in corso** e porta in testa la copertura misurata.

⚠ **Di ciascuno esistono due copie con due destini diversi**, e dal 20/09/2026 la differenza è
l'accesso. Quella dello **standard** si genera dai soli sorgenti `_*`, sta sotto `_usr/_pages/`
( `/_manual/read/`, `/_manual/user/`, `/_quickstart/` ) ed è **pubblica**: descrive il framework, non
un cliente, ed è il link che l'applicazione può mostrare ai suoi utenti, che la password del manuale
non ce l'hanno. Quella del **progetto** nasce dai **soli** sorgenti custom, sta sotto `usr/pages/`
( `/manual/read/`, `/manual/user/`, `/quickstart/` ) ed è dietro **Basic auth**, perché descrive le
personalizzazioni. Ogni documento rimanda agli altri, e uno pubblico rimanda ai soli pubblici.

⚠ **La documentazione di progetto non è mai ridondante rispetto a quella del framework: è soltanto
CORRETTIVA, SOSTITUTIVA o ADDITIVA.** Regola data da Fabio il **21/09/2026**. Fino a quel giorno il
manuale di progetto era la *somma* dei due, cioè si portava dentro una copia integrale del manuale
del framework: due copie della stessa pagina da tenere allineate a mano, che si scoprono divergenti
mesi dopo. Adesso un capitolo entra nel manuale di progetto **solo se esiste il sorgente custom** —
`usr/docs/READ.md` e `USER.md`, `usr/docs/read/*.md` e `usr/docs/user/*.md`, il `READ.md` di un
modulo sotto `mod/`, quello di un template sotto `src/tpl/` — e tutto il resto lo copre il manuale
dello standard, che è pubblico e a cui ogni pagina rimanda dalla barra laterale.

⚠ **Un deploy senza personalizzazioni documentate non ha il manuale di progetto**, e non è un
errore: le pagine di un giro precedente vengono **tolte** ( `docsBuildVuoto()` ), e il link sparisce
da solo perché `_src/_config/_030.common.php` lo mostra solo se la pagina esiste. Su un deploy così
i manuali sono quelli dello standard, sotto `/_manual/`.

### La versione stampabile, e il PDF

Ogni manuale esce **anche** in pagina unica e in PDF, accanto ai capitoli: `tutto.html` mette tutti i
capitoli di seguito nell'ordine dell'indice, e `<titolo-del-manuale>.pdf` ne è la stampa. Sono linkati
**dall'indice del manuale e solo da lì**: è la pagina da cui si comincia, ed è dove si cerca il
documento intero da portarsi via. In barra laterale sarebbero una voce riletta a ogni pagina per una
cosa che si prende una volta sola.

Il PDF lo produce **chromium headless** ( `--print-to-pdf` ), che è lo stesso binario con cui
`_src/_sh/_docs.shots.sh` fotografa le maschere: nessuna libreria nuova, nessuna conversione a mano
del markup, e il risultato usa il CSS di stampa che le pagine hanno già. Il formato del foglio lo
impone `@page { size: A4 }` in `_usr/_docs/_etc/_page.css`, perché il default di chromium è **letter**.

⚠ **Dove chromium non c'è — i deploy cliente, di norma — il PDF non si genera e non è un errore**: la
voce di menu punta alla pagina unica, che il browser stampa lo stesso, e la generazione prosegue.
Deve proseguire: gira dentro `_gw.upgrade.sh`, e c'è un `timeout 300` sul comando perché un chromium
che non torna più bloccherebbe l'aggiornamento invece della sola documentazione.

Tre cose non sono dettagli implementativi:

- **`tutto.html` va dichiarata fra le chiavi della potatura** ( `$chiavi` in `docsBuildManuale()` ):
  non è un capitolo, e `docsBuildPota()` la toglierebbe a ogni giro subito dopo averla scritta;
- **il PDF si converte dal file già pubblicato**, non da una copia temporanea: la pagina cita gli
  screenshot con percorso relativo ( `shot/<id>.png` ), e da un'altra cartella uscirebbe senza figure
  senza che l'esito del comando lo dica;
- **i corpi dei capitoli si convertono una volta sola** e si tengono da parte: servono alla pagina del
  capitolo e alla versione stampabile, e una seconda conversione sarebbe due documenti che il giorno
  che una delle due cambia non dicono più la stessa cosa.

Quando un manuale resta senza capitoli, `docsBuildVuoto()` porta via anche il PDF: `docsBuildPota()`
guarda i soli `.html`, e il PDF sarebbe l'unico pezzo ancora servito — per giunta quello che li
contiene tutti.

### ⚠ Il `READ.md` della root del deploy non è documentazione

Un livello **sopra** la document root vive un `READ.md` che contiene gli **accessi** del progetto: CMS,
SSH, database. Non è sorgente di documentazione, non va scansionato, non va pubblicato, non va citato.
Non confonderlo con `dev/READ.md`, che è il manuale sviluppatore del framework: sono due file diversi
con lo stesso nome a due livelli diversi. Tutti i percorsi della generazione sono relativi alla
document root e `docsBuildPath()` aborta se uno risolve fuori.

**E per lo stesso motivo la root del deploy non è versionata, di proposito.** Il repository è la
document root, `dev/`; il livello che la contiene ne sta fuori perché ci vivono le password in chiaro
e le informazioni del progetto — quel `READ.md` degli accessi, i file di stato, gli script operativi.
Versionarli significherebbe consegnare le credenziali a chiunque abbia accesso al repository. Quindi
non proporre di metterli sotto git, non crearci dentro un repository e non trattarli come "non
protetti": la macchina ha uno snapshot notturno e li comprende. Sono due piani con due meccanismi di
protezione diversi, e un `git status` pulito su `dev/` non dice — né deve dire — niente su di loro.

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
`_src/_cli/_docs.build.php`. Tre cose non sono dettagli implementativi ma vincoli:

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
  nulla. Vale per i documenti di progetto e **solo** per quelli: quelli dello standard non passano di
  qui, perché stanno sotto `_usr/_pages/` e sono pubblici di proposito. Serve perché `AuthUserFile` vuole un percorso **assoluto**, che cambia fra DEV, TEST e PROD: la
  riga viene riallineata a ogni giro e il resto del `.htaccess` non viene mai toccato. Un target su cui
  quel file non fosse mai arrivato servirebbe le personalizzazioni in chiaro, in silenzio.

Due inciampi già pagati: **`/manual/` senza nome file dà 404**, perché la regola di accesso diretto del
`.htaccess` richiede un file (`-f`), quindi si linka sempre `index.html`; e i `.md` sono negati via HTTP
dal `FilesMatch`, quindi si pubblica sempre `.html`.
