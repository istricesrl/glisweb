# modulo SMS

Il modulo SMS è l'interfaccia di amministrazione della coda degli SMS del framework: mostra gli SMS in
uscita e quelli già inviati, offre gli strumenti per forzare l'evasione della coda, e porta con sé una
propria versione del task di invio. Il meccanismo vero e proprio — accodamento, provider, configurazione
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
l'invio viene rimandato di tante ore quanti sono i tentativi fatti.

> **attenzione** — la copia in `sms_sent` è un `SELECT *`: le due tabelle devono avere le stesse colonne
> nello stesso ordine. Una colonna aggiunta a una sola delle due fa fallire la copia, e il task non ne
> controlla l'esito: la riga viene comunque cancellata da `sms_out`, per cui l'SMS già consegnato dal
> provider sparisce senza comparire fra gli inviati.

## dipendenze
Il modulo si appoggia a funzioni del core, che vengono caricate sempre:

- `/_src/_lib/_sms.tools.php` per l'accodamento e per `array2smsString()`, con cui le viste rendono
  leggibili mittente e destinatari serializzati;
- `/_src/_lib/_skebby.tools.php` per `skebbySend()`, l'unico provider che il task del modulo sa usare;
- i runlevel `/_src/_config/_340.sms.php`, `/_src/_config/_540.sms.php` e `/_src/_config/_545.sms.php`,
  che definiscono template, server e profili SMS.

Con il modulo `TE000.template` attivo la vista degli SMS guadagna la scheda `sms.template.view`, definita
da quel modulo e inserita da questo prima degli strumenti. Senza, la scheda semplicemente non c'è.

## tabelle del database
Il modulo lavora su `sms_out` ( la coda in uscita ) e `sms_sent` ( gli inviati ), descritte colonna per
colonna nel capitolo `315.database.s.md`; i diritti di accesso sono in `/_src/_config/_250.auth.php`
( controllo completo a `roots` e `staff` ).

> **attenzione** — le due tabelle sono elencate nel capitolo del database e nei diritti, ma nei file di
> schema di `_usr/_database/_patch/` non c'è il loro `CREATE TABLE`: su un'installazione nuova vanno
> create a mano, altrimenti le viste e il task falliscono sulla prima query.

## configurazione
Il task sceglie il server così: se la riga di `sms_out` ha la colonna `server` valorizzata usa
`$cf['sms']['servers'][ <server> ]`, altrimenti il server del profilo corrente, `$cf['sms']['server']`.
Del server legge `type`, `username` e `password`; il task del modulo gestisce solo `type: skebby`.

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
| `sms.out.form`, `sms.out.form.tools` | la scheda di un SMS in uscita |
| `sms.sent.form`, `sms.sent.form.tools` | la scheda di un SMS inviato |

> **attenzione** — le pagine di scheda ( `sms.out.form`, `sms.sent.form` e i loro strumenti ) puntano a
> macro e template che il modulo non ha: `_sms.out.form.php`, `_sms.out.form.tools.php`,
> `_sms.sent.form.php`, `_sms.sent.form.tools.php`, `sms.out.form.twig` e `sms.sent.form.twig` non
> esistono nell'albero. Un clic su una riga delle viste apre una pagina rotta.

> **nota** — il modulo legacy `0030.strumenti` definisce pagine con gli stessi ID ( `sms.out.view`,
> `sms.sent.view`, `sms.tools`, ... ) sui template vecchi a `.html`. Con tutti e due attivi prevale la
> definizione caricata per ultima.

## il task di invio
Il task si chiama come `/task/SM000.sms/sms.queue.send` e richiede il privilegio
`GESTIONE_COMUNICAZIONI`. Ha quattro modalità, scelte dai parametri della richiesta:

