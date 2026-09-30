# modulo veicoli

Il modulo veicoli gestisce l'anagrafica dei mezzi: i singoli veicoli, con targa, tipologia, costruttore e
modello, e l'albero delle tipologie di veicolo. Le tipologie non servono solo a classificare i mezzi: sono
il dato a cui la logistica collega le collocazioni di magazzino ( la tabella `mastri_tipologie_veicoli` dice
con quali tipi di mezzo si raggiunge un magazzino ), ed è per questo che la loro tendina vive in questo
modulo.

## dipendenze
Le pagine del modulo stanno sotto la dashboard `logistica`, definita da `05000.logistica`: senza quel
modulo attivo la vista dei veicoli resta senza genitore. Nessun altro modulo è richiesto.

Il costruttore di un veicolo è un'anagrafica: la tendina della maschera è quella dei produttori, la stessa
che usano le maschere di prodotti e marchi di `PR000.prodotti`, e legge da `anagrafica_view_static` le
anagrafiche con una categoria che ha `se_produttore`. Un costruttore che non sta in una categoria di
produttori non compare nella tendina.

La scheda veicoli dei magazzini del modulo legacy `0500.mastri` non usa `tendinaTipologieVeicoli()`: legge
`tipologie_veicoli_view` direttamente, perché con questo modulo spento la funzione non esiste. Tutte le
`tendinaTipologie…()` dei moduli della linea nuova stanno nella libreria del proprio modulo, e nella libreria del
core stanno solo le tendine che non appartengono a un modulo ( stati, province, anni, mesi… ).

## tabelle del database
| tabella | contenuto |
|---|---|
| `veicoli` | i veicoli: tipologia, targa, nome, modello, costruttore ( `id_costruttore`, un'anagrafica ), descrizione, dati di archiviazione |
| `tipologie_veicoli` | l'albero delle tipologie, con `id_genitore`, nome, ordine e icona ( entità HTML o Font Awesome ) |

Le viste `veicoli_view` e `tipologie_veicoli_view` costruiscono l'etichetta `__label__` usata negli
elenchi e nelle tendine: per un veicolo è costruttore, nome, modello e targa separati da trattino, per
una tipologia è il percorso completo nell'albero, calcolato dalla funzione SQL `tipologie_veicoli_path()`.
Schema e viste stanno nei file di `_usr/_database/_patch/`; i diritti in `/_src/_config/_250.auth.php`
danno il controllo completo a `roots` e `staff`. Le colonne sono descritte nei capitoli della reference
del database, alle voci `veicoli` e `tipologie_veicoli`.

> **nota** — `veicoli`, `tipologie_veicoli` e `mastri_tipologie_veicoli` hanno chiave primaria,
> AUTO_INCREMENT e indici dal 29/09/2026 ( `_030000999999.indexes.sql`, e per i deploy esistenti
> `_202609291500.chiavi.primarie.sql` ); fino ad allora le maschere non potevano inserire righe nuove.
> Vincoli sulle chiavi esterne non ce ne sono, come per le altre tabelle dei mastri. Dove una tabella
> aveva già id ripetuti la patch non aggiunge la chiave e lo dice: i doppioni vanno risolti a mano.

## pagine
Tutte le pagine sono aperte ai gruppi `roots` e `staff`; la vista dei veicoli compare nel menu di
amministrazione come **veicoli** ( priorità 800 ), sotto `logistica`. La struttura è quella dei moduli
della linea nuova con un'entità archiviabile e le sue tipologie ( lo stesso schema di `AT000.attivita`
e di `NO000.notizie` ).

| pagina | cosa mostra |
|---|---|
| `logistica.veicoli.view` | i veicoli non archiviati, ordinati per etichetta |
| `logistica.veicoli.view.archiviati` | i veicoli archiviati, cioè con `data_archiviazione` valorizzata |
| `logistica.veicoli.tools` | gli strumenti dell'elenco dei veicoli |
| `logistica.veicoli.form` | la scheda di un veicolo: tipologia, targa, nome, costruttore, modello e descrizione |
| `logistica.veicoli.form.archiviazione` | data e note di archiviazione del veicolo |
| `logistica.veicoli.form.tools` | gli strumenti della scheda del veicolo |
| `logistica.tipologie.veicoli.view` | l'albero delle tipologie, per percorso |
| `logistica.tipologie.veicoli.form` | la scheda di una tipologia: genitore, nome, ordine e icone |
| `logistica.tipologie.veicoli.form.tools` | gli strumenti della scheda della tipologia |

