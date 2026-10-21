# pagine

Le **pagine** sono la struttura fissa del sito: la home, *chi siamo*, *contatti*, le pagine dei
servizi. Ogni pagina ha un posto nell'albero del sito ( può stare dentro un'altra ), una veste
grafica e un periodo in cui è visibile; i testi che il visitatore legge si scrivono nella linguetta
*contenuti*, lingua per lingua.

Il modulo sta nell'area **contenuti**, alla voce **pagine**, e porta con sé anche i **redirect** e
le **voci di menu**. Tutte le pagine sono aperte a chi appartiene allo **staff** o agli
**amministratori**.

## l'elenco delle pagine
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.pagine.view -->

Mostra una riga per pagina, in ordine alfabetico:

| colonna | contenuto |
|---|---|
| sito | il sito a cui la pagina appartiene, quando l'installazione ne ospita più d'uno |
| pagina | il nome della pagina |
| template, schema, tema | la veste grafica con cui la pagina viene composta |

Sopra l'elenco, oltre alla ricerca per parola chiave, c'è la tendina del **sito**, che mostra le
sole pagine di un sito. Un clic su una riga apre la scheda, il più ne apre una nuova.

Le altre linguette sono **redirect**, **archiviate** e **azioni**.

## la scheda di una pagina
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.pagine.form -->

La linguetta *gestione* ha tre riquadri e un sotto-elenco:

| riquadro | campi |
|---|---|
| dati generali | **sito**; **genitore**, cioè la pagina dentro cui questa sta nell'albero; **nome**; **note** |
| flag di elaborazione | **sitemap**, se la pagina va nella mappa del sito per i motori di ricerca; **cacheable**, se il sito può tenerla da parte già pronta invece di ricomporla a ogni visita |
| template, schema e tema | la veste grafica: il **template** del sito, lo **schema** della pagina dentro il template, il **tema** dei colori e dei caratteri |

| sotto-elenco | cosa si compila |
|---|---|
| pubblicazioni | ordine, tipologia, inizio, fine, note: i periodi in cui la pagina è visibile |

> **nota** — le tendine dello **schema** e del **tema** dipendono dal template scelto, e si
> riempiono **dopo aver salvato** la scheda col template impostato: su una pagina nuova si sceglie
> il template, si salva, e poi si scelgono schema e tema.

> **attenzione** — una pagina **esce sul sito solo se ha una pubblicazione in corso**, di una
> tipologia che la rende visibile. Senza pubblicazioni, o con tutte scadute, la pagina esiste nel
> gestionale ma il visitatore non la vede: è anche il modo per preparare una pagina in anticipo e
> farla comparire da una certa data.

Le altre linguette compaiono se ci sono i moduli che le gestiscono:

| linguetta | cosa ci sta |
|---|---|
| SEO/SEM | i dati per i motori di ricerca |
| contenuti | titolo, testo e gli altri testi, lingua per lingua |
| menu | le voci con cui la pagina compare nei menu del sito, qui sotto |
| javascript | il codice da eseguire su questa pagina, descritto nel capitolo *il javascript di una pagina* |
| macro | le elaborazioni aggiuntive che la pagina esegue quando viene composta |
| immagini, video, audio, file | i media e gli allegati della pagina |
| metadati | informazioni aggiuntive in forma di coppie nome–valore |
| archiviazione | la data di archiviazione e le note che la spiegano |
| azioni | le operazioni sulla pagina |

## la pagina nei menu del sito
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: contenuti.pagine.form.menu -->

La linguetta **menu** elenca le voci con cui la pagina compare nei menu del sito: la stessa pagina
può stare in più menu, e in lingue diverse. Per ogni voce si compila:

| campo | contenuto |
|---|---|
| ordine | la posizione della voce nel menu |
| menu | in quale menu del template va la voce ( principale, piede, laterale… ); le scelte le decide il template |
| lingua | la lingua in cui la voce compare |
| voce | il testo della voce |
| target | *apri in nuova scheda*, se la pagina deve aprirsi in una scheda nuova del browser |
| ancora | un punto preciso della pagina a cui portare, se serve |
| sottopagine | se sotto la voce si vedono le pagine figlie: *espandi sottovoci* ( solo quando la voce è attiva ), *mostra sempre sottovoci*, *non mostrare sottovoci* |

