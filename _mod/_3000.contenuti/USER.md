# contenuti

L'area **contenuti** raccoglie le maschere con cui si gestiscono le pagine del sito, il loro aspetto, i
redirect e le recensioni. Si apre dal menu di amministrazione, alla voce **contenuti**: la schermata
iniziale è una griglia di riquadri, uno per ogni sotto-area attiva. Quasi tutte le maschere sono aperte a chi
appartiene allo **staff** o agli **amministratori**; dove una linguetta è riservata agli amministratori
lo si dice. Per come funzionano elenchi, schede e linguette in generale vedi i capitoli *gli elenchi* e *le
schede*.

## l'elenco delle pagine
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: pagine.view -->

Alla voce **pagine** c'è una riga per pagina. Le colonne sono:

| colonna | contenuto |
|---|---|
| # | il numero della pagina |
| sito | il sito a cui appartiene; *Nessun sito* se non è stato scelto, *Sito non definito* se il sito indicato non esiste più |
| pagina | l'etichetta della pagina |
| template | il modello grafico usato |
| schema | lo schema ( il file `.html` del modello ) |
| tema | il foglio di stile |

In alto si può restringere l'elenco con la tendina **sito** e con la **ricerca per parola chiave**; il
pulsante **+** apre una pagina nuova. Un clic su una riga apre la scheda. Le altre linguette
dell'elenco sono **statistiche pagine** e **azioni**.

## la scheda di una pagina
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: pagine.form -->

La linguetta *gestione* ha due riquadri.

**dati generali**, con in legenda la data dell'ultimo aggiornamento:

| campo | contenuto |
|---|---|
| sito | il sito in cui la pagina vive |
| genitore | la pagina che sta sopra a questa nella struttura del sito. Propone solo le pagine dello stesso sito e non quelle che creerebbero un giro chiuso. Si compila dopo aver scelto e salvato il sito |
| etichetta | il nome della pagina nel gestionale |
| se sitemap | spuntato, la pagina compare nella mappa del sito che leggono i motori di ricerca |
| se cacheable | spuntato, il sito può tenerne in memoria il risultato per rispondere più in fretta |
| note | annotazioni interne |

**aspetto**:

| campo | contenuto |
|---|---|
| template | il modello grafico, scelto fra quelli disponibili sul sito |
| schema | la struttura della pagina, fra gli schemi del modello scelto |
| tema | il foglio di stile, fra quelli del modello scelto |

> **nota** — *schema* e *tema* si riempiono solo dopo aver impostato il *template* e **salvato**: la
> prima volta si sceglie il template, si salva, e poi si scelgono schema e tema.

In fondo c'è l'elenco delle **pubblicazioni**: una riga per periodo, con ordine, tipologia, inizio, fine
( data e ora ) e note. Il pulsante accanto alla riga la toglie.

> **attenzione** — una pagina è visibile sul sito solo mentre ha una pubblicazione in corso. Senza
> pubblicazione, o a pubblicazione scaduta, la pagina esiste nel gestionale ma il visitatore non la vede.

Le linguette della scheda, nell'ordine:

| linguetta | cosa ci sta | chi la vede |
|---|---|---|
| gestione | dati generali, aspetto, pubblicazioni | staff, amministratori |
| SEM/SMM | indirizzo e dati per i motori di ricerca e i social | amministratori |
| testo | i testi della pagina, lingua per lingua | staff, amministratori |
| menu | la pagina nei menu del sito | staff, amministratori |
| progetti ( icona della valigetta ) | i progetti collegati alla pagina, e il pulsante per collegarne uno; c'è solo se è attivo il modulo dei progetti | staff, amministratori |
| immagini, video, audio, file | i media della pagina | amministratori |
| macro | i programmi che completano la pagina | amministratori |
| metadati | coppie nome–valore aggiuntive | amministratori |
| gruppi | chi può aprire la pagina | amministratori |
| statistiche pagina | i dati di visita | staff, amministratori |
| azioni pagina | duplicare e pubblicare | staff, amministratori |

## i testi della pagina
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: pagine.form.testo -->

In alto si sceglie la **lingua**: ogni lingua ha i suoi testi. Il riquadro *contenuti della pagina* ha:

| campo | contenuto |
|---|---|
| valore del tag h1, h2, h3 | i titoli della pagina, dal più importante in giù |
| cappello | il breve testo introduttivo |

Sotto, tre linguette con un editor di testo ciascuna: **testo**, **abstract** e **specifiche**. Quali di
questi testi compaiono davvero lo decide il template della pagina.

## SEM/SMM
<!-- @pubblico: amministratore -->
<!-- @pagina: pagine.form.sem -->

Anche qui si sceglie prima la **lingua**. I riquadri sono tre.

