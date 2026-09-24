# I cinque file di un progetto: il regolamento completo

*Riferimento della skill `glisweb`, letto **su richiesta**: non sta nel preambolo di ogni sessione.
Spostato il 24/09/2026 da `_etc/_claude/_claude.framework.md` ( prima parte ) e dal `SKILL.md` ( appendice ), tali e quali. Il file del framework ne tiene l'essenziale e rimanda qui.*

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

⚠ **Nella voce 3 ci vanno anche i deploy e le relazioni fra loro**, non solo le macchine: quali
deploy esistono di questo progetto ( produzione, test, dev ), **su quale macchina sta ciascuno**,
qual è la document root di ognuno, cosa si propaga da dove e in che direzione, e se il deploy è
dentro o fuori l'aggiornamento notturno del framework. Un cliente può avere **due deploy su due
macchine diverse** — il sito su una, il gestionale legacy su un'altra: se il READ non lo dice,
nessuno lo sa.

### ⚠ Il READ si legge prima di chiedere, e si scrive quando si scopre

Detto da Fabio il 23/09/2026: *"mi fanno domande riguardo a cose che dovrebbero essere descritte
dal READ.md"*. Una domanda del tipo *"su che macchina sta questo?"*, *"dove sta il database?"*,
*"qual è il deploy di produzione?"*, *"come si fa il rilascio qui?"* **è un buco nel READ**, non è
una domanda. Prima di farla:

1. **si cerca nel READ** — le sette voci, non solo quella che sembra;
2. se non c'è, **si guarda**: la macchina risponde. `ssh`, `src/config.json`, `/etc/cron.d`,
   `git remote -v`, `update.branch.conf`, il vhost;
3. **si scrive nel READ**, nella voce che le compete, **nello stesso turno in cui si è scoperta** —
   non "poi", non in un todo;
4. **si chiede a Fabio solo quello che sa solo lui**: una decisione, cosa vuole il cliente, una
   credenziale che non è scritta da nessuna parte.

Il metro è quello del suo `CLAUDE.md`: **se una risposta gli aumenta il lavoro invece di ridurlo, è
sbagliata.** Fargli da indice dell'infrastruttura di un progetto che è nostro è esattamente questo.

⚠ **Il READ non è mai "finito".** Ogni volta che si scopre un fatto stabile — una macchina, un
percorso, un cron, un vincolo, una procedura che si è dovuta ricostruire — si aggiunge. Un READ che
non cresce mai è un READ che nessuno sta usando, e la prossima sessione rifarà la stessa domanda.

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

---

# Appendice: la sintesi che stava nel `SKILL.md`

## I cinque file di un progetto ( sintesi )

⚠ **La root del deploy non è versionata, ed è voluto.** Il repository è la document root, `dev/`: il
livello che la contiene ne sta **fuori di proposito**, perché ci vivono le password in chiaro e le
informazioni del progetto — il `READ.md` degli accessi ( CMS, SSH, database ), i file di stato, gli
script operativi del deploy. Metterli sotto git significherebbe pubblicare le credenziali a chiunque
abbia accesso al repository, e in un progetto cliente anche ai suoi fork.

Quindi: **non proporre di versionarli, non crearci dentro un repository, non "metterli al sicuro" su
git.** Sono già al sicuro — la macchina ha uno snapshot notturno, e quei file ci sono dentro come tutto
il resto. Un `git status` pulito su `dev/` non dice niente su di loro, e non deve: sono due piani con
due meccanismi di protezione diversi, entrambi funzionanti.

Nella root del deploy vivono **cinque file** con cinque tempi di vita diversi, più il `burndown.md` che è
generato e non si tocca a mano:

- **`CLAUDE.md`** — **come ci si deve comportare qui**: le regole, cosa non fare, le convenzioni. Stabile,
  cambia di rado. Se una riga comincia con "non fare mai", il suo posto è questo;
- **`READ.md`** — **cosa serve sapere per metterci le mani**: i fatti. Sette voci e solo quelle —
  descrizione generale, credenziali ( o dove trovarle ), architettura e risorse, **mappa delle
  personalizzazioni**, FAQ, problemi frequenti, procedure del progetto. Se una riga comincia con "il
  database sta su", il suo posto è questo. ⚠ **Non ci va la documentazione del framework**: uno snippet
  che vale su qualunque deploy non è informazione di questo progetto. E vale il limite di lunghezza del
  TODO — il fatto e il riferimento, non la trattazione: una procedura lunga sta in un file suo sotto
  `var/`;
- **`TODO.md`** — solo lavoro **aperto** ( `- [ ]` da fare, `- [=]` in attesa di qualcun altro,
  `- [?]` sospesa; le ultime due **non contano nel carico** ). Quando una voce
  chiude non resta qui: si sposta;
- **`DONE.md`** — l'archivio del **fatto** ( `- [v]` fatta, `- [x]` scartata ) e delle cronache di come è
  andata. Si consulta con `grep`, non si rilegge;
- **`CHAT.md`** — lo **stato attuale** della conversazione col cliente: cosa aspetta lui, cosa aspettiamo
  noi, cosa c'è da dirgli, con data e canale di ogni contatto. **Si riscrive**, non si accumula.

Due regole che valgono più di tutte le altre:

1. **una cosa sta in un file solo.** Se la stessa riga è in due file, il prossimo che legge non sa quale
   delle due è vera;
