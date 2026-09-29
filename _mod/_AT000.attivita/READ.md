# modulo attivita

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_AT000.attivita/_src/_api/_task/_attivita.archiviazione.php
Questo task si occupa di archiviare dei gruppi di attività.

### /_mod/_AT000.attivita/_src/_api/_task/_attivita.view.static.popolazione.php
Questo task si occupa di popolare la view statica delle attività.

### /_mod/_AT000.attivita/_src/_inc/_controllers/_attivita.finally.php
Questa controller viene eseguita al finally di ogni elaborazione dell'entità attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_anagrafica.form.attivita.php
Questa è la macro della scheda attività della gestione anagrafica: elenca le attività in cui il
contatto è il cliente ( `id_cliente` ) e le apre, o ne inserisce di nuove, con la scheda attività
del modulo, `produzione.attivita.form`.

### /_mod/_AT000.attivita/_src/_inc/_macro/_anagrafica.form.lavoro.php
Questa è la macro della scheda lavoro della gestione anagrafica: elenca le attività di cui il
contatto è esecutore o incaricato ( `id_anagrafica` o `id_anagrafica_programmazione` ) e le apre, o
ne inserisce di nuove, con la stessa scheda `produzione.attivita.form`.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.form.archiviazione.php
Questa è la macro della scheda archiviazione della gestione attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.form.php
Questa è la macro della pagina di gestione attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.form.tools.php
Questa è la macro della pagina strumenti della gestione attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.tools.php
Questa è la macro della pagina strumenti della view attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.view.archiviate.php
Questa è la macro della view delle attività archiviate.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.attivita.view.php
Questa è la macro della view delle attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.tipologie.attivita.form.php
Questa è la macro della pagina di gestione delle tipologie di attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.tipologie.attivita.form.tools.php
Questa è la macro della pagina degli strumenti della gestione delle tipologie di attività.

### /_mod/_AT000.attivita/_src/_inc/_macro/_produzione.tipologie.attivita.view.php
Questa è la macro della view delle tipologie di attività.

### /_mod/_AT000.attivita/_src/_inc/_pages/_anagrafica.it-IT.php
Qui vengono definite le pagine del modulo attività.

### /_mod/_AT000.attivita/_src/_inc/_pages/_produzione.it-IT.php
Qui vengono definite le pagine del modulo attività relative al modulo produzione: la vista
`produzione.attivita.view` ( voce di menu sotto `produzione` ) con le linguette tipologie, stampe,
archiviate e azioni, la scheda `produzione.attivita.form` con archiviazione e azioni, e la scheda
delle tipologie. Ogni pagina è dichiarata una volta sola.

### /_mod/_AT000.attivita/_src/_lib/_mysql.utils.add.php
In questa libreria vengono definite funzioni specifiche per le attività da aggiungere a /_src/_lib/_mysql.utils.php.
