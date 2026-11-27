# catalogo

Il modulo *catalogo* organizza i prodotti in **categorie** ad albero: ogni categoria ha un genitore opzionale e può avere una propria presentazione sul sito (testi, immagini, menu, tag per i motori di ricerca). La voce **catalogo** sta nel menu dell'area riservata, con sotto la voce **categorie**; sono accessibili allo staff e agli amministratori. I prodotti veri e propri si gestiscono nel modulo *prodotti*.

Per elenchi e schede in generale vedi i capitoli [012 elenchi](../../_usr/_docs/_user/012.elenchi.md) e [014 schede](../../_usr/_docs/_user/014.schede.md).

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo -->

## la dashboard del catalogo

La pagina **catalogo** ha due linguette, *catalogo* e *stampe*. Al momento non espongono tessere: serve come punto di partenza per raggiungere le categorie e i prodotti dal menu.

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: categorie.prodotti.view -->

## l'elenco delle categorie

Mostra le categorie ordinate per codice crescente.

| colonna | contenuto |
|---|---|
| codice | il codice della categoria |
| categoria | l'etichetta della categoria |

Sopra l'elenco ci sono la ricerca per parola chiave e il filtro **genitore**, che permette di vedere tutte le categorie oppure solo quelle che hanno figli. Il **+** apre una scheda nuova, un clic sulla riga apre la scheda della categoria.

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: categorie.prodotti.form -->

## la scheda di una categoria

La scheda si chiama "gestione categoria" e ha le linguette descritte sotto.

### gestione

| campo | contenuto |
|---|---|
| sito | il sito a cui appartiene la categoria |
| genitore | la categoria di livello superiore; non può essere la categoria stessa |
| codice | codice della categoria, usato anche per l'ordinamento dell'elenco |
| nome | nome mostrato |
| note | annotazioni ad uso interno |
| template | il template grafico della categoria |
| schema | schema del template |
| tema | tema del template |

> **nota** — le tendine **schema** e **tema** si riempiono solo dopo aver scelto e **salvato** il template.

In fondo alla linguetta c'è il sotto-elenco delle **pubblicazioni**: i periodi in cui la categoria è visibile (ordine, tipologia, inizio, fine, note).

### linguette dei contenuti web

- **web**: sito, template, schema e tema, più le due opzioni "inserisci nella sitemap" e "pagina in cache";
- **SEM/SMM** (dati per i motori di ricerca e i social): si compila lingua per lingua scegliendo la lingua dalla tendina. I campi sono path custom (alias non canonico, deve iniziare con una barra), URL custom (per i link interni, deve iniziare con una barra), rewrite custom (testo che sostituisce il tag title ai fini della riscrittura dell'indirizzo), tag title, keywords e description, e i dati per la condivisione sui social (OG type, determiner, title, image, audio, video, description);
- **testo**: per ciascuna lingua, i titoli h1, h2 e h3, il cappello e tre testi (testo, abstract, specifiche) da scrivere nell'editor, scegliendo quale modificare con il selettore;
- **menu**: l'elenco delle voci di menu in cui la categoria compare (ordine, menu, lingua, voce, target "apri in nuova scheda", sottopagine). Le scelte della tendina menu dipendono dal template, quindi vanno impostate dopo aver salvato il template;
- **macro**: le macro del sito da associare alla categoria.

### prodotti

Elenco in sola lettura dei prodotti della categoria (numero e nome). Un clic apre la scheda del prodotto; il **+** crea un nuovo prodotto già assegnato a questa categoria.

### immagini, video, audio, file, metadati

Sono le linguette comuni dei media e degli allegati e delle coppie nome–valore: vedi il capitolo [014 schede](../../_usr/_docs/_user/014.schede.md). La linguetta **statistiche** è la pagina generica delle statistiche della scheda.

### azioni

| tessera | cosa fa |
|---|---|
| duplica categoria | apre la finestra "duplica la categoria corrente", con conferma o annulla |
| pubblica pagina | pubblica la pagina della categoria tramite una finestra dedicata |

## quello che questo capitolo non dice ancora

- il comportamento esatto della tessera *pubblica pagina* e di cosa viene copiato da *duplica categoria*;
- le caratteristiche associate alla categoria (esiste un sotto-elenco con ordine, caratteristica, testo, presente, visibile, ma la linguetta non è esposta nella scheda);
- le tessere della linguetta *stampe*, oggi vuota;
- la scelta dei valori di *OG type* e *OG determiner*.
