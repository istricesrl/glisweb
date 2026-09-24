# Job in background: come si scrive uno che non si pianta

*Riferimento della skill `glisweb`, letto **su richiesta**: non sta nel preambolo di ogni sessione.
Spostato il 24/09/2026 da `_etc/_claude/_claude.framework.md`, tale e quale. Il file del framework ne tiene l'essenziale e rimanda qui.*

## Job in background: come si scrive uno che non si pianta

Un **job** è un lavoro lungo spezzato in iterazioni. A differenza di un **task**, che gira e risponde subito a
chi l'ha chiamato, un job vive in una riga della tabella `job` e viene fatto avanzare da qualcun altro, una
iterazione per volta. Chi lo ha lanciato non vede l'errore: vede una barra che si muove, o che non si muove.
Per questo un job scritto male non dà fastidio — sparisce, e ci si accorge del problema giorni dopo.

Il file di un job sta in `src/api/job/<nome>.php` (`_src/_api/_job/_<nome>.php` per gli standard, o sotto
`mod/<modulo>/src/api/job/`) e viene incluso con `require` da due motori diversi:

| chi lo fa avanzare | quando | limite di tempo |
|---|---|---|
| `_src/_api/_job.php` | il browser chiama `/job/<id>` ogni 3 secondi, per i job con `se_foreground = 1` | quello di Apache (`max_execution_time`, tipicamente **30 s**) |
| `_src/_api/_cron.php` | a ogni passata, `iterazioni` volte di fila, per i job **non** in foreground | nessuno (PHP da riga di comando), ma c'è il tetto `cron.durata_massima` |

Entrambi mettono un **lock** (`job.token`), includono il file, e alla fine risalvano `job.workspace` — che è
l'unico posto dove lo stato di lavoro sopravvive fra un'iterazione e l'altra — azzerando il token. **Se
l'iterazione muore a metà, quell'UPDATE finale non viene mai eseguita:** il workspace resta indietro e il lock
resta appeso. È la premessa di tutto quello che segue.

### Le colonne che contano, e cosa vogliono dire davvero

| colonna | significato |
|---|---|
| `corrente` / `totale` | **avanzamento**: quante unità di lavoro sono state fatte su quante. Servono a disegnare la barra. |
| `timestamp_completamento` | **fine**: il job è finito. È l'unica cosa che lo dice. |
| `token` | lock: chi ci sta lavorando adesso. |
| `se_foreground` | 1 = lo fa avanzare il browser, il cron lo ignora. |

L'errore da cui nasce tutta questa sezione è confondere le prime due righe della tabella: **`corrente >= totale`
non vuol dire "completato"**, vuol dire "l'ultima unità di lavoro è stata fatta". La chiusura — il file da
produrre, la mail da mandare, il `timestamp_completamento` da scrivere — viene dopo, e può non riuscire.

### Lo scheletro giusto

È quello che usano già i job di importazione (`_src/_api/_job/_anagrafica.importazione.php`,
`_src/_api/_job/_comuni.importazione.php` e i loro fratelli nei moduli). Il modello commentato è
`_src/_api/_job/_test.job.php`.

```php
if( defined( 'CRON_RUNNING' ) || defined( 'JOB_RUNNING' ) ) {

    // 1. il job è davvero finito: non si fa niente. Notare il ">" e non il ">="
    if( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

        $status['info'][] = 'iterazione a vuoto su job completato';

    } elseif( /* requisiti formali: manca un parametro nel workspace, ... */ ) {

        $status['err'][] = '...';

    } else {

        // 2. avvio oppure avanzamento del contatore, in memoria
        if( empty( $job['corrente'] ) ) {
            // ... si calcola $job['totale'] ...
            $job['corrente'] = 1;
        } else {
            $job['corrente']++;
        }

        // 3. chiusura: un'iterazione TUTTA SUA, alternativa al lavoro
        if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

            // ... risultato, notifiche ...
            // UPDATE job SET timestamp_completamento = ? WHERE id = ?

        } else {

            // 4. il lavoro di questa iterazione
            $widx = $job['corrente'] - 1;
            // ...

            // 5. ULTIMA cosa: salvare l'avanzamento
            // UPDATE job SET totale = ?, corrente = ? WHERE id = ?

        }

    }

}
```

