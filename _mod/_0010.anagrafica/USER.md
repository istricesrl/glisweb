# anagrafica

L'anagrafica è l'elenco delle **persone e delle organizzazioni** con cui si ha a che fare: clienti,
fornitori, collaboratori. È il modulo su cui si appoggiano quasi tutti gli altri, perché un documento,
un ordine o una spedizione hanno sempre qualcuno da una parte e qualcuno dall'altra.

Una persona **non si registra due volte** perché cambia il rapporto che ha con noi: la stessa
anagrafica può essere insieme cliente, fornitore e collaboratore, e ognuno di quei ruoli è una
scheda in più sullo stesso contatto.

Nel menu la voce è **anagrafica**; sotto, il modulo aggiunge le voci **account** ( con la sotto-voce
**gruppi** ), **categorie** e **ranking**, descritte in fondo. L'area è riservata al personale interno;
account, gruppi, categorie e ranking sono riservati agli amministratori. L'archivio degli **indirizzi**
non ha una voce di menu propria.

Per come funzionano gli elenchi e le schede in generale ( ricerca, ordinamento, salvataggio,
sotto-elenchi ) vedi i capitoli sugli **elenchi** e sulle **schede**: qui si dice solo quello che
è specifico dell'anagrafica.

## l'elenco delle anagrafiche
<!-- @pubblico: operatore, amministratore -->

È la maschera da cui si parte, e mostra una riga per contatto:

| colonna | contenuto |
|---|---|
| codice | il codice del contatto |
| denominazione | nome del contatto ( per le persone fisiche, nome e cognome ) |
| telefoni | i recapiti telefonici ( su schermi stretti la colonna sparisce ) |
| mail | gli indirizzi di posta ( idem ) |
| categorie | le categorie a cui il contatto appartiene |
| azioni | le icone delle azioni rapide |

In alto, accanto alla ricerca libera, stanno tre filtri: **stato**, **provincia** e **categoria**.
Nella stessa barra c'è il campo *inserisci una nuova anagrafica*, per creare un contatto nuovo senza
passare dal pulsante di inserimento. Un clic su una riga apre la scheda.

> **nota** — le anagrafiche **archiviate non compaiono qui**: stanno nella linguetta *archivio*,
> che è lo stesso elenco visto dall'altra parte ( colonne contatto, telefoni, mail, categorie ).

| linguetta | cosa ci sta |
|---|---|
| anagrafica | l'elenco qui sopra |
| archivio | le anagrafiche archiviate |
| statistiche | il grafico degli ordini per periodo, vedi sotto |
| stampe | le stampe sull'insieme delle anagrafiche |
| azioni | importazioni, esportazioni ed elaborazioni, vedi sotto |

## la scheda di un contatto
<!-- @pubblico: operatore, amministratore -->

La prima linguetta, *gestione*, tiene i dati che valgono per chiunque. Nel riquadro **dati generali**:

| campo | contenuto |
|---|---|
| sigla | il tipo di contatto |
| nome, cognome, sesso | per le persone fisiche |
| denominazione | per le organizzazioni |
| soprannome | il modo in cui il contatto viene chiamato correntemente |
| codice | il codice del contatto |
| note | annotazioni libere |

Sotto stanno i **sotto-elenchi**, uno per ogni cosa di cui può essercene più di una. Si aggiunge una
riga col pulsante accanto al titolo, si toglie quella appena aggiunta col cestino e una già
salvata col meno; tutto diventa definitivo al salvataggio della scheda.

| sotto-elenco | cosa si compila |
|---|---|
| e-mail | indirizzo, PEC, note; per una riga già salvata c'è anche un pulsante che apre la scheda dell'indirizzo |
| telefoni | numero, tipo ( fisso, cellulare… ), note |
| URL | URL, tipo, note |
| indirizzi | ruolo, indirizzo, interno, note |
| categorie | la categoria, una per riga |

