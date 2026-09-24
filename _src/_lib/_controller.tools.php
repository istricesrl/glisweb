<?php

    /**
     * libreria del controller dei dati
     *
     * Questa libreria contiene la funzione controller(), che è il punto unico attraverso cui il framework legge e
     * scrive le entità del database, e le funzioni di supporto con cui essa decide cosa fare dei dati ricevuti.
     *
     * introduzione
     * ============
     * La controller() riceve un blocco dati, cioè un array associativo che rappresenta una riga (o un insieme di
     * righe) di un'entità, il nome dell'entità e il metodo HTTP da applicare, e lo traduce nella query MySQL
     * corrispondente dopo averne verificato i permessi. Viene chiamata principalmente da
     * _src/_config/_750.controller.php, che le passa ogni blocco dati trovato in $_REQUEST (da form HTTP, da chiamata
     * REST tramite _src/_api/_rest.php o da file CSV tramite _src/_config/_740.controller.php), e dalle macro di vista
     * (_src/_inc/_macro/_default.view.php, _src/_inc/_macro/_default/_default.view.php) e dalle stampe CSV per
     * estrarre i dati degli elenchi. Per il formato dei blocchi dati e i canali di ingresso si vedano i commenti al
     * file _src/_config/_750.controller.php.
     *
     * Il lavoro della controller() si divide in due modalità, scelte in base al metodo e alla presenza dell'id:
     *
     * modalità view
     * -------------
     * Una GET senza id (o con la richiesta esplicita __view_mode__) è una richiesta di elenco: la controller()
     * compone una SELECT sulla vista dell'entità (<tabella>_view_static se esiste, altrimenti <tabella>_view, o la
     * tabella stessa in modalità report/filesystem) applicando ricerca, filtri, restrizioni, raggruppamenti,
     * ordinamenti e paginazione indicati nell'array delle informazioni $i, e restituisce le righe trovate nel blocco
     * dati $d; il numero totale di righe e di pagine viene scritto in $i['__pager__']. Le chiavi di $i riconosciute
     * sono descritte nei commenti dentro la funzione, alla sezione "features della modalità di visualizzazione".
     *
     * modalità modifica
     * -----------------
     * Ogni altro caso (POST, PUT, REPLACE, UPDATE, DELETE, e GET con id per la lettura di un singolo record) è una
     * richiesta sulla singola riga: la controller() compone la query INSERT, UPDATE, REPLACE, INSERT ... ON DUPLICATE
     * KEY UPDATE, DELETE o SELECT corrispondente, la esegue, confronta la riga prima e dopo l'operazione, propaga
     * l'operazione ai sottomoduli (le entità collegate da chiave esterna) chiamando sé stessa e infine integra il
     * blocco dati con la riga letta dalla vista, così che chi lo riceve abbia anche i campi calcolati.
     *
     * punti di inclusione delle controller
     * ------------------------------------
     * In modalità modifica la controller() include, in quattro punti del suo lavoro, dei file PHP che permettono di
     * personalizzare il comportamento per entità senza toccare la funzione. I file vengono cercati in
     * _src/_inc/_controllers/ e nella stessa cartella dei moduli attivi, con i nomi _default.<punto>.php (valido per
     * tutte le entità) e _<tabella>.<punto>.php (con gli underscore del nome della tabella sostituiti da punti, ad es.
     * _anagrafica.categorie.before.php), più le rispettive versioni custom trovate da path2custom():
     *
     * punto            | quando viene incluso
     * -----------------|-----------------------------------------------------------------------
     * before           | prima della composizione della query; può modificare i dati o bloccare l'operazione
     * append           | dopo la composizione della query e prima della sua esecuzione; può modificare la query
     * after            | dopo l'esecuzione della query e il confronto prima/dopo
     * finally          | dopo l'elaborazione dei sottomoduli, prima dell'integrazione finale del blocco dati
     *
     * I file vengono inclusi con require dentro la funzione, quindi vedono tutte le sue variabili locali ($c, $mc,
     * $d, $t, $a, $ks, $vs, $q, $e, $i, $comparison...) e possono modificarle. Un controller before o append blocca
     * l'operazione impostando in $i['__status__'] un codice di errore (400 o superiore) e svuotando $a, come fa ad
     * esempio _src/_inc/_controllers/_file.before.php.
     *
     * costanti
     * ========
     * Le costanti definite e utilizzate dalla libreria sono elencate nella seguente tabella; descrivono l'esito del
     * confronto prima/dopo della modalità modifica, che la controller() scrive nella variabile $comparison a
     * disposizione dei controller after e finally.
     *
     * costante                     | spiegazione
     * -----------------------------|--------------------------------------------------------------
     * ROW_CREATED                  | la riga non esisteva prima dell'operazione ed è stata creata
     * ROW_MODIFIED                 | la riga esisteva ed è cambiata (vale anche per la cancellazione)
     * ROW_UNMODIFIED               | la riga non è cambiata
     *
     * funzioni
     * ========
     * Le funzioni di questa libreria sono divise in gruppi in base al lavoro che svolgono; nei paragrafi successivi le
     * analizzeremo nel dettaglio.
     *
     * funzioni di gestione dei dati
     * -----------------------------
     * Le funzioni in questo gruppo servono per leggere e scrivere le entità del database.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * controller()                     | legge o scrive un blocco dati su un'entità del database
     *
     * funzioni di verifica
     * --------------------
     * Le funzioni in questo gruppo servono alla controller() e ai suoi chiamanti per decidere come trattare i dati.
     *
     * funzione                         | descrizione
     * ---------------------------------|---------------------------------------------------------------
     * checkNomeBloccoDati()            | verifica se una chiave di $_REQUEST è un blocco dati da elaborare
     * checkModalitaVisualizzazione()   | verifica se la richiesta va trattata in modalità view
     * checkModalitaModifica()          | verifica se la richiesta può essere trattata in modalità modifica
     * isFieldNumeric()                 | verifica se un campo di una tabella è di tipo numerico
     *
     * dipendenze
     * ==========
     * Questa libreria ha alcune dipendenze che devono essere soddisfatte per funzionare correttamente. In particolare
     * sono richieste le seguenti funzioni:
     *
     * funzione                         | libreria di appartenenza
     * ---------------------------------|---------------------------------------------------------------
     * logWrite()                       | _src/_lib/_log.utils.php
     * logger()                         | core
     * timerCheck()                     | core
     * timerNow()                       | core
     * timerDiff()                      | core
     * path2custom()                    | core
     * getAclPermission()               | _src/_lib/_acl.utils.php
     * getAclRights()                   | _src/_lib/_acl.utils.php
     * getAclRightsTable()              | _src/_lib/_acl.utils.php
     * getAclRightsAccountId()          | _src/_lib/_acl.utils.php
     * checkFirmaImportazione()         | _src/_lib/_acl.utils.php
     * mysqlQuery()                     | _src/_lib/_mysql.tools.php
     * mysqlSelectRow()                 | _src/_lib/_mysql.tools.php
     * mysqlSelectValue()               | _src/_lib/_mysql.tools.php
     * mysqlSelectCachedValue()         | _src/_lib/_mysql.tools.php
     * mysqlCachedQuery()               | _src/_lib/_mysql.tools.php
     * getStaticViewExtension()         | _src/_lib/_mysql.tools.php
     * numeric2null()                   | _src/_lib/_string.tools.php
     * string2boolean()                 | _src/_lib/_string.tools.php
     * arrayKeyValuesImplode()          | _src/_lib/_array.tools.php
     *
     * changelog
     * =========
     * Questa sezione riporta la storia delle modifiche più significative apportate alla libreria.
     *
     * data             | autore               | descrizione
     * -----------------|----------------------|---------------------------------------------------------------
     * 2026-09-16       | Fabio Mosti          | $timer passato per riferimento, cache dell'indice SORTING
     * 2026-09-18       | Fabio Mosti          | lettura per id dalle viste con il valore scritto nella query
     * 2026-09-23       | Fabio Mosti          | ricerca delle date scritte all'italiana
     * 2026-09-24       | Fabio Mosti          | filtri EQ numerici scritti nella query sulle viste
     * 2026-09-24       | Fabio Mosti          | documentazione
     *
     * licenza
     * =======
     * Questa libreria fa parte del progetto GlisWeb (https://github.com/istricesrl/glisweb) ed è distribuita
     * sotto licenza Open Source. Fare riferimento alla pagina GitHub del progetto per i dettagli.
     *
     */

    // costanti
    define('ROW_CREATED', 'INSERITO');
    define('ROW_MODIFIED', 'MODIFICATO');
    define('ROW_UNMODIFIED', 'INVARIATO');

    /**
     * FUNZIONI DI GESTIONE DEI DATI
     */

    /**
     * legge o scrive un blocco dati su un'entità del database
     *
     * Questa funzione elabora il blocco dati $d per l'entità $t secondo il metodo $a, nelle due modalità descritte
     * nella testata della libreria (view e modifica); i dettagli di ogni passo sono nei commenti dentro la funzione.
     * In sintesi:
     *
     * -# separa in $d i campi della riga, i sottomoduli (i valori array) e le chiavi speciali con il doppio underscore,
     *    e sostituisce i valori speciali (__parent_id__, __self_id__, __timestamp__, __date__, __null__);
     * -# se $d contiene solo sottomoduli (modalità multipla) chiama sé stessa per ciascuno di essi;
     * -# verifica i permessi sull'entità con getAclPermission() o con la firma di importazione; se mancano scrive
     *    401 in $i['__status__'] e si ferma;
     * -# in modalità view compone ed esegue la SELECT sulla vista e mette le righe trovate in $d;
     * -# in modalità modifica esegue la query sulla riga, include i controller before/append/after/finally, propaga
     *    l'operazione ai sottomoduli e integra $d con la riga letta dalla vista, oppure, se è stato richiesto il
     *    reset (esplicitamente con __reset__ o implicitamente con una DELETE), salva $d in
     *    $_SESSION['__latest__'][ $t ] e lo svuota lasciando solo __reset__ = 1.
     *
     * Il blocco dati $d, l'array degli errori $e e l'array delle informazioni $i sono passati per riferimento e
     * vengono modificati: $d contiene alla fine il risultato (le righe dell'elenco, la riga letta o scritta con il
     * suo id), $e['__codes__'] i codici di errore MySQL raccolti da mysqlQuery(), $i lo stato, il paginatore e le
     * informazioni restituite dai sottomoduli, annidate per entità e indice. Se $d è vuoto viene inizializzato a un
     * array vuoto; tutti i suoi valori passano per numeric2null().
     *
     * NB: nel ramo "diritti INSUFFICIENTI" (riga esistente su cui l'account non ha diritti) la funzione scrive solo
     * una riga di log e restituisce lo stato presente in $i, o 200 se non ce n'è; il chiamante non riceve un 401.
     *
     * TODO nel ramo dei diritti insufficienti sulla riga lo stato restituito non segnala il rifiuto (vedi sopra)
     *
     * TODO in modalità view, una __search__ senza __fields__ fatta solo di parole più corte di tre caratteri lascia
     * $cond non definito, e la WHERE riceve implode() di un valore non array
     *
     * il parametro $timer
     * -------------------
     * `$timer` va passato per RIFERIMENTO, altrimenti i cronometri interni non escono.
     *
     * Questa funzione contiene otto `timerCheck( $timer, ... )`, ma finché `$timer` era passato
     * per valore scrivevano tutti in una copia locale che veniva buttata via al `return`. Il
     * chiamante — `_src/_config/_750.controller.php`, che gli passa `$cf['speed']` — non ne vedeva
     * nessuno, e nel log delle richieste lente ( `var/log/slow/` ) tutto il lavoro del controller
     * compariva come **un passo solo e opaco**, `fine elaborazione blocco \<tabella\>`.
     *
     * Non è un dettaglio estetico: su una scheda con dei sottomoduli quel passo è quasi sempre la
     * voce più cara della richiesta, e senza i tempi interni non c'è modo di sapere se il tempo se
     * ne va nel record principale, negli hook o nella cascata sui sottomoduli. Su un deploy dove è
     * stato misurato valeva il 74% del tempo della pagina, e la cascata da sola i due terzi di
     * quello: informazioni che lo strumento sapeva già produrre e che non arrivavano a nessuno.
     *
     * È una modifica di **sola osservazione**: `$cf['speed']` viene letto unicamente da
     * `_src/_api/_pages.php` e `_src/_api/_rest.php`, che lo stampano nel log quando la richiesta
     * supera la soglia. Nessun ramo di logica cambia.
     *
     * Il parametro resta opzionale — in PHP un parametro per riferimento può avere un default — e
     * tutti i chiamanti che si fermano prima dell'undicesimo argomento continuano a funzionare
     * identici.
     *
     * Le chiamate ricorsive passano `$timer` a loro volta, così il log mostra anche i tempi dei
     * singoli sottomoduli e non solo il totale della cascata.
     *
     * Gli si passa anche `$ci` perché è il decimo argomento e serve riempirlo per arrivare
     * all'undicesimo. ⚠ `$ci` **non è documentato da nessuna parte** — compare solo in questa
     * firma e nell'inizializzazione del chiamante, dove ha un commento vuoto — e dentro questa
     * funzione non viene letto da nessuno: verificato con `grep` su tutto `_src/` e `_mod/`. Non è
     * quindi "inutilizzato", è **riservato e mai definito**. Passandolo giù si è scelto di
     * condividerlo lungo la ricorsione come già si fa con `$e` e `$i`: se un giorno gli si dà un
     * significato — per esempio raccogliere gli id dei figli creati — quella è la semantica che
     * quasi certamente si vuole. Chi glielo dà, però, sappia che da qui in poi è condiviso.
     *
     * ⚠ Chi tocca questa firma controlli i chiamanti: passare un'espressione invece di una
     * variabile al decimo o all'undicesimo argomento diventa un fatal *"Only variables can be
     * passed by reference"*.
     *
     * @param       mysqli      $c      la connessione al database
     * @param       object      $mc     la connessione a memcache, usata per le query in cache sullo schema
     * @param       array       $d      il blocco dati da elaborare, modificato sul posto con il risultato
     * @param       string      $t      il nome dell'entità (tabella) su cui lavorare; può essere sostituito dalla
     *                                  chiave speciale __table__ del blocco dati
     * @param       string      $a      il metodo da applicare (default METHOD_GET); può essere sostituito dalla
     *                                  chiave speciale __method__ del blocco dati
     * @param       mixed       $p      l'id del record padre, usato per il valore speciale __parent_id__ nelle
     *                                  chiamate ricorsive sui sottomoduli (default NULL)
     * @param       array       $e      l'array degli errori, modificato sul posto
     * @param       array       $i      l'array delle informazioni (filtri, ordinamenti, paginazione in ingresso;
     *                                  stato, paginatore ed errori in uscita), modificato sul posto
     * @param       array       $pi     passato a checkModalitaModifica() e, nella ricorsione, valorizzato con
     *                                  $i['__auth__'] del chiamante; getAclRights() però non lo riceve (si veda
     *                                  checkModalitaModifica())
     * @param       array       $ci     riservato e mai letto, si veda la nota sopra
     * @param       array       $timer  l'array del cronometro, per riferimento (tipicamente $cf['speed'])
     *
     * @return      int                 lo stato dell'operazione, lo stesso scritto in $i['__status__']: 200 in
     *                                  caso di successo, 401 se mancano i permessi sull'entità, 409 per una chiave
     *                                  duplicata (errore MySQL 1062), 400 per un campo inesistente (errore 1054),
     *                                  o il codice di errore impostato da un controller before o append
     *
     */
    function controller($c, $mc, &$d, $t, $a = METHOD_GET, $p = NULL, &$e = array(), &$i = array(), &$pi = array(), &$ci = array(), &$timer = array()) {

        /**
         * inizializzazione delle variabili
         * --------------------------------
         * In questa sezione vengono inizializzate le variabili che verranno poi utilizzate nella funzione.
         * 
         */

        // log
        logWrite("avvio controller per $t/$a", 'controller');

        // timer
        timerCheck( $timer, '-> -> inizio lavoro controller per ' . $t . '/' . $a );

        // inizializzazioni
        $q                      = NULL;                                         // la query MySQL che verrà eseguita
        $s                      = array();                                      // l'array dei sottomoduli (subform) trovati nel blocco dati
        $r                      = false;                                        // richiesta di reset del blocco dati (__reset__, forzata dalla DELETE)
        $ks                     = array();                                      // l'array delle chiavi (nomi dei campi)
        $vs                     = array();                                      // l'array dei valori (valori dei campi)
        $vm                     = false;                                        // richiesta di modalità view (__view_mode__)
        $rm                     = getStaticViewExtension($mc, $c, $t);          // suffisso della vista da interrogare (_view_static o _view, NULL in modalità report)

        // ricerca dei controller
        $cb                    = DIR_SRC_INC_CONTROLLERS . '_{default,' . str_replace('_', '.', $t) . '}.';
        $cm                    = DIR_MOD_ATTIVI_SRC_INC_CONTROLLERS . '_{default,' . str_replace('_', '.', $t) . '}.';

        // inizializzazione array dati
        if( empty( $d ) ) {
            $d = array();
        }

        // modifico in NULL tutti i valori vuoti
        $d = array_map('numeric2null', $d);

        /**
         * elaborazione dei dati
         * ---------------------
         * In questa sezione i dati ricevuti in $d vengono elaborati per separare i dati veri e propri dai subform e dai dati speciali,
         * identificati dal doppio underscore. Al termine di questa sezione, gli array $ks e $vs conterranno rispettivamente le chiavi e i valori
         * da utilizzare per la query MySQL. Si noti che mentre in $ks le chiavi sono memorizzate come un vettore, $vs è un array
         * di array associativi del tipo array( 's' => $v ), in quanto i valori devono poi essere passati a mysqlQuery() per il bind dei parametri.
         * 
         * Le subform vengono stoccate nella variabile $s, mentre i dati speciali vanno a valorizzare
         * le rispettive variabili:
         * 
         * chiave                   | variabile             | descrizione
         * -------------------------|-----------------------|-------------------------------------------------------------
         * __firma__                | $f                    | firma per bypassare il controllo permessi
         * __method__               | $a                    | metodo del form (GET, POST, PUT, DELETE, REPLACE, UPDATE)
         * __table__                | $t                    | tabella del form
         * __reset__                | $r                    | richiesta esplicita di svuotare $_REQUEST[$t]
         * __view_mode__            | $vm                   | richiesta esplicita di visualizzazione dei dati
         * __forced_view__          | $fvm                  | richiesta esplicita di visualizzazione forzata dei dati
         * __report_mode__          | $rm                   | modalità report (o filesystem mode)
         * __filesystem_mode__      | $rm                   | modalità filesystem (o report mode)
         * 
         * Sempre in questa sezione il valore di $v viene valutato per la sostituzione dei seguenti valori speciali:
         * 
         * valore speciale          | sostituzione
         * -------------------------|-------------------------------------------------------------
         * __null__                 | NULL
         * __parent_id__            | $p (id del record padre)
         * __self_id__              | id del record corrente (se presente, altrimenti NULL)
         * __timestamp__            | time() (timestamp corrente)
         * __date__                 | date('Y-m-d') (data corrente)
         * 
         * Terminata anche questa elaborazione, è possibile procedere con il lavoro della funzione.
         * 
         */

        // genero l'array delle chiavi, dei valori e dei sottomoduli
        foreach ($d as $k => $v) {

            // valutazione di $v
            if (is_array($v) && substr($k, 0, 2) !== '__') {            // nel caso il valore sia un subform, viene

                logWrite("subform rilevato: $k/$a", 'controller');
                $s[$k] = $v;                                            // passato così com'è per la ricorsione

            } elseif (strtolower($k)    == '__firma__') {               //
                $f = $v;                                                // firma per bypassare il controllo permessi
            } elseif (strtolower($k)    == '__method__') {              //
                $a = strtoupper($v);                                    // impostazione esplicita del method del form
            } elseif (strtolower($k)    == '__table__') {               //
                $t = $v;                                                // impostazione esplicita della tabella del form
            } elseif (strtolower($k)    == '__reset__') {               //
                $r = string2boolean($v);                                // richiesta esplicita di svuotare $_REQUEST[ $t ]
            } elseif (strtolower($k)    == '__view_mode__') {           // obsoleto (vedi sotto)
                $vm = true;                                             //
            } elseif (strtolower($k)    == '__forced_view__') {         // obsoleto (vedi sotto)
                $fvm = true;                                            //
            } elseif (strtolower($k)    == '__report_mode__') {         // obsoleto (vedi sotto)
                $rm = NULL;                                             //
            } elseif (strtolower($k)    == '__filesystem_mode__') {     // obsoleto (vedi sotto)
                $rm = NULL;                                             //
            } elseif (substr($k, 0, 2)  !== '__') {                     //

                if( ! empty( $v ) && $v !== NULL ) {
                    if (strtolower($v)    == '__parent_id__') {
                        $v = $p;
                    }
                    if (strtolower($v)    == '__self_id__') {
                        $v = (isset($d['id'])) ? $d['id'] : NULL;
                    }
                    if (strtolower($v)    == '__timestamp__') {
                        $v = time();
                    }
                    if (strtolower($v)    == '__date__') {
                        $v = date('Y-m-d');
                    }
                    if (strtolower($v)    == '__null__') {
                        $v = NULL;
                    }
                }

                $vs[$k] = array( 's' => $v );                           // array dei valori per il bind dei parametri
                $ks[] = $k;                                             // array delle chiavi per la costruzione della query

            }
        }

        /**
         * gestione chiavi speciali
         * ------------------------
         * Le richieste di modalità che nel blocco dati sono ormai obsolete (__view_mode__, __forced_view__,
         * __report_mode__, __filesystem_mode__) possono essere passate anche nell'array delle informazioni, sotto
         * $i['__mode__'], con valore 1; l'effetto è lo stesso delle chiavi omonime del blocco dati: __view_mode__
         * forza la modalità view, __forced_view__ fa leggere il singolo record dalla vista invece che dalla tabella
         * e salta l'elaborazione dei sottomoduli, __report_mode__ e __filesystem_mode__ azzerano il suffisso della
         * vista, così che le query lavorino sulla tabella.
         *
         */

        // modalità passate tramite l'array delle informazioni
        if( isset( $i['__mode__'] ) ) {
            if( isset( $i['__mode__']['__view_mode__'] ) && $i['__mode__']['__view_mode__'] == 1 ){
                $vm = true;
            }
            if( isset( $i['__mode__']['__forced_view__'] ) && $i['__mode__']['__forced_view__'] == 1 ){
                $fvm = true;
            }
            if( isset( $i['__mode__']['__report_mode__'] ) && $i['__mode__']['__report_mode__'] == 1 ){
                $rm = NULL;
            }
            if( isset( $i['__mode__']['__filesystem_mode__'] ) && $i['__mode__']['__filesystem_mode__'] == 1 ){
                $rm = NULL;
            }
        }
 
        /**
         * modalità singola e modalità multipla
         * ------------------------------------
         * La controller() può essere utilizzata in due modalità: singola e multipla; ovvero, è possibile passarle un solo record
         * nella forma:
         * 
         * ```
         * array(
         *    'test' => array(
         *          'id' => 1,
         *          'nome' => 'Test',
         *     )
         * )
         * ```
         * 
         * oppure un array di record nella forma:
         * 
         * ```
         * array(
         *    'test' => array(
         *         '0' => array(
         *              'id' => 1,
         *             'nome' => 'Test',
         *         ),
         *         '1' => array(
         *             'id' => 2,
         *            'nome' => 'Test 2',
         *        ),
         *    )
         * )
         * ```
         * 
         * Per capire in quale scenario si trova, la controller() verifica se l'array $ks è vuoto e se l'array $s contiene dei subform.
         * L'array $ks vuoto infatti sta a significare che non sono stati passati campi al primo livello, ma solo subform. Se si va in
         * modalità multipla, la controller() non fa altro che chiamare sé stessa per ogni subform presente nell'array $s; viceversa, in
         * modalità singola, la controller() procede con la normale elaborazione dei dati.
         * 
         */

        // controllo modalità singola / modalità multipla
        if (count($ks) == 0 && count($s) > 0) {

            logWrite("subform rilevati: " . implode(', ', array_keys($s)), 'controller');

            // elaborazione subform
            foreach ($s as $x => $y) {
                logWrite("elaborazione subform: $x", 'controller');
                controller($c, $mc, $y, $t, $a, NULL, $e, $i[$t][$x], $i['__auth__'], $ci, $timer);
            }

        } else
        
        /**
         * controllo permessi
         * ------------------
         * Prima di effettuare qualsiasi operazione, la controller() verifica se l'utente ha i permessi necessari per svolgere l'azione richiesta
         * sull'entità specificata; questo viene fatto tramite la funzione getAclPermission(), alla quale si rimanda per ulteriori dettagli. In
         * alternativa, viene valutata la firma di importazione tramite la funzione checkFirmaImportazione(), per consentire l'elaborazione batch
         * di dati importati tramite file CSV o simili. Per questa modalità di lavoro si vedano i commenti al file /_src/_config/_740.controller.php.
         * 
         */
        
        if (getAclPermission($t, $a, $i) || checkFirmaImportazione($d, $t)) {

            /**
             * modalità di visualizzazione e modalità di inserimento, cancellazione e modifica
             * -------------------------------------------------------------------------------
             * Una volta verificati i permessi, la controller() procede con l'elaborazione dei dati in base al metodo richiesto; qui i due principali rami
             * sono la modalità di visualizzazione (GET) e la modalità di inserimento, cancellazione e modifica (POST, PUT, REPLACE, UPDATE, DELETE).
             * 
             * La modalità di visualizzazione ha logiche proprie, molto diverse da quelle della modalità di modifica, in quanto per la visualizzazione
             * le esigenze di filtro, ordinamento e paginazione sono fondamentali, mentre per l'altro ramo sono assenti.
             * 
             */

            // se è stata effettuata una GET senza ID, passo alla modalità view
            if( checkModalitaVisualizzazione( $a, $d, $vm ) ) {

                /**
                 * la modalità di visualizzazione
                 * ------------------------------
                 * Prima di qualsiasi altra cosa, la modalità di visualizzazione verifica se è necessario integrare la query con i permessi specifici
                 * indicati dalla servo tabella di ACL. Nel caso la tabella di ACL esista, viene aggiunta in JOIN alla query, in modo da filtrare i risultati
                 * per riga in base ai permessi dell'utente corrente.
                 * 
                 */

                // log
                logWrite("permessi sufficienti per $t/$a", 'controller');
                logWrite("modalità di visualizzazione per $t/$a: " . print_r($i, true), 'details/controller/'.$t.'.'.$a);

                // vado a cercare il campo e la tabella per le ACL
                $aclTb = getAclRightsTable($t);
                $aclId = getAclRightsAccountId();

                // scompongo i campi nel caso siano passati come lista
                if( isset($i['__fields__']) && ! is_array($i['__fields__']) ) {
                    $i['__fields__'] = explode( ',', $i['__fields__'] );
                }

                // campi da selezionare dalla vista
                if (isset($i['__fields__'])) {
                    $fld = implode(', ', preg_filter('/^/', "$t$rm.", $i['__fields__']));
                } else {
                    $fld = "$t$rm.*";
                }

                // preparo la query
                $q = "SELECT SQL_CALC_FOUND_ROWS $fld FROM $t$rm";

                // inizializzo l'array per ricerca e filtri
                $whr = array();

                /**
                 * Fix 2026-09-23: filtri EQ numerici scritti nella query sulle viste
                 * -------------------------------------------------------------------
                 * Sulle viste che raggruppano (i __report_*__, le *_view) il filtro passato come parametro di un
                 * prepared statement non entra nella vista, e si paga la materializzazione completa per poi
                 * scartare quasi tutto: la griglia di /anagrafica/iscrizioni filtrata per id_anagrafica impiegava
                 * 0,465 s col ? contro 0,021 s col valore scritto (produzione, 23/09; 284 s al giorno su 122
                 * letture). Stessa cura della lettura per id del 17/09: solo valori di sole cifre, scritti fra
                 * apici — cioè ancora come stringa, identici nel significato al binding 's' — e se la query
                 * interpolata fallisce (1052 sulle viste scritte male) la tabella viene segnata in no_id_inline e
                 * si ripiega sul parametro.
                 */
                $eqInline = ( $rm === '_view' || $rm === NULL )
                         && empty( $GLOBALS['cf']['controller']['no_id_inline'][ $t ] );
                $eqInlineRipiego = array();

                // filtri per i campi
                foreach ($ks as $fk) {
                    $whr[] = "$fk = ?";
                }

                // unisco la tabella di ACL se presente
                if (!empty($aclTb)) {
                    $q .= " LEFT JOIN $aclTb ON $aclTb.id_entita = $t$rm.id ";
                    // NOTA il filtro sull'account sta QUI e non solo nella WHERE. Senza, MySQL
                    // incrocia ogni riga della tabella di ACL con TUTTE le righe di
                    // account_gruppi, e per ognuna invoca gruppi_path_check(): una funzione
                    // NOT DETERMINISTIC che fa una SELECT a ogni chiamata. Su crm.eurosnodi.it
                    // erano oltre 130.000 chiamate per l'elenco anagrafica, 21 secondi di cui 20
                    // di sola funzione; filtrando qui si scende a 1,3 secondi.
                    // E' equivalente perche' la WHERE qui sotto pretende comunque
                    // account_gruppi.id_account = <account>: le righe degli altri account non
                    // potevano contribuire nemmeno prima, venivano calcolate e scartate.
                    // Verificato il 10/09/2026 confrontando l'insieme esatto degli id visibili,
                    // vecchia contro nuova, su tutti e 17 gli account di quel deploy: identici.
                    // Il valore e' interpolato come intero e non come segnaposto perche' i
                    // parametri di questa query sono posizionali e aggiungerne uno sposterebbe il
                    // binding di tutti quelli successivi; id_account e' int(11) e $aclId viene da
                    // $_SESSION['account']['id'].
                    $q .= " LEFT JOIN account_gruppi ON ( account_gruppi.id_account = " . ( (int) $aclId ) . " AND ( account_gruppi.id_gruppo = $aclTb.id_gruppo OR gruppi_path_check( $aclTb.id_gruppo, account_gruppi.id_gruppo ) OR $aclTb.id_account = ? ) )";
                    $whr[] = "( account_gruppi.id_account = ? OR $t$rm.id_account_inserimento = ? )";
                    // NOTA il valore per il ? della JOIN va in TESTA a $vs, perché nella query quel ? precede tutti
                    // quelli della WHERE, compresi i filtri sui campi di $d già accodati sopra; accodandolo, con $d
                    // non vuoto i valori finivano spostati di un posto rispetto ai segnaposto ( corretto il 2026-09-24 )
                    array_unshift( $vs, array('s' => $aclId) );
                    $vs[] = array('s' => $aclId);
                    $vs[] = array('s' => $aclId);
                    $i['__group__'] = array($t . $rm . '.id');
                }

                /**
                 * features della modalità di visualizzazione
                 * ------------------------------------------
                 * Questa modalità consente di estrarre i dati da una tabella applicando filtri, ordinamenti, raggruppamenti e paginazione, in modo da
                 * ottenere un insieme di dati che può essere presentato all'utente. Per ottenere questo, la controller() utilizza diversi parametri
                 * speciali che vengono passati nell'array $_REQUEST['__info__']:
                 * 
                 * parametro                | descrizione
                 * -------------------------|-------------------------------------------------------------
                 * __fields__               | campi da selezionare dalla vista (se non specificato, vengono selezionati tutti i campi)
                 * __search__               | stringa di ricerca da applicare ai campi della vista (se non specificato, non viene applicata alcuna ricerca)
                 * __filters__              | filtri da applicare alla vista (se non specificato, non vengono applicati filtri)
                 * __restrict__             | restrizioni da applicare alla vista (se non specificato, non vengono applicate restrizioni)
                 * __group__                | campi da utilizzare per il raggruppamento dei risultati (se non specificato, non viene applicato alcun raggruppamento)
                 * __sort__                 | campi da utilizzare per l'ordinamento dei risultati (se non specificato, non viene applicato alcun ordinamento)
                 * __pager__                | paginazione dei risultati (se non specificato, non viene applicata alcuna paginazione)
                 * 
                 * I filtri e le restrizioni a disposizione sono i seguenti:
                 * 
                 * parametro                | descrizione
                 * -------------------------|-------------------------------------------------------------
                 * NN                       | not null (il campo non deve essere NULL)
                 * NL                       | null (il campo deve essere NULL)
                 * EQ                       | uguale (il campo deve essere uguale al valore specificato)
                 * GT                       | maggiore (il campo deve essere maggiore del valore specificato)
                 * GE                       | maggiore o uguale (il campo deve essere maggiore o uguale al valore specificato)
                 * LT                       | minore (il campo deve essere minore del valore specificato)
                 * LE                       | minore o uguale (il campo deve essere minore o uguale al valore specificato)
                 * LK                       | like (il campo deve contenere il valore specificato)
                 * IN                       | in (il campo deve essere uno dei valori specificati, separati da |)
                 * NI                       | not in (il campo non deve essere nessuno dei valori specificati, separati da |)
                 * BT                      | between (il campo deve essere compreso tra i due valori specificati, separati da |)
                 * 
                 * L'applicazione di filtri e restrizioni solitamente avviene per tramite del file _src/_inc/_default.view.php, che si occupa di trasformare
                 * le direttive presenti nell'array $_REQUEST['__view__'] in direttive che vengono passate alla controller() tramite l'array $_REQUEST['__info__'].
                 * Si prenda ad esempio la seguente indicazione di filtro:
                 * 
                 * ```
                 * $ct['view']['__restrict__']['id_cliente']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
                 * ```
                 * 
                 * Questa verrà processata dal file _src/_inc/_default.view.php per poi essere passata alla controller(). Per ulteriori dettagli su come passare
                 * istruzioni alla controller() tramite la default view si rimanda ai commenti presenti nel file _src/_inc/_default.view.php. Se si vuole inviare un
                 * comando di filtro direttamente alla controller(), è possibile farlo tramite il parametro $i.
                 * 
                 * TODO qui fare esempio
                 * 
                 * Si noti che è possibile specificare un filtro su campi multipli in OR separandoli con pipe, ad esempio:
                 * 
                 * ```
                 * $ct['view']['__restrict__']['id_cliente|id_fornitore']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
                 * ```
                 * 
                 * TODO finire di documentare (PER BENE!!!)
                 * 
                 * TODO fare file di esempio delle varie modalità di funzionamento della controller()
                 * 
                 */

                /*
                 * UNA DATA SI CERCA COM'E' SCRITTA A VIDEO ( segnalazione Stefano Zoli del
                 * 22/09/2026 )
                 *
                 * Gli elenchi mostrano le date all'italiana ( GG/MM/AAAA, _inc/_macro/
                 * _default.view.php ), ma a database stanno in ISO: cercando "22/09/2026" il LIKE
                 * non trovava niente, e l'operatore non ha modo di saperlo. Qui i termini che hanno
                 * la forma di una data italiana si riscrivono in AAAA-MM-GG prima di entrare nella
                 * WHERE; tutto il resto della stringa non viene toccato.
                 *
                 * Il callback serve per lo zero davanti: "1/9/2026" a database e' "2026-09-01", e
                 * una sostituzione secca darebbe "2026-9-1", che non corrisponde a nessuna riga.
                 */
                if (isset($i['__search__']) && !empty($i['__search__'])) {
                    $i['__search__'] = preg_replace_callback(
                        '#\b([0-9]{1,2})/([0-9]{1,2})/([0-9]{4})\b#',
                        function( $data ) { return sprintf( '%04d-%02d-%02d', $data[3], $data[2], $data[1] ); },
                        $i['__search__']
                    );
                }

                // ricerca nella vista
                if (isset($i['__fields__']) && isset($i['__search__']) && !empty($i['__search__'])) {
                    foreach (explode(' ', $i['__search__']) as $tks) {
                        if (!empty($tks)) {
                            $like = "%$tks%";
                            $equal = "$tks";
                            $cond = array();
                            foreach (preg_filter('/^/', "$t$rm.", $i['__fields__']) as $field) {
                                $cond[] = $field . ( ( isFieldNumeric( $mc, $c, $t, $field) ) ? ' =' : ' LIKE' ) . ' ?';
                                $vs[] = array('s' => ( ( isFieldNumeric( $mc, $c, $t, $field) ) ? $equal : $like ) );
                            }
                            $whr[] = '(' . implode(' OR ', $cond) . ')';
                        }
                    }
                } elseif (isset($i['__search__']) && !empty($i['__search__'])) {
                    foreach (explode(' ', $i['__search__']) as $tks) {
                        if (!empty($tks) && strlen($tks) >= 3) {
                            $like = "%$tks%";
                            $vs[] = array('s' => $like);
                            $cond[] = ' __label__ LIKE ? ';
                        }
                    }
                    $whr[] = '(' . implode(' AND ', $cond) . ')';
                }

                /*
                * TODO IMPORTANTE
                * implementare filtri che implichino una JOIN con filtro sulla tabella di JOIN
                * ad es. cercare sull'anagrafica quelli che hanno un'associazione con la categoria clienti
                * sulla tabella anagrafica_categorie (adesso la cosa è gestita maldestramente con LK)
                */

                // gestione locale dei filtri
                if (isset($i['__filters__']) && !empty($i['__filters__'])) {
                    $filters = $i['__filters__'];
                } else {
                    $filters = array();
                }

                // restrizioni in atto
                if (isset($i['__restrict__']) && !empty($i['__restrict__'])) {
                    $filters = array_replace_recursive(
                        $filters,
                        $i['__restrict__']
                    );
                }

                // filtri della vista
                if (isset($filters) && !empty($filters)) {
                    foreach ($filters as $fc => $sn) {
                        if (strpos($fc, '|') !== false) {
                            foreach ($sn as $sk => $sv) {
                                if ((string) $sv != '') {
                                    switch ($sk) {
                                        case 'EQ':
                                            $whri = array();
                                            $fcs = explode('|', $fc);
                                            foreach ($fcs as $fci) {
                                                $whri[] = "$fci = ?";
                                                $vs[] = array('s' => $sv);
                                            }
                                            $whr[] = '( ' . implode(' OR ', $whri) . ' )';
                                            break;
                                    }
                                }
                            }
                        } else {
                            foreach ($sn as $sk => $sv) {
                                if ((string) $sv != '') {
                                    switch ($sk) {
                                        case 'NN':
                                            $not = ( $sv == '1' ) ? 'NOT' : ( ( $sv < 0 ) ? '' : '' );
                                            $whr[] = "$fc IS $not NULL";
                                            break;
                                        case 'NL':
                                            $not = ( $sv == '1' ) ? '' : ( ( $sv < 0 ) ? 'NOT' : '' );
                                            $whr[] = "$fc IS $not NULL";
                                            break;
                                        case 'EQ':
                                            if( $eqInline && ctype_digit( (string) $sv ) ) {
                                                $eqInlineRipiego[] = array( 'w' => count( $whr ), 'v' => count( $vs ), 'fc' => $fc, 'sv' => $sv );
                                                $whr[] = "$fc = '" . $sv . "'";
                                            } else {
                                                $whr[] = "$fc = ?";
                                                $vs[] = array('s' => $sv);
                                            }
                                            break;
                                        case 'GT':
                                            $whr[] = "$fc > ?";
                                            $vs[] = array('s' => $sv);
                                            break;
                                        case 'GE':
                                            $whr[] = "$fc >= ?";
                                            $vs[] = array('s' => $sv);
                                            break;
                                        case 'LT':
                                            $whr[] = "$fc < ?";
                                            $vs[] = array('s' => $sv);
                                            break;
                                        case 'LE':
                                            $whr[] = "$fc <= ?";
                                            $vs[] = array('s' => $sv);
                                            break;
                                        case 'LK':
                                            $whr[] = "$fc LIKE ?";
                                            $vs[] = array('s' => '%' . $sv . '%');
                                            break;
                                        case 'IN':
                                            $sva = explode('|', $sv);
                                            $whr[] = "$fc IN (" . implode(',', array_fill(0, count($sva), '?')) . ")";
                                            foreach ($sva as $svi) {
                                                $vs[] = array('s' => $svi);
                                            }
                                            break;
                                        case 'NI':
                                            $sva = explode('|', $sv);
                                            $whr[] = "$fc NOT IN (" . implode(',', array_fill(0, count($sva), '?')) . ")";
                                            foreach ($sva as $svi) {
                                                $vs[] = array('s' => $svi);
                                            }
                                            break;
                                        case 'BT':
                                            $sva = explode('|', $sv);
                                            $whr[] = "$fc BETWEEN ? AND ?";
                                            $vs[] = array('s' => $sva[0]);
                                            $vs[] = array('s' => $sva[1]);
                                            break;
                                    }
                                }
                            }
                        }
                    }
                }

                // parte della query che precede le clausole WHERE, per l'eventuale ripiego
                $qBase = $q;

                // aggiungo le clausole WHERE alla query
                if (!empty($whr)) {
                    $q .= ' WHERE ' . implode(' AND ', $whr);
                    // print_r( $whr );
                }

                // raggruppamenti della vista
                if (isset($i['__group__']) && array_filter($i['__group__'])) {
                    $q .= ' GROUP BY ' . implode(', ', $i['__group__']);
                }

                // ordinamenti della vista
                if (isset($i['__sort__']) && array_filter($i['__sort__'])) {
                    $q .= ' ORDER BY ' . arrayKeyValuesImplode($i['__sort__'], ' ', ', ');
                }

                // paginazione della vista
                if (isset($i['__pager__']['page']) && isset($i['__pager__']['rows'])) {
                    $q .= ' LIMIT ' . ($i['__pager__']['page'] * $i['__pager__']['rows']) . ',' . $i['__pager__']['rows'];
                }

                // eseguo la query
                if( ! empty( $eqInlineRipiego ) ) {

                    // tentativo coi valori EQ scritti nella query
                    $eInline = array();
                    $d = mysqlQuery($c, $q, $vs, $eInline);

                    // senza parametri mysqlQuery() non valorizza $e: l'errore si legge dalla connessione
                    if( $d === false || mysqli_errno( $c ) ) {
                        $eInline[] = mysqli_errno( $c );
                    }

                    // ripiego sul parametro
                    if( ! empty( $eInline ) ) {

                        $GLOBALS['cf']['controller']['no_id_inline'][ $t ] = true;
                        logWrite( 'filtro EQ inline non utilizzabile su ' . $t . $rm . ', si ripiega sul parametro per il resto della richiesta', 'controller', LOG_WARNING );

                        // coda della query ( raggruppamenti, ordinamenti, paginazione )
                        $qCoda = substr( $q, strlen( $qBase . ' WHERE ' . implode(' AND ', $whr) ) );

                        // rimetto i ? e i relativi valori nelle loro posizioni
                        foreach( $eqInlineRipiego as $k => $r ) {
                            $whr[ $r['w'] ] = $r['fc'] . ' = ?';
                            array_splice( $vs, $r['v'] + $k, 0, array( array( 's' => $r['sv'] ) ) );
                        }

                        // ricompongo la query
                        $q = $qBase . ' WHERE ' . implode(' AND ', $whr) . $qCoda;

                    }

                }

                if( empty( $eqInlineRipiego ) || ! empty( $eInline ) ) {
                    $d = mysqlQuery($c, $q, $vs, $e['__codes__']);
                }

                // registro il numero totale di righe
                $i['__pager__']['total'] = mysqlSelectValue($c, 'SELECT found_rows() AS t');
                if (isset($i['__pager__']['rows'])) {
                    $i['__pager__']['pages'] = ceil($i['__pager__']['total'] / $i['__pager__']['rows']);
                }

                // log
                logWrite("view mode / eseguo ($a) la query: $q", 'controller');

                // debug
                // echo $q;

                // TODO il valore di ritorno dipende da eventuali errori
                $i['__status__'] = 200;

                // TODO il valore di ritorno dipende da eventuali errori
                return $i['__status__'];

            } elseif( checkModalitaModifica( $d, $t, $a, $i, $pi ) ) {

                /**
                 * la modalità di modifica, inserimento e cancellazione
                 * ----------------------------------------------------
                 * Si arriva qui quando la richiesta non è un elenco e checkModalitaModifica() ha verificato che la riga
                 * sia nuova oppure che l'account abbia i diritti su quella esistente. Il lavoro procede per passi:
                 * inclusione dei controller before, lettura della riga com'era prima (per PUT, REPLACE, UPDATE e
                 * DELETE con id), composizione della query in base al metodo, inclusione dei controller append,
                 * esecuzione della query, traduzione degli errori MySQL in stato, lettura della riga com'è dopo e
                 * confronto prima/dopo (il cui esito finisce in $comparison, con i valori ROW_CREATED, ROW_MODIFIED e
                 * ROW_UNMODIFIED), inclusione dei controller after, elaborazione dei sottomoduli, inclusione dei
                 * controller finally e integrazione finale del blocco dati.
                 *
                 * Il confronto prima/dopo esclude i campi id_account_aggiornamento e timestamp_aggiornamento, che
                 * cambiano a ogni salvataggio. Un metodo non riconosciuto, o $a svuotato da un controller o dalla
                 * guardia anti-riga-vuota più sotto, fa saltare composizione ed esecuzione della query senza errori.
                 *
                 */

                // log
                logWrite("diritti sufficienti per $t/$a", 'controller');
                logWrite("modalità di inserimento, modifica, cancellazione per $t/$a: " . print_r($i, true), 'details/controller/'.$t.'.'.$a);

                /**
                 * Fix 2026-09-11: gli errori segnalati dai controller non vanno più persi
                 * ----------------------------------------------------------------------
                 * Un controller before o append può bloccare l'operazione segnalando un errore in
                 * $i['__status__'] e azzerando $a (p.es. _file.before.php, che rifiuta un file senza
                 * path); prima di questa fix lo stato veniva però sovrascritto con un 200 subito dopo,
                 * qui e più sotto, e l'operazione falliva in perfetto silenzio: niente query, niente
                 * errore a video, niente riga di log. Registro quindi lo stato all'ingresso in $sb, in
                 * modo da riconoscere un errore segnalato da un controller e conservarlo.
                 */
                $sb = $i['__status__'] ?? NULL;

                // controller pre query (before)
                $cn = 'before.php';
                $ct = array_merge(
                    glob($cb . $cn, GLOB_BRACE),
                    glob($cm . $cn, GLOB_BRACE),
                    glob(path2custom($cb . $cn), GLOB_BRACE),
                    glob(path2custom($cm . $cn), GLOB_BRACE)
                );
                foreach ($ct as $f) {
                    require $f;
                    timerCheck( $timer, '-> -> fine elaborazione di ' . $f );
                }

                // stato di default, a meno che un controller before non abbia segnalato un errore
                $sg = ( isset( $i['__status__'] ) && $i['__status__'] >= 400 && $i['__status__'] !== $sb );
                if( $sg ) {
                    logWrite( "controller before ha bloccato $t/$a con stato " . $i['__status__'], 'controller', LOG_ERR );
                } else {
                    $i['__status__'] = 200;
                }

                // variabile per confronto prima/dopo
                $before = NULL;

                // recupero dati per confronto prima/dopo
                if (isset($d['id'])) {
                    switch (strtoupper($a)) {
                        case METHOD_PUT:
                        case METHOD_REPLACE:
                        case METHOD_UPDATE:
                        case METHOD_DELETE:
                            $before = md5(serialize(
                                mysqlSelectRow($c, 'SELECT ' . implode(',', array_diff($ks, array('id_account_aggiornamento', 'timestamp_aggiornamento'))) . ' FROM ' . $t . ' WHERE id = ?', array(array('s' => $d['id'])))
                            ));
                            $befores = mysqlSelectRow($c, 'SELECT * FROM ' . $t . ' WHERE id = ?', array(array('s' => $d['id'])));
                            break;
                    }
                }

                /**
                 * Fix 2026-05-22: guardia anti-riga-vuota per i sottomoduli
                 * ---------------------------------------------------------
                 * Evita l'INSERT di una NUOVA riga (senza id) priva di contenuto reale, tipico delle
                 * righe di sottomodulo aggiunte col pulsante "+" e salvate vuote (telefoni/mail/indirizzi).
                 * La mappa $GLOBALS['cf']['controller']['campi_contenuto'][$t] (popolata in
                 * src/config/730.controller.php) elenca i campi-contenuto della tabella: se è una nuova
                 * riga in inserimento e TUTTI quei campi sono vuoti/NULL, la riga è "vuota" e non va creata.
                 * Tabelle non mappate -> comportamento invariato. Annullo $a così nessun ramo dello switch
                 * di composizione/esecuzione costruisce o esegue una query (coerente con la riga ~771).
                 */
                $campiContenuto = $GLOBALS['cf']['controller']['campi_contenuto'][ $t ] ?? null;
                if(
                    is_array( $campiContenuto ) && count( $campiContenuto )
                    && empty( $d['id'] )
                    && in_array( strtoupper( $a ), array( METHOD_POST, METHOD_REPLACE, METHOD_UPDATE ), true )
                ) {
                    $rigaVuota = true;
                    foreach( $campiContenuto as $campoContenuto ) {
                        $valoreContenuto = $vs[ $campoContenuto ]['s'] ?? null;
                        if( $valoreContenuto !== null && $valoreContenuto !== '' ) {
                            $rigaVuota = false;
                            break;
                        }
                    }
                    if( $rigaVuota ) {
                        logWrite( "riga sottomodulo '$t' senza contenuto reale: INSERT saltato", 'controller' );
                        $a = '';
                    }
                }

                // composizione della query in base all'azione richiesta
                switch (strtoupper($a)) {

                    // inserimento di un nuovo record
                    case METHOD_POST:

                        // compongo la query
                        $q = "INSERT INTO $t (" . implode(',', $ks) . ") VALUES (" . implode(',', array_fill(0, count($ks), '?')) . ") ";

                        break;

                    // modifica di un record già esistente
                    case METHOD_PUT:

                        // compongo la query
                        $q = "UPDATE $t SET ";

                        // compongo i campi della query
                        foreach ($ks as $k) {
                            $tks[] = "$k = ?";
                        }

                        // compongo la condizione WHERE
                        $q .= implode(', ', $tks) . " WHERE id = ?";

                        // aggiungo l'id per la clausola WHERE
                        $vs[] = array('s' => $d['id']);

                        break;

                    // rimpiazzo di un record già esistente
                    case METHOD_REPLACE:

                        // compongo la query
                        $q = "REPLACE INTO $t (" . implode(',', $ks) . ") VALUES (" . implode(',', array_fill(0, count($ks), '?')) . ") ";

                        break;

                    // aggiornamento di un record già esistente con INSERT INTO ... ON DUPLICATE KEY UPDATE
                    case METHOD_UPDATE:

                        // compongo la query
                        $q = "INSERT INTO $t (" . implode(',', $ks) . ") VALUES (" . implode(',', array_fill(0, count($ks), '?')) . ") ";
                        $vks = [];
                        foreach ($ks as $k) {
                            $vks[] = "$k=VALUES($k)";
                        }
                        $q .= "ON DUPLICATE KEY UPDATE " . ((!in_array('id', $ks)) ? "id=LAST_INSERT_ID(id)," : NULL) . implode(',', $vks);

                        break;

                    // eliminazione di un record già esistente
                    case METHOD_DELETE:

                        // compongo la query
                        $q = "DELETE FROM $t WHERE id = ?";

                        // forzo il reset del form
                        $r = true;

                        break;

                    // prelevamento di un record già esistente
                    case METHOD_GET:

                        // compongo la query
                        $q = "SELECT * FROM $t" . (( ! empty( $fvm ) ) ? $rm : '');

                        // compongo i campi della query
                        foreach ($ks as $k) {
                            $tks[] = "$k = ?";
                        }

                        // compongo la condizione WHERE
                        if (is_array($tks) && array_filter($tks)) {
                            $q .= " WHERE " . implode(' AND ', $tks);
                            // print_r( $tks );
                        }

                        break;

                }

                // controller in query (append)
                $cn = 'append.php';
                $ct = array_merge(
                    glob($cb . $cn, GLOB_BRACE),
                    glob($cm . $cn, GLOB_BRACE),
                    glob(path2custom($cb . $cn), GLOB_BRACE),
                    glob(path2custom($cm . $cn), GLOB_BRACE)
                );
                foreach ($ct as $f) {
                    require $f;
                    timerCheck( $timer, '-> -> fine elaborazione di ' . $f );
                }

                // esecuzione della query
                switch (strtoupper($a)) {

                    // inserimento di un nuovo record
                    case METHOD_POST:

                        // eseguo la query
                        $d['id'] = mysqlQuery($c, $q, $vs, $e['__codes__']);

                        break;

                    // modifica o cancellazione di un oggetto esistente
                    case METHOD_PUT:
                    case METHOD_DELETE:

                        // eseguo la query
                        mysqlQuery($c, $q, $vs, $e['__codes__']);

                        break;

                    // rimpiazzo di un oggetto esistente
                    case METHOD_REPLACE:
                    case METHOD_UPDATE:

                        // eseguo la query
                        $id = mysqlQuery($c, $q, $vs, $e['__codes__']);
                        $d['id'] = (isset($d['id']) && !empty($d['id'])) ? $d['id'] : $id;

                        break;

                    // prelevamento di un oggetto esistente
                    case METHOD_GET:

                        // eseguo la query
                        $d = mysqlQuery($c, $q, $vs, $e['__codes__']);

                        if (is_array($d)) {
                            $d = array_shift($d);
                        }

                        logger('righe recuperate dalla query ' . $q . ': ' . print_r($d,true), 'details/controller/select');
                        logger('valori utilizzati dalla query ' . $q . ': ' . print_r($vs,true), 'details/controller/select');

                        break;

                }


                // stato di default, a meno che un controller before o append non abbia segnalato un errore
                $sg = ( isset( $i['__status__'] ) && $i['__status__'] >= 400 && $i['__status__'] !== $sb );
                if( ! $sg ) {
                    $i['__status__'] = 200;
                }

                // gestione degli errori
                if (isset($e['__codes__']) && is_array($e['__codes__'])) {

                    if (array_key_exists('1062', $e['__codes__'])) {
                        $i['__status__'] = 409;
                        $i['__err__'] = $e['__codes__']['1062'][0];
                    }

                    if (array_key_exists('1054', $e['__codes__'])) {
                        $i['__status__'] = 400;
                        $i['__err__'] = $e['__codes__']['1054'][0];
                    }

                } elseif (empty($a)) {

                    // log
                    if( $sg ) {
                        logWrite("nessuna azione intrapresa per l'entità $t: bloccata da un controller con stato " . $i['__status__'], 'controller', LOG_ERR);
                    } else {
                        logWrite("nessuna azione intrapresa per l'entità $t", 'controller');
                    }

                } else {

                    // log
                    logWrite("row mode / eseguo ($a) la query: $q", 'controller');

                }

                // variabile per confronto prima/dopo
                $after = NULL;

                // recupero dati per confronto prima/dopo
                switch (strtoupper($a)) {
                    case METHOD_POST:
                    case METHOD_PUT:
                    case METHOD_REPLACE:
                    case METHOD_UPDATE:
                        $afters = mysqlSelectRow($c, 'SELECT ' . implode(',', array_diff($ks, array('id_account_aggiornamento', 'timestamp_aggiornamento'))) . ' FROM ' . $t . ' WHERE id = ?', array(array('s' => $d['id'])));
                        $after = md5(serialize($afters));
                        break;
                }

                // esito del controllo prima/dopo
                $comparison = ($before !== $after) ? ((empty($before)) ? ROW_CREATED : ROW_MODIFIED) : ROW_UNMODIFIED;

                // log
                logWrite("record $comparison per la query: $q", 'controller');

                // controller post query (after)
                $cn = 'after.php';
                $ct = array_merge(
                    glob($cb . $cn, GLOB_BRACE),
                    glob($cm . $cn, GLOB_BRACE),
                    glob(path2custom($cb . $cn), GLOB_BRACE),
                    glob(path2custom($cm . $cn), GLOB_BRACE)
                );
                foreach ($ct as $f) {
                    require $f;
                    timerCheck( $timer, '-> -> fine elaborazione di ' . $f );
                }

                /**
                 * gestione dei sotto moduli
                 * -------------------------
                 * I sottomoduli messi da parte in $s all'inizio vengono reintegrati nel blocco dati, e poi, a meno che
                 * non sia stata richiesta la visualizzazione forzata (__forced_view__), elaborati con una chiamata
                 * ricorsiva della controller() per ciascuna riga:
                 *
                 * - in scrittura (POST, PUT, REPLACE, UPDATE) ogni riga di ogni sottomodulo presente nel blocco dati
                 *   viene passata alla controller() con lo stesso metodo, con l'entità pari al nome del sottomodulo e
                 *   con l'id della riga corrente come id padre, da usare con il valore speciale __parent_id__;
                 * - in lettura (GET con id nei campi) la controller() cerca in information_schema le tabelle che hanno
                 *   una chiave esterna verso l'entità corrente, escluse quelle il cui vincolo termina in _nofollow,
                 *   legge gli id delle righe collegate (ordinate secondo l'eventuale indice SORTING) e chiama sé stessa
                 *   in GET per ciascuna, riempiendo $d[ <tabella figlia> ][ <indice> ]; se una tabella figlia ha più
                 *   di 10 righe o richiede più di 1,5 secondi viene scritta una riga nel log speed.
                 *
                 * La DELETE non viene propagata ai sottomoduli da questa funzione: cosa succede alle righe collegate
                 * dipende dai vincoli di chiave esterna definiti sul database.
                 *
                 */

                // reintegrazione dei sottomoduli
                if (is_array($d)) {
                    $d = array_merge($d, $s);
                }

                // timer
                timerCheck( $timer, '-> -> inizio elaborazione sotto moduli' );

                if (empty($fvm)) {

                    // elaborazione dei sottomoduli
                    switch (strtoupper($a)) {
                        case METHOD_POST:
                        case METHOD_PUT:
                        case METHOD_REPLACE:
                        case METHOD_UPDATE:
                            foreach ($d as $k => $v) {
                                if (is_array($v)) {
                                    foreach ($v as $x => $y) {
                                        controller($c, $mc, $d[$k][$x], $k, $a, $d['id'], $e, $i[$k][$x], $i['__auth__'], $ci, $timer);
                                    }
                                }
                            }
                            break;

                        case METHOD_GET:
                            if (in_array('id', $ks)) {
                                $x = mysqlCachedQuery($mc, $c, 'SELECT * FROM information_schema.key_column_usage WHERE referenced_table_name = ? AND constraint_name NOT LIKE "%_nofollow" AND table_schema = database()', array(array('s' => $t)));
                                $xrefs = array();
                                foreach ($x as $ref) {
                                    $xrefs[$ref['TABLE_NAME']]['TABLE_NAME'] = $ref['TABLE_NAME'];
                                    $xrefs[$ref['TABLE_NAME']]['COLUMN_NAME'][] = $ref['COLUMN_NAME'];
                                }

                                foreach ($xrefs as $ref) {

                                    $refCols = array();
                                    foreach ($ref['COLUMN_NAME'] as $colName) {
                                        $refCols[] = $colName . " = '" . $d['id'] . "'";
                                    }

                                    /**
                                     * L'indice SORTING si chiede a memcache, non al database.
                                     *
                                     * Questa riga sta dentro il ciclo sulle tabelle figlie, quindi
                                     * gira una volta per figlia a ogni apertura di scheda — e di
                                     * nuovo, per ogni riga figlia, sulle figlie di quella. Su una
                                     * scheda con qualche sottomodulo sono facilmente una dozzina di
                                     * `SHOW INDEX` per caricamento, cioè il grosso delle query
                                     * della cascata, tutte per chiedere sempre la stessa cosa: se
                                     * una tabella ha o non ha l'indice `SORTING`.
                                     *
                                     * È **schema**, non dato: cambia quando qualcuno fa una
                                     * migrazione, non quando un utente salva un record. La riga qui
                                     * sopra, che interroga `information_schema` per scoprire quali
                                     * sono le tabelle figlie, passa già da `mysqlCachedQuery()` per
                                     * lo stesso identico motivo.
                                     *
                                     * TTL esplicito di un'ora invece del default: dove
                                     * `MEMCACHE_DEFAULT_TTL` vale 0 uno schema resterebbe in cache
                                     * per sempre e non si riallineerebbe più dopo una migrazione
                                     * senza un flush a mano.
                                     *
                                     * VERIFICATO che l'ordinamento non cambi, perché è l'unica cosa
                                     * che questa riga può rompere. Il dubbio è il ramo di cache HIT:
                                     * `memcacheWrite()` salva `serialize( $data )` e
                                     * `memcacheRead()` rileva la stringa serializzata e la
                                     * deserializza, quindi un risultato **vuoto** torna come
                                     * `array()` e non come `false` — che è ciò che conta, perché
                                     * `mysqlCachedQuery()` decide se usare la cache con
                                     * `$r === false`. Provato contro un memcached vivo su tutti e
                                     * tre i casi: tabella senza indice ( nessun ORDER BY, prima e
                                     * dopo ), con `SORTING` su una colonna, e con `SORTING` su due
                                     * colonne — dove si verifica anche che l'ordine delle colonne
                                     * sopravviva al giro. Identici.
                                     *
                                     * Nota di contorno: sul deploy da cui questa modifica è nata
                                     * **nessuna tabella ha l'indice `SORTING`**, e nemmeno gli
                                     * schemi standard lo definiscono. Quelle query tornavano sempre
                                     * vuote: si pagava una dozzina di interrogazioni a richiesta
                                     * per non aggiungere mai nessun ORDER BY.
                                     */
                                    $idx = array_column(mysqlCachedQuery($mc, $c, 'SHOW INDEX FROM ' . $ref['TABLE_NAME'] . ' WHERE key_name = "SORTING"', false, 3600), 'Column_name');
                                    $q = "SELECT id FROM " . $ref['TABLE_NAME'] . " WHERE " . implode(' OR ', $refCols) . ((count($idx)) ? ' ORDER BY ' . implode(', ', $idx) : NULL);
                                    $rows = mysqlQuery($c, $q);
                                    logWrite("cerco le referenze a " . $ref['TABLE_NAME'] . " dove " . implode($ref['COLUMN_NAME']) . " è " . $d['id'] . ", " . count($rows) . " referenze trovate", 'controller');
                                    $tStart = timerNow();
                                    $ix = 0;
                                    foreach ($rows as $row) {
                                        if (!empty($row['id'])) {
                                            $d[$ref['TABLE_NAME']][$ix]['id'] = $row['id'];
                                            $e[$ref['TABLE_NAME']][$ix] = array();
                                            $i[$ref['TABLE_NAME']][$ix] = array();
                                            controller($c, $mc, $d[$ref['TABLE_NAME']][$ix], $ref['TABLE_NAME'], $a, NULL, $e[$ref['TABLE_NAME']][$ix], $i[$ref['TABLE_NAME']][$ix], $i['__auth__'], $ci, $timer);
                                            $ix++;
                                        }
                                    }
                                    $tDone = timerDiff($tStart);
                                    if (count($rows) > 10 || $tDone > 1.5) {
                                        logWrite($ref['TABLE_NAME'] . ' causa overload: ' . $tDone . ' secondi, ' . count($rows) . ' righe', 'speed', LOG_ERR);
                                    }

                                }

                            }

                            break;
                    }

                }

                // timer
                timerCheck( $timer, '-> -> fine elaborazione sotto moduli' );

                // controller post elaborazione (finally)
                $cn = 'finally.php';
                $ct = array_merge(
                    glob($cb . $cn, GLOB_BRACE),
                    glob($cm . $cn, GLOB_BRACE),
                    glob(path2custom($cb . $cn), GLOB_BRACE),
                    glob(path2custom($cm . $cn), GLOB_BRACE)
                );
                // logWrite(print_r($ct, true), 'controllers/' . $t, LOG_ERR);	// debug disattivato: dump a ogni controller, saturava var/log/controllers/*.err
                foreach ($ct as $f) {
                    require $f;
                    timerCheck( $timer, '-> -> fine elaborazione di ' . $f );
                }

                /**
                 * operazioni finali
                 * -----------------
                 * Se è stato richiesto il reset del blocco dati (con __reset__, o implicitamente con la DELETE) il blocco
                 * viene salvato in $_SESSION['__latest__'][ $t ], così che la pagina possa ancora mostrare cosa è stato
                 * appena elaborato, e poi svuotato lasciando solo la chiave __reset__ a 1.
                 *
                 * Altrimenti, per GET, POST, PUT, REPLACE e UPDATE, la riga viene riletta per id dalla vista dell'entità
                 * e unita al blocco dati, in modo che il chiamante riceva anche i campi calcolati dalla vista (ad
                 * esempio __label__); i valori già presenti nel blocco dati prevalgono su quelli letti. Se la lettura
                 * non trova niente il blocco dati resta com'è.
                 *
                 */

                // svuotamento o integrazione del blocco dati
                if ($r) {

                    $_SESSION['__latest__'][$t] = $d;
                    $d = array();
                    $d['__reset__'] = 1;

                } else {

                    switch (strtoupper($a)) {
                        case METHOD_GET:
                        case METHOD_POST:
                        case METHOD_PUT:
                        case METHOD_REPLACE:
                        case METHOD_UPDATE:

                            /**
                             * Lettura per id da una VISTA: il valore va scritto DENTRO la query,
                             * non legato come parametro.
                             *
                             * MariaDB 10.3 non spinge la condizione dentro una vista con GROUP BY
                             * se il valore arriva da un segnaposto: il piano passa da `const` su una
                             * riga a `ALL` sull'intera tabella, con tutti i JOIN della vista
                             * eseguiti per ognuna. Misurato in produzione su `contratti_view` il
                             * 17/09/2026: 0,014 s con il valore nella query, 0,5-1,8 s con il `?`, a
                             * parita' di tutto il resto ( EXPLAIN: `contratti const 1` contro
                             * `contratti ALL 5384`, derived stimato 7.774.496 righe ). La cascata di
                             * una scheda ne fa decine: sono i 7 secondi che la segreteria vede sulla
                             * scheda iscrizione, e il motivo per cui togliere i lock delle statiche
                             * non era bastato.
                             *
                             * Si interpola SOLO un id fatto di sole cifre, castato a intero: nessun
                             * altro valore raggiunge la query, quindi non c'e' spazio per
                             * un'iniezione. Tutto il resto — id non interi come quelli degli
                             * articoli, viste statiche, tabelle vere — resta sul prepared statement,
                             * dove il problema non si pone perche' si legge da una tabella con la
                             * chiave primaria.
                             *
                             * ⚠ La rete sotto, imparata da un errore in produzione il 17/09. Su
                             * alcune viste il valore scritto fa fallire la query con
                             * `ERRORE 1052 Column 'id' in order clause is ambiguous`: sono quelle che
                             * raggruppano su due colonne `id` di tabelle diverse
                             * ( `group by contratti.id, anagrafica.id` ), dove la condizione spinta
                             * dentro la vista diventa ambigua. Col segnaposto non succede, perche' la
                             * vista viene materializzata prima; nessun alias esterno lo evita.
                             *
                             * Due livelli, e nessuno dei due nomina le viste di un deploy:
                             * - `$cf['controller']['no_id_inline'][ <tabella> ]` le dichiara in
                             *   configurazione, per chi le conosce gia' e non vuole pagare nemmeno il
                             *   primo errore ( la stessa chiave la legge refreshStaticView() );
                             * - se una query interpolata fallisce lo stesso, si ripiega SUBITO sul
                             *   prepared statement e la tabella si segna per il resto della
                             *   richiesta, cosi' l'errore si paga una volta sola e mai il risultato.
                             */
                            $idInline = ( $rm === '_view' )
                                     && ctype_digit( (string) ( $d['id'] ?? '' ) )
                                     && empty( $GLOBALS['cf']['controller']['no_id_inline'][ $t ] );

                            $w = array();

                            if( $idInline ) {

                                $eInline = array();
                                $w = mysqlSelectRow($c, "SELECT * FROM $t$rm WHERE id = " . (int) $d['id'], false, $eInline);

                                if( ! empty( $eInline ) ) {
                                    $GLOBALS['cf']['controller']['no_id_inline'][ $t ] = true;
                                    $idInline = false;
                                    $w = array();
                                    logWrite( 'lettura per id inline non utilizzabile su ' . $t . $rm . ', si ripiega sul parametro per il resto della richiesta', 'controller', LOG_WARNING );
                                }

                            }

                            if( ! $idInline ) {
                                $w = mysqlSelectRow($c, "SELECT * FROM $t$rm WHERE id = ?", array(array('s' => $d['id'])));
                            }

                            timerCheck( $timer, '-> -> fine integrazione blocco dati' );

                            if (is_array($w) && is_array($d)) {
                                $d = array_merge($w, $d);
                            }

                            break;

                    }

                }

                return $i['__status__'];

            } else {

                // log dei diritti insufficienti sulla riga ( lo stato non viene impostato, vedi il TODO nel docblock )
                logWrite("diritti INSUFFICIENTI per $t/$a - " . $d['id'], 'controller');

            }

        } else {

            // log
            logWrite("permessi insufficienti per gestire $t/$a", 'controller');

            // restituisco 401 unauthorized
            $i['__status__'] = 401;

        }

        // log
        logWrite("esito finale per $t/$a: " . $i['__status__'], 'controller');

        // restituzione di 200 per default
        return $i['__status__'] ?? 200;

    }

    /**
     * FUNZIONI DI VERIFICA
     */

    /**
     * verifica se una chiave di $_REQUEST è un blocco dati da elaborare
     *
     * Questa funzione è usata da _src/_config/_750.controller.php per decidere quali array di $_REQUEST passare alla
     * controller(): restituisce true per ogni chiave che non comincia con il doppio underscore (il nome di
     * un'entità) e per le chiavi che cominciano con __report, cioè le entità di report, mentre restituisce false
     * per le altre chiavi speciali (__info__, __err__, __view__...). Una chiave vuota o di un solo carattere non
     * comincia con __ e quindi restituisce true.
     *
     * NOTA il ramo strlen( $k ) < 2 non viene mai raggiunto, perché una chiave così corta non comincia con __ ed
     * è già stata accettata dalla prima condizione
     *
     * @param       string      $k      la chiave di $_REQUEST da verificare
     *
     * @return      bool                true se la chiave è un blocco dati da elaborare, false altrimenti
     *
     */
    function checkNomeBloccoDati( $k ) {

        if( substr( $k, 0, 2 ) !== '__' || substr( $k, 0, 8 ) == '__report' ) {
            return true;
        } elseif( strlen( $k ) < 2 ) {
            return false;
        } else {
            return false;
        }

    }

    /**
     * verifica se la richiesta va trattata in modalità view
     *
     * Questa funzione restituisce true se il metodo è esattamente METHOD_GET (il confronto è stretto e sensibile
     * alle maiuscole) e il blocco dati non ha la chiave id, oppure se è stata richiesta esplicitamente la modalità
     * view; in ogni altro caso restituisce false e la controller() prova la modalità modifica. Basta la presenza
     * della chiave id, anche con valore vuoto, per escludere la modalità view.
     *
     * @param       string      $a      il metodo della richiesta
     * @param       array       $d      il blocco dati
     * @param       bool        $vm     true se è stata richiesta esplicitamente la modalità view (__view_mode__)
     *
     * @return      bool                true se la richiesta va trattata in modalità view, false altrimenti
     *
     */
    function checkModalitaVisualizzazione( $a, $d, $vm ) {

        if ($a === METHOD_GET && (!array_key_exists('id', $d) || $vm === true)) {
            return true;
        } else {
            return false;
        }

    }

    /**
     * verifica se la richiesta può essere trattata in modalità modifica
     *
     * Questa funzione restituisce true se il blocco dati non ha un id valorizzato (si tratta quindi di una riga
     * nuova, per cui bastano i permessi sull'entità già verificati dalla controller()), oppure se l'account ha i
     * diritti sulla riga esistente secondo getAclRights(), oppure se il blocco dati porta una firma di importazione
     * valida secondo checkFirmaImportazione(); altrimenti restituisce false.
     *
     * NOTA $i è passato per valore, per cui le eventuali modifiche fatte da getAclRights() non tornano alla
     * controller(); inoltre $pi viene passato a getAclRights() come quinto argomento, ma quella funzione ne
     * dichiara solo quattro e lo ignora
     *
     * @param       array       $d      il blocco dati
     * @param       string      $t      il nome dell'entità
     * @param       string      $a      il metodo della richiesta
     * @param       array       $i      l'array delle informazioni
     * @param       array       $pi     ignorato (vedi la nota sopra)
     *
     * @return      bool                true se la richiesta può essere trattata in modalità modifica, false altrimenti
     *
     */
    function checkModalitaModifica( $d, $t, $a, $i, $pi ) {

        if(!isset($d['id']) || (getAclRights($t, $a, $d['id'], $i, $pi) != false || checkFirmaImportazione($d, $t) != false)) {
            return true;
        } else {
            return false;
        }

    }

    /**
     * verifica se un campo di una tabella è di tipo numerico
     *
     * Questa funzione è usata dalla ricerca della modalità view della controller() per decidere se cercare un termine
     * in un campo con = (campi numerici) o con LIKE (tutti gli altri). Il campo può essere passato con il prefisso
     * della tabella (tabella.campo), che viene tolto; il tipo viene letto da INFORMATION_SCHEMA.COLUMNS del database
     * corrente con una query in cache, e il campo è considerato numerico se il tipo è int, tinyint, smallint,
     * mediumint, bigint, decimal, float, double o bit. Se la tabella o il campo non esistono restituisce false.
     *
     * NOTA la controller() le passa il nome della tabella $t e non quello della vista su cui cerca, per cui un campo
     * che esiste solo nella vista risulta non numerico e viene cercato con LIKE; l'array $textTypes non viene usato
     *
     * @param       object      $m      la connessione a memcache
     * @param       mysqli      $c      la connessione al database
     * @param       string      $table  il nome della tabella
     * @param       string      $field  il nome del campo, eventualmente preceduto da tabella e punto
     *
     * @return      bool                true se il campo è di tipo numerico, false altrimenti
     *
     */
    function isFieldNumeric( $m, $c, $table, $field ) {

        $field = preg_replace('/^.*\./', '', $field);

        $numericTypes = [
            'int','tinyint','smallint','mediumint','bigint',
            'decimal','float','double','bit'
        ];

        $textTypes = [
            'char','varchar','text','tinytext','mediumtext','longtext'
        ];

        $type = mysqlSelectCachedValue( $m, $c,
            'SELECT DATA_TYPE
            FROM INFORMATION_SCHEMA.COLUMNS
            WHERE TABLE_SCHEMA = DATABASE()
            AND TABLE_NAME = ? AND COLUMN_NAME = ?',
            array(
                array( 's' => $table ),
                array( 's' => $field )
            )
        );

        if( in_array( strtolower( $type ?? '' ), $numericTypes, true ) ) {
            return true;
        } else {
            return false;
        }

    }