Il punto non ovvio è **perché la chiusura sta in un ramo alternativo al lavoro invece che in coda**. Perché
`corrente` viene salvato a database soltanto in fondo al ramo del lavoro (punto 5): finché la chiusura non
riesce, a database resta l'avanzamento precedente, e l'iterazione successiva ricalcola `corrente` in memoria,
rientra nel ramo di chiusura e **ritenta**. Il job si ripara da solo.

Vale la pena sapere che il primo ramo — quello dell'"iterazione a vuoto" — in condizioni normali non scatta
quasi mai: a chiudere il rubinetto è il motore, che seleziona soltanto i job con `timestamp_completamento IS
NULL` (`_src/_api/_job.php`, `_src/_api/_cron.php`). Quel ramo è una rete di sicurezza per il caso in cui il job
venga incluso lo stesso, non il meccanismo che ferma il lavoro: non caricarlo di responsabilità che non ha, ed
è esattamente per questo che scriverci `>=` fa danno.

### I due difetti, che sono simmetrici

**Il job che non finisce mai più.** Si ottiene salvando l'avanzamento *prima* della chiusura e usando `>=` nel
guard iniziale. Se la chiusura muore in mezzo, a database resta `corrente = totale` con
`timestamp_completamento` a NULL: da lì in avanti ogni iterazione entra nel primo ramo, dichiara "job
completato" e non fa niente. Il lavoro è fermo a un passo dalla fine e **non lo sblocca nessuno** — né il
browser, né il cron, né azzerare il token di lock a mano. Successo davvero, il 07/09/2026, a un'esportazione
di 26.000 anagrafiche: la chiusura conteneva una `UPDATE` con un join non indicizzato che sfondava i 30 secondi
di Apache, e il job è rimasto piantato a 71 iterazioni su 71.

