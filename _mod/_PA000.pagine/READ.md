# modulo pagine

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_PA000.pagine/_src/_config/_310.pages.php
In questo file la struttura delle pagine viene caricata nell'albero dei contenuti del sito.

### /_mod/_PA000.pagine/_src/_config/_420.pages.php
In questo file vengono caricati i dati specifici della pagina corrente.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.archivio.menu.view.php
Questa è la macro della view dei menu dell'archivio contenuti.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.menu.form.php
Questa è la macro della scheda di una voce di menu ( contenuti.menu.form ), che l'elenco dell'archivio menu apre; prima
la pagina era citata dalla vista ma non esisteva. È un form semplice sulla tabella menu sul modello di
contenuti.redirect.form, con le tendine della linguetta menu delle pagine ( sottopagine, target, lingue ) e quella delle
categorie notizie; pagina e categoria prodotti si cercano via API. Il nome del menu è un campo di testo perché l'elenco
dei menu dipende dal template della pagina collegata, che qui non è noto a priori.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.menu.form.tools.php
Questa è la macro della scheda strumenti della voce di menu, sul canone delle schede tools.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.menu.php
Questa è la macro della scheda menu del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.php
Questa è la macro del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.tools.php
QUesta è la macro della scheda strumenti della view delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.view.archiviate.php
Questa è la macro della view delle pagine archiviate.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.pagine.view.php
Questa è la macro della view delle pagine.

### /_mod/_PA000.pagine/_src/_inc/_macro/_contenuti.redirect.view.php
Questa è la macro della view dei redirect.

### /_mod/_PA000.pagine/_src/_inc/_pages/_contenuti.it-IT.php
In questo file vengono deifinite le pagine relative alla gestione delle pagine.

### /_mod/_PA000.pagine/_src/_lib/_mysql.utils.add.php
Questa è una libreria di funzioni MySQL aggiuntive del modulo pagine.
