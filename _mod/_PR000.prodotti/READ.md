# modulo prodotti

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_PR000.prodotti/_src/_config/_030.common.php
In questo file vengono definite le variabili comuni del modulo prodotti.

### /_mod/_PR000.prodotti/_src/_config/_035.common.php
In questo file la configurazione comune del modulo prodotti viene integrata con la configurazione letta da file.

### /_mod/_PR000.prodotti/_src/_config/_310.pages.php
In questo file l'albero delle categorie dei prodotti e dei prodotti viene integrato con l'albero generale dei
contenuti del sito.

### /_mod/_PR000.prodotti/_src/_inc/_controllers/_articoli.finally.php
Questa controller viene eseguita alla fine di ogni gruppo di elaborazioni della tabella articoli.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione degli articoli.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.barcode.php
Questa è la macro della scheda barcode del modulo di gestione degli articoli. I codici a barre dell'articolo sono le
colonne ean e isbn della tabella articoli ( non c'è una tabella dei barcode ): la scheda è un form semplice sulla tabella
articoli, sul modello della scheda archiviazione, e l'EAN non sta più nella linguetta principale.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.caratteristiche.php
Questa è la macro della scheda caratteristiche del modulo di gestione degli articoli. Il sotto-elenco delle righe di
articoli_caratteristiche ( macro caratteristiche di lib/catalogo.articoli.form.sub.twig ) arriva con la scheda perché
controller() segue la chiave articoli_caratteristiche_ibfk_01; la tendina legge caratteristiche_view filtrata su
se_articoli, perché la chiave esterna di id_caratteristica punta alla tabella caratteristiche.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.distinta.php
Questa è la macro della scheda distinta base del modulo di gestione degli articoli. Il sotto-elenco delle righe di
distinta ( macro distinta di lib/catalogo.articoli.form.sub.twig, sul modello di quella delle relazioni ) arriva con la
scheda perché controller() segue la chiave distinta_ibfk_01 ( id_articolo, l'articolo composto ); ogni riga ha il
componente, scelto con la ricerca degli articoli ( source api articoli, come l'articolo collegato delle relazioni ), e
la quantità. La chiave di id_componente è distinta_ibfk_02_nofollow, quindi la scheda del componente non carica le
distinte in cui compare; la macro non prepara tendine.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.php
Questa è la macro del modulo di gestione degli articoli.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.relazioni.php
Questa è la macro della scheda relazioni del modulo di gestione articoli: prepara la tendina dei ruoli ( ruoli_articoli_view )
per il sotto-elenco delle righe di relazioni_articoli ( macro relazioni di lib/catalogo.articoli.form.sub.twig, sul
modello di /_mod/_AN000.anagrafica/_src/_tpl/_athena/lib/anagrafica.form.relazioni.sub.twig ). Siccome controller()
segue sia relazioni_articoli_ibfk_01 sia _ibfk_02, nel sotto-elenco compaiono anche le relazioni in cui l'articolo è
quello collegato: per questo la riga mostra anche l'articolo principale.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione articoli.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.articoli.view.php
Questa è la macro della vista articoli.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione categorie prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.php
Questa è la macro del modulo di gestione categorie prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.prodotti.php
Questa è la macro della scheda prodotti del modulo di gestione categorie prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione categorie prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.tools.php
Questa è la macro della scheda strumenti della vista prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.view.archiviati.php
Questa è la macro della vista delle categorie prodotti archiviate.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.categorie.prodotti.view.php
Questa è la macro della vista categorie prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione marchi.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.php
Questa è la macro del modulo di gestione marchi.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.prodotti.php
Questa è la macro della scheda prodotti del modulo di gestione marchi.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione marchi.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.tools.php
Questa è la macro della scheda strumenti della vista marchi.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.view.archiviati.php
Questa è la macro della vista marchi archiviati.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.marchi.view.php
Questa è la macro della vista marchi.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.archiviazione.php
Questa è la macro della scheda archiviazione del modulo di gestione prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.articoli.php
Questa è la macro della scheda articoli del modulo di gestione prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.caratteristiche.php
Questa è la macro della scheda caratteristiche del modulo di gestione prodotti: il sotto-elenco delle righe di
prodotti_caratteristiche ( macro caratteristiche di lib/catalogo.prodotti.form.sub.twig ) arriva con la scheda tramite la
chiave prodotti_caratteristiche_ibfk_01; la tendina legge caratteristiche_view filtrata su se_prodotti. Le categorie del
prodotto non hanno una scheda loro: si compilano nel sotto-elenco della linguetta principale.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.php
Questa è la macro del modulo di gestione prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.relazioni.php
Questa è la macro della scheda relazioni del modulo di gestione prodotti: prepara la tendina dei ruoli ( ruoli_prodotti_view )
per il sotto-elenco delle righe di relazioni_prodotti ( macro relazioni di lib/catalogo.prodotti.form.sub.twig ), che
come per gli articoli comprende anche le relazioni in cui il prodotto è quello collegato ( relazioni_prodotti_ibfk_02 ).

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.form.tools.php
Questa è la macro della scheda strumenti del modulo di gestione prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.stampe.php
Questa è la macro della scheda stampe della vista prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.tools.php
Questa è la macro della scheda strumenti della vista prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.view.archiviati.php
Questa è la macro della vista prodotti archiviati.

### /_mod/_PR000.prodotti/_src/_inc/_macro/_catalogo.prodotti.view.php
Questa è la macro della vista prodotti.

### /_mod/_PR000.prodotti/_src/_inc/_pages/_catalogo.it-IT.php
Questa è la macro della dashboard catalogo.

### /_mod/_PR000.prodotti/_src/_lib/_mysql.utils.add.php
Questa è una libreria aggiuntiva di funzioni per MySQL relative ai prodotti.
