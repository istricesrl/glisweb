# modulo SMS

Il modulo SMS è l'interfaccia di amministrazione della coda degli SMS del framework: mostra gli SMS in
uscita e quelli già inviati, offre gli strumenti per forzare l'evasione della coda, e porta con sé le
copie dei task della coda, come il modulo `MA000.mail` fa per le mail. Il meccanismo vero e proprio — accodamento, provider, configurazione
dei server — sta nel core e il modulo lo usa così com'è: la descrizione generale è nel capitolo
`151.sms.md`, qui si documenta solo quello che il modulo aggiunge.

# logica generale del modulo
Un SMS nasce nella tabella `sms_out` tramite `queueSms()` o `queueSmsFromTemplate()`, definite in
`/_src/_lib/_sms.tools.php`: mittente e destinatari vengono salvati **serializzati** ( il mittente nella
forma `array( nome => numero )`, i destinatari come array di numeri ), il corpo in chiaro. Il modulo non
accoda nulla: lo fanno le controller e i task dei moduli che hanno bisogno di mandare un SMS.

L'evasione avviene un messaggio alla volta con lo schema a token usato anche per le mail: il task marca
con il proprio token una riga di `sms_out`, la legge, la passa al provider e, se l'invio riesce, la copia
in `sms_sent` ( `REPLACE INTO sms_sent SELECT * FROM sms_out` ), vi scrive la timestamp di invio e la
cancella da `sms_out`. Se l'invio fallisce la riga resta in coda, il contatore `tentativi` sale di uno e
l'invio viene rimandato di tante ore quanti sono i tentativi fatti, fino a `$cf['sms']['tentativi_massimi']`
tentativi falliti ( default 10, runlevel `_540.sms.php`; 0 toglie il limite ), come per le mail: lì la riga resta
in `sms_out` ferma con il token dedicato `TROPPI_TENTATIVI`, l'errore va nel log `sms` e il titolo della scheda
( la `__label__` di `sms_out_view` ) dice dopo quanti tentativi. La ferma non la riprendono né il giro normale, né
`hard`, né `full`, né lo sblocco: la fa ripartire, con i tentativi azzerati, l'invio forzato dalla scheda ( `id` ).

La copia in `sms_sent` è un `SELECT *`, quindi le due tabelle devono avere le stesse colonne nello stesso
ordine. Se la copia fallisce l'SMS è già partito: il task non cancella la riga e non la rimette in coda,
la lascia in `sms_out` marcata con il token dedicato `COPIA_FALLITA`, che la esclude da tutte le modalità di
evasione e dallo sblocco descritto qui sotto, e scrive l'errore nel log `sms` a livello critico. La riga va
sistemata a mano, allineando le tabelle o cancellandola dalla sua scheda.

Insieme al token il task scrive l'ora della marcatura in `timestamp_elaborazione`. Se il processo muore a metà
giro la riga resterebbe marcata per sempre: per questo all'inizio di ogni giro, in tutte le modalità, il task
toglie il token alle righe marcate da più di `$cf['sms']['minuti_sblocco']` minuti ( default 60, runlevel
`/_src/_config/_540.sms.php` ), che tornano in coda. Un SMS sbloccato così può partire due volte, se il processo
era morto dopo averlo consegnato al provider. Fino al 2026-09-30 queste righe restavano bloccate.

## dipendenze
Il modulo si appoggia a funzioni del core, che vengono caricate sempre:

- `/_src/_lib/_sms.tools.php` per l'accodamento e per `array2smsString()`, con cui le viste rendono
  leggibili mittente e destinatari serializzati;
- `/_src/_lib/_skebby.tools.php` e `/_src/_lib/_ehiweb.tools.php` per `skebbySend()` ed `ehiwebSend()`,
  le funzioni dei due provider che il task sa usare;
- i runlevel `/_src/_config/_340.sms.php`, `/_src/_config/_540.sms.php` e `/_src/_config/_545.sms.php`,
  che definiscono template, server e profili SMS.

