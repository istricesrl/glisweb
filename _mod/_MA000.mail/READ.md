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
Questo task riaccoda per l'invio una mail già inviata.

### /_mod/_MA000.mail/_src/_api/_task/_mail.queue.send.php
Questo task elabora la coda delle mail in uscita, inviando il primo messaggio in lista.

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
