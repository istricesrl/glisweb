# file

Il modulo file permette di **allegare documenti** — un PDF, un foglio di calcolo, un catalogo, una
scheda tecnica — agli oggetti dell'applicazione: a un contatto, a una pagina del sito, a un prodotto,
a una mail. Ogni file caricato è una riga con la sua etichetta, la sua lingua e il suo **ruolo**, che
dice a cosa serve quel file per quell'oggetto ( la scheda tecnica, il manuale, l'allegato ).

Come le immagini, i file si gestiscono **dalla scheda dell'oggetto** a cui appartengono, nella
linguetta **file**; l'archivio dei file serve a vederli tutti insieme.

## la linguetta file
<!-- @pubblico: operatore, amministratore -->

Compare nelle schede di:

| area | schede |
|---|---|
| anagrafica | contatto |
| contenuti | pagina, notizia, categoria di notizie |
| catalogo | prodotto, categoria di prodotti, articolo, marchio |
| posta | template di una mail, mail in uscita, mail inviata |

È un sotto-elenco, **file collegati**, una riga per file:

| campo | contenuto |
|---|---|
| ordine | la posizione del file fra gli altri, dove l'ordine conta |
| etichetta | il nome con cui il file viene mostrato |
| lingua | per quale lingua vale il file; vuota se vale per tutte |
| ruolo | a cosa serve il file per questo oggetto |
| file | il pulsante con la **cartella** per scegliere il file dal proprio computer |

Si aggiunge una riga col più, si sceglie il file con la cartella — il caricamento parte subito, e
una rotellina gira finché non è finito — e si salva la scheda. Su un file già caricato compare il
pulsante per **aprirlo** in una nuova finestra, e accanto il suo nome.

> **nota** — la tendina del **ruolo** propone solo i ruoli che hanno senso per quel tipo di scheda:
> quelli di un prodotto non sono quelli di una mail.

Nelle mail in uscita i file collegati sono gli **allegati**: toglierne uno dalla linguetta lo toglie
anche dalla mail che deve ancora partire.

## l'archivio dei file
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.archivio.file.view -->

Nell'area *contenuti*, sotto **archivio**, la linguetta **file** elenca tutti i file caricati, in
ordine alfabetico, qualunque sia l'oggetto a cui appartengono.

La scheda di un file ha queste linguette:

| linguetta | cosa ci sta |
|---|---|
| gestione | ordine, etichetta, lingua, ruolo, il file stesso, note |
| collegamenti | **a cosa è attaccato** il file: un contatto, una pagina, un template, una mail in uscita o inviata, una notizia o una categoria di notizie, un prodotto, una categoria di prodotti, un articolo, un marchio |
| immagini | le immagini collegate al file, per esempio la sua copertina, se l'installazione gestisce le immagini |
| azioni | per ora **senza riquadri** |

La linguetta *collegamenti* è il modo per **spostare** un file da un oggetto a un altro senza
ricaricarlo, o per sapere a cosa appartiene un file trovato nell'elenco.

> **attenzione** — un file **non si salva senza il file**: la riga con etichetta e ruolo ma senza
> niente caricato viene rifiutata, e lo stesso vale se si svuota il file di una riga già salvata.

## quello che questo capitolo non dice ancora

- i **ruoli** disponibili di serie e dove li usa il sito;
- dove finiscono i file caricati e chi può scaricarli dal sito pubblico;
- come si comporta un file con la **lingua** impostata, sul sito in un'altra lingua.
