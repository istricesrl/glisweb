# catalogo

Il **catalogo** è l'area del menu che raccoglie ciò che si vende: prodotti, marchi, categorie,
listini. Come le altre aree porta una dashboard con stampe e azioni e un archivio, che gli altri
moduli riempiono con le loro voci; in più tiene nel suo archivio l'elenco di **tutti i prezzi**,
che è la maschera da cui si vede in un colpo solo quanto costa cosa, in quale listino e da quando.

Com'è fatta una dashboard, un elenco e una scheda lo dicono i capitoli *la dashboard e la cornice
dell'applicazione*, *la pagina strumenti* e *Athena, la cornice e le maschere*: qui si dice soltanto
che cosa c'è in quest'area.

## la dashboard del catalogo
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo -->

Si apre dalla voce **catalogo** del menu, e ha tre linguette:

| linguetta | cosa contiene |
|---|---|
| catalogo | la dashboard: riquadri raccolti in gruppi, con ciò che vale la pena vedere entrando nell'area |
| stampe | i riquadri delle stampe in PDF dell'area |
| azioni | le operazioni dell'area, divise in esportazioni, importazioni ed elaborazioni |

> **nota** — lo standard prepara le tre pagine ma **non ci mette riquadri**: su un'installazione
> che non le ha personalizzate sono vuote, e in fondo c'è solo il pulsante per tornare indietro.

Tutte le pagine dell'area sono aperte solo a chi appartiene allo **staff** o agli
**amministratori**.

## le voci dell'area
<!-- @pubblico: operatore, amministratore -->

Aperta la voce *catalogo*, il menu mostra sotto di lei le sotto-voci dell'area. Quali siano dipende
dai moduli attivi:

| sotto-voce | da dove viene | cosa si trova |
|---|---|---|
| prodotti | il modulo dei prodotti | i prodotti, con le loro categorie, le stampe, gli archiviati e le azioni |
| marchi | il modulo dei prodotti | i marchi a cui i prodotti appartengono |
| listini | il modulo dei listini | i listini di vendita |
| archivio | questo modulo | l'archivio dell'area, qui sotto |

## l'archivio dei prezzi
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.archivio.prezzi.view -->

La voce **archivio** ha tre linguette: la dashboard dell'archivio ( vuota nello standard ), i
**prezzi** e le **azioni**. La linguetta *prezzi* è l'elenco di tutti i prezzi registrati, di
qualunque prodotto e di qualunque listino:

| colonna | contenuto |
|---|---|
| reparto | il reparto a cui il prezzo si applica |
| listino | il listino in cui il prezzo vale |
| valuta | la valuta del listino |
| prodotto, articolo | a che cosa si riferisce il prezzo: un prodotto intero o un suo articolo |
| prefisso, prezzo, suffisso | l'importo, con il testo da mostrare prima e dopo |
| % su articoli | lo sconto percentuale sugli articoli |
| iva | l'aliquota IVA |

L'elenco è ordinato per listino. Un clic su una riga apre la scheda del prezzo; il più ne apre una
nuova.

> **nota** — la colonna *azioni* in fondo all'elenco nello standard è vuota.

## la scheda di un prezzo
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.archivio.prezzi.form -->

La scheda ha due riquadri. Nei **dati generali**:

| campo | contenuto |
|---|---|
| prodotto, articolo | a che cosa si riferisce il prezzo |
| data inizio, data fine | il periodo in cui il prezzo vale |
| reparto | il reparto a cui il prezzo si applica |
| listino | il listino in cui il prezzo vale, e da cui prende la valuta |
| iva | l'aliquota da applicare |
| prefisso, prezzo, suffisso | l'importo, col testo da mostrare prima e dopo |

Nei **dati commerciali**:

| campo | contenuto |
|---|---|
| fascia | un'etichetta libera per raggruppare i prezzi |
| q.tà min, q.tà max | la quantità da cui a cui il prezzo vale, per i prezzi a scaglioni |
| sconto | lo sconto percentuale sugli articoli |
| provv. %, provv. fissa | la provvigione riconosciuta su quel prezzo, in percentuale o fissa |

La scheda ha anche la linguetta **azioni**, che nello standard è vuota.

> **attenzione** — lo stesso prodotto può avere più prezzi, uno per listino, per periodo o per
> scaglione di quantità: prima di aggiungerne uno conviene cercare nell'elenco se ce n'è già uno
> che si sovrappone.

## quello che questo capitolo non dice ancora

- quale prezzo vince quando più righe valgono insieme per lo stesso prodotto, listino e quantità;
- come i prezzi di quest'archivio si incontrano con quelli che si inseriscono dalla scheda di un
  prodotto o di un listino;
- i riquadri che una personalizzazione tipica mette nella dashboard e nelle stampe dell'area.
