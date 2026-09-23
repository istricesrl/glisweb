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

## I cinque file di un progetto: `CLAUDE.md`, `READ.md`, `TODO.md`, `DONE.md`, `CHAT.md`

Nella **root del deploy** (il livello che contiene `dev/`) vivono cinque file, più il `burndown.md`
che è generato. Fanno cinque lavori diversi e hanno cinque tempi di vita diversi: tenerli separati
non è ordine estetico, è la condizione perché restino leggibili.

| file | risponde a | come si scrive |
|---|---|---|
| `CLAUDE.md` | **come ci si deve comportare qui** | stabile, cambia di rado |
| `READ.md` | **cosa serve sapere per metterci le mani** | stabile, si aggiorna quando cambia l'infrastruttura |
| `TODO.md` | **cosa c'è da fare**: solo `[ ]` e `[?]` | si **pota** quando una voce chiude |
| `DONE.md` | **cosa è successo, e perché si è deciso così**: `[v]`, `[x]` e le cronache | append, non si rilegge: si consulta con `grep` |
| `CHAT.md` | **come siamo messi col cliente** | si **riscrive**: non è un diario, è una fotografia di adesso |

Il confine fra i primi due: il `CLAUDE.md` dice **come comportarsi** (le regole, cosa non fare, le
convenzioni), il `READ.md` dice **i fatti** (dove sta la roba, come ci si entra, quali comandi). Se
una riga comincia con "non fare mai" va nel CLAUDE; se comincia con "il database sta su" va nel READ.

⚠ **Nel `READ.md` di progetto non va la documentazione del framework.** Snippet e tecniche che
valgono su qualunque deploy glisweb non sono informazioni di *questo* progetto: vanno nella
documentazione del framework (questo file, `dev/READ.md`, o la skill). Il READ di progetto tiene
sette cose, e solo quelle: **1)** descrizione generale — cos'è, a cosa serve, per chi; **2)** tutte le
credenziali utili, o il posto preciso dove trovarle; **3)** architettura e risorse — macchine,
database, servizi esterni, domini; **4)** mappa delle personalizzazioni — cosa in questo deploy è
diverso dallo standard, e perché; **5)** FAQ di progetto; **6)** soluzioni ai problemi frequenti —
il sintomo, e cosa si fa; **7)** procedure proprie del progetto.

Vale anche per il READ il limite di lunghezza del TODO: **tiene il fatto e il riferimento, non la
trattazione.** Una procedura lunga sta in un file suo sotto `var/`, il READ ci rimanda.

La regola che tiene insieme i tre file di stato: **una cosa sta in un file solo.** Quando un lavoro finisce esce
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

### Concorrenza: non sei l'unico che scrive questi file

**Questi tre file stanno fuori dal repository, e su un progetto vivo ci scrive più di uno.** Due
sessioni di Claude Code aperte sullo stesso deploy, una persona che apre il `TODO.md` con l'editor,
uno script che ci aggiunge una riga: nessuno di questi vede gli altri. E fuori da git non c'è
merge, non c'è conflitto, non c'è storia da cui ripescare — **l'ultimo che salva vince, e quello che
ha scritto l'altro sparisce senza un messaggio**.

Non è teorico: il 14 settembre 2026 una sessione ha potato dal `CHAT.md` una sezione ormai detta, e
nel farlo ha cancellato la risposta a una segnalazione del cliente che un'altra sessione aveva
scritto lì mezz'ora prima. È stata ricostruita dal `DONE.md`, dov'era per fortuna raccontata per
esteso; se non ci fosse stata, era persa e nessuno se ne sarebbe accorto.

Da qui tre regole, in ordine di importanza:

- **si rilegge il file subito prima di scriverlo**, non ci si fida di quello che si è letto
  all'inizio del lavoro. Fra la lettura e la scrittura possono essere passati minuti o ore, e in
  mezzo può esserci passato qualcun altro. Vale anche — soprattutto — quando si è convinti di avere
  già in testa il contenuto;
- **si modifica il meno possibile alla volta.** Aggiungere una voce, sostituire un blocco preciso e
  breve: sono operazioni che al massimo perdono sé stesse. Riscrivere una sezione intera, o
  rigenerare il file, è l'operazione che cancella il lavoro degli altri — e il `CHAT.md` è il più
  esposto dei tre, perché è quello che per sua natura si riscrive;
