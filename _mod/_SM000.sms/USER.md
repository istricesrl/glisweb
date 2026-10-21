# sms

Gli SMS funzionano come le mail: l'applicazione **non li spedisce nel momento in cui li scrive**,
li mette in una **coda in uscita**, e un lavoro automatico che gira a intervalli regolari li
preleva uno alla volta e li consegna al **fornitore del servizio SMS** configurato
sull'installazione. Quelli consegnati passano nella **coda degli inviati**.

Questo modulo mostra le due code e permette di intervenire. Gli SMS non si scrivono da qui: li
producono gli altri moduli, di norma a partire da un **template** — vedi il capitolo del modulo
template.

Si apre dalla voce **sms**, sotto *strumenti*, ed è riservato agli **amministratori**. Chi conosce
il capitolo delle mail ritrova qui le stesse maschere, con meno campi.

## gli SMS in uscita
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.out.view -->

È la prima linguetta, *in uscita*: una riga per ogni SMS che deve ancora partire.

| colonna | contenuto |
|---|---|
| invio previsto | data e ora da cui l'SMS può partire; *in uscita* se può partire subito |
| destinatari | i numeri a cui l'SMS è diretto |
| corpo | il testo del messaggio |

Il giro automatico prende sempre **il primo SMS pronto**: quello con la priorità più alta e, a
parità, quello previsto da più tempo.

Le altre linguette della sezione sono **inviati**, **template** ( se c'è il modulo dei template ) e
gli **strumenti sms**.

> **nota** — se un invio non riesce, l'SMS **resta in coda**: il numero dei tentativi cresce di uno
> e l'invio viene rimandato di tante ore quanti sono i tentativi fatti. Succede anche quando il
> fornitore del servizio **non è configurato**: in quel caso gli SMS si accumulano qui e non
> partiranno finché chi amministra l'installazione non lo configura. Dopo dieci tentativi falliti
> ( o il numero impostato sull'installazione ) l'SMS **si ferma**: resta nell'elenco ma non viene più
> riprovato, e il titolo della sua scheda dice "fermo dopo N tentativi"; lo si fa ripartire con
> **invia immediatamente l'SMS** dagli strumenti della scheda, che azzera i tentativi. Un SMS rimasto
> a metà di un giro interrotto torna in coda da solo dopo un'ora ( o il tempo impostato sull'installazione ).

## la scheda di un SMS
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.out.form -->

Un clic su una riga apre la scheda:

| riquadro | campi |
|---|---|
| mittente | il nome o il numero che il destinatario vede come mittente |
| destinatari | i numeri a cui l'SMS è diretto |
| contenuto dell'SMS | il testo del messaggio |
| dati di invio | la data e l'ora previste per l'invio |

L'ultima linguetta, **strumenti**, ha un riquadro solo:

| riquadro | cosa fa |
|---|---|
| invia immediatamente l'SMS | tenta subito l'invio di **questo** SMS, senza aspettare il giro automatico, e porta all'elenco degli inviati; un SMS fermo per troppi tentativi riparte con i tentativi azzerati |

> **attenzione** — un SMS è stato composto da un altro modulo, e la correzione fatta qui vale solo
> per quella copia: se l'errore è nel testo, va corretto nel **template** da cui è nato.

## gli SMS inviati
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.sent.view -->

La linguetta *inviati* ha le stesse colonne della coda in uscita, ma la data è quella in cui l'SMS
**è partito davvero**, cioè è stato accettato dal fornitore del servizio; *data non registrata* vuol
dire che l'SMS è partito ma l'applicazione non è riuscita a segnarne l'ora.

## rimettere in coda un SMS inviato
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.sent.form -->

La scheda di un SMS inviato è uguale a quella di un SMS in uscita; la linguetta **strumenti** ha:

| riquadro | cosa fa |
|---|---|
| reinvia l'SMS | toglie l'SMS dagli inviati e lo **rimette nella coda in uscita**, pronto a partire subito e coi tentativi azzerati; poi porta all'elenco degli SMS in uscita |

## gli strumenti sms
<!-- @pubblico: amministratore -->
<!-- @pagina: sms.tools -->

L'ultima linguetta della sezione raccoglie le operazioni sulle code intere. Nel gruppo
**elaborazioni**:

| riquadro | cosa fa |
|---|---|
| invia il prossimo SMS in uscita | spedisce subito il primo SMS della coda, **anche se il suo invio era previsto più avanti** |
| elabora coda SMS in uscita | rimette in circolo **tutta** la coda: rende subito inviabili tutti gli SMS, compresi quelli programmati e quelli rimandati dopo un errore, e libera quelli rimasti bloccati da un giro interrotto; gli SMS fermi per troppi tentativi restano fermi. In quel momento **non spedisce niente**: li spedisce il giro automatico dal passaggio successivo, uno alla volta ( chiede conferma ) |

Nel gruppo **code**:

| riquadro | cosa fa |
|---|---|
| svuotamento coda SMS inviati | cancella il registro degli SMS inviati ( chiede conferma ) |
| svuotamento coda SMS in uscita | cancella tutti gli SMS in attesa **senza spedirli** ( chiede conferma ) |

> **attenzione** — i due svuotamenti **non si disfano**, e un SMS spedito di norma **costa**: prima
> di rimettere in coda o di forzare l'invio di molti messaggi conviene sapere quanti sono.

## quello che questo capitolo non dice ancora

- quali **fornitori** del servizio SMS l'applicazione sa usare e come si sceglie quello di un
  singolo messaggio;
- **ogni quanto** gira l'invio automatico, che dipende da come è configurata l'installazione;
- come si scrivono **mittente e destinatari** nella scheda, e cosa succede a un numero scritto in un
  formato che il fornitore non accetta;
- la **lunghezza** di un SMS e cosa succede a un testo che la supera.
