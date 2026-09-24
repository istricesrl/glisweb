# Le due migrazioni in corso: Bootstrap 4 → 5 e generazioni dei moduli

*Riferimento della skill `glisweb`, letto **su richiesta**: non sta nel preambolo di ogni sessione.
Spostato il 24/09/2026 da `_etc/_claude/_claude.framework.md`, tale e quale. Il file del framework ne tiene l'essenziale e rimanda qui.*

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
`.media`/`.media-body`->flex utilities, `data-toggle`/`data-target`/`data-dismiss`->`data-bs-*`,
`order-6`..`order-12`->non esistono (vedi sotto).

Tre trappole imparate convertendo:
- **`form-row` NON si tocca**: è morto in BS5, ma nel markup sta sempre come `class="form-row row"`
  (`row` porta il flex, quindi funziona), e dei CSS di progetto ci **agganciano selettori**
  (es. `.form-row.row.d-flex`). Rimuoverlo per "pulizia" rompe quei selettori senza guadagno.
- **il livello condiviso è congelato**: gli include comuni `_src/_twig/` e `_src/_html/`, e i template
  di modulo `_mod/*/_src/_templates/`, sono usati da **tutti** i progetti insieme, quindi da template
  sia BS4 sia BS5. Lì le classi BS4 **non si possono convertire** finché esiste anche un solo template
  di pagina su BS4: è questo che tiene ferma la migrazione. Si sblocca solo quando **tutti** i template
  di pagina sono passati a BS5; allora si migrano in blocco condivisi e moduli.
- **`order-*` si ferma a 5**: in BS4 le utility di ordinamento flex andavano da `order-1` a `order-12`,
  in BS5 esistono solo `order-0`..`order-5` più `order-first` (-1) e `order-last` (6). Un `order-10` o
  `order-12` rimasto nel markup **non è un errore visibile**: semplicemente non corrisponde a nessuna
  regola, l'elemento resta a `order: 0` e finisce nell'ordine del DOM. Il danno emerge solo quando
  qualcos'altro cambia — in `_src/_tpl/_minerva/inc/navbar.twig` è saltato fuori il 2026-09-15, quando
  togliendo un `flex-wrap: nowrap` la barra ha ricominciato ad andare a capo e i pulsanti
  account/carrello/logout, che si credevano `order-1` prima del menu, sono finiti su una terza riga.
  Quando si converte un template, `grep -rn "order-\(6\|7\|8\|9\|1[012]\)\b"` sui suoi file è un
  passaggio obbligato, perché è l'unica classe morta che non dà nessun segno di sé.

I **tooltip** in BS5 (`data-bs-toggle="tooltip"`) vanno **inizializzati via JS**: il solo attributo non
li accende (il `title` nativo del browser sì). Nei template non sono inizializzati, quindi la conversione
degli attributi è corretta ma non "accende" i tooltip da sola.

### Le due generazioni dei moduli, e come si riconoscono

I moduli sono in mezzo a una migrazione, esattamente come i template, e per lo stesso motivo: le due
generazioni convivono perche' un progetto ne sposti uno per volta. Prima di toccare un modulo bisogna
sapere in quale delle due sta, e **il prefisso non si legge a occhio**:

| generazione | forma del nome | esempio | template che si porta dietro |
|---|---|---|---|
| vecchia | `_NNNN.nome` — quattro cifre | `_4000.catalogo` | `_src/_templates/`, file `.html` |
| vecchia | `_XNNN.nome` — **una** lettera e tre cifre | `_V300.immobiliari` | `_src/_templates/`, file `.html` |
| nuova | `_NNNNN.nome` — cinque cifre, per **area** | `_04000.catalogo` | `_src/_tpl/`, file `.twig` |
| nuova | `_XXNNN.nome` — **due** lettere e tre cifre, per **entita'** | `_AN000.anagrafica` | `_src/_tpl/`, file `.twig` |

La trappola e' la seconda riga: **un prefisso di lettere non vuol dire "nuovo"**. `_V300.immobiliari`,
`_V900.software`, `_F030.pagamenti`, `_V150.macchine` ed `_E300.modula` hanno una lettera sola e sono
della generazione vecchia; `_AN000`, `_CT000`, `_DO000` ne hanno due e sono della nuova. A contarle
male si tratta un modulo vecchio come nuovo, e ci si porta dietro l'albero di template sbagliato.

Per questo la prova solida non e' il nome ma la **struttura**: si guarda quale albero di template il
modulo si porta dietro. I moduli vecchi hanno `_mod/<modulo>/_src/_templates/`, i nuovi
`_mod/<modulo>/_src/_tpl/`, e **non esiste un modulo che abbia tutt'e due** — verificato su tutti e 79
i moduli di oldstable. Da qui la regola pratica: i due fronti di migrazione, moduli e templating, si
muovono insieme. Un deploy fermo sui moduli vecchi lo e' quasi sempre anche sui template.

**Stesso nome non vuol dire stesso modulo.** `_4000.catalogo` e `_04000.catalogo` condividono due macro
su ventuno; `_0400.documenti` ha 130 macro e `_DO000.documenti` ne ha 18, e non ne hanno **nessuna** in
comune. Il modulo nuovo e' quasi sempre una riscrittura, non una rinumerazione, e a volte si occupa di
cose diverse. Migrare un deploy da `_4000.catalogo` a `_04000.catalogo` **non e' rinominare una
cartella**: e' un lavoro di adattamento, da preventivare come tale.

**Latest non ha nessun modulo della generazione vecchia.** E' la stessa scelta fatta per
`_src/_templates/`, e ha la stessa conseguenza: e' la disponibilita' del modulo a decidere se un deploy
puo' passare a latest, non lo stato dei suoi template. Un progetto che usa anche un solo modulo vecchio
privo di controparte resta su oldstable a prescindere da quanto ha migrato dei template.

Sulla macchina del framework l'inventario aggiornato lo produce `./moduli-migrazione.sh` dalla cartella
esterna di glisdev, che scrive in `moduli-migrazione.log`: generazione di ogni modulo dedotta dal nome e
dai file ( e le eventuali incoerenze fra le due letture ), stato per deploy, moduli vecchi in uso senza
controparte in latest, e quanto condividono davvero le coppie omonime. Va rilanciato: e' una fotografia.

---
