# manuale sviluppatore

Questo è il manuale di chi **sviluppa** con GlisWeb: il framework visto dal lato del codice, da tenere
sotto mano mentre lo si studia e mentre ci si lavora.

> **nota** — per partire da zero c'è la guida introduttiva, che è breve e serve a far partire, non a
> coprire tutto. Questo manuale invece copre, e non si legge dall'inizio: si consulta.

## architettura generale

Il framework GlisWeb, come ogni web application, risponde su chiamata e termina l'esecuzione inviando
l'output al richiedente. Quando il framework riceve una chiamata, questa viene gestita in primo luogo
dal file `/.htaccess` (su Apache) o dal file `/index.php` (su Nginx).

L'esecuzione viene a quel punto passata a una API in grado di gestire la richiesta; ad esempio, se
viene richiesta una pagina web, l'esecuzione passerà a `/_src/_api/_pages.php`.

Una volta passata l'esecuzione all'API di competenza, questa si occupa innanzitutto di fare il
bootstrap del framework includendo il file `/_src/_config.php`, il quale provvede a:

- dichiarare le funzioni core
- includere i file di configurazione
- includere le librerie
- predisporre l'ambiente
- eseguire i runlevel

Il funzionamento di `/_src/_config.php` è troppo complicato per essere riassunto qui, ma leggere quel
file dovrebbe essere il primo passo per chi vuole studiare il funzionamento del framework.

Una volta che l'esecuzione del kernel del framework è terminata, il controllo torna all'API chiamante,
che ha facoltà di eseguire tutte le operazioni che vuole prima di terminare inviando l'output al
richiedente.

## com'è organizzato questo manuale

I capitoli seguono cinque fasce, e il numero in testa al nome serve solo a tenerle in ordine:

| fascia | cosa ci sta |
|---|---|
| `0xx` | i fondamenti: installazione, aggiornamento, cartelle, entità, moduli |
| `1xx` | le funzioni del framework, una per capitolo: cache, task, job, autenticazione, mail, stampe, template, privacy, deploy, test |
| `2xx` | la reference: le variabili globali, e i file del framework descritti uno per uno |
| `3xx` | la reference del database, spezzata per iniziale della tabella |
| `4xx` e `5xx` | le guide pratiche e le integrazioni con i servizi esterni |
| `9xx` | le raccomandazioni |

Dopo i capitoli numerati vengono quelli dei **template** e dei **moduli**. Quelli non sono scritti qui:
il loro sorgente vive dentro il template e dentro il modulo, accanto al codice che descrivono, e il
manuale li raccoglie senza copiarli. È la regola che tiene insieme tutta la documentazione — **una cosa
sta in un posto solo** — ed è il motivo per cui un modulo che non è attivo su questa installazione non
ha un capitolo.

## la reference dei file, e come si legge

La fascia `2xx` descrive i file del framework **uno per uno**, in ordine di albero. Non sostituisce i
commenti nel codice, che restano la fonte di dettaglio: serve a dare l'idea dell'insieme e a rispondere
alla domanda «questo file cosa ci sta a fare».

Vale la pena sapere che quella reference è **verificata meccanicamente**: `_src/_sh/_docs.check.sh`
confronta le sezioni con l'albero vero e segnala sia i file che nessuno descrive, sia le sezioni che
descrivono file che non esistono più. Con `--copertura` stampa l'inventario completo, file per file,
dicendo dove ciascuno è documentato.

## le convenzioni che ricorrono ovunque

Tre cose si ripetono in tutto il framework, e conoscerle risparmia la lettura di mezzo manuale:

- **l'underscore**: i file e le cartelle che cominciano con `_` sono standard e non si modificano; la
  personalizzazione vive nel file corrispondente senza underscore. Il capitolo delle cartelle spiega
  come si compongono i due;
- **i runlevel**: il bootstrap esegue i file di `_src/_config/` in ordine di numero, e ogni decina ha
  un dominio suo. Il capitolo della reference dei runlevel li descrive uno per uno;
- **i tre array globali**: `$cf` è la configurazione interna, `$ct` il sottoinsieme che arriva ai
  template, `$cx` quello che si legge dai file JSON e YAML. Il capitolo delle variabili li apre tutti
  e tre.
