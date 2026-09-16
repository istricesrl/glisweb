# modulo logistica

> **nota** — la reference dei file di questo modulo è stata travasata il 2026-09-16 dal
> `READ.md` che stava nella radice del framework. I percorsi sono verificati contro l'albero.

> **attenzione** — di questo modulo è documentata per ora la sola struttura dei file. A cosa
> serve, come si configura e come lo si usa sono da scrivere.

## i file del modulo

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.php
Questa è la macro della dashboard del modulo logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.archivio.php
Questa è la macro della dashboard dell'archivio logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.archivio.tools.php
Questa è la macro della scheda strumenti dell'archivio logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.ciclo.attivo.php
Questa è la macro della dashboard del ciclo attivo della logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.ciclo.attivo.tools.php
Questa è la macro della scheda strumenti della dashboard del ciclo attivo della logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.ciclo.passivo.php
Questa è la macro della dashboard del ciclo passivo della logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.ciclo.passivo.tools.php
Questa è la macro della scheda strumenti della daashboard del ciclo passivo della logistica.

### /_mod/_05000.logistica/_src/_inc/_macro/_logistica.tools.php
Questa è la macro della scheda strumenti della dashboard della logistica.

### /_mod/_05000.logistica/_src/_inc/_pages/_logistica.it-IT.php
In questo file vengono definite le pagine del modulo logistica.

## come si fa

> **nota** — travasato il 2026-09-16 dalla FAQ, dove era una domanda: la procedura sta nel
> capitolo del suo argomento, che esisteva gia'.

### come funziona l'aggiornamento dei report di magazzino?
Di base l'aggiornamento dei report di magazzino viene attivata dalla controller su documenti_articoli nel modulo mastri. In pratica ogni volta che
una riga di documento viene salvata, le relative informazioni di magazzino vengono aggiornate.