> **nota** — anche qui le scelte della tendina *menu* dipendono dal template della pagina, e
> compaiono solo se il template è stato impostato e salvato.

## i redirect
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.redirect.view -->

Un **redirect** manda chi apre un indirizzo verso un altro: serve quando una pagina cambia
indirizzo, per non perdere i visitatori che arrivano dal vecchio o dai motori di ricerca.

L'elenco, nella linguetta *redirect*, mostra **sito**, **codice**, **sorgente** e
**destinazione**, ordinati per sorgente, con la stessa tendina del sito dell'elenco delle pagine. La
scheda di un redirect ha:

| campo | contenuto |
|---|---|
| sito | il sito su cui il redirect vale |
| codice http | il tipo di reindirizzamento: di norma **301** se lo spostamento è definitivo, **302** se è temporaneo |
| sorgente | il vecchio indirizzo |
| destinazione | l'indirizzo verso cui mandare il visitatore |
| query string | se il redirect deve tenere conto anche della parte dell'indirizzo dopo il punto interrogativo |

> **attenzione** — un redirect sbagliato può rendere irraggiungibile una pagina buona, o mandare i
> visitatori in un giro senza fine fra due indirizzi che si rimandano a vicenda. Dopo averne
> aggiunto uno conviene sempre aprire il vecchio indirizzo e controllare dove si arriva.

## le voci di menu nell'archivio
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.archivio.menu.view -->

Nell'archivio dei contenuti la linguetta **menu** elenca **tutte** le voci di menu di tutte le
pagine, con la tendina del sito per restringere l'elenco: serve a vedere un menu intero, cosa che
dalla scheda di una singola pagina non si può.

## la scheda di una voce di menu
<!-- @pubblico: amministratore -->
<!-- @pagina: contenuti.menu.form -->

Un clic su una riga dell'elenco apre la scheda della voce, il più ne apre una nuova. La linguetta
*gestione* ha tre riquadri:

| riquadro | campi |
|---|---|
| dati generali | **menu** ( il nome del menu del sito in cui compare ), **ordine**, **lingua** e **voce**, cioè il testo |
| collegamento | dove porta la voce: una **pagina**, una **categoria di prodotti** o una **categoria di notizie** |
| comportamento | **target** ( se il link si apre in una nuova scheda ), **ancora** e **sottopagine** ( se sotto la voce compaiono anche le pagine figlie ) |

L'altra linguetta è **azioni**, dove lo standard prepara i gruppi ma non mette riquadri.

> **nota** — qui il **menu** si scrive a mano, e deve essere esattamente uno dei nomi di menu del
> template del sito. Dalla linguetta *menu* della pagina a cui la voce appartiene, invece, si
> sceglie da una tendina: di solito conviene lavorare da lì, e usare questa scheda per rivedere un
> menu intero.

## archiviare invece di cancellare
<!-- @pubblico: operatore, amministratore -->

Una pagina che non serve più **si archivia**, compilando la data nella linguetta *archiviazione*:
esce dall'elenco ordinario e si trova in *archiviate*. Per toglierla soltanto dal sito, invece,
basta chiuderne la pubblicazione; se la pagina aveva visite, conviene aggiungere un **redirect** dal
suo indirizzo verso quella che la sostituisce.

Le linguette *azioni* hanno la forma di tutte le pagine di riquadri ( vedi il capitolo *la pagina
strumenti* ); lo standard prepara i gruppi ma non ci mette riquadri.

## quello che questo capitolo non dice ancora

- le **tipologie di pubblicazione** e quali rendono una pagina visibile;
- la linguetta **macro** vista da vicino: quali elaborazioni si possono aggiungere a una pagina;
- come si cambia l'**indirizzo** di una pagina, e dove si scrive;
- in che ordine compaiono le **pagine figlie** quando il menu le mostra.
