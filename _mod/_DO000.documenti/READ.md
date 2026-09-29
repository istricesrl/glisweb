# modulo documenti

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.aggregate.php
Questa è la macro della scheda aggregate della pagina di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.php
Questa è la macro della pagina di gestione delle righe dei documenti. La tendina dei reparti propone solo
quelli con un'aliquota IVA non archiviata ( `iva.timestamp_archiviazione` vuoto ): dal 2026-09-30 sono
archiviate le aliquote con la natura generica N6, che lo SDI scarta, e quella dell'art. 71 con la natura
N3.6. Il reparto già scelto per la riga resta nella tendina, con la scritta *aliquota archiviata*, perché
salvando la scheda non vada perso; è lo stesso criterio della tendina delle entità delle pianificazioni.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.stampe.php
Questa è la macro della scheda stampe della pagine di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.articoli.view.php
Questa è la macro della view delle righe dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.archiviazione.php
Questa è la macro della scheda archiviazione della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.dati.fiscali.php
Questa è la macro della scheda dati fiscali della pagina di gestione dei documenti: il bollo virtuale
( `documenti.se_bollo_virtuale` e `importo_bollo` ) e, come sotto moduli, le ritenute
( `documenti_ritenute` ) e i contributi alle casse previdenziali ( `documenti_casse_previdenziali` ), cioè
i dati dei blocchi DatiBollo, DatiRitenuta e DatiCassaPrevidenziale della fattura elettronica. Le tendine
sono le tabelle standard `ritenute` e `casse_previdenziali`, le aliquote IVA non archiviate ( più quelle
già usate dai contributi del documento ) e le causali della Certificazione Unica ammesse dallo schema,
senza `Z`. Importi e imponibili lasciati vuoti li calcola `generaContenutiDocumento()` di
`_mod/_0400.documenti` quando genera la fattura elettronica; il template e il sotto modulo sono
`amministrazione.archivio.documenti.form.dati.fiscali.twig` e
`lib/amministrazione.archivio.documenti.form.dati.fiscali.sub.twig`, ricalcati sulla scheda relazioni.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.documenti.articoli.php
Questa è la macro della scheda articoli della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.evasione.php
Questa è la macro della scheda evasione della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.pagamenti.php
Questa è la macro della scheda pagamenti della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.php
Questa è la macro della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.relazioni.php
Questa è la macro della scheda relazioni della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.php
Questa è la macro della pagina di gestione dei pagamenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione dei pagamenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.pagamenti.view.php
Questa è la macro della view dei pagamenti.

### /_mod/_DO000.documenti/_src/_inc/_macro/_amministrazione.archivio.documenti.view.php
Questa è la macro della view dei documenti.

### /_mod/_DO000.documenti/_src/_inc/_pages/_amministrazione.it-IT.php
Questa è la macro della dashboard dell'amministrazione.

### /_mod/_DO000.documenti/_src/_lib/_mysql.utils.add.php
Questa libreria contiene le funzioni che calcolano il numero di un nuovo documento, copiate da `_0400.documenti` perché
le pianificazioni di documenti di `_PI000.pianificazioni` funzionino anche senza il modulo legacy.