Con il modulo `TE000.template` attivo la vista degli SMS guadagna la scheda `sms.template.view`, definita
da quel modulo e inserita da questo prima degli strumenti. Senza, la scheda semplicemente non c'è.

## tabelle del database
Il modulo lavora su `sms_out` ( la coda in uscita ) e `sms_sent` ( gli inviati ), descritte colonna per
colonna nel capitolo `315.database.s.md`; i diritti di accesso sono in `/_src/_config/_250.auth.php`
( controllo completo a `roots` e `staff` ). Le definizioni, con le viste `sms_out_view` e `sms_sent_view`,
stanno nei file di base di `_usr/_database/_patch/` e nella patch `_202609291000.sms.sql`, che le ha
rimesse dopo che il riallineamento del 02/03/2026 le aveva perse; la colonna `timestamp_elaborazione` l'ha
aggiunta la patch `_202609301600.code.marcatura.sql`.

## configurazione
Il task sceglie il server così: se la riga di `sms_out` ha la colonna `server` valorizzata usa
`$cf['sms']['servers'][ <server> ]`, altrimenti il server del profilo corrente, `$cf['sms']['server']`.
Del server legge `type`, `username` e `password`, e per Ehiweb anche `id_api`; i tipi gestiti sono
`skebby` ed `ehiweb`. Un server nominato nella riga ma assente dalla configurazione, un profilo senza
server o un tipo sconosciuto sono un errore di invio: l'SMS resta in coda e l'errore va nel log.

La chiave `sms.minuti_sblocco` ( default 60 ) dice dopo quanti minuti una riga marcata e mai rilasciata torna
in coda; va tenuta più lunga del giro più lento che il task possa fare.

```
sms:
  servers:
    skebby:
      type: skebby
      username: <utente>
      password: <password>
  profiles:
    PROD:
      servers:
        - skebby
```

La convenzione dei profili per ambiente è quella di tutte le factory del framework, vedi
`/_src/_config/_545.sms.php`.

## pagine
Tutte le pagine sono riservate al gruppo `roots` e stanno sotto la pagina `strumenti`; la vista degli SMS
in uscita compare nel menu di amministrazione come **sms** ( priorità 950 ).

| pagina | cosa mostra |
|---|---|
| `sms.out.view` | la coda degli SMS in uscita, con la data di invio prevista o *in uscita* se non ce n'è una |
| `sms.sent.view` | gli SMS inviati |
| `sms.tools` | gli strumenti della coda: invio del prossimo SMS, evasione dell'intera coda, svuotamento delle code |
| `sms.out.form`, `sms.out.form.tools` | la scheda di un SMS in uscita, con l'invio immediato fra gli strumenti |
| `sms.sent.form`, `sms.sent.form.tools` | la scheda di un SMS inviato, con la reimmissione in coda fra gli strumenti |

Le schede ricalcano quelle delle mail del modulo `MA000.mail`: macro e template hanno la stessa forma,
senza i campi che un SMS non ha ( copia, copia nascosta, oggetto, allegati ).

> **nota** — il modulo legacy `0030.strumenti` definisce pagine con gli stessi ID ( `sms.out.view`,
> `sms.sent.view`, `sms.tools`, ... ) sui template vecchi a `.html`. È il caso ammesso di una pagina
> dichiarata da due moduli di generazione diversa; con tutti e due attivi prevale la definizione
> caricata per ultima.

## il task di invio
Il task si chiama come `/task/SM000.sms/sms.queue.send` e richiede il privilegio
`GESTIONE_COMUNICAZIONI`. Ha quattro modalità, scelte dai parametri della richiesta:

