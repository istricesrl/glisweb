# video

Il modulo permette di **collegare dei video** alle cose che il sito mostra: una pagina, una
notizia, un prodotto, un marchio, un'anagrafica. Il video non si carica nel gestionale: di norma sta
su un servizio esterno — YouTube, Vimeo — e qui se ne registra il **codice di incorporamento**,
cioè il riferimento che permette al sito di mostrarlo al suo posto.

Il modulo non ha una voce di menu propria. Aggiunge due cose:

- la linguetta **video** alle schede degli oggetti a cui un video si può collegare;
- la linguetta **video** all'archivio dei contenuti, con l'elenco di tutti i video registrati.

Tutte le sue pagine sono aperte a chi appartiene allo **staff** o agli **amministratori**.

## la linguetta video di una scheda
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.pagine.form.video -->

Compare nelle schede delle **pagine**, delle **notizie** e delle **categorie di notizie**, dei
**prodotti**, degli **articoli**, delle **categorie di prodotti**, dei **marchi** e delle
**anagrafiche**. Contiene un solo sotto-elenco, **video collegati**, con una riga per video:

| campo | contenuto |
|---|---|
| ordine | la posizione del video fra quelli dello stesso oggetto |
| etichetta | il nome del video, per riconoscerlo |
| lingua | la lingua del video, se il sito è in più lingue |
| ruolo | che cosa il video è per quell'oggetto ( presentazione, tutorial… ) |
| embed | il servizio da cui il video arriva: *HTML5* per un file video, *Vimeo*, *YouTube* |
| codice embed | il riferimento del video su quel servizio |

Si aggiunge una riga col più e la si toglie col cestino; tutto diventa definitivo al salvataggio
della scheda, come per ogni sotto-elenco.

> **nota** — la tendina del **ruolo** mostra solo i ruoli abilitati per quel tipo di oggetto: un
> ruolo pensato per i prodotti non compare nella scheda di una pagina. Se manca il ruolo giusto, va
> chiesto a chi amministra l'installazione.

## l'archivio dei video
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.archivio.video.view -->

Nell'archivio dei contenuti la linguetta **video** elenca tutti i video registrati, di qualunque
oggetto, in ordine alfabetico. Serve a cercare un video quando non si sa a che cosa è attaccato; il
lavoro di tutti i giorni si fa dalla linguetta *video* della scheda dell'oggetto.

Un clic su una riga apre la scheda del video:

| linguetta | cosa ci sta |
|---|---|
| gestione | **ordine**, **etichetta**, **lingua**, **ruolo**, **codice embed** e **note** |
| immagini | le immagini del video, come l'anteprima, se c'è il modulo delle immagini |
| collegamenti | **a che cosa** il video è attaccato: anagrafica, pagina, notizia, categoria di notizie, prodotto, categoria di prodotti, articolo, marchio |
| azioni | le operazioni sul video; nello standard la pagina prepara i gruppi ma non ci mette riquadri |

> **nota** — la scheda dell'archivio **non ha il campo embed**, cioè il servizio da cui il video
> arriva: quello si imposta dalla linguetta *video* della scheda dell'oggetto.

> **attenzione** — la linguetta *collegamenti* permette di spostare un video da un oggetto a un
> altro, o di attaccarlo a più oggetti insieme. È comoda per correggere un errore, ma cambia ciò che
> il sito mostra **in tutti i posti coinvolti**.

## quello che questo capitolo non dice ancora

- dove si trova il **codice embed** su YouTube e su Vimeo, e in che forma va copiato;
- come si carica un video **HTML5**, cioè un file ospitato dal sito stesso;
- dove e come il video compare **sul sito**, che dipende dall'aspetto grafico della pagina;
- l'elenco dei **ruoli** dei video e dove si configurano.
