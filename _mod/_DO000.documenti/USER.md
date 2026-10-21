# documenti

Un **documento** è qualunque carta che passa fra noi e qualcun altro: una fattura, una nota di
credito, un DDT, un ordine, un preventivo. Tutti hanno la stessa forma — chi lo emette, a chi è
destinato, una data, un numero, delle **righe** e, quando ci sono soldi di mezzo, dei **pagamenti** —
e questo modulo è il posto in cui quella forma comune si vede **tutta insieme**, qualunque sia il
tipo del documento.

I moduli dedicati a un tipo di documento — le fatture, per esempio — mostrano la stessa cosa filtrata
e con le sole voci che servono a quel tipo. Questo è l'**archivio generale**: il posto da cui cercare
un documento quando non si sa di che tipo sia, o per vedere in un colpo solo tutto quello che è stato
emesso e ricevuto.

Si arriva dall'area *amministrazione*, voce **archivio**: il modulo vi aggiunge le linguette
**documenti**, **righe** e **pagamenti**.

## l'elenco dei documenti
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.archivio.documenti.view -->

Tutti i documenti, i più recenti in cima:

| colonna | contenuto |
|---|---|
| codice | il codice del documento |
| tipologia | fattura, nota di credito, DDT… |
| data | la data del documento |
| numero | numero e sezionale |
| documento | il nome del documento |
| emittente | chi lo ha emesso |
| destinatario | a chi è rivolto |

> **nota** — questo elenco mostra **anche i documenti archiviati**: è l'archivio completo, e non ha
> una linguetta *archiviati* separata.

## la scheda di un documento
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.archivio.documenti.form -->

La linguetta *gestione* raccoglie la testata del documento:

| riquadro | campi |
|---|---|
| dati generali | tipologia, data, numero, sezionale, codice, nome, note |
| riferimenti di fatturazione | condizioni di pagamento, **esigibilità** dell'IVA ( immediata, differita, scissione dei pagamenti ) |
| riferimenti per la pubblica amministrazione | CIG, CUP, documento di riferimento |
| dati emittente | emittente e sua sede |
| dati destinatario | destinatario e sua sede |
| dati spedizione | presso chi spedire e a quale sede, note di spedizione interne, note di consegna per il corriere |

Emittente, destinatario e destinatario della spedizione sono contatti dell'anagrafica, e si cercano
scrivendone il nome.

> **attenzione** — le tendine delle **sedi** elencano gli indirizzi del contatto scelto, e si
> riempiono **dopo aver salvato** la scheda: su un documento nuovo si scelgono prima emittente e
> destinatario, si salva, e poi si scelgono le sedi.

### le altre linguette

| linguetta | cosa ci sta |
|---|---|
| righe | il sotto-elenco delle righe del documento, con codice e descrizione; il più aggiunge una riga, un clic su una riga la apre |
| pagamenti | il sotto-elenco dei pagamenti legati al documento, con le stesse regole |
| dati fiscali | il bollo virtuale, le ritenute e i contributi alle casse previdenziali, che vanno nella fattura elettronica |
| evasione | per ora **vuota**: la pagina c'è ma non ha ancora campi |
| relazioni | i legami con altri documenti, una riga per legame: documento principale, tipo di relazione, documento collegato |
| archiviazione | la data di archiviazione e le note che la spiegano |
| stampe | i documenti PDF che si possono produrre, se l'installazione ne ha configurati |
| azioni | le operazioni sul documento |

Se l'installazione gestisce le pianificazioni, compare anche la linguetta **pianificazioni**, per i
documenti che si ripetono nel tempo.

> **esempio** — una nota di credito che storna una fattura si lega a lei nella linguetta
> *relazioni*: da una delle due si risale all'altra senza doverla cercare.

Due tipi di relazione finiscono anche nella **fattura elettronica**: *fattura collegata*, per la
fattura a cui si riferisce una nota di credito ( o una fattura di saldo dopo un acconto ), e *DDT
collegato*, per i documenti di trasporto di una fattura differita. La relazione si mette sul documento
che si sta emettendo: la nota di credito è il documento principale, la fattura quello collegato. Una
nota di credito senza la fattura collegata, o una fattura differita *TD24* senza DDT, si può vedere e
scaricare, ma **non si può inviare** allo SDI.

### i dati fiscali
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.archivio.documenti.form.dati.fiscali -->

