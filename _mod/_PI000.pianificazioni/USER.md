# pianificazioni

Una **pianificazione** crea da sola, a intervalli regolari, un oggetto sempre uguale: una fattura
di canone ogni mese con le sue righe e i suoi pagamenti, un'attività ogni lunedì e giovedì, un
rinnovo di contratto ogni anno. Si scrive una volta **quando** crearlo e **com'è fatto**, e da lì in
avanti l'applicazione lo crea al momento giusto senza che nessuno debba ricordarselo.

Le cose che si possono pianificare sono sei:

| entità | che cosa nasce a ogni ripetizione |
|---|---|
| documenti | un documento nuovo, per esempio una fattura, con le sue righe e i suoi pagamenti |
| todo | una cosa da fare |
| attività | un'attività programmata |
| rinnovi | un rinnovo del contratto a cui la pianificazione è collegata |
| righe di un documento | una riga aggiunta a un documento che esiste già |
| pagamenti di un documento | una scadenza aggiunta a un documento che esiste già |

Nella tendina compaiono solo le entità che l'installazione sa gestire: se il modulo dei documenti,
delle attività o dei contratti non è attivo, la voce corrispondente non c'è.

Questo capitolo racconta l'uso. Come l'applicazione calcola le date e crea gli oggetti — e perché si
comporta come si comporta — è spiegato nel **manuale sviluppatore**, nel capitolo sui meccanismi di
esecuzione delle pianificazioni e in quello del modulo.

## l'elenco delle pianificazioni
<!-- @pubblico: amministratore -->
<!-- @pagina: pianificazioni.view -->

Si apre dal menu **strumenti**, alla voce *pianificazioni*, accanto ai task e ai job: le
pianificazioni sono la terza delle automazioni dell'applicazione. L'elenco mostra una riga per
pianificazione, le più recenti in cima:

| colonna | contenuto |
|---|---|
| entità | che cosa la pianificazione crea |
| pianificazione | il suo nome |
| periodicità, ogni | la frequenza: *mensile* e *1* è ogni mese, *mensile* e *3* ogni tre mesi |
| attiva dal | da quando l'applicazione la prende in considerazione |
| ultimo oggetto | la data dell'ultimo oggetto creato |
| fino al | la data di fine, se c'è |
| ultima elaborazione | quando l'applicazione l'ha guardata l'ultima volta |

Le righe e i pagamenti che fanno parte del modello di un documento **non compaiono** qui: si vedono e
si modificano dentro la pianificazione del documento a cui appartengono.

La linguetta **strumenti** dell'elenco ha un solo riquadro, *elabora la prossima pianificazione*: fa
subito, per la prima pianificazione in attesa, lo stesso lavoro che l'applicazione fa da sola a ogni
passata automatica. Si vede solo se il proprio utente ha il permesso di gestire le pianificazioni.

## la scheda di una pianificazione
<!-- @pubblico: amministratore -->
<!-- @pagina: pianificazioni.form -->

La prima linguetta, *gestione*, dice **quando** la pianificazione crea gli oggetti.

| riquadro | campi |
|---|---|
| dati generali | **entità** e **nome**, obbligatori, e le note |
| ripetizione | **periodicità** ( da giornaliera ad annuale ) e **ogni**, cioè ogni quante volte |
| date | **attiva dal**, **primo oggetto il**, **fino al**, **crea con anticipo di** e **rinnova di**, in giorni |

La ripetizione cambia secondo la periodicità scelta: per la **settimanale** compaiono i giorni della
settimana da spuntare; dalla **mensile** in su compare lo **schema**, che dice se ripetere lo
*stesso giorno del mese* ( il 15 di ogni mese ) o lo *stesso giorno della settimana* ( il secondo
martedì ).

Le date si leggono così:

- **attiva dal** è il giorno da cui l'applicazione comincia a occuparsene;
- **primo oggetto il** è la data del primo oggetto, e da lei si contano tutte le altre. Le
  ripetizioni mensili e più lunghe che cadono in un giorno che un mese non ha si fermano all'ultimo
  giorno di quel mese: partendo dal 31 gennaio, i successivi sono il 28 febbraio, il 31 marzo, il 30
  aprile;
