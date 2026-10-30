# notizie

Le **notizie** sono i contenuti datati del sito: comunicati, articoli, novità. A differenza delle pagine,
che formano la struttura fissa, le notizie si aggiungono nel tempo e si raggruppano in **categorie**, che
sul sito diventano le pagine di elenco.

Si trovano nell'area **contenuti**, alla voce **notizie**; sotto c'è la sotto-voce **categorie**. Le
maschere sono aperte a chi appartiene allo **staff** o agli **amministratori**. Per elenchi e schede in
generale vedi i capitoli *gli elenchi* e *le schede*.

## l'elenco delle notizie
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: notizie.view -->

Una riga per notizia, con il numero, il **titolo** e le **categorie** in cui sta. Un clic apre la scheda,
il pulsante **+** ne apre una nuova.

## la scheda di una notizia
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: notizie.form -->

La linguetta *gestione* ha il riquadro **dati generali**:

| campo | contenuto |
|---|---|
| tipologia | il tipo di notizia |
| nome | il nome nel gestionale |
| se sitemap | spuntato, la notizia compare nella mappa del sito per i motori di ricerca |
| se cacheable | spuntato, il sito può tenerne in memoria il risultato |
| note | annotazioni interne |

Il riquadro **aspetto** ha **template**, **schema** e **tema**, che si scelgono come per le pagine: prima il
template, poi si salva, poi schema e tema. In fondo c'è l'elenco delle **pubblicazioni**, una riga per
periodo, con ordine, tipologia, inizio, fine e note.

> **attenzione** — una notizia esce sul sito solo mentre ha una pubblicazione in corso. Senza
> pubblicazione la notizia esiste nel gestionale ma il visitatore non la vede.

| linguetta | cosa ci sta | chi la vede |
|---|---|---|
| gestione | dati generali, aspetto, pubblicazioni | staff, amministratori |
| web | **sito**, template, schema, tema, mappa del sito, cache e pubblicazioni | staff, amministratori |
| SEM/SMM | dati per motori di ricerca e social | staff, amministratori |
| testo | titoli e testi, lingua per lingua | staff, amministratori |
| immagini, video, audio, file, metadati | media, allegati e coppie nome–valore | amministratori |
| azioni notizia | le operazioni sulla notizia | staff, amministratori |

La linguetta **testo** ha in alto la scelta della **lingua**, poi i campi *valore del tag h1*, *h2*, *h3*
e *cappello*, e sotto gli editor di testo. La linguetta **SEM/SMM** ha gli stessi campi delle pagine ( path
e URL custom, tag title, keywords, description, robots, OpenGraph ): vedi il capitolo *contenuti*.

## le categorie
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: categorie.notizie.view -->

Dalla sotto-voce **categorie** si apre l'elenco delle categorie. Ogni categoria è sul sito la pagina di
elenco delle sue notizie, e le categorie si annidano l'una nell'altra.

La scheda ( **categorie.notizie.form** ) ha in *dati generali*:

| campo | contenuto |
|---|---|
| sito | il sito in cui la categoria compare |
| tipologia | il tipo di categoria |
| genitore | la categoria che contiene questa |
| etichetta | il nome della categoria |
| se sitemap, se cacheable | come per le notizie |
| note | annotazioni interne |

Seguono *aspetto* e *pubblicazioni*, come nella notizia. Le linguette sono le stesse della notizia, più
**menu**: da lì la pagina della categoria si aggiunge ai menu del sito, con gli stessi campi descritti per
le pagine nel capitolo *contenuti*.

> **nota** — anche la categoria esce sul sito solo se ha una pubblicazione in corso. Una categoria non
> pubblicata nasconde la sua pagina di elenco, anche se le notizie che contiene lo sono.

## quello che questo capitolo non dice ancora

- l'ordine con cui le notizie compaiono nella pagina di una categoria;
- le **tipologie** di notizia e di categoria e dove si definiscono;
- le linguette dei media e dei metadati;
- il contenuto della linguetta delle azioni.
