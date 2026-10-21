# modulo template

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_TE000.template/_src/_inc/_macro/_mail.template.form.php
Questa è la macro del modulo di gestione dei template mail.

### /_mod/_TE000.template/_src/_inc/_macro/_mail.template.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione template mail.

### /_mod/_TE000.template/_src/_inc/_macro/_mail.template.view.php
Questa è la macro della vista template mail.

### /_mod/_TE000.template/_src/_inc/_macro/_sms.template.form.php
Questa è la macro del modulo di gestione dei template SMS, gemella di quella dei template mail. Il template
sms.template.form.twig è la copia di mail.template.form.twig con il campo nascosto se_sms al posto di se_mail: prima
l'elenco dei template SMS apriva la scheda mail, e salvando da lì il template diventava anche un template mail.

### /_mod/_TE000.template/_src/_inc/_macro/_sms.template.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione template SMS, gemella di quella dei template mail.

### /_mod/_TE000.template/_src/_inc/_macro/_sms.template.view.php
Questa è la macro della vista template SMS: elenca i template con se_sms e li apre nella scheda sms.template.form.

### /_mod/_TE000.template/_src/_inc/_pages/_mail.it-IT.php
In questo file vengono definite le pagine relative alla gestione dei template mail.

### /_mod/_TE000.template/_src/_inc/_pages/_sms.it-IT.php
In questo file vengono definite le pagine relative alla gestione dei template SMS; la linguetta dei contenuti
( sms.template.form.contenuti ) la definisce /_mod/_CO000.contenuti/_src/_inc/_pages/_sms.it-IT.php e si inserisce solo
se il modulo dei contenuti è attivo, come per le mail.

> **attenzione** — /_src/_config/_340.sms.php legge i template SMS dal database ma il ciclo che ne carica i contenuti è
> commentato ( TODO ), quindi i testi scritti nella linguetta contenuti non arrivano ancora a queueSmsFromTemplate().
