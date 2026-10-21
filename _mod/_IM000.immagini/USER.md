# immagini

Il modulo immagini permette di **collegare fotografie e grafiche** agli oggetti dell'applicazione:
la foto di un prodotto, la copertina di una notizia, il logo di un marchio, il ritratto di un
contatto. Si carica l'immagine una volta, alla dimensione originale, e l'applicazione ne prepara da
sola le **versioni ridotte** che servono al sito, così che chi visita una pagina da telefono non
scarichi la fotografia a piena risoluzione.

Come i file, le immagini si gestiscono **dalla scheda dell'oggetto** a cui appartengono, nella
linguetta **immagini**; l'archivio serve a vederle tutte insieme.

## la linguetta immagini
<!-- @pubblico: operatore, amministratore -->

Compare nelle schede di:

| area | schede |
|---|---|
| anagrafica | contatto |
| contenuti | pagina, notizia, categoria di notizie; e, nell'archivio, file e video |
| catalogo | prodotto, categoria di prodotti, articolo, marchio |

È un sotto-elenco, **immagini collegate**, una riga per immagine:

| campo | contenuto |
|---|---|
| ordine | la posizione dell'immagine fra le altre |
| etichetta | il nome dell'immagine, che il sito può usare come testo alternativo |
| lingua | per quale lingua vale l'immagine; vuota se vale per tutte |
| ruolo | a cosa serve l'immagine per questo oggetto ( copertina, galleria, logo… ) |
| orientamento | **automatico**, oppure orizzontale, verticale o quadrato, per forzarlo |
| taglio | dove tenere il **peso** dell'immagine quando va ritagliata: all'inizio, al centro o alla fine |
| immagine | il pulsante con la **cartella** per scegliere il file dal proprio computer |

Si aggiunge una riga col più, si sceglie l'immagine con la cartella — il caricamento parte subito —
e si salva la scheda.

> **esempio** — una foto verticale di una persona, usata in uno spazio orizzontale, va ritagliata:
> con il taglio *peso iniziale* si tiene la parte alta, dove c'è il viso, invece del centro.

> **nota** — la tendina del **ruolo** propone solo i ruoli pensati per quel tipo di scheda, e
> l'orientamento lasciato su *automatico* va bene quasi sempre: l'applicazione lo ricava dalle
> proporzioni dell'immagine.

## l'archivio delle immagini
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.archivio.immagini.view -->

Nell'area *contenuti*, sotto **archivio**, la linguetta **immagini** elenca tutte le immagini
caricate, in ordine alfabetico, qualunque sia l'oggetto a cui appartengono.

La scheda di un'immagine ha queste linguette:

| linguetta | cosa ci sta |
|---|---|
| gestione | ordine, etichetta, lingua, ruolo, orientamento, taglio, l'immagine stessa e, in un riquadro a parte, un'**immagine alternativa** |
| collegamenti | **a cosa è attaccata** l'immagine: un contatto, un file, un video, una pagina, una notizia o una categoria di notizie, un prodotto, una categoria di prodotti, un articolo, un marchio |
| azioni | le operazioni sull'immagine |

La linguetta *collegamenti* serve a **spostare** un'immagine da un oggetto a un altro senza
ricaricarla, o a scoprire a cosa appartiene un'immagine trovata nell'elenco.

Nella linguetta *azioni*, fra le **elaborazioni**, il riquadro **scalatura immagine** rifà subito le
versioni ridotte di quell'immagine. Di solito non serve: le versioni ridotte le prepara un lavoro
periodico dell'installazione, in un secondo momento, e un'immagine appena caricata può comparire
sul sito con qualche minuto di ritardo; il riquadro serve quando la si vuole vedere subito.

## quello che questo capitolo non dice ancora

- i **ruoli** di serie e dove li usa il sito;
- a cosa serve l'**immagine alternativa**, e quando il sito la mostra al posto della principale;
- quali **dimensioni** vengono preparate, e in quali formati.
