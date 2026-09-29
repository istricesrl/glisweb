# prodotti

Il modulo tiene ciò che si vende, su due livelli. Il **prodotto** è la cosa come la si descrive a un
cliente — *la maglietta girocollo*, *il trapano a percussione* —, con il suo nome, il suo marchio,
le sue categorie. L'**articolo** è la cosa concreta che si mette in un ordine o in un documento e
che ha un codice proprio: *la maglietta girocollo, taglia M, blu*. Un prodotto ha almeno un
articolo, e spesso molti.

Attorno a prodotti e articoli il modulo tiene le **categorie** in cui si ordinano e i **marchi** a
cui appartengono. I **prezzi** non stanno qui: si registrano per listino, e il loro elenco completo
è nell'archivio del catalogo ( vedi il capitolo di quell'area e quello dei listini ).

Il modulo sta nell'area **catalogo**, alle voci **prodotti** ( con la sotto-voce **categorie** ) e
**marchi**. Tutte le pagine sono aperte a chi appartiene allo **staff** o agli
**amministratori**.

## l'elenco dei prodotti
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.prodotti.view -->

Mostra una riga per prodotto, in ordine alfabetico. Un clic su una riga apre la scheda, il più ne
apre una nuova.

Le altre linguette sono **articoli** ( l'elenco di tutti gli articoli, più sotto ), **archiviati**,
**stampe** e **azioni**.

## la scheda di un prodotto
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.prodotti.form -->

La linguetta *gestione* ha tre riquadri e un sotto-elenco:

| riquadro | campi |
|---|---|
| dati generali | **tipologia**, **codice**, **nome** |
| descrizione e codifica | **note**; **note di codifica**, cioè le regole con cui sono costruiti i codici degli articoli di questo prodotto |
| produttore e brand | **codice produttore**, il codice con cui il produttore identifica il prodotto; **produttore**, scelto fra le anagrafiche che hanno la scheda di produttore; **marchio** |

| sotto-elenco | cosa si compila |
|---|---|
| categorie | le categorie a cui il prodotto appartiene, una per riga |

Le linguette della scheda sono:

| linguetta | cosa ci sta |
|---|---|
| caratteristiche | le **caratteristiche tecniche** del prodotto, una per riga: la caratteristica ( scelta fra quelle previste per i prodotti ), la lingua, il valore, le note e l'ordine in cui mostrarle |
| articoli | gli **articoli di questo prodotto**; il più ne crea uno nuovo già legato al prodotto |
| web, SEO/SEM, contenuti, metadati | la pubblicazione del prodotto sul sito, i dati per i motori di ricerca, i testi lingua per lingua, le informazioni aggiuntive — se c'è il modulo dei contenuti |
| immagini, video, audio, file | i media e gli allegati, se ci sono i moduli che li gestiscono |
| relazioni | i **legami** del prodotto con altri prodotti o articoli ( accessori, alternative, ricambi ), uno per riga: il tipo di relazione e il prodotto o l'articolo collegato |
| stampe | i documenti che si possono stampare per questo prodotto |
| archiviazione | la data di archiviazione e le note che la spiegano |
| azioni | le operazioni sul prodotto |

> **nota** — il **produttore** si sceglie solo fra le anagrafiche che hanno la scheda di
> *produttore*: se chi si cerca non compare nella tendina, va aperta la sua anagrafica e compilata
> quella scheda ( vedi il capitolo dell'anagrafica ).

## gli articoli
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.articoli.view -->

La linguetta **articoli** dell'elenco dei prodotti mostra tutti gli articoli di tutti i prodotti, in
ordine alfabetico: il nome di un articolo è quello del suo prodotto seguito da ciò che lo distingue
( *maglietta girocollo M blu* ).

La scheda di un articolo ha:

| riquadro | campi |
|---|---|
| dati generali | **prodotto** a cui l'articolo appartiene, **codice**, **nome** — cioè ciò che distingue l'articolo dagli altri dello stesso prodotto |
| descrizione e codifica | **note** e **note di codifica** |
| produttore | **codice produttore** |

> **nota** — conviene dare all'articolo **solo la parte che lo distingue** ( *M blu* ), non di
> nuovo il nome del prodotto: il nome completo lo compone l'applicazione. Se i due coincidono,
> l'applicazione lo scrive una volta sola.

Le linguette della scheda di un articolo sono:

| linguetta | cosa ci sta |
|---|---|
| caratteristiche | le caratteristiche dell'articolo, una per riga, come per il prodotto; in più la spunta **assente**, per dire che su questo articolo una caratteristica **non c'è** |
| distinta | la **distinta base**: gli articoli che compongono questo, uno per riga, con la **quantità** che ne serve; il componente si cerca scrivendo almeno tre lettere del suo nome |
| metadati, immagini, video, audio, file | le informazioni aggiuntive e i media, se ci sono i moduli che li gestiscono |
| barcode | i **codici a barre** dell'articolo: l'**EAN**, il codice a barre commerciale, e l'**ISBN** dei libri |
| relazioni | i legami dell'articolo con altri articoli o prodotti, uno per riga, come per il prodotto |
| archiviazione | la data di archiviazione e le note che la spiegano |
| azioni | le operazioni sull'articolo |

## le categorie
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.categorie.prodotti.view -->

Si aprono dalla sotto-voce **categorie**. Le categorie si annidano l'una nell'altra — *utensili →
elettroutensili → trapani* — e un prodotto può stare in più di una. L'elenco ha le linguette
**stampe**, **archiviati** e **azioni**.

La scheda di una categoria tiene **genitore** ( la categoria che la contiene ), **codice**,
**nome** e **note**. La sua linguetta **prodotti** elenca i prodotti della categoria, e da lì si
lavora nei due sensi:

| comando | cosa fa |
|---|---|
| la catena, in alto | apre la riga in cui si sceglie un prodotto da **collegare** alla categoria |
| la catena spezzata, sulla riga | **scollega** quel prodotto dalla categoria, senza toccare il prodotto |

Le altre linguette sono le stesse di un prodotto per la parte web e media, più la linguetta
**menu**, da cui la pagina della categoria si aggiunge ai menu del sito.

## i marchi
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: catalogo.marchi.view -->

Si aprono dalla voce **marchi** dell'area catalogo. L'elenco ha le linguette **archiviati** e
**azioni**; la scheda di un marchio tiene **nome**, **produttore** ( anche qui fra le anagrafiche
con la scheda di produttore ) e **note**.

La linguetta **prodotti** della scheda elenca i prodotti del marchio; il più crea un prodotto nuovo
già legato al marchio. Le altre linguette sono web, SEO/SEM, contenuti e i media, se ci sono i
moduli che li gestiscono, poi **archiviazione** e **azioni**.

## archiviare invece di cancellare
<!-- @pubblico: operatore, amministratore -->

Un prodotto, un articolo, una categoria o un marchio che non servono più **si archiviano**,
compilando la data nella linguetta *archiviazione*: escono dall'elenco ordinario e si trovano in
*archiviati*, e i documenti e gli ordini che li citano restano leggibili.

Le linguette *stampe* e *azioni* hanno la forma di tutte le pagine di riquadri ( vedi il capitolo
*la pagina strumenti* ); lo standard prepara i gruppi ma non ci mette riquadri.

## quello che questo capitolo non dice ancora

- le **tipologie** di prodotto: dove si configurano e che effetto hanno;
- dove si definiscono le **caratteristiche** e i **tipi di relazione** che le tendine propongono;
- come si vede, dalla scheda di un prodotto, **quanto costa** in ciascun listino;
- come il prodotto arriva sul **sito**, e cosa lo rende visibile al visitatore.
