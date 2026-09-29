# modulo veicoli

Il modulo veicoli gestisce l'anagrafica dei mezzi: i singoli veicoli, con targa e tipologia, e l'albero
delle tipologie di veicolo. Le tipologie non servono solo a classificare i mezzi: sono il dato a cui la
logistica collega le collocazioni di magazzino ( la tabella `mastri_tipologie_veicoli` dice con quali
tipi di mezzo si raggiunge un magazzino ), ed è per questo che la loro tendina vive in questo modulo.

## dipendenze
Le pagine del modulo stanno sotto la dashboard `logistica`, definita da `05000.logistica`: senza quel
modulo attivo la vista dei veicoli resta senza genitore. Nessun altro modulo è richiesto; l'eventuale
costruttore di un veicolo è un'anagrafica, ma la maschera oggi non lo gestisce.

La funzione `tendinaTipologieVeicoli()` è usata anche fuori dal modulo, dalla scheda veicoli dei
magazzini del modulo legacy `0500.mastri`: con quel modulo attivo e questo spento la scheda va in errore
per funzione inesistente.

## tabelle del database
| tabella | contenuto |
|---|---|
| `veicoli` | i veicoli: tipologia, targa, nome, modello, costruttore ( `id_costruttore`, un'anagrafica ), descrizione, dati di archiviazione |
| `tipologie_veicoli` | l'albero delle tipologie, con `id_genitore`, nome, ordine e icona ( entità HTML o Font Awesome ) |

Le viste `veicoli_view` e `tipologie_veicoli_view` costruiscono l'etichetta `__label__` usata negli
elenchi e nelle tendine: per un veicolo è costruttore, nome, modello e targa separati da trattino, per
una tipologia è il percorso completo nell'albero, calcolato dalla funzione SQL `tipologie_veicoli_path()`.
Schema e viste stanno nei file di `_usr/_database/_patch/`; i diritti in `/_src/_config/_250.auth.php`
danno il controllo completo a `roots` e `staff`.

## pagine
Tutte le pagine sono aperte ai gruppi `roots` e `staff`; la vista dei veicoli compare nel menu di
amministrazione come **veicoli** ( priorità 800 ), sotto `logistica`.

| pagina | cosa mostra |
|---|---|
| `logistica.veicoli.view` | i veicoli non archiviati, ordinati per etichetta |
| `logistica.veicoli.form` | la scheda di un veicolo: tipologia, targa e nome |
| `logistica.tipologie.veicoli.view` | l'albero delle tipologie, per percorso |
| `logistica.tipologie.veicoli.form` | la scheda di una tipologia: genitore e nome |

Le maschere usano i template `logistica.veicoli.form.twig` e `logistica.tipologie.veicoli.form.twig` del
modulo, sotto `_src/_tpl/_athena/`; le viste i template generici del tema.

> **attenzione** — il modulo dichiara più pagine di quante ne implementi. Le schede
> `logistica.veicoli.view.archiviate`, `logistica.veicoli.tools` e
> `logistica.tipologie.veicoli.form.tools` puntano a macro che non esistono
> ( `_logistica.veicoli.view.archiviate.php`, `_logistica.veicoli.tools.php`,
> `_logistica.tipologie.veicoli.tools.php` ), e le schede `logistica.veicoli.form.archiviazione` e
> `logistica.veicoli.form.tools` elencate fra quelle della maschera del veicolo non sono definite
> affatto. Di conseguenza un veicolo archiviato sparisce dalla vista e non ha una pagina da cui
> ritrovarlo.

> **nota** — le maschere espongono solo una parte delle colonne: modello, costruttore e descrizione del
> veicolo, ordine e icone della tipologia si possono scrivere solo per altra via.

## i file del modulo

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.tipologie.veicoli.form.php
Macro della maschera `logistica.tipologie.veicoli.form`: imposta `tipologie_veicoli` come tabella gestita,
carica la tendina delle tipologie per la scelta del genitore e passa alla macro di default del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.tipologie.veicoli.view.php
Macro della vista `logistica.tipologie.veicoli.view`: elenca `tipologie_veicoli` per `__label__`, cioè per
percorso nell'albero, e apre le righe sulla maschera della tipologia. La colonna *azioni* c'è ma resta
vuota: il ciclo che dovrebbe riempirla non aggiunge alcun pulsante.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.form.php
Macro della maschera `logistica.veicoli.form`: imposta `veicoli` come tabella gestita, carica la tendina
delle tipologie e passa alla macro di default del form.

### /_mod/_VE000.veicoli/_src/_inc/_macro/_logistica.veicoli.view.php
Macro della vista `logistica.veicoli.view`: elenca i veicoli con `data_archiviazione` vuota, ordinati per
etichetta, e apre le righe sulla maschera del veicolo. Come nella vista delle tipologie, la colonna
*azioni* è predisposta ma vuota.

### /_mod/_VE000.veicoli/_src/_inc/_pages/_logistica.it-IT.php
Definisce le pagine del modulo sotto la dashboard `logistica` ( vedi la tabella delle pagine sopra ),
compresa la voce di menu. Dichiara anche le schede degli archiviati e degli strumenti, le cui macro non
esistono nel modulo.

### /_mod/_VE000.veicoli/_src/_lib/_mysql.utils.add.php
Libreria del modulo, inclusa da `/_src/_config.php` insieme alle altre librerie dei moduli attivi ( il
nome `.add` qui è solo una convenzione di nome, non l'aggancio a una libreria del core ). Contiene `tendinaTipologieVeicoli()`, che restituisce `id` e `__label__` di tutte le tipologie da
`tipologie_veicoli_view`, ordinate per percorso, passando per la cache delle query indicizzate.