> **nota** — nei **indirizzi** l'indirizzo si sceglie fra quelli già registrati nell'archivio. Se
> quello che serve non c'è, la scheda offre una finestra per **aggiungere un indirizzo nuovo** senza
> uscire; in alcune installazioni l'inserimento è invece semplificato e chiede solo ruolo, indirizzo
> e note.

> **attenzione** — la scheda si salva per intero: se si cambia linguetta senza salvare, le modifiche
> non ancora salvate della linguetta lasciata non vengono conservate.

## le altre linguette della scheda
<!-- @pubblico: operatore, amministratore -->

Ogni linguetta ha il suo salvataggio e tiene i dati di un solo argomento.

| linguetta | cosa ci sta |
|---|---|
| informazioni | **badge di accesso** ( il codice del badge ); **dati fiscali** ( codice fiscale, partita IVA ); **data e luogo di nascita** ( giorno, mese, anno, luogo, stato ); l'elenco delle **cittadinanze** ( cittadinanza, inizio, fine ) |
| relazioni | i legami con altri contatti, letti da sinistra a destra: *Rossi Mario* **è il/la** *genitore* **di** *Rossi Anna*. Per ogni riga si scelgono l'anagrafica, il ruolo e l'anagrafica collegata |
| amministrazione | note amministrative; codice fiscale, partita IVA, regime fiscale; registro imprese ( ufficio REA, numero REA, capitale sociale, soci, liquidazione ) e rappresentante fiscale in Italia; fatturazione elettronica ( codice destinatario SDI, PEC per fatturazione ); i sotto-elenchi delle **modalità** e delle **condizioni di pagamento** |
| cliente | ranking, agente, responsabile operativo; note commerciali, condizioni di vendita, note amministrative; codice fiscale, partita IVA, regime fiscale; codice destinatario SDI e PEC per la fatturazione; modalità e condizioni di pagamento |
| fornitore | ranking e condizioni di fornitura; codice fiscale e partita IVA |
| collaboratore | note di collaborazione; codice fiscale e partita IVA |
| immagini, video, audio, file | gli allegati multimediali del contatto |
| metadati | i dati aggiuntivi a chiave e valore |
| archiviazione | la data di archiviazione e le note che la spiegano |
| statistiche | il grafico degli ordini del singolo contatto, vedi sotto |
| stampe | le stampe del contatto |
| azioni | le operazioni disponibili sul contatto, vedi sotto |

Le schede **cliente**, **fornitore** e **collaboratore** si compilano **solo se quel rapporto c'è**.
I dati fiscali compaiono in più schede perché servono in contesti diversi, ma sono gli stessi dati
del contatto.

Se sono attivi i relativi moduli compaiono anche le linguette dei **contratti**, dei **documenti**
( con le loro righe ), delle **certificazioni**, dei **progetti**, delle **attività**, dei
**todo** e altre ancora: sono descritte nel capitolo di ciascun modulo. Dove il modulo non c'è,
la linguetta non c'è.

## archiviare invece di cancellare
<!-- @pubblico: operatore, amministratore -->

Un contatto che non serve più **si archivia**, compilando la data nella linguetta *archiviazione*.
Da quel momento esce dall'elenco ordinario e si trova nella linguetta *archivio*, ma tutto ciò a
cui era legato — documenti, ordini, storico — resta leggibile.

La cancellazione vera serve per le righe sbagliate appena inserite: un contatto con dei documenti
dietro non si può cancellare, e l'applicazione lo rifiuta.

## le statistiche
<!-- @pubblico: operatore, amministratore -->

La linguetta *statistiche*, sia nell'elenco sia nella scheda del singolo contatto, disegna un
grafico dell'andamento degli ordini. Il riquadro **impostazioni** chiede:

| campo | contenuto |
|---|---|
| sorgente dati | cosa misurare: importo degli ordini, utile degli ordini, quantità ordinate |
| categoria prodotti | limita il calcolo a una categoria di prodotti |
| data inizio periodo / data fine periodo | il periodo da considerare |
| precisione | il livello di dettaglio del grafico |
| confronta con | un secondo periodo da mettere a confronto |

Nell'elenco generale si può restringere anche per **stato** e per provincia. Sotto le impostazioni
compaiono il **grafico** e la tabella dei **dati**.

