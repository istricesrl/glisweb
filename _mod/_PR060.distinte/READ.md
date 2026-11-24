# modulo distinte

Il modulo aggiunge la **distinta base** alla scheda articolo del modulo `PR000.prodotti`, da cui dipende: senza
prodotti non dichiara nessuna pagina. Fino al 2026-11-24 la scheda stava dentro `PR000.prodotti` e compariva su ogni
deploy col catalogo; la tabella `distinta` non è cambiata. Nella linea legacy lo stesso ruolo lo ha `_4130.distinte`.

## i file del modulo

### /_mod/_PR060.distinte/_src/_inc/_pages/_catalogo.it-IT.php
Dichiara la pagina `catalogo.articoli.form.distinta` e inserisce la sua linguetta dopo quella delle caratteristiche,
solo se `PR000.prodotti` è attivo.

### /_mod/_PR060.distinte/_src/_inc/_macro/_catalogo.articoli.form.distinta.php
Questa è la macro della scheda distinta base del modulo di gestione degli articoli. Il sotto-elenco delle righe di
distinta ( macro distinta di lib/catalogo.articoli.form.distinta.sub.twig, sul modello di quella delle relazioni ) arriva con la
scheda perché controller() segue la chiave distinta_ibfk_01 ( id_articolo, l'articolo composto ); ogni riga ha il
componente, scelto con la ricerca degli articoli ( source api articoli, come l'articolo collegato delle relazioni ), e
la quantità. La chiave di id_componente è distinta_ibfk_02_nofollow, quindi la scheda del componente non carica le
distinte in cui compare; la macro non prepara tendine.

### /_mod/_PR060.distinte/_src/_tpl/_athena/catalogo.articoli.form.distinta.twig
Il template della scheda: apre il form dell'articolo e ci mette il sotto-elenco della distinta.

### /_mod/_PR060.distinte/_src/_tpl/_athena/lib/catalogo.articoli.form.distinta.sub.twig
La macro `distinta` del sotto-elenco, travasata da `lib/catalogo.articoli.form.sub.twig` di `PR000.prodotti`.

### /_mod/_PR060.distinte/_usr/_test/_tests/backend/catalogoArticoliFormDistintaCest.php
Il test della scheda: la linguetta compare nella scheda articolo e mostra il componente con la sua quantità.
