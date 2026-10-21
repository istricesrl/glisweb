# modulo listini

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## vendita e acquisto

Lo stesso listino sta nel catalogo o negli acquisti secondo il suo `id_emittente`: è **di acquisto**
se ha un emittente e l'emittente non è fra le aziende gestite ( `tendinaAziendeGestite()` ), è **di
vendita** in tutti gli altri casi, compreso l'emittente vuoto. Le viste di acquisto lo dicono con
`__restrict__` ( `id_emittente` `NN` più `NI` delle aziende gestite ); quelle di vendita, che
dovrebbero dire "vuoto oppure fra le gestite" e con `__restrict__` non possono, escludono con `NI`
gli ID restituiti da `listiniAcquistoId()`. Così ogni listino compare in uno e un solo elenco, sia
fra gli attivi sia fra gli archiviati.

## i file del modulo

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.form.archiviazione.php
Questa è la macro della scheda archiviazione del form di gestione dei listini di acquisto.

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.form.php
Questa è la macro del form di gestione dei listini di acquisto: le stesse tendine del form di vendita;
l'emittente, obbligatorio, si sceglie dall'API dell'anagrafica.

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.form.tools.php
Questa è la macro della pagina degli strumenti del form di gestione dei listini di acquisto; configura i
gruppi esportazioni, importazioni, elaborazioni e viste statiche.

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.stampe.php
Questa è la macro della scheda stampe dei listini di acquisto.

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.tools.php
Questa è la macro della pagina degli strumenti dei listini di acquisto.

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.view.archiviati.php
Questa è la macro della view dei listini di acquisto archiviati; apre `acquisti.listini.acquisto.form`.

### /_mod/_LI000.listini/_src/_inc/_macro/_acquisti.listini.acquisto.view.php
Questa è la macro della view dei listini di acquisto.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.form.php
Questa è la macro del form di gestione dei listini di vendita del catalogo; la tendina `emittenti` è
quella delle aziende gestite.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.form.archiviazione.php
Questa è la macro della scheda archiviazione del form di gestione dei listini di vendita del catalogo.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.form.stampe.php
Questa è la macro della scheda stampe del form di gestione dei listini di vendita del catalogo; configura
il metro di stampa PDF e include le macro di default.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.form.tools.php
Questa è la macro della pagina degli strumenti del form di gestione dei listini di vendita del catalogo;
configura i metro per esportazioni, importazioni, elaborazioni, viste statiche e gestione account.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.stampe.php
Questa è la macro della scheda stampe dei listini di vendita del catalogo.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.tools.php
Questa è la macro della pagina degli strumenti dei listini di vendita del catalogo.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.view.archiviati.php
Questa è la macro della view dei listini di vendita archiviati del catalogo.

### /_mod/_LI000.listini/_src/_inc/_macro/_catalogo.listini.vendita.view.php
Questa è la macro della view dei listini di vendita del catalogo.

### /_mod/_LI000.listini/_src/_inc/_pages/_acquisti.it-IT.php
In questo file vengono definite le pagine del modulo listini relative agli acquisti.

### /_mod/_LI000.listini/_src/_inc/_pages/_catalogo.it-IT.php
In questo file vengono definite le pagine del modulo listini relative al catalogo.

### /_mod/_LI000.listini/_src/_lib/_mysql.utils.add.php
Questa è una libreria di funzioni MySQL aggiuntive per il modulo listini: `tendinaTipologieListini()`
e `listiniAcquistoId()`, che restituisce gli ID dei listini di acquisto per le viste di vendita.

### /_mod/_LI000.listini/_src/_tpl/_athena/acquisti.listini.acquisto.form.archiviazione.twig
Template della scheda di archiviazione del listino di acquisto: data e note di archiviazione.

### /_mod/_LI000.listini/_src/_tpl/_athena/acquisti.listini.acquisto.form.twig
Template della maschera di un listino di acquisto: genitore, tipologia, codice, nome e valuta;
emittente obbligatorio; note.

### /_mod/_LI000.listini/_src/_tpl/_athena/catalogo.listini.vendita.form.twig
Template della maschera di un listino di vendita: genitore, tipologia, codice, nome e valuta;
emittente fra le aziende gestite; note.
