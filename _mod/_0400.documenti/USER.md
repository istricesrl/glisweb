# documenti

Il modulo raccoglie **tutti i documenti commerciali e amministrativi**: offerte, ordini, DDT, fatture, proforma,
note di credito e di debito, ricevute, missioni di magazzino e i pagamenti con cui si chiudono. Ogni documento ha
una **testata** ( data, numero, emittente, destinatario ) e delle **righe** ( cosa si vende, in che quantità ), e
passa da una fase all'altra: dall'offerta all'ordine, dall'ordine al DDT, dal DDT o dalla proforma alla fattura.

Nel menu i documenti si trovano in punti diversi, secondo **chi li usa**: le **offerte** nel ramo commerciale, gli
**ordini**, i **DDT** e le **missioni** in quello del magazzino, **fatture**, **proforma**, **note di credito** e di
debito, **ricevute** e lo **scadenziario** in quello dell'amministrazione. Le voci *ciclo attivo* e *ciclo passivo*
dei rami *commerciale*, *logistica* e *amministrazione* sono solo pagine di ingresso che portano agli elenchi.
L'area è riservata al personale interno.

Per come funzionano gli elenchi e le schede in generale ( ricerca, filtri, righe, salvataggio ) vedi i capitoli
sugli **elenchi** e sulle **schede**: qui si dice solo quello che è specifico dei documenti.

## attivi e passivi
<!-- @pubblico: operatore, amministratore -->

Quasi ogni tipo di documento esiste in due versioni, e le voci di menu si chiamano di conseguenza:

| ciclo | cosa vuol dire | esempi |
|---|---|---|
| **attivo** | il documento lo emettiamo noi, verso un cliente | offerte, ordini attivi, DDT attivi, fatture attive |
| **passivo** | il documento ci arriva da un fornitore | ordini passivi, DDT passivi, fatture passive |

Sono le stesse maschere con pochi campi in meno: nei passivi mancano, per esempio, le linguette dei riferimenti e
dei dati fiscali. Quando sotto si parla di una linguetta si intende quella dei documenti attivi, se non è detto altro.

## la struttura comune di una scheda
<!-- @pubblico: operatore, amministratore -->

La prima linguetta, *gestione*, ha nel riquadro **dati generali** la **data**, il **sezionale** e il **numero** ( che
insieme identificano il documento ), un **nome** e le **note**; nei tipi che lo prevedono anche il **codice**.
Seguono i riquadri **dati emittente** e **dati destinatario**, ciascuno con l'anagrafica e la **sede** da usare sul
documento: la sede si sceglie fra quelle dell'anagrafica scelta, quindi prima si compila l'anagrafica.

> **nota** — se non si indica l'emittente, la scheda propone **l'azienda gestita**: negli elenchi dei documenti
> attivi compaiono infatti solo i documenti emessi dalle aziende gestite dall'installazione.

Le altre linguette, presenti in quasi tutti i tipi:

| linguetta | cosa ci sta |
|---|---|
| righe | l'elenco delle righe del documento; un clic su una riga apre la **scheda riga**, descritta sotto |
| pagamenti | le scadenze e i pagamenti collegati al documento |
| chiusura | la data di chiusura e le note di chiusura: da compilare quando il documento non va più toccato |
| stampe | le stampe del documento, in PDF o in XML |
| azioni / strumenti | le operazioni sul documento, diverse da tipo a tipo |

> **attenzione** — **chiudere** un documento serve a bloccarlo: da quel momento esce dal lavoro in corso. Si chiude
> dalla linguetta *chiusura* oppure con *chiudi documento* nelle azioni, che usa la data e l'ora del momento.

### la scheda riga

Ogni riga ha le sue linguette. I riquadri sono:

| riquadro | campi |
|---|---|
| dati generali | data, tipologia, descrizione; nelle offerte anche l'ordine |
| contenuto della riga | quantità, unità di misura, articolo, matricola, specifiche |
| valore della riga | ( fatture, proforma, note, ricevute ) importo, reparto, listino |
| riferimenti | emittente, destinatario, documento, riga genitore |
| attribuzione | progetto e todo a cui la riga si riferisce |
| magazzino | mastro di **scarico** e di **carico** |

Nelle fatture e negli altri documenti amministrativi c'è anche la linguetta *righe aggregate*: le righe che sono
state raggruppate dall'azione *aggrega righe*.

## le offerte
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: offerte.commerciale.view -->

La voce **offerte**, nel ramo commerciale, elenca i preventivi emessi. Le colonne sono **codice**, **numero**,
**sezionale**, **data**, **destinatario** e **nome**; si può filtrare per **emittente** e cercare con il campo
*cerca*. Un clic su una riga apre l'offerta.

La scheda ha quattro linguette:

