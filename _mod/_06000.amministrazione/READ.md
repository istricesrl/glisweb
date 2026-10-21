# modulo amministrazione

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.php
Questa è la macro dell'archivio dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.reparti.form.php
Questa è la macro della scheda di un reparto ( `amministrazione.archivio.reparti.form` ): gestisce la
tabella `reparti` e prepara le tendine `iva` ( da `iva_view` ) e `settori` ( da `settori_view` ), poi
passa a `_default.form.php`. Il template è `amministrazione.archivio.reparti.form.twig`; accanto alla
scheda c'è la linguetta `amministrazione.archivio.reparti.form.tools`, e tutt'e due hanno per genitore
la vista `amministrazione.archivio.reparti.view`, come le altre schede di tabelle semplici.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.reparti.form.tools.php
Questa è la macro della linguetta azioni della scheda di un reparto: gruppi esportazioni,
importazioni, elaborazioni e viste statiche, vuoti nello standard.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.reparti.view.php
Questa è la macro della pagina di vista dell'archivio reparti.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.archivio.tools.php
Questa è la macro della pagina degli strumenti dell'archivio amministrazione

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.attivo.php
Questa è la macro della dashboard del ciclo attivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.attivo.tools.php
Questa è la macro della pagina degli strumenti della dashboard del ciclo attivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.passivo.php
Questa è la macro della dashboard del ciclo passivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.ciclo.passivo.tools.php
Questa è la macro della pagina degli strumenti del ciclo passivo dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.php
Questa è la macro della dashbaord dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.stampe.php
Questa è la macro della scheda stampe della dashboard dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_macro/_amministrazione.tools.php
Questa è la macro della pagina degli strumenti della dashboard dell'amministrazione.

### /_mod/_06000.amministrazione/_src/_inc/_pages/_amministrazione.it-IT.php
Qui vengono definite le pagine del modulo amministrazione.

### /_mod/_06000.amministrazione/_src/_tpl/_athena/amministrazione.archivio.reparti.form.twig
Template della scheda di un reparto: nome, aliquota IVA e settore, poi le note.