| parametro | comportamento |
|---|---|
| `id=<id>` | invia l'SMS indicato, anche se non è ancora il suo momento |
| `hard=1` | invia il primo SMS della coda per `ordine` e `timestamp_invio`, ignorando la data prevista |
| `full=1` | azzera `timestamp_invio` su tutta la coda, così che i giri successivi la evadano per intero; in questo giro non invia nulla |
| nessuno | invia il primo SMS la cui data prevista è passata o assente |

Esiste anche il task del core `/_src/_api/_task/_sms.queue.send.php` ( `/task/sms.queue.send` ), con la
stessa logica: i due non sono la stessa cosa e oggi divergono. Quello del core supporta anche Ehiweb e
rifiuta i tipi di server sconosciuti, quello del modulo ha la modalità `full` e i messaggi di stato. Lo
svuotamento delle code esiste invece solo nel core ( `/_src/_api/_task/_sms.queue.clean.out.php` e
`/_src/_api/_task/_sms.queue.clean.sent.php` ).

## log
Il task scrive nella factory `sms`, la libreria di Skebby nella factory `skebby` ( autenticazione, dati
inviati ed esito di ogni chiamata ).

## i file del modulo

### /_mod/_SM000.sms/_src/_api/_task/_sms.queue.send.php
Task di evasione della coda degli SMS, raggiungibile come `/task/SM000.sms/sms.queue.send` o dal cron;
richiede `GESTIONE_COMUNICAZIONI`. Marca con il proprio token una riga di `sms_out` secondo la modalità
scelta ( `id`, `hard`, `full` o standard, vedi sopra ), la invia con `skebbySend()` e in caso di successo
la sposta in `sms_sent`; in caso di errore incrementa `tentativi` e rimanda l'invio di altrettante ore,
senza un limite massimo. È una variante del task omonimo del core, non un suo override.

> **attenzione** — lo `switch` sul tipo di server ha il solo ramo `skebby` e nessun `default`: con un
> server di altro tipo, o senza server configurato, `$r` resta indefinito, il controllo `$r !== false`
> passa e l'SMS viene spostato fra gli inviati senza essere mai partito. In modalità `id` inoltre la
> riga viene marcata anche se ha già il token di un altro processo, cosa che il task del core evita.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.out.view.php
Macro della vista `sms.out.view`: elenca `sms_out` con ID, data di invio prevista, destinatari e corpo e
apre le righe su `sms.out.form`. Dopo la macro di default converte `timestamp_invio` in data leggibile
( o *in uscita* se è vuota ) e deserializza mittente e destinatari con `array2smsString()`.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.sent.view.php
Macro della vista `sms.sent.view`: identica a quella della coda in uscita ma su `sms_sent`, con le righe
che aprono `sms.sent.form`. La colonna della data si chiama ancora *invio previsto* anche se qui contiene
la data di invio effettiva: è un residuo della copia dalla vista in uscita.

### /_mod/_SM000.sms/_src/_inc/_macro/_sms.tools.php
Macro della pagina `sms.tools`. Dichiara i gruppi di strumenti e ne popola due: in *elaborazioni* l'invio
del prossimo SMS ( `sms.queue.send?hard=1` ) e l'evasione di tutta la coda ( `?full=1` ), in *code* lo
svuotamento delle code degli inviati e degli SMS in uscita.

> **attenzione** — i due pulsanti di svuotamento chiamano `/task/SM000.sms/sms.queue.clean.sent` e
> `/task/SM000.sms/sms.queue.clean.out`, che nel modulo non esistono: i task di pulizia ci sono solo nel
> core, raggiungibili come `/task/sms.queue.clean.sent` e `/task/sms.queue.clean.out`.

### /_mod/_SM000.sms/_src/_inc/_pages/_sms.it-IT.php
Definisce le pagine del modulo ( vedi la tabella delle pagine sopra ): le due viste, le due schede con i
rispettivi strumenti e la pagina degli strumenti della coda. Se `TE000.template` è attivo inserisce la
scheda `sms.template.view` fra quelle della vista, prima di `sms.tools`.
