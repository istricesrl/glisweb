# prodotti

Il modulo *prodotti* gestisce l'anagrafica dei prodotti e dei loro **articoli**. Il **prodotto** è l'oggetto del catalogo (per esempio una maglietta), l'**articolo** è la variante vendibile (la maglietta in una certa taglia e colore, con il suo codice e il suo codice EAN). Le voci stanno nel menu sotto **catalogo**: *prodotti*, *articoli*, *caratteristiche* e *reparti*. Sono accessibili allo staff e agli amministratori.

Per elenchi, schede e stampe in generale vedi i capitoli [012 elenchi](../../_usr/_docs/_user/012.elenchi.md), [014 schede](../../_usr/_docs/_user/014.schede.md) e [016 stampe](../../_usr/_docs/_user/016.stampe.md).

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: prodotti.view -->

## l'elenco dei prodotti

| colonna | contenuto |
|---|---|
| # | numero del prodotto |
| prodotto | codice del prodotto |
| nome | nome del prodotto |
| codice produttore | codice assegnato dal produttore |
| categorie | le categorie a cui il prodotto appartiene |
| pubblicazione | lo stato di pubblicazione |

I filtri sono **pubblicazione** e **categoria**, oltre alla ricerca per parola chiave. Il **+** apre una scheda nuova, un clic sulla riga apre la scheda. L'elenco ha altre due linguette:

- **stampe**: le tessere *manuale barcode* (PDF con gli articoli e i relativi codici a barre), *cartellini vetrina* (etichetta prezzo di tutti gli articoli in PDF) ed *etichette prezzo* (finestra con un intervallo **dal / al** da stampare);
- **azioni**: le esportazioni delle e-mail e dell'indirizzario dei contatti, l'importazione delle anagrafiche e l'**importazione prodotti/articoli** in formato CSV (la finestra "importa CSV prodotti" chiede il file e un pulsante importa).

> **attenzione** — l'importazione CSV scrive direttamente nell'archivio: controlla il file prima di caricarlo.

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: prodotti.form -->

## la scheda di un prodotto

### gestione

| riquadro | campi |
|---|---|
| dati generali | tipologia, codice, nome, produttore, codice produttore, marchio |
| descrizione e codifica | note, note di codifica |

### le altre linguette

| linguetta | cosa ci sta |
|---|---|
| categorie | le categorie del prodotto, ciascuna con un ordine |
| caratteristiche | coppie caratteristica–valore per lingua (con ordine e note), più le stagioni di listino |
| relazioni | i collegamenti con altri prodotti e altri articoli, ciascuno con il tipo di relazione |
| articoli | elenco in sola lettura degli articoli del prodotto (numero, nome, EAN); il **+** crea un articolo già legato al prodotto |
| prezzi | un prezzo per riga: data di inizio, listino, prefisso, prezzo, suffisso, quantità minima, percentuale su articoli, percentuale di provvigione, IVA |
| web, SEM/SMM, testo | contenuti e aspetto sul sito, dati per i motori di ricerca, testi: stessi campi della scheda delle categorie (vedi il capitolo *catalogo*) |
| immagini, video, audio, file, metadati | allegati e coppie nome–valore |
| stampe | le stampe del prodotto |
| statistiche | statistiche del prodotto |
| azioni | **duplica il prodotto**: chiede il nuovo codice e crea la copia |

Nella linguetta *web* compare anche il sotto-elenco delle **pubblicazioni** (periodi di visibilità).

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: articoli.view -->

## l'elenco degli articoli

Colonne: prodotto, # , articolo (codice), nome, EAN, pubblicazione, tipologia e una colonna di azioni. Filtri: **pubblicazione**, **tipologia** e ricerca per parola chiave.

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: articoli.form -->

## la scheda di un articolo

La linguetta *gestione* contiene i dati dell'articolo.

| riquadro | campi |
|---|---|
| dati generali | prodotto, codice, nome, produttore, codice EAN, specifiche, reparto di default, periodicità, tipologia di rinnovo |
| misure | quantità per pezzo (peso e capacità, ciascuna con la sua unità di misura), lunghezza, larghezza, altezza con unità di misura, taglia, colore |
| descrizione e codifica | note, note di codifica |

Le altre linguette:

| linguetta | cosa ci sta |
|---|---|
| caratteristiche, relazioni | come per il prodotto |
| distinta base | i componenti dell'articolo, ciascuno con la quantità |
| prezzi | come per il prodotto |
| spedizioni | le modalità di spedizione: zona, lotto, importo netto, IVA, giorni di spedizione e di consegna |
| web, SEM/SMM, testo | come per il prodotto |
| immagini, video, audio, file, metadati, stampe, statistiche | come per il prodotto |
| azioni | **duplica l'articolo**: chiede il codice del nuovo articolo e il prodotto di destinazione |

Dove è presente la gestione del magazzino compaiono anche le linguette **logistica** (ruolo e collocazione per ogni riga), **giacenze** e **movimenti**.

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: caratteristiche.prodotti.view -->

## le caratteristiche

L'elenco mostra numero e nome delle caratteristiche, con il filtro **genitore** per navigare l'albero. La scheda ha il solo campo **nome**; la struttura ad albero serve a raggruppare le caratteristiche (per esempio "materiale" sopra "cotone").

<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: reparti.view -->

## i reparti

Un reparto raggruppa gli articoli ai fini della vendita. La scheda "gestione reparto" ha i campi **nome**, **IVA** (aliquota predefinita), **settore** e **note**. Il reparto scelto nella scheda articolo viene proposto come reparto di default.

## quello che questo capitolo non dice ancora

- il formato del CSV di importazione di prodotti e articoli e le regole di validazione;
- il significato dei valori di tipologia di prodotto, periodicità e tipologia di rinnovo;
- la differenza fra le stampe *cartellini vetrina* ed *etichette prezzo* e il contenuto esatto dei PDF;
- le linguette di magazzino (logistica, giacenze, movimenti), che dipendono dai moduli del magazzino;
- le pagine dei coupon, che hanno un template ma non una voce di menu verificata.