**Il job che non finisce e basta.** È il rischio opposto, e ci si casca "riparando" il primo: se la chiusura può
essere ritentata all'infinito e fallisce sempre, il cron riprende il job a ogni passata per sempre, in silenzio.
Contro questo il framework ha una guardia in `_src/_api/_cron.php`: un job che viene preso in carico e non fa
avanzare `corrente` per `cron.stalli_massimi` passate (default 30, mezz'ora di cron al minuto) viene **chiuso
d'ufficio** con un log di errore. Il contatore vive in `workspace.__stalli__`, si scrive *prima* di lavorare —
così regge anche se il job muore dentro il `require` — e si azzera appena `corrente` avanza.

### Il dataset del job, e perché è il punto in cui si fa il danno più grosso

Un job che lavora su un elenco — un CSV da importare, una lista da elaborare — ha un problema che lo
scheletro qui sopra non risolve: **il file del job viene incluso da capo a ogni iterazione**, quindi
l'elenco va ricaricato ogni volta. Lo schema storico è memcache, con il ripiego di rileggere il file
di partenza quando la cache non risponde.

Quel ripiego costa quanto tutto il file, **a ogni iterazione**. Ed è qui che il 12/09/2026 un
deploy ha riempito un filesystem da 246 GB:

- l'importazione di 14.522 anagrafiche non entrava in memcache — 7,13 MB serializzati contro il
  limite da **1 MB per elemento**, `set()` rifiutata con `MEMCACHED_E2BIG` — e il job ha riletto e
  riparsato lo stesso CSV a ogni iterazione, **dodicimila volte**;
- `csvFile2array()` scriveva nel canale `details/csv` un `print_r` dell'intero file, due volte per
  chiamata, e in DEV il livello di log standard è `LOG_DEBUG`, quindi lo scriveva davvero: una
  decina di megabyte a chiamata, per dodicimila chiamate. **122 GB in un file solo**, mai aperto da
  nessuno;
- il fallimento della cache **era loggato**, a `LOG_ERR`, in `var/log/memcache.err.AAAAMM.log`,
  nell'istante esatto in cui il job si apriva. Una riga in un file che nessuno apre non è un
  allarme.

Da qui tre regole, e la prima vale ben oltre i job:

- **quello che un job scrive va moltiplicato per il numero di iterazioni.** Una riga di log che su
  una richiesta è innocua, su un job da diecimila giri è un file da gigabyte. Prima di loggare
  dentro un job, chiedersi quante volte verrà scritta quella riga;
- **il dataset si salva con `jobDatasetScrivi()` e si rilegge con `jobDatasetLeggi()`**
  (`_src/_lib/_job.utils.php`), che provano la cache e ripiegano su un file di spool dedicato al job
  (`var/spool/job/` più l'id): un `unserialize()` per iterazione invece di un parsing completo, e
  senza limiti di dimensione. La chiusura chiama `jobDatasetPulisci()`, perché quel file pesa;
- **l'esito del salvataggio va messo nel `workspace`**, non solo nel log: `jobDatasetScrivi()` lo
  restituisce apposta. Chi lancia un import guarda la barra di avanzamento e lo stato del job, non
  `var/log/memcache.err`. Un fallimento che cambia il costo del lavoro di tre ordini di grandezza
  deve comparire dove l'operatore guarda davvero.

E una nota su `csvFile2array()`: dal 12/09/2026 logga **l'impronta** del file — righe, separatore,
colonne, prime tre righe — e non più il contenuto. Il dump integrale esiste ancora ma va chiesto,
accendendo `$cf['debug']['csv']['dump']` per il giro in cui serve. Se il dataset serve per intero e
sistematicamente, la copia leggibile la scrive già `jobDatasetScrivi()` in `var/log/job/` sotto la
cartella dell'id, nel file `dataset.log`: una volta sola e accanto agli altri log di quel job, molto
più utile di dodicimila copie accavallate in un canale mensile condiviso.

### Regole pratiche

- Nel guard iniziale si scrive `>`, **mai** `>=` e mai `==`. Un uguale non è una guardia, è una coincidenza:
  se per qualunque motivo il contatore scavalca il totale, non chiude più niente.
- L'`UPDATE` dell'avanzamento è l'**ultima** istruzione del ramo di lavoro: è la riga che dichiara riuscita
  l'iterazione. Anticiparla vuol dire perdere il diritto di rifarla.
- La chiusura dev'essere **idempotente**: può essere eseguita più volte.
- La chiusura dev'essere **breve**. Il lavoro pesante va spalmato sulle iterazioni — è il motivo per cui i job
  esistono. Una chiusura che dura più del tempo massimo di una richiesta viene uccisa a metà ogni volta. Se
  proprio non se ne può fare a meno, darle un `set_time_limit()` suo, e ricordare che in foreground quel tempo
  è un browser che aspetta.
- Prima di aggiungere una query alla chiusura, guardarne l'`EXPLAIN`. Un join fra due colonne avvolte in
  `LOWER( TRIM( ... ) )` non usa indici da nessuna delle due parti, e su decine di migliaia di righe diventa un
  prodotto cartesiano. Il difetto resta invisibile finché una delle tabelle è vuota.
- Il `result` che il driver mostra a fine barra (`d.result` in `main.js`) va scritto in
  `$job['workspace']['result']`, non solo in `$status`: il workspace è l'unica cosa che il motore risalva.
- **Dopo aver lanciato un job lungo, guardare la prima passata prima di andarsene.** Non la barra:
  `workspace.status`, e `var/log/memcache.err` se il job usa un dataset. Il difetto che costa caro si
  vede nei primi sessanta secondi e poi si moltiplica in silenzio per tutte le ore che seguono.

### Quando un job è piantato

```bash
# stato
SELECT id, nome, corrente, totale, se_foreground, token, timestamp_completamento FROM job WHERE id = <id>;

# lock appeso: lo azzera anche il cron da solo dopo 10 minuti (_src/_api/_cron.php)
UPDATE job SET token = NULL WHERE id = <id>;

# provocare un'iterazione senza aspettare il cron
curl "https://<host>/job/<id>"
```

Se dopo lo sblocco il job continua a rispondere "iterazione a vuoto", il difetto è quello del guard `>=`: il
lavoro c'è tutto, manca solo la chiusura, e va corretto il codice del job prima che riparta. I log delle
iterazioni stanno in `var/log/job/<id>/` e `var/log/job/<id>.log`; l'ultima iterazione che *non* compare lì è
quella in cui il job è morto.

---