- **quando una modifica è sostituzione, la si ancora al testo che si sta sostituendo** e si verifica
  che sia ancora quello di prima. Se non lo è più, si ricomincia dalla rilettura invece di forzare.

E una regola di buon senso che le risparmia quasi tutte: **se si sa che c'è un'altra sessione aperta
sullo stesso progetto, i file di stato li scrive una sola**, e l'altra lo dice invece di farlo. Alla
fine di un giro, dire quali dei tre si sono toccati costa una riga e fa risparmiare la ricostruzione.

### I cinque marcatori

| marcatore | significato | stato | dove vive |
|---|---|---|---|
| `- [ ]` | da fare, ed è lavoro **tuo** | aperta, **conta nel carico** | `TODO.md` |
| `- [=]` | da fare, ma la palla è di **un altro** | aperta, **fuori dal carico** | `TODO.md` |
| `- [?]` | da fare, ma prima serve un approfondimento | aperta, **fuori dal carico** | `TODO.md` |
| `- [v]` | fatta | chiusa | `DONE.md` |
| `- [x]` | scartata, tenuta solo per memoria storica | chiusa | `DONE.md` |

⚠ **`[?]` non conta nel residuo.** Deciso da Fabio il 15/09/2026: `[?]` è il posto dove mettere una
cosa senza doverla né fare né buttare, e serve proprio a **poter lasciar cadere qualcosa senza
perderlo**. Se contasse come lavoro aperto non servirebbe a niente.

⚠ **`[=]` — in attesa di qualcuno.** Aggiunto da Fabio il **16/09/2026**. Il buco che chiude: quel
giorno il punto della giornata diceva *"72 todo aperti, 32 con la palla mia e vivi, 29 in attesa di
altri"*, e **quel conto era fatto a mano**, perché nei file le 29 voci erano `[ ]` come tutte le
altre. Il carico risultava più che doppio di quello vero.

**Non è un doppione di `[?]`:** `[?]` vuol dire *non so se va fatta* — nessuno l'aspetta, può
restare lì per sempre; `[=]` vuol dire *va fatta, è decisa, e tornerà*, ma adesso è ferma su
qualcun altro. Mettere in `[?]` una voce ferma su un cliente è una bugia; lasciarla in `[ ]` gonfia
il numero.

**Due cose sono obbligatorie su ogni `[=]`**, altrimenti diventa il posto dove finisce tutto quello
che non si vuole guardare, cioè un secondo `[?]`: **il nome di chi si aspetta** e **la data da cui
si aspetta**. Una cosa ferma su un altro da tre settimane non è "in attesa", è **da sollecitare**.

    - [=] (-!!) il primo listino vero compilato
    -- **Matteo Montanari, dal 10/09** — ricordato il 15/09. Finché non arriva restano ferme le
       righe con articoli di altre macchine e le opzioni valide per qualsiasi macchina

È la stessa informazione che il `CHAT.md` tiene in *"Aspetta lui — cosa gli abbiamo chiesto"*, messa
però dove si conta il lavoro: i due file si tengono allineati.

**Non esistono altri marcatori**: se ne incontri uno
diverso (`[y]`, `[X]`, `[-]`, …) è un errore, normalizzalo a uno dei cinque invece di inventare
uno stato nuovo.