- **fino al** è l'ultima data possibile, ed è **compresa**; se è vuota la pianificazione non si
  ferma;
- **crea con anticipo di** dice quanti giorni prima della sua data un oggetto viene creato: a zero
  nasce il giorno stesso;
- **rinnova di** allunga da sola la data di fine di quei giorni quando la si sta per raggiungere, ed
  è il modo di dire *si rinnova finché non la si ferma*.

Una pianificazione già salvata mostra anche, in sola lettura, la data dell'**ultimo oggetto creato**
e quella in cui è stata **elaborata** l'ultima volta.

> **attenzione** — l'**entità si sceglie per prima**, e dopo non si cambia a cuor leggero: da lei
> dipendono i campi della linguetta *modello*.

## il modello
<!-- @pubblico: amministratore -->
<!-- @pagina: pianificazioni.form.modello -->

La linguetta *modello* dice **com'è fatto** l'oggetto da creare, e i suoi campi cambiano con
l'entità. Finché l'entità non è scelta, chiede di sceglierla.

| entità | cosa si compila |
|---|---|
| documenti | tipologia ( obbligatoria ), sezionale, condizioni di pagamento, esigibilità dell'IVA, nome, note per il cliente; **emittente** e **destinatario**, obbligatori, con le rispettive sedi e l'IBAN dell'emittente; e il sotto-elenco **righe e pagamenti** |
| todo | tipologia, nome, cliente, responsabile, orario ( dalle, alle, ore ) e note di programmazione |
| attività | come le todo, con l'**operatore** al posto del responsabile, più le note |
| rinnovi | tipologia, codice, se è automatico, note |
| righe di un documento | il **documento** a cui aggiungerla, l'articolo, nome, quantità, unità di misura, importo, reparto, listino |
| pagamenti di un documento | il documento, nome, modalità, IBAN, **importo**, listino, e lo spostamento della scadenza in giorni ed eventualmente a fine mese |

Data e numero di un documento **non si scrivono**: li assegna l'applicazione quando lo crea, e i
documenti escono numerati in ordine di data. Allo stesso modo la data di una todo o di un'attività
è quella della ripetizione, e la scadenza di un pagamento è la data della ripetizione più lo
spostamento indicato.

Nel sotto-elenco **righe e pagamenti** di un documento si aggiunge una riga col più, se ne sceglie
il tipo — *riga* o *pagamento* — e si salva: i campi di quel tipo compaiono dopo il salvataggio,
e si compilano come quelli delle righe e dei pagamenti autonomi della tabella qui sopra.

Nei campi di testo si possono usare **le variabili della data** dell'oggetto, che l'applicazione
sostituisce ogni volta: il modello le propone già nel sezionale e nel nome di un documento. Si
scrivono fra doppie graffe, così come sono:

| variabile | diventa |
|---|---|
| `{{ dt.now.giorno }}` | il giorno, a due cifre |
| `{{ dt.now.nome_giorno }}` | il nome del giorno della settimana |
| `{{ dt.now.mese }}` | il mese, a due cifre |
| `{{ dt.now.nome_mese }}` | il nome del mese |
| `{{ dt.now.anno }}` | l'anno, a quattro cifre |
| `{{ dt.articoli.totale }}` | solo nell'importo di un pagamento del modello di un documento: il totale delle righe, IVA compresa |

> **esempio** — una fattura di canone mensile: entità *documenti*, periodicità *mensile*, ogni *1*,
> primo oggetto il 31 gennaio. Nel modello la tipologia *fattura*, il sezionale con l'anno della
> data, il nome *canone* seguito dal mese e dall'anno, una riga da 100,00 al reparto dell'IVA al 22%
> e un pagamento pari al totale delle righe, a 30 giorni fine mese. Le fatture escono il 31
> gennaio, il 28 febbraio, il 31 marzo, e il pagamento della prima scade il 28 febbraio.