2. **prima di scrivere al cliente si legge `CHAT.md`**, e prima di scrivere "da chiedere a X" si cerca in
   `CHAT.md` e `DONE.md` se la risposta esiste già. Chiedere a un cliente una cosa a cui ha già risposto
   gli dice che quello che ha detto non è stato registrato;
3. **non sei l'unico che scrive questi file.** Stanno fuori dal repository, quindi niente merge e niente
   storia: due sessioni aperte sullo stesso deploy si sovrascrivono a vicenda in silenzio. Si **rilegge
   il file subito prima di scriverlo** ( non ci si fida della lettura di mezz'ora fa ), si modifica il
   meno possibile alla volta, e riscrivere una sezione intera è proprio l'operazione che cancella il
   lavoro degli altri — il `CHAT.md` è il più esposto, perché è quello che per sua natura si riscrive.
   Se due sessioni sono aperte, i file di stato li tiene una sola.

#### ⚠ Quando una voce chiude, il giro non finisce nel `DONE.md`

Regola data da Fabio il **22/09/2026**, ribadita il **23/09/2026**: *"quando fanno le cose e chiudono i
task devono sempre aggiornare di conseguenza il `CHAT.md`"*.

Chiudere una voce sono **tre gesti nello stesso turno**, non uno:

1. il marcatore diventa `[v]` ( o `[x]` se si è deciso di non farla );
2. la voce **trasloca** nel `DONE.md`, nel capitolo di oggi, con **com'è andata e perché si è deciso
   così** — è l'unica cosa che risponderà a *"perché l'avevamo fatto così?"* fra sei mesi;
3. ⚠ se è una cosa che **il cliente vede o che stava aspettando**, la stessa riga va **anche nel
   `CHAT.md`**, nella sezione `### Da dirgli alla prossima occasione` della persona giusta, **il giorno
   stesso**.

**Il test, in una riga**: *se ne accorgerebbe, o l'aveva chiesta lui?* Se sì, il terzo gesto non è
facoltativo. **Uno sviluppo finito e non comunicato, per il cliente, non è finito** — e nessuno se ne
accorge, perché da noi risulta fatto.

**Non è una deroga a "una cosa sta in un file solo"**: nel `DONE.md` sta il **lavoro fatto**, nel
`CHAT.md` sta la **comunicazione da fare**. Sono due informazioni diverse e hanno due vite diverse —
la riga del `CHAT.md` sparisce appena gliel'hai detto, quella del `DONE.md` resta per sempre.

**Vale in tutt'e due i versi.** Una voce `[=]` è ferma su qualcuno, e quando la risposta arriva — e
arriva quasi sempre dal `CHAT.md`, che è il canale con l'assistente generale di Fabio — la voce torna
`[ ]` e la riga del `CHAT.md` si aggiorna. Una `[=]` la cui risposta è già arrivata è peggio di una
voce mancante: tiene fermo un lavoro senza motivo, e non lo dice a nessuno.

⚠ **Il `CHAT.md` si scrive col lock**, sempre: si legge la sezione `## lock` in fondo, se dice `libero`
ci si mette la propria riga, **si rilegge per verificare di avercela ancora**, si scrive **solo** nella
sezione di quella persona, si rimette `libero`. Un lock più vecchio di dieci minuti è stantio: si prende
e si annota che è stato forzato. Il protocollo per esteso sta nella sezione `CHAT.md`
qui sopra.

## Come si scrive il `TODO.md` ( deciso il 15/09/2026 )

⚠ **Per aree del progetto, non in ordine cronologico.** La data in cui una cosa è stata scritta è l'unico
ordine che non aiuta mai a decidere cosa fare: le aree reggono per anni, i capitoli datati crescono
all'infinito. La cronologia ha un posto suo, ed è il `DONE.md`, dove si tiene **un capitolo per giornata**.

⚠ **Una riga per compito**, con **tre flag** fra parentesi subito dopo il marcatore — urgenza, rilevanza,
impatto, `!` se sì e `-` se no:

    - [ ] (!!!)   urgente, rilevante, impattante
    - [ ] (-!!)   non urgente, ma qualcuno l'aspetta e se non si fa si blocca qualcosa
    - [ ] (!--)   urgente ma non rilevante e senza impatto — si fa e si dimentica
    - [ ] (---)   nessuna delle tre: candidata naturale a cadere

**urgente** = scadenza vicina o qualcuno fermo ad aspettare adesso; **rilevante** = c'è qualcuno che
l'aspetta, altrimenti `-`; **impattante** = se non si fa qualcosa si rompe o resta bloccato. Senza questi
tre elementi non si può decidere cosa lasciar cadere, e quindi non si lascia cadere niente.

⚠ **`[?]` non conta nel residuo**: è il posto dove mettere una cosa senza doverla né fare né buttare.

⚠ **Nel TODO ci sta quello che serve per decidere e per cominciare, niente di più.** L'analisi lunga va in
un file sotto `var/`, e la voce ci rimanda con un sunto di una o due righe: *"per lavorare una specifica
linea di todo si legge solo la sua analisi e non tutto il file todo con l'analisi anche di roba che non
c'entra niente"*.

I conteggi sono ancorati a inizio riga, quindi il `- ` iniziale e l'assenza di indentazione non sono
dettagli stilistici: le aperte si contano in `TODO.md`, le chiuse in `TODO.md` **e** `DONE.md`. La regola
completa sta nella sezione **"I cinque file di un progetto"** nella prima parte di questo file, che è
la fonte autorevole: leggila prima di modificare uno di questi file.