Li conta [avanzamenti-todo](https://github.com/the-linux-nerd/avanzamenti-todo) con espressioni
**ancorate a inizio riga**: le aperte le cerca in `TODO.md`, le chiuse in `TODO.md` **e** in
`DONE.md`, e le somma. ⚠ **Allineato il 16/09/2026**: il carico è ora **solo `[ ]`**, mentre `[=]` e
`[?]` finiscono nella colonna *attesa* del cruscotto; la burndown chart conta `[ ]` + `[=]`, perché
una `[=]` è lavoro che tornerà e una `[?]` può non tornare mai. Fino a quel giorno lo strumento
sommava `[ ]` e `[?]`, quindi **una curva che scende di uno scalino il 16/09 è il cambio di
criterio, non lavoro chiuso**. Le regole di scrittura che seguono non sono questioni di stile: se non le
rispetti i conteggi sbagliano in silenzio, e te ne accorgi settimane dopo guardando una curva che
non torna.

### Come si scrive una voce

- una voce per riga, che **inizia a colonna 1** con `- ` seguito dal marcatore e da uno spazio;
- niente indentazione: una sotto-voce rientrata non viene contata;
- il `- ` iniziale non è facoltativo — una riga che inizia direttamente con `[ ]` sfugge al conteggio;
- se devi **citare** un marcatore dentro una frase o un esempio, non metterlo a inizio riga, o verrà
  contato come una cosa da fare.

### `TODO.md`: come si aggiorna

⚠ **Il `TODO.md` si organizza per aree del progetto, non in ordine cronologico.** Deciso da Fabio il
15/09/2026: la data in cui una cosa è stata scritta è l'unico ordine che non aiuta mai a decidere
cosa fare. Le aree reggono per anni, i capitoli datati crescono all'infinito. La cronologia ha un
posto suo, ed è il `DONE.md`.

- le voci si raggruppano **per area del progetto** (`## catalogo`, `## preventivazione`,
  `## infrastruttura`, …), con l'intestazione sottolineata da `=` o un `##`. Una voce nuova va
  nell'area a cui appartiene, non in fondo al file;
- quando un lavoro finisce si cambia il marcatore in `[v]` e **si sposta la voce in `DONE.md`**, nel
  capitolo della giornata. Non si cancella niente: si trasloca;
- quando un lavoro si abbandona, `[x]`, stessa strada;
- **un'area senza più voci aperte resta**, vuota o no: è una struttura, non un capitolo;

#### I tre flag: urgenza, rilevanza, impatto

Dopo il marcatore, **tre posizioni fisse** fra parentesi. `!` se sì, `-` se no:

    - [ ] (!!!)   urgente, rilevante, impattante
    - [ ] (-!!)   non urgente, ma qualcuno l'aspetta e se non si fa si blocca qualcosa
    - [ ] (!--)   urgente ma non rilevante e senza impatto — si fa e si dimentica
    - [ ] (---)   nessuna delle tre: candidata naturale a cadere

1. **urgente** — ha una scadenza vicina, o qualcuno è fermo ad aspettare **adesso**;
2. **rilevante** — c'è **qualcuno** che l'aspetta: un cliente, un collega, un altro lavoro. Se non
   l'aspetta nessuno, è `-`;
3. **impattante** — se non si fa, qualcosa **si rompe o resta bloccato**; oppure se si fa, cambia
   parecchio. Una cosa che si può non fare per sempre senza conseguenze è `-`.

Senza questi tre elementi non si può decidere cosa lasciar cadere, e quindi non si lascia cadere
niente.

#### Quanto dettaglio ci sta in una voce

⚠ **Nel TODO ci sta quello che serve per decidere e per cominciare. Niente di più.** Ogni compito
occupa **una riga sola**; i dettagli stanno in un paragrafo sotto la voce, e l'analisi lunga va in un
file suo **sotto `var/`**, con la voce che ci rimanda in una o due righe:

    - [ ] (-!!) i report, e il registro presenze per primo
    -- chiesto da Melania il 14/09: "ci serve al più presto". Piano in
       var/2026-08-07-report-melania/piano.md

Il motivo, parole di Fabio: *"per lavorare una specifica linea di todo si legge solo la sua analisi e
non tutto il file todo con l'analisi anche di roba che non c'entra niente"*. Ventidue righe per voce
non è una lista, è prosa con dei quadratini dentro.

- niente domande al cliente nel `TODO.md`. Le domande stanno in `CHAT.md`, e qui resta semmai il
  lavoro che dipende dalla risposta;
- una riga `SAL PIANIFICATA <data>` viene raccolta nel cruscotto `/root/avanzamenti.sh` fra le
  prossime scadenze.

### `DONE.md`: l'archivio

**Un capitolo per giornata di lavoro**, in ordine di tempo, con gli stessi marcatori — ma **non si
legge dall'inizio**: è
il posto dove si va a cercare *come era andata* una certa cosa. Ci finiscono anche i blocchi
narrativi che spiegano una diagnosi, una decisione o una migrazione: sono la memoria del progetto,
e sono esattamente ciò che rende illeggibile il `TODO.md` se restano lì.

Non si riscrive e non si riordina: si aggiunge in fondo. Se cresce troppo lo si spezza per anno
(`DONE.2026.md`), mai per argomento.

### `CHAT.md`: lo stato della conversazione col cliente, e il canale fra i claude

**È il file da leggere prima di scrivere al cliente**, sempre, anche per un messaggio di una riga.

⚠ **Dal 16/09/2026 non è più solo nostro.** È il canale con cui l'assistente generale di Fabio ci
passa quello che arriva da **mail e WhatsApp** — l'unica cosa che ha lui e noi no — e con cui noi
gli diciamo come siamo messi. Da qui discendono le due novità: le sezioni per destinatario e il
lock.

Non è un diario e non è un log: contiene **soltanto ciò che è vero adesso**.

⚠ **Quando una voce chiude, il cliente non lo sa.** Regola data da Fabio il **22/09/2026**:
nel momento in cui una voce passa dal `TODO.md` al `DONE.md`, se è una cosa che il cliente vede o
che stava aspettando, **la stessa riga va anche nel `CHAT.md`**, nella sezione
`### Da dirgli alla prossima occasione` della persona giusta, **il giorno stesso**. Uno sviluppo
finito e non comunicato, per il cliente, non è finito — e nessuno se ne accorge, perché da noi
risulta fatto.

#### Una sezione per conversazione e destinatario

Non un blocco unico, e non più "un progetto, un interlocutore": **una sezione `##` per persona**.
Due che scrivono su due persone diverse non si toccano nemmeno, e chi legge trova l'interlocutore
senza scorrere tutto il file.

```markdown
# CHAT.md — <progetto>

## <Nome Cognome> — <ruolo>

Ultimo contatto: mail 05/09, WhatsApp 08/09 11:22, telefono 07/09 (12 minuti).

### Aspetta lui — cosa gli abbiamo chiesto
  - [ ] <domanda>, chiesta il <data> per <canale>

### Aspettiamo noi — cosa ha chiesto lui
  - [ ] <richiesta>, arrivata il <data>

### Da dirgli alla prossima occasione
  - [ ] <cosa fatta che lui non sa ancora>

### Ultimi scambi, in breve
- <data> — <cosa si è detto, due righe>

## <Altra persona> — <ruolo>
...

## lock
```

#### Il lock, ultima sezione del file

Vale per tutto il file:

```markdown
## lock

- libero
```

Chi scrive: legge il lock; se dice `libero` lo sostituisce con la propria riga; **rilegge per
verificare di avercela ancora** ( se compaiono due righe ha vinto chi sta per primo: l'altro toglie
la sua e riprova ); scrive **solo nella sezione di quella persona**; rimette `libero`.

```markdown
- preso da: claude-<progetto>@web03 — 2026-09-16 13:42
```

- un lock **più vecchio di dieci minuti è stantio**: si prende e si annota che è stato forzato,
  perché una sessione può essere morta tenendolo;
- da shell si usa anche `flock` sul file: rende atomica la singola scrittura. La sezione serve ai
  claude, che `flock` non lo vedono;
- ⚠ **non riscrivere mai il file intero quando basta la sezione di una persona**: rigenerare il
  file è l'operazione che cancella il lavoro degli altri.

#### Le regole che evitano le figuracce

- **quando una domanda ha risposta, si toglie da qui**: la risposta diventa una voce di lavoro nel
  `TODO.md` o una decisione nel `DONE.md`. Una domanda che resta scritta dopo la risposta è una
  trappola, perché il prossimo che legge la rifà;
- **le telefonate si scrivono qui il giorno stesso**, con durata e decisioni: una chiamata non
  trascritta è un buco nero e produce esattamente l'errore di richiedere il già detto;
- **si annota il canale e la data di ogni contatto**: serve a sapere se una cosa è stata detta a
  voce o per iscritto, e con quali parole;
- prima di scrivere "da chiedere a <cliente>" da qualunque parte, **si cerca qui e nel `DONE.md`**
  se la risposta esiste già;
- il tono delle voci è quello che si userebbe col cliente: niente nomi di tabelle, niente dettagli
  interni. Quelli stanno nel `TODO.md`;
- **il materiale lungo non ci va**: allegati, screenshot, trascrizioni dei vocali e diagnosi stanno
  in `var/<cartella-parlante>/`, e qui ci va il **rimando**;
- ⚠ **se da un messaggio nasce una cosa da fare, quella va nel `TODO.md`** — anche o soltanto lì, a
  seconda dell'urgenza. Lo stato della conversazione non è il lavoro da fare, e il carico si conta
  nel TODO.

#### I file ancora nel formato vecchio

Il `CHAT.md` di questo deploy può essere ancora un blocco unico col solo `## lock` aggiunto in
fondo: **la prima volta che ci si mette mano si riorganizza per destinatario**. È il momento
giusto, perché il contesto per capire chi è chi ce l'ha chi ci sta lavorando.


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

### Il dataset del job, e perché è il punto in cui si fa il danno più grosso

Un job che lavora su un elenco — un CSV da importare, una lista da elaborare — ha un problema che lo
scheletro qui sopra non risolve: **il file del job viene incluso da capo a ogni iterazione**, quindi
l'elenco va ricaricato ogni volta. Lo schema storico è memcache, con il ripiego di rileggere il file
di partenza quando la cache non risponde.

Quel ripiego costa quanto tutto il file, **a ogni iterazione**. Ed è qui che il 12/09/2026 un
deploy ha riempito un filesystem da 246 GB:

- l'importazione di 14.522 anagrafiche non entrava in memcache — 7,13 MB serializzati contro il
  limite da **1 MB per elemento**, `set()` rifiutata con `MEMCACHED_E2BIG` — e il job ha riletto e
  riparsato lo stesso CSV a ogni iterazione, **dodicimila volte**;
- `csvFile2array()` scriveva nel canale `details/csv` un `print_r` dell'intero file, due volte per
  chiamata, e in DEV il livello di log standard è `LOG_DEBUG`, quindi lo scriveva davvero: una
  decina di megabyte a chiamata, per dodicimila chiamate. **122 GB in un file solo**, mai aperto da
  nessuno;
- il fallimento della cache **era loggato**, a `LOG_ERR`, in `var/log/memcache.err.AAAAMM.log`,
  nell'istante esatto in cui il job si apriva. Una riga in un file che nessuno apre non è un
  allarme.

Da qui tre regole, e la prima vale ben oltre i job:

- **quello che un job scrive va moltiplicato per il numero di iterazioni.** Una riga di log che su
  una richiesta è innocua, su un job da diecimila giri è un file da gigabyte. Prima di loggare
  dentro un job, chiedersi quante volte verrà scritta quella riga;
- **il dataset si salva con `jobDatasetScrivi()` e si rilegge con `jobDatasetLeggi()`**
  (`_src/_lib/_job.utils.php`), che provano la cache e ripiegano su un file di spool dedicato al job
  (`var/spool/job/` più l'id): un `unserialize()` per iterazione invece di un parsing completo, e
  senza limiti di dimensione. La chiusura chiama `jobDatasetPulisci()`, perché quel file pesa;
- **l'esito del salvataggio va messo nel `workspace`**, non solo nel log: `jobDatasetScrivi()` lo
  restituisce apposta. Chi lancia un import guarda la barra di avanzamento e lo stato del job, non
  `var/log/memcache.err`. Un fallimento che cambia il costo del lavoro di tre ordini di grandezza
  deve comparire dove l'operatore guarda davvero.

E una nota su `csvFile2array()`: dal 12/09/2026 logga **l'impronta** del file — righe, separatore,
colonne, prime tre righe — e non più il contenuto. Il dump integrale esiste ancora ma va chiesto,
accendendo `$cf['debug']['csv']['dump']` per il giro in cui serve. Se il dataset serve per intero e
sistematicamente, la copia leggibile la scrive già `jobDatasetScrivi()` in `var/log/job/` sotto la
cartella dell'id, nel file `dataset.log`: una volta sola e accanto agli altri log di quel job, molto
più utile di dodicimila copie accavallate in un canale mensile condiviso.

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
- **Dopo aver lanciato un job lungo, guardare la prima passata prima di andarsene.** Non la barra:
  `workspace.status`, e `var/log/memcache.err` se il job usa un dataset. Il difetto che costa caro si
  vede nei primi sessanta secondi e poi si moltiplica in silenzio per tutte le ore che seguono.

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