| parametro | comportamento |
|---|---|
| `id=<id>` | invia l'SMS indicato, anche se non è ancora il suo momento, purché nessun altro processo lo abbia già marcato |
| `hard=1` | invia il primo SMS della coda per `ordine` e `timestamp_invio`, ignorando la data prevista |
| `full=1` | rimette in circolo tutta la coda: azzera `timestamp_invio` su tutte le righe e non invia nulla, la coda la riprende il cron dal giro successivo; la risposta dice quante date ha azzerato e quante righe ha sbloccato |
| nessuno | invia il primo SMS la cui data prevista è passata o assente |

Il task è la copia nel modulo di quello del core, `/_src/_api/_task/_sms.queue.send.php`
( `/task/sms.queue.send` ), come il modulo `MA000.mail` ha la sua copia del task delle mail: le due copie
sono identiche a parte l'inclusione del framework e vanno tenute uguali. Allo stesso modo il modulo ha le
copie dei due task di svuotamento delle code ( `sms.queue.clean.out` e `sms.queue.clean.sent` ), che
chiamano i pulsanti della pagina `sms.tools`, e in più il task `sms.queue.resend`, gemello di
`mail.queue.resend`, che rimette in coda un SMS inviato.

## log
I task scrivono nella factory `sms`, la libreria di Skebby nella factory `skebby` ( autenticazione, dati
inviati ed esito di ogni chiamata ), quella di Ehiweb nella factory `ehiweb`.

## i file del modulo

### /_mod/_SM000.sms/_src/_api/_task/_sms.queue.clean.out.php
Svuota la coda degli SMS in uscita ( `sms_out` ), senza inviarli, e ottimizza la tabella; è la copia nel
modulo di `/_src/_api/_task/_sms.queue.clean.out.php` e la chiama il pulsante della pagina `sms.tools`.
Richiede `GESTIONE_COMUNICAZIONI`.

### /_mod/_SM000.sms/_src/_api/_task/_sms.queue.clean.sent.php
Svuota l'archivio degli SMS inviati ( `sms_sent` ) e ottimizza la tabella; è la copia nel modulo di
`/_src/_api/_task/_sms.queue.clean.sent.php` e la chiama il pulsante della pagina `sms.tools`. Richiede
`GESTIONE_COMUNICAZIONI`.

### /_mod/_SM000.sms/_src/_api/_task/_sms.queue.resend.php
Rimette in coda l'SMS inviato indicato con `id=<id>`, gemello di `mail.queue.resend` del modulo
`MA000.mail`: lo marca con il proprio token, lo copia in `sms_out` con lo stesso ID azzerando token, ora
della marcatura, tentativi e data prevista, e lo cancella da `sms_sent`. Se la copia fallisce la riga resta fra gli inviati,
senza token, e l'errore va nel log. Lo chiama la scheda `sms.sent.form.tools`; richiede
`GESTIONE_COMUNICAZIONI`.

### /_mod/_SM000.sms/_src/_api/_task/_sms.queue.send.php
Task di evasione della coda degli SMS, raggiungibile come `/task/SM000.sms/sms.queue.send` o dal cron;
richiede `GESTIONE_COMUNICAZIONI`. Marca con il proprio token una riga di `sms_out` secondo la modalità
scelta ( `id`, `hard`, `full` o standard, vedi sopra ), la invia con `skebbySend()` o `ehiwebSend()` secondo
il tipo del server e in caso di successo la sposta in `sms_sent`, controllando l'esito della copia prima di
cancellare la riga; in caso di errore incrementa `tentativi` e rimanda l'invio di altrettante ore, fino a
`$cf['sms']['tentativi_massimi']` tentativi falliti, dopo i quali la riga resta ferma con il token
`TROPPI_TENTATIVI` ( vedi sopra ). All'inizio di ogni giro sblocca le righe marcate da più di
`$cf['sms']['minuti_sblocco']` minuti, tranne quelle con `COPIA_FALLITA` o `TROPPI_TENTATIVI`. È la copia identica del task omonimo del core, che va tenuta allineata.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.out.form.php
Macro della scheda `sms.out.form`: dichiara `sms_out` come tabella gestita e lascia il resto alla macro di
default. Ricalca `_mail.out.form.php` del modulo `MA000.mail`. Il campo *invio* è un input `datetime-local` su
`timestamp_invio`, convertito in lettura e in scrittura dalle controller di default
( `/_src/_inc/_controllers/_default.after.php` e `_default.before.php` ).