Un veicolo si archivia dalla scheda *archiviazione*, scrivendo la data: da quel momento sparisce da
`logistica.veicoli.view` e si ritrova in `logistica.veicoli.view.archiviati`, da cui si riapre la sua
scheda; svuotando la data torna fra i veicoli attivi.

Le maschere usano i template `logistica.veicoli.form.twig`, `logistica.veicoli.form.archiviazione.twig`
e `logistica.tipologie.veicoli.form.twig` del modulo, sotto `_src/_tpl/_athena/`; le viste e le pagine
degli strumenti i template generici del tema ( `default.view.twig`, `default.tools.twig` ).

> **nota** — le pagine degli strumenti dichiarano i gruppi di controlli canonici ( esportazioni,
> importazioni, elaborazioni, viste statiche ) ma non vi aggiungono alcun controllo, come negli altri
> moduli della linea nuova. Allo stesso modo la colonna *azioni* delle due viste resta vuota: il ciclo che
> la riempie è lo stesso, vuoto, di tutte le viste della linea nuova, e non c'è un'azione di riga canonica
> da mettervi.

## i file del modulo

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.tipologie.veicoli.form.php
Macro della maschera `logistica.tipologie.veicoli.form`: imposta `tipologie_veicoli` come tabella gestita,
carica la tendina delle tipologie per la scelta del genitore e passa alla macro di default del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.tipologie.veicoli.form.tools.php
Macro della pagina `logistica.tipologie.veicoli.form.tools`: imposta `tipologie_veicoli` come tabella
gestita, dichiara i gruppi di controlli e passa alle macro di default degli strumenti e del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.tipologie.veicoli.view.php
Macro della vista `logistica.tipologie.veicoli.view`: elenca `tipologie_veicoli` per `__label__`, cioè per
percorso nell'albero, e apre le righe sulla maschera della tipologia.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.form.archiviazione.php
Macro della scheda `logistica.veicoli.form.archiviazione`: imposta `veicoli` come tabella gestita e passa
alla macro di default del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.form.php
Macro della maschera `logistica.veicoli.form`: imposta `veicoli` come tabella gestita, carica la tendina
delle tipologie e quella dei produttori per il costruttore, e passa alla macro di default del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.form.tools.php
Macro della pagina `logistica.veicoli.form.tools`: imposta `veicoli` come tabella gestita, dichiara i
gruppi di controlli e passa alle macro di default degli strumenti e del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.tools.php
Macro della pagina `logistica.veicoli.tools`: dichiara i gruppi di controlli degli strumenti dell'elenco.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.view.archiviati.php
Macro della vista `logistica.veicoli.view.archiviati`: elenca i veicoli con `data_archiviazione`
valorizzata, ordinati per etichetta, e apre le righe sulla maschera del veicolo.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.view.php
Macro della vista `logistica.veicoli.view`: elenca i veicoli con `data_archiviazione` vuota, ordinati per
etichetta, e apre le righe sulla maschera del veicolo.

### /_mod/_VE000.veicoli/_src/_inc/_pages/_logistica.it-IT.php
Definisce le pagine del modulo sotto la dashboard `logistica` ( vedi la tabella delle pagine sopra ),
compresa la voce di menu.

### /_mod/_VE000.veicoli/_src/_lib/_mysql.utils.add.php
Libreria del modulo, inclusa da `/_src/_config.php` insieme alle altre librerie dei moduli attivi ( il
nome `.add` qui è solo una convenzione di nome, non l'aggancio a una libreria del core ). Contiene `tendinaTipologieVeicoli()`, che restituisce `id` e `__label__` di tutte le tipologie da
`tipologie_veicoli_view`, ordinate per percorso, passando per la cache delle query indicizzate.

### /_mod/_VE000.veicoli/_src/_tpl/_athena/logistica.tipologie.veicoli.form.twig
Template della maschera di una tipologia: genitore e nome, poi ordine, entità HTML e icona Font Awesome.

### /_mod/_VE000.veicoli/_src/_tpl/_athena/logistica.veicoli.form.archiviazione.twig
Template della scheda di archiviazione del veicolo: data e note di archiviazione.

### /_mod/_VE000.veicoli/_src/_tpl/_athena/logistica.veicoli.form.twig
Template della maschera di un veicolo: tipologia, targa e nome; costruttore e modello; descrizione.