| linguetta | cosa ci sta |
|---|---|
| gestione | i dati generali, l'emittente e il destinatario, come nella struttura comune |
| righe | le voci dell'offerta, con le colonne articolo, scarico, carico e quantità |
| stampe | *stampa PDF*: la copia dell'offerta da mandare al cliente |
| strumenti | le operazioni sulla vista statica dell'elenco, vedi sotto |

> **nota** — la linguetta *righe* ha un riquadro di **inserimento rapido**: si sceglie l'articolo dalla giacenza
> disponibile, si scrive la quantità e si salva. Per i dettagli di una riga ( descrizione, specifiche, progetto ) si
> apre la riga dall'elenco.

L'**elenco** delle offerte non si legge direttamente dai documenti ma da una **vista statica**, una copia pensata per
essere veloce. Se un'offerta appena creata non compare, o ne compare una cancellata, si apre *strumenti* e si usa:

| azione | cosa fa |
|---|---|
| ripopola la vista statica delle offerte | riscrive le righe rimaste indietro rispetto ai documenti |
| pulizia della vista statica delle offerte | toglie le righe dei documenti cancellati o che non sono più offerte |
| svuotamento della vista statica delle offerte | la svuota del tutto; solo per le emergenze, poi va ripopolata |

> **attenzione** — lo svuotamento lascia l'elenco vuoto finché non si ripopola. Si usa solo se le altre due non
> bastano.

## gli ordini
<!-- @pubblico: operatore, amministratore -->

Il ramo del magazzino ha due voci, **ordini attivi** e **ordini passivi**. Le colonne dell'elenco sono numero,
sezionale, data, destinatario, nome e, per gli attivi, la **data di chiusura**. Il pulsante *righe* mostra l'elenco
di tutte le righe di tutti gli ordini.

La scheda di un ordine attivo ha: *gestione*, *righe*, *chiusura*, *invio*, *stampe* e *strumenti*. La linguetta
**invio** registra quando l'ordine è stato mandato al fornitore o al cliente ( **data invio**, **note invio** ).
L'ordine passivo non ha la linguetta *invio*. La stampa è la copia di cortesia in PDF.

## i DDT
<!-- @pubblico: operatore, amministratore -->

Il DDT accompagna la merce. Le voci sono **DDT attivi** e **DDT passivi**; l'elenco mostra codice, numero,
sezionale, data, destinatario e nome. Rispetto agli altri documenti, il DDT attivo ha in più:

| linguetta | cosa ci sta |
|---|---|
| gestione | oltre ai dati di emittente e destinatario, il riquadro **dati spedizione** con il destinatario e la sede della spedizione, se diversi dal destinatario del documento |
| relazioni | i documenti collegati |
| ordine | lo stato dell'ordine che il DDT evade: per ogni prodotto, quanto era **richiesto**, quanto è già **inserito** e quanto **manca**; sopra, il riquadro di **inserimento rapido riga** ( collo, scarico, quantità ) |
| packing | la packing list: cosa va in quale collo |
| stampe | il DDT in PDF, la packing list in PDF e la packing list divisa per bancali |

Il DDT passivo ha solo gestione, righe, stampe e strumenti.

## le missioni
<!-- @pubblico: operatore, amministratore -->

La **missione** è il documento di lavoro con cui il magazzino prepara la merce di uno o più ordini. L'elenco
mostra codice, data, nome, i documenti che la missione **evade**, quelli di **controllo** e la data di **chiusura**;
le missioni chiuse sono in una linguetta a parte.

| linguetta | cosa ci sta |
|---|---|
| gestione | data, tipologia, sezionale, numero, codice, nome, carico, note, referente ed emittente |
| contenuto | il riepilogo di cosa contiene la missione ( solo amministratori ) |
| evasione | si legge il **codice o la matricola** del prodotto e si indica la **quantità**, per assegnarlo alla missione |
| righe | le righe della missione |
| chiusura | la chiusura, come negli altri documenti |
| stampe | il **barcode semplice** e la **copertina della missione**, in PDF |
| azioni | *importa intero ordine* assegna alla missione tutte le righe libere di un ordine; *creazione DDT* crea i DDT degli ordini associati |

## fatture, proforma, note e ricevute
<!-- @pubblico: operatore, amministratore -->

Sono i documenti dell'amministrazione, e condividono la stessa scheda: *gestione*, *riferimenti*, *righe*,
*pagamenti*, *chiusura*, *stampe* e *azioni*. Le voci di menu sono **fatture**, **proforma**, **note di credito** e
**note di debito**, **ricevute**. Gli elenchi mostrano numero, sezionale, data, cliente e nome; accanto all'elenco
c'è sempre l'elenco delle loro **righe**, con data, documento, cliente, nome, quantità e importo.

Nel riquadro *dati generali* di fatture, note e ricevute compaiono in più:

