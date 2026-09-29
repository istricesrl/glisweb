# audio

Il modulo permette di **collegare dei contenuti audio** alle cose che il sito mostra: una pagina,
una notizia, un prodotto, un marchio, un'anagrafica. Di un audio il gestionale registra il nome, la
lingua, il ruolo e il **codice di incorporamento**, cioè il riferimento con cui il sito lo mette al
suo posto.

È il gemello del modulo dei video, e si usa allo stesso modo. Non ha una voce di menu propria:
aggiunge due cose.

- la linguetta **audio** alle schede degli oggetti a cui un audio si può collegare;
- la linguetta **audio** all'archivio dei contenuti, con l'elenco di tutti gli audio registrati.

## la linguetta audio di una scheda
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.pagine.form.audio -->

Compare nelle schede delle **pagine**, delle **notizie** e delle **categorie di notizie**, dei
**prodotti**, degli **articoli**, delle **categorie di prodotti**, dei **marchi** e delle
**anagrafiche**, se i moduli che le gestiscono sono attivi. Contiene un solo sotto-elenco, **audio
collegati**, con una riga per audio:

| campo | contenuto |
|---|---|
| ordine | la posizione dell'audio fra quelli dello stesso oggetto |
| etichetta | il nome dell'audio, per riconoscerlo |
| lingua | la lingua dell'audio, se il sito è in più lingue |
| ruolo | che cosa l'audio è per quell'oggetto |
| embed | il modo in cui l'audio viene riprodotto: c'è solo *HTML5*, cioè il lettore del browser |
| codice embed | il riferimento dell'audio |

Si aggiunge una riga col più e la si toglie col cestino; tutto diventa definitivo al salvataggio
della scheda, come per ogni sotto-elenco. Una riga già salvata ha accanto la **matita**, che apre la
scheda di quell'audio nell'archivio e poi riporta qui.

> **nota** — la tendina del **ruolo** mostra solo i ruoli abilitati per quel tipo di oggetto: un
> ruolo pensato per i prodotti non compare nella scheda di una pagina. Se manca il ruolo giusto, va
> chiesto a chi amministra l'installazione.

## l'archivio degli audio
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.archivio.audio.view -->

Nell'archivio dei contenuti la linguetta **audio** elenca tutti gli audio registrati, di qualunque
oggetto, in ordine alfabetico. Serve a cercare un audio quando non si sa a che cosa è attaccato; il
lavoro di tutti i giorni si fa dalla linguetta *audio* della scheda dell'oggetto.

Un clic su una riga apre la scheda dell'audio:

| linguetta | cosa ci sta |
|---|---|
| gestione | **ordine**, **etichetta**, **lingua**, **ruolo**, **codice embed** e **note** |
| collegamenti | **a che cosa** l'audio è attaccato: anagrafica, pagina, notizia, categoria di notizie, prodotto, categoria di prodotti, articolo, marchio |
| azioni | le operazioni sull'audio; nello standard la pagina prepara i gruppi ma non ci mette riquadri |

Nella linguetta *collegamenti* l'anagrafica c'è sempre; i riquadri delle pagine, delle notizie e
del catalogo compaiono solo se i moduli corrispondenti sono attivi.

> **nota** — a differenza dei video, la scheda di un audio **non ha la linguetta delle immagini**:
> a un audio non si può associare un'immagine di anteprima.

> **nota** — la scheda dell'archivio **non ha il campo embed**: si imposta dalla linguetta *audio*
> della scheda dell'oggetto.

> **attenzione** — la linguetta *collegamenti* permette di spostare un audio da un oggetto a un
> altro, o di attaccarlo a più oggetti insieme. È comoda per correggere un errore, ma cambia ciò che
> il sito mostra **in tutti i posti coinvolti**.

## quello che questo capitolo non dice ancora

- che cosa va scritto nel **codice embed** di un audio HTML5, e dove sta il file che il sito
  riproduce: la scheda non ha un campo per caricarlo;
- dove e come l'audio compare **sul sito**, che dipende dall'aspetto grafico della pagina;
- l'elenco dei **ruoli** degli audio e dove si configurano.