| riquadro | campi |
|---|---|
| opzioni URL | **path custom** ( un indirizzo alternativo per la pagina ), **URL custom** ( l'indirizzo da usare nei collegamenti interni ), **rewrite custom** ( un testo che sostituisce il titolo nel costruire l'indirizzo ). Path e URL devono cominciare con `/` |
| meta tag | **tag title**, **tag keywords**, **tag description**, **robots** ( cosa possono fare i motori con la pagina ) |
| OpenGraph protocol | OG:type, OG:determiner, OG:title, OG:image, OG:audio, OG:video, OG:description: come la pagina appare quando la si condivide sui social |

## la pagina nei menu del sito
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: pagine.form.menu -->

Nella linguetta **menu** una riga dice "questa pagina compare in questo menu":

| campo | contenuto |
|---|---|
| ordine | la posizione nel menu |
| menu | **obbligatorio**. Il menu scelto fra quelli che il template della pagina prevede |
| lingua | la lingua della voce |
| voce | il testo mostrato; se vuoto si usa il nome della pagina |
| target | *apri in nuova scheda*, oppure niente |
| ancora | un punto della pagina di destinazione |
| sottopagine | **obbligatorio**: *espandi sottovoci* ( le mostra quando la voce è attiva ), *non mostrare sottovoci*, *mostra sempre sottovoci* |

> **nota** — l'elenco dei menu dipende dal template: se è vuoto, il template non è stato impostato e
> salvato.

## i gruppi e le macro
<!-- @pubblico: amministratore -->
<!-- @pagina: pagine.form.gruppi -->

Nella linguetta **gruppi** si aggiungono una riga per ogni gruppo di utenti che può aprire la pagina.
Nella linguetta **macro** si collegano alla pagina i programmi del sito che ne costruiscono il
contenuto: ogni riga ha un solo campo, **macro**, obbligatorio, scelto da un elenco.

## duplicare e pubblicare
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: pagine.form.tools -->

La linguetta **azioni pagina** ha due riquadri.

- **duplica pagina** crea una copia della pagina e di tutto ciò che ha collegato ( immagini, video, voci
  di menu… ). Chiede conferma.
- **pubblica pagina** porta la pagina e le sue entità collegate su un altro ambiente del sito. Si sceglie la
  **destinazione** fra gli altri ambienti configurati; la finestra mostra quanti file verranno trasferiti e
  una barra di avanzamento.

> **attenzione** — durante la pubblicazione non si chiude la finestra finché il trasferimento non è
> finito.

## i template
<!-- @pubblico: amministratore -->
<!-- @pagina: template.pagine.view -->

Alla voce **template** c'è l'elenco dei modelli grafici del sito, con la ricerca per parola chiave. La
scheda di un modello ha il riquadro *file del template*: i suoi file, con tipo ( schema HTML, foglio di stile
CSS, script Javascript ) e modulo di appartenenza, filtrabili per tipologia e per modulo. Il pulsante **+**
inserisce un file nuovo scegliendo **modulo** e **nome**. Un clic su un file apre l'**editor**, una
maschera con un editor di codice che mostra il contenuto del file.

> **attenzione** — un file del template è codice che il sito usa subito: una modifica sbagliata si vede su
> tutte le pagine che lo usano.

## i redirect
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: redirect.view -->

Un redirect manda chi apre un vecchio indirizzo verso uno nuovo. L'elenco mostra sito, codice HTTP,
sorgente e destinazione, e si filtra per sito e per parola chiave. Le linguette sono *elenco*, *statistiche*
e *azioni*.

Nella scheda ( **dati generali** ) si compilano:

| campo | contenuto |
|---|---|
| sito | il sito in cui vale il redirect |
| codice | **obbligatorio**: il codice HTTP, per esempio 301 per uno spostamento definitivo |
| sorgente | **obbligatorio**: l'indirizzo vecchio |
| destinazione | **obbligatorio**: l'indirizzo nuovo |

La linguetta *azioni* ha il riquadro **pubblica redirect**, che funziona come la pubblicazione di una
pagina.

## le recensioni
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: recensioni.view -->

Alla voce **recensioni** l'elenco ha data, autore, titolo, valutazione e una spunta **approvata**. Nella
scheda si sceglie la **lingua** e si compilano **data** ( oggi, se non si cambia ), **autore**, **titolo**
e **valutazione** ( tutti obbligatori ), la spunta **approvata** e il **testo**.

> **nota** — la spunta *approvata* è il filtro di moderazione: va messa perché la recensione sia
> considerata pubblicabile.

## quello che questo capitolo non dice ancora

- le schede di **corsi**, **discipline**, **fasce** e **livelli**, a cui il modulo aggiunge le linguette
  web, SEM/SMM, testo e menu, quando la gestione dei corsi è presente;
- le linguette **immagini**, **video**, **audio**, **file** e **metadati** delle pagine;
- le **statistiche** delle pagine e dei redirect;
- come l'approvazione di una recensione ne decide la comparsa sul sito.