> **attenzione** — a differenza delle schede delle mail, che hanno le controller `_mail.out.*` e `_mail.sent.*`
> per convertire gli indirizzi, le schede degli SMS mostrano mittente e destinatari come sono nel database,
> serializzati, e una modifica fatta lì scrive testo libero dove il task si aspetta un valore serializzato. Per
> convertirli servono delle controller `_sms.out.*` e
> `_sms.sent.*` e una funzione inversa di `array2smsString()`, che oggi non esiste.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.out.form.tools.php
Macro della scheda `sms.out.form.tools`: offre l'invio immediato dell'SMS aperto
( `/task/SM000.sms/sms.queue.send?id=<id>` ), che al termine porta alla vista degli inviati. Ricalca
`_mail.out.form.tools.php` del modulo `MA000.mail`.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.out.view.php
Macro della vista `sms.out.view`: elenca `sms_out` con ID, data di invio prevista, destinatari e corpo e
apre le righe su `sms.out.form`. Dopo la macro di default converte `timestamp_invio` in data leggibile
( o *in uscita* se è vuota ) e deserializza mittente e destinatari con `array2smsString()`.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.sent.form.php
Macro della scheda `sms.sent.form`: dichiara `sms_sent` come tabella gestita e lascia il resto alla macro
di default. Ricalca `_mail.sent.form.php` del modulo `MA000.mail`.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.sent.form.tools.php
Macro della scheda `sms.sent.form.tools`: offre la reimmissione in coda dell'SMS aperto
( `/task/SM000.sms/sms.queue.resend?id=<id>` ), che al termine porta alla vista degli SMS in uscita.
Ricalca `_mail.sent.form.tools.php` del modulo `MA000.mail`.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.sent.view.php
Macro della vista `sms.sent.view`: identica a quella della coda in uscita ma su `sms_sent`, con le righe
che aprono `sms.sent.form` e la colonna della data intitolata *invio*, come nella vista delle mail inviate.
Una riga senza data di invio mostra *data non registrata*: fino al 2026-09-30 mostrava *in uscita*, come la coda.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.tools.php
Macro della pagina `sms.tools`. Dichiara i gruppi di strumenti e ne popola due: in *elaborazioni* l'invio
del prossimo SMS ( `sms.queue.send?hard=1` ) e la rimessa in circolo di tutta la coda, che il cron riprende dal
giro successivo ( `?full=1` ), in *code* lo
svuotamento delle code degli inviati e degli SMS in uscita con i task del modulo
( `/task/SM000.sms/sms.queue.clean.sent` e `/task/SM000.sms/sms.queue.clean.out` ).

### /_mod/_SM000.sms/_src/_inc/_pages/_sms.it-IT.php
Definisce le pagine del modulo ( vedi la tabella delle pagine sopra ): le due viste, le due schede con i
rispettivi strumenti e la pagina degli strumenti della coda. Se `TE000.template` è attivo inserisce la
scheda `sms.template.view` fra quelle della vista, prima di `sms.tools`.

### /_mod/_SM000.sms/_src/_tpl/_athena/sms.out.form.twig
Template della scheda `sms.out.form` sul tema Athena: mittente, destinatari, corpo e data di invio, con i
comandi standard del form. Ricalca `mail.out.form.twig` del modulo `MA000.mail` senza i campi che un SMS
non ha e senza l'editor CodeMirror, perché il corpo di un SMS è testo semplice.

### /_mod/_SM000.sms/_src/_tpl/_athena/sms.sent.form.twig
Template della scheda `sms.sent.form`, identico a quello della scheda in uscita ma sulla tabella
`sms_sent`, come per le mail.