| campo | contenuto |
|---|---|
| tipologia | il tipo di documento ( per esempio fattura o documento di reso ) |
| condizioni pagamento | le condizioni da applicare, da cui nascono le scadenze |
| esigibilità | l'esigibilità dell'IVA |
| riferimenti per la pubblica amministrazione | **CIG**, **CUP** e **documento di riferimento** |
| variazioni | un **coupon**, che a seconda del documento vale come sconto o come reso |
| fatturazione elettronica | **codice archivium**, **codice SDI**, **progressivo invio** |

La linguetta **dati fiscali** ( fatture e note ) ha l'**imposta di bollo** e il suo importo. La linguetta **file**
( fatture e ricevute ) tiene i file collegati al documento.

Le **azioni** sono nel riquadro *operazioni amministrative*:

| azione | cosa fa |
|---|---|
| chiudi documento | chiude il documento con la data e l'ora del momento |
| aggrega righe | aggiunge al documento tutte le righe che non appartengono a nessun documento |
| invia fattura elettronica | manda la fattura, o la nota di credito, tramite Archivium |
| crea fattura / apri la fattura | **solo dalla proforma**: genera la fattura corrispondente, oppure apre quella già creata |

Le **stampe** sono la copia di cortesia in **PDF** e il file **XML** della fattura elettronica. Per le fatture
sono previsti anche i moduli di ritiro e di consegna hardware, che il cliente deve firmare.

> **attenzione** — **l'invio allo SDI si ferma se la fattura non passa i controlli**: errori nei dati fiscali o
> nelle aliquote la rendono non inviabile, mentre gli avvisi ( per esempio sul bollo ) non bloccano nulla. Alcune
> aliquote IVA sono state **archiviate**: non compaiono più nelle tendine, e una fattura che le usa si vede e si
> scarica ma non si invia. Prima di inviare, si controlla l'XML dalla stampa.

Il documento si può anche **mandare per mail** dalla linguetta *invio* ( dove c'è ): si indicano **mittente**,
**destinatario**, **oggetto** e **testo**, e il PDF viene allegato. Se la stampa non riesce, la mail non parte.

## i pagamenti e lo scadenziario
<!-- @pubblico: operatore, amministratore -->

La voce **scadenziario** elenca tutti i pagamenti: scadenza, documento, nome, chi paga e chi riceve, importo e
**data del pagamento**. La scheda di un pagamento ha:

| riquadro | campi |
|---|---|
| dati generali | ordine, documento, nome, modalità di pagamento, IBAN, importo, listino, IVA, scadenza, note |
| debito senza documento | creditore e debitore, per un debito che non nasce da un documento |
| conti | i mastri di scarico e di carico |
| pagamento | **data pagamento** e note: compilare la data è ciò che segna la scadenza come saldata |

Dentro ogni documento, la linguetta *pagamenti* mostra solo le scadenze di quel documento.

## la voce documenti e le schede dell'anagrafica
<!-- @pubblico: amministratore -->

La voce **documenti**, riservata agli amministratori, raccoglie **tutti** i documenti di ogni tipo in un unico
elenco ( tipologia, numero, sezionale, data, emittente, destinatario, nome ). Ha quattro linguette: i documenti,
le loro righe, i pagamenti e le azioni. Le azioni sono tre **importazioni da CSV**: delle testate, delle testate con
le righe, e dei codici clienti. La scheda è quella comune, con in più la linguetta *relazioni* e il pulsante
*elimina documento*, che toglie il documento **e tutte le sue righe**.

> **attenzione** — *elimina documento* è definitivo e porta via anche le righe. Per un documento emesso si
> preferisce chiuderlo, o emettere una nota di credito.

Nella scheda di ogni anagrafica, il modulo aggiunge due linguette ( vedi il capitolo dell'anagrafica ):

| linguetta | cosa ci sta |
|---|---|
| documenti anagrafica | i documenti in cui la persona compare: tipologia, numero, sezionale, data, emittente, destinatario, nome, totale e coupon |
| righe documenti anagrafica | le righe di quei documenti: data, documento, tipologia, articolo, quantità e importo |

## la logistica
<!-- @pubblico: operatore, amministratore -->

Il ramo *logistica* ha le pagine d'ingresso del ciclo attivo e passivo. Nel ciclo passivo c'è l'azione
**generazione DDT di carico**, che crea al volo un DDT per caricare a magazzino il rifornimento.

## quello che questo capitolo non dice ancora

- le **note di debito** e le **ricevute** hanno le stesse linguette delle fatture, ma i loro campi non sono stati
  verificati uno per uno;
- il comportamento delle linguette *relazioni* e *packing* ( collegamento fra documenti, colli e bancali );
- le linguette dei documenti che compaiono solo con altri moduli ( per esempio le attività );
- le tendine di sezionale e tipologia, i cui valori dipendono dalla configurazione.
