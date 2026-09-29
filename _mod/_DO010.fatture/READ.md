# modulo fatture

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.articoli.view.php
Questa è la macro della view delle righe delle fatture attive: filtra `documenti_articoli_view` sulla
colonna `id_tipologia`, che nella vista è la tipologia del **documento** ( la tipologia della riga è
`id_tipologia_riga` ), con gli ID delle tipologie che hanno `se_fattura = 1`. Il clic su una riga
apre la scheda riga del modulo documenti, `amministrazione.archivio.documenti.articoli.form`.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.archiviazione.php
Questa è la macro della scheda archiviazione della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.dati.fiscali.php
Questa è la macro della scheda dati fiscali della pagina di gestione delle fatture attive, gemella di
quella del modulo documenti ( `_amministrazione.archivio.documenti.form.dati.fiscali.php` ): bollo
virtuale, ritenute e contributi alle casse previdenziali, cioè i dati dei blocchi DatiBollo, DatiRitenuta
e DatiCassaPrevidenziale della fattura elettronica. Come per le relazioni, il modulo ha una sua copia del
template e del sotto modulo.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.documenti.articoli.php
Questa è la macro della scheda articoli della pagina di gestione delle fatture attive; apre e inserisce
le righe con la scheda riga del modulo documenti, `amministrazione.archivio.documenti.articoli.form`,
invece di dichiararne una propria.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.pagamenti.php
Questa è la macro della scheda pagamenti della pagina di gestione delle fatture attive; apre e inserisce
i pagamenti con la scheda pagamento del modulo documenti, `amministrazione.archivio.documenti.pagamenti.form`.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.php
Questa è la macro della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.relazioni.php
Questa è la macro della scheda relazioni della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.stampe.php
Questa è la macro della scheda stampe della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.form.tools.php
Questa è la macro della scheda strumenti della pagina di gestione delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.pagamenti.view.php
Questa è la macro della view dei pagamenti delle fatture attive: filtra `pagamenti_view` sulla colonna
`id_tipologia_documento` ( la tipologia del documento del pagamento; `id_tipologia` nella vista è quella
del pagamento, con ripiego su quella del documento ) con gli ID delle tipologie che hanno
`se_fattura = 1`. Il clic su una riga apre `amministrazione.archivio.documenti.pagamenti.form`.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.tools.php
Questa è la macro della scheda strumenti della view delle fatture attive.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.view.archiviate.php
Questa è la macro della scheda archivio della view delle fatture attive; filtra le tipologie come la
view delle fatture.

### /_mod/_DO010.fatture/_src/_inc/_macro/_amministrazione.ciclo.attivo.fatture.view.php
Questa è la macro della view delle fatture attive. Le tipologie mostrate sono quelle con
`se_fattura = 1` in `tipologie_documenti`, lette con `mysqlSelectColumn()` e passate a `__restrict__`
come lista `IN`: è lo stesso criterio della tendina della scheda, quindi un documento salvato dalla
scheda ricompare sempre nell'elenco.

### /_mod/_DO010.fatture/_src/_inc/_pages/_amministrazione.it-IT.php
In questo file vengono dichiarate le pagine relative alle fatture per il modulo amministrazione.