> **nota** — il **contratto** a cui si attaccano i rinnovi non si sceglie da questa scheda: una
> pianificazione di rinnovi nasce già collegata al suo contratto, dal modulo dei contratti.

## gli oggetti creati
<!-- @pubblico: amministratore -->
<!-- @pagina: pianificazioni.form.oggetti -->

La linguetta *oggetti creati* elenca tutto quello che la pianificazione ha prodotto, i più recenti
in cima, con la data e il nome; per i rinnovi, il periodo e il codice. Un clic su una riga apre
l'oggetto nella sua area — la fattura fra i documenti, l'attività fra le attività — e da lì lo si
lavora come qualunque altro.

Gli oggetti non si aggiungono da qui: li crea la pianificazione.

## gli strumenti di una pianificazione
<!-- @pubblico: amministratore -->
<!-- @pagina: pianificazioni.form.tools -->

La linguetta *strumenti* ha tre riquadri, visibili solo su una pianificazione già salvata e a chi ha
il permesso di gestire le pianificazioni:

| riquadro | cosa fa |
|---|---|
| crea gli oggetti | crea **subito** gli oggetti già dovuti, senza aspettare il passaggio automatico; i documenti uno per volta |
| ferma la pianificazione | chiede una **data di fine**, che diventa il suo *fino al*; spuntando la casella cancella anche gli oggetti già creati dopo quella data |
| ripianifica | chiede una data, e da quella in poi **cancella e ricrea** gli oggetti secondo i parametri attuali |

La ripianificazione serve quando si è cambiata la periodicità, i giorni o il modello di una
pianificazione che aveva già creato degli oggetti futuri: senza, quelli resterebbero com'erano.

> **attenzione** — **i documenti non si cancellano mai**, né fermando né ripianificando: un documento
> numerato che sparisce lascerebbe un buco nella numerazione. Restano dove sono, e i nuovi partono
> dopo l'ultimo esistente. Se uno di loro va davvero tolto, lo si fa a mano dalla sua scheda.

> **nota** — la ripianificazione non tocca neanche gli oggetti **già lavorati**: le todo chiuse, le
> attività svolte e i pagamenti già pagati restano, e non vengono ricreati.

## la linguetta pianificazione di fatture, documenti e attività
<!-- @pubblico: amministratore -->
<!-- @pagina: amministrazione.ciclo.attivo.fatture.form.pianificazioni -->

Dove ci sono i moduli delle fatture, dei documenti e delle attività, le loro schede hanno una
linguetta **pianificazione**. È una pagina di riquadri e fa due cose:

- se l'oggetto è nato da una pianificazione, il riquadro **pianificazione di origine** porta alla sua
  scheda;
- il riquadro **pianifica questa fattura** ( o *questo documento*, *questa attività* ) crea una
  pianificazione nuova che ha **quell'oggetto come modello** — per un documento con le sue righe e i
  suoi pagamenti — e apre la sua scheda. Chiede conferma prima di partire.

È il modo più comodo per cominciare: si prepara una volta la fattura come la si vuole, e la si
trasforma in pianificazione.

> **attenzione** — la pianificazione così creata **non ha ancora periodicità né date**, e finché non
> le si danno non crea niente. La si completa nella linguetta *gestione* che si apre subito dopo.

## se una pianificazione non parte

Prima di segnalare un problema vale la pena guardare, nella scheda:

- **attiva dal**, che dev'essere oggi o nel passato;
- **fino al**, che non dev'essere già passata;
- l'**ultimo oggetto creato**: le date fino a quella, compresa, non vengono ricreate;
- la data in cui è stata **elaborata**: se è oggi, per oggi l'applicazione ha già fatto;
- che il modulo dell'entità sia ancora attivo: se è stato spento, l'entità resta nella tendina con
  la scritta *modulo non attivo* e la pianificazione aspetta, senza creare niente, che venga
  riacceso.

## quello che questo capitolo non dice ancora

- come si imposta la ripetizione **settimanale** se non si spunta nessun giorno;
- le **tipologie** di todo, attività e rinnovi, e dove si configurano;
- come nasce, dal lato del modulo dei contratti, una pianificazione di **rinnovi**.