## le stampe e le azioni
<!-- @pubblico: operatore, amministratore -->

Nelle **stampe** sia dell'elenco sia della scheda c'è l'etichetta per le **cartelle sospese**: per
la scheda la costina del singolo contatto, per l'elenco quelle di tutti. Si apre in una nuova
finestra, in PDF.

Nelle **azioni** dell'elenco, divise per riquadri:

| riquadro | cosa c'è |
|---|---|
| esportazioni | *esportazione per MailChimp* ( le e-mail dei contatti in CSV ) ed *esportazione indirizzario* ( gli indirizzi in CSV ) |
| importazioni | *importazione anagrafiche* da un file CSV |
| elaborazioni | *unione anagrafiche*: unisce due anagrafiche e tutti gli oggetti collegati; e la versione che pulisce in blocco i doppioni |
| viste statiche | ripopolamento, pulizia e svuotamento della vista statica dell'anagrafica, usata per velocizzare gli elenchi |

> **attenzione** — l'**unione** di due anagrafiche sposta sull'anagrafica tenuta tutti i documenti,
> gli ordini e gli altri oggetti dell'altra, e **non si annulla**. Si usa solo quando si è sicuri
> che i due contatti siano la stessa persona.

Nelle **azioni** della scheda stanno le esportazioni e importazioni e, dove l'installazione le
prevede, le azioni per **Archivium** ( l'invio dell'anagrafica per la fatturazione elettronica,
riservato a chi ha il relativo privilegio ) e per l'**account**: *crea account* crea l'accesso
all'applicazione per quel contatto e invia la mail di attivazione.

## account e gruppi
<!-- @pubblico: amministratore -->

La voce **account** elenca chi può entrare nell'applicazione ( le azioni dell'elenco permettono l'*importazione di account* da un file CSV ): per ogni riga il nome dell'account,
l'anagrafica collegata, se è **attivo** e i **gruppi** a cui appartiene. La scheda ha:

| linguetta | cosa ci sta |
|---|---|
| gestione | l'anagrafica, l'e-mail per il recupero della password, lo username e la password; il sotto-elenco dei gruppi, con gruppo e ruolo |
| attribuzione | i gruppi e le entità collegate all'account ( gruppo, entità collegata ) |

La voce **gruppi** elenca i gruppi di utenti. La scheda ha il nome del gruppo, il **genitore** (i
gruppi si annidano) e il riferimento alla struttura organizzativa; la linguetta *membri* elenca chi
ne fa parte.

> **attenzione** — account e gruppi decidono **chi può fare cosa** nell'applicazione. Sono
> riservati agli amministratori e si modificano di rado e con un motivo.

## categorie, ranking e indirizzi
<!-- @pubblico: amministratore -->

Sono gli elenchi che alimentano le tendine delle schede.

- **categorie** — l'elenco ha le colonne categoria e membri. La scheda ha il **genitore** ( le
  categorie si annidano ), il nome e tre riquadri di ruoli: *ruoli dell'applicazione*, *ruoli
  commerciali* e *ruoli aziendali*. La linguetta *membri* elenca i contatti che vi appartengono;
  fra le azioni c'è l'esportazione dei membri per MailChimp.
- **ranking** — la scala con cui si valutano clienti e fornitori. L'elenco ha una sola colonna, il
  nome; la scheda e la linguetta *membri* funzionano come per le categorie.
- **indirizzi** — l'archivio di tutti gli indirizzi registrati ( stato, comune, indirizzo ), in
  sotto-voce dell'archivio dell'anagrafica. Fra le azioni c'è l'**unione indirizzi**, che fonde due
  indirizzi e tutti gli oggetti collegati.

Cambiare una categoria o un ranking cambia ciò che vedono **tutti**.

## quello che questo capitolo non dice ancora

- le schede delle linguette che compaiono solo con altri moduli, che stanno nei capitoli dei moduli;
- le tendine della **sigla** e dei **ruoli**, i cui valori dipendono da come è configurata l'installazione.
