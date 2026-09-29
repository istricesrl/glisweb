# modulo mail

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.clean.out.php
Questo task pulisce la coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.clean.sent.php
Questo task pulisce la coda delle mail inviate.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.resend.php
Rimette in coda la mail inviata indicata con `id=<id>`: la marca con il proprio token, la copia in `mail_out`
con lo stesso ID azzerando token, tentativi e data prevista, ricollega alla mail in coda i file collegati a
quella inviata e la cancella da `mail_sent`. Se la copia fallisce la riga resta fra le inviate, senza token, e
l'errore va nel log `mail`. Lo chiama la scheda `mail.sent.form.tools`; richiede `GESTIONE_COMUNICAZIONI`.
Fino al 2026-09-29 la copia si portava dietro il token del task, che escludeva la mail da tutte le modalità di
evasione: la mail rimessa in coda non ripartiva mai. Il gemello per gli SMS è `sms.queue.resend` del modulo
`SM000.sms`.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.send.php
Task di evasione della coda delle mail, raggiungibile come `/task/MA000.mail/mail.queue.send` o dal cron;
richiede `GESTIONE_COMUNICAZIONI`. È la copia identica del task del core `/_src/_api/_task/_mail.queue.send.php`,
cui si rimanda per le modalità ( `id`, `hard`, `full` o standard ), e va tenuta allineata: cambia solo
l'inclusione del framework. Marca con il proprio token una riga di `mail_out`, la invia con `sendMail()` e in
caso di successo la sposta in `mail_sent`, controllando l'esito della copia prima di cancellare la riga: se la
copia fallisce la riga resta in `mail_out` bloccata dal token e l'errore va nel log a livello critico. In caso
di errore di invio incrementa `tentativi` e rimanda l'invio di altrettante ore, senza un limite massimo. Lo
chiama la scheda `mail.out.form.tools` con `id=<id>` e la pagina `mail.tools` con `hard=1` e `full=1`.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.out.after.php
Questa è la controller che interviene dopo l'elaborazione di ogni oggetto della coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.out.before.php
Questa è la controller che viene eseguita prima dell'elaborazione di ogni oggetto della coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.out.finally.php
Questa controller viene eseguita alla fine di tutte le elaborazioni della coda delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.sent.after.php
Questa controller viene eseguita dopo l'elaborazione di ogni oggetto della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.sent.before.php
Questa controller viene eseguita prima di ogni elaborazione della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_controllers/_mail.sent.finally.php
Questa controller viene eseguita alla fine delle elaborazioni di ogni oggetto della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.out.form.php
Questa è la macro del modulo di gestione delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.out.form.tools.php
Questa è la macro della scheda tools del modulo di gestione delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.out.view.php
Questa è la macro della view delle mail in uscita.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.sent.form.php
Questa è la macro del modulo di gestione delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.sent.form.tools.php
Questa è la macro della scheda tools del modulo di gestione delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.sent.view.php
Questa è la macro della view delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_macro/_mail.tools.php
Questa è la macro della scheda strumenti della coda delle mail inviate.

### /_mod/_MA000.mail/_src/_inc/_pages/_mail.it-IT.php
In questo file vengono definite le pagine del modulo mail.