La linguetta **dati fiscali** raccoglie quello che la fattura elettronica chiede in certi casi:

| riquadro | campi |
|---|---|
| imposta di bollo | se il bollo è assolto in modo virtuale, e il suo importo ( di solito 2 euro ) |
| ritenute | una riga per tipo di ritenuta: il tipo ( ritenuta d'acconto, contributo INPS, ENASARCO… ), l'aliquota, la causale della Certificazione Unica e, solo se non va calcolato, l'importo |
| contributi alle casse previdenziali | una riga per cassa: la cassa, l'aliquota, l'imponibile e l'importo solo se non vanno calcolati, l'IVA sul contributo e se il contributo è soggetto a ritenuta |

Gli importi lasciati vuoti li calcola la stampa della fattura elettronica: il contributo di cassa sul
totale delle righe ( tranne le spese escluse dall'IVA per l'art. 15, come le anticipazioni per conto
del cliente ), la ritenuta sulle righe **soggette a ritenuta** ( una casella della scheda della riga )
e sui contributi soggetti; se nessuna riga è segnata, sono soggette tutte tranne quelle escluse.

> **attenzione** — il bollo non si mette da solo: quando le righe senza IVA superano 77,47 euro la
> fattura elettronica lo **segnala** fra le cose da verificare, perché alcune operazioni senza IVA
> ( le esportazioni, le cessioni verso altri paesi UE ) ne sono esenti.

## le righe
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.archivio.documenti.articoli.form -->

La linguetta **righe** dell'archivio elenca le righe di tutti i documenti non archiviate, con
codice, tipologia, documento di appartenenza e descrizione. Serve a cercare **dove** compare un
articolo o una voce, senza aprire i documenti uno per uno.

La scheda di una riga è la stessa che si apre dalla linguetta *righe* di un documento:

| riquadro | campi |
|---|---|
| dati generali | tipologia, documento, codice, data, descrizione, note |
| contenuto della riga | quantità, unità di misura, articolo, specifiche |
| costi della riga | costo unitario e totale, note sui costi |
| valore della riga | prezzo unitario, sconto in percentuale o in valore, reparto, listino, totale della merce, totale fisso, totale lordo, totale finale, se la riga è soggetta a ritenuta |

Il **reparto** decide l'aliquota IVA della riga. La tendina non propone i reparti con un'aliquota
**archiviata**, come il reverse charge con la natura generica *N6* che lo SDI non accetta più: una
riga che ne ha già uno lo mantiene, segnato *aliquota archiviata*, e va corretta scegliendo un reparto
con la natura di dettaglio ( *N6.1*… *N6.9* ).

> **nota** — la scheda di una riga ha anche un riquadro *attribuzione* e una linguetta **righe
> aggregate**, entrambi per ora **vuoti**.

## i pagamenti
<!-- @pubblico: operatore, amministratore -->
<!-- @pagina: amministrazione.archivio.documenti.pagamenti.form -->

La linguetta **pagamenti** dell'archivio elenca i pagamenti non archiviati, gli ultimi inseriti in
cima. Un pagamento è una **scadenza**: nasce quando si sa che qualcuno deve pagare, e si chiude quando
il pagamento arriva.

| riquadro | campi |
|---|---|
| dati generali | documento, codice, nome, note |
| importo e sconti | importo base, sconto da coupon, importo finale, listino |
| modalità di pagamento e scadenza | tipologia, data di scadenza, modalità, IBAN su cui pagare |
| debito senza documento | debitore e creditore, per le somme dovute che non hanno un documento dietro |
| pagamento | data e ora in cui il pagamento è avvenuto, note |

Un pagamento è **saldato** quando ha la data del riquadro *pagamento*; finché è vuota, è una
scadenza aperta.

> **nota** — la tendina **IBAN** propone i conti di chi ha emesso il documento, e si riempie quando
> il pagamento è legato a un documento. La tendina **tipologia** del riquadro *modalità di pagamento
> e scadenza* per ora **resta vuota**.

## quello che questo capitolo non dice ancora

- come si **numera** un documento nuovo, e che ruolo ha il sezionale;
- l'**evasione** di un documento, quando la linguetta sarà realizzata;
- come si **calcolano** i totali di una riga, e quali campi si compilano a mano;
- le **stampe** e le **azioni** disponibili, che dipendono dall'installazione.
