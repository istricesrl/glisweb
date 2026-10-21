# notizie

Le **notizie** sono i contenuti datati del sito: comunicati, articoli del blog, novità, eventi. A
differenza delle pagine, che formano la struttura fissa del sito, le notizie si aggiungono nel
tempo e si raggruppano in **categorie**, e sono le categorie a formare le pagine di elenco che il
visitatore sfoglia.

Il modulo sta nell'area **contenuti**, alla voce **notizie**; sotto di lei c'è la sotto-voce
**categorie**. Tutte le pagine sono aperte a chi appartiene allo **staff** o agli
**amministratori**.

## l'elenco delle notizie
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.notizie.view -->

Mostra una riga per notizia, in ordine alfabetico. Un clic su una riga apre la scheda, il più ne
apre una nuova.

Le altre linguette sono **tipologie** ( i tipi di notizia, più sotto ), **archiviate** e
**azioni**.

## la scheda di una notizia
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.notizie.form -->

La linguetta *gestione* tiene i **dati generali** e due sotto-elenchi:

| campo | contenuto |
|---|---|
| tipologia | il tipo di notizia, dall'elenco delle tipologie |
| nome | il nome della notizia, come compare negli elenchi del gestionale |
| note | annotazioni interne |

| sotto-elenco | cosa si compila |
|---|---|
| categorie | le categorie in cui la notizia compare, una per riga |
| persone | le anagrafiche legate alla notizia: ordine, ruolo ( autore, citato… ) e anagrafica |

Il **titolo** e il **testo** che il visitatore legge non stanno qui ma nella linguetta *contenuti*,
una versione per lingua. Le linguette della scheda sono, se ci sono i moduli che le gestiscono:

| linguetta | cosa ci sta |
|---|---|
| web | il sito, se la notizia va nella mappa del sito, l'aspetto grafico e le **pubblicazioni**, cioè da quando a quando è visibile |
| SEO/SEM | i dati per i motori di ricerca |
| contenuti | titolo, testo e gli altri testi, lingua per lingua |
| metadati | informazioni aggiuntive in forma di coppie nome–valore |
| immagini, video, audio, file | i media e gli allegati della notizia |
| archiviazione | la data di archiviazione e le note che la spiegano |
| azioni | le operazioni sulla notizia |

> **attenzione** — una notizia **esce sul sito solo a due condizioni**: ha una **pubblicazione in
> corso**, con la sua tipologia, nel sotto-elenco della linguetta *web*, e sta in almeno una
> **categoria** di quel sito. Senza una delle due la notizia esiste nel gestionale ma il visitatore
> non la vede: è la categoria, non la notizia, a decidere su quale sito compare.

## le categorie
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.categorie.notizie.view -->

Si aprono dalla sotto-voce **categorie**. Ogni categoria diventa sul sito una **pagina di elenco**
delle sue notizie, e le categorie si annidano l'una nell'altra: *eventi* può stare dentro
*novità*.

L'elenco ha le linguette **archiviate** e **azioni**. La scheda di una categoria tiene **genitore**
( la categoria che la contiene ), **nome** e **note**, e ha le stesse linguette di una notizia, più
la linguetta **menu**, da cui la pagina della categoria si aggiunge ai menu del sito.

> **nota** — anche la categoria esce sul sito **solo se ha una pubblicazione in corso**, nella sua
> linguetta *web*. Una categoria non pubblicata nasconde la sua pagina di elenco, anche se le
> notizie che contiene sono pubblicate.

## le tipologie
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.tipologie.notizie.view -->

La linguetta **tipologie** elenca i tipi di notizia che si possono scegliere nelle schede. La
scheda di una tipologia ha **genitore** e **nome**, e nessun'altra linguetta.

## archiviare invece di cancellare
<!-- @pubblico: operatore, amministratore -->

Una notizia o una categoria che non serve più **si archivia**, compilando la data nella linguetta
*archiviazione*: esce dall'elenco ordinario e si trova in *archiviate*. Per toglierla soltanto dal
sito, invece, basta chiuderne la pubblicazione.

Le linguette *azioni* dell'elenco e delle schede hanno la forma di tutte le pagine di riquadri
( vedi il capitolo *la pagina strumenti* ); lo standard prepara i gruppi ma non ci mette riquadri.

## quello che questo capitolo non dice ancora

- le **pubblicazioni** viste da vicino: le loro tipologie, e cosa succede quando se ne sovrappongono
  due;
- l'**aspetto** delle pagine della notizia e della categoria sul sito, e come si sceglie un modello
  diverso da quello predefinito;
- i **ruoli** che si possono dare a una persona legata a una notizia, e dove si configurano;
- in che ordine le notizie compaiono nella pagina di una categoria.
