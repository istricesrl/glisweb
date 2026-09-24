<?php

    /**
     *
     *
     *
     *
     *
     * TODO documentare
     *
     */

    // costanti
    define('ROW_CREATED', 'INSERITO');
    define('ROW_MODIFIED', 'MODIFICATO');
    define('ROW_UNMODIFIED', 'INVARIATO');

    /**
     * 
     * 
     * 
     * 
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * 
     * modalità view
     * =============
     * 
     * 
     * 
     * 
     * 
     * 
     * modalità modifica
     * =================
     * 
     * 
     * 
     * 
     * punti di inclusione delle controller
     * ------------------------------------
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     *
     */
    /**
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
        $s                      = array();                                      // 
        $r                      = false;                                        // 
        $ks                     = array();                                      // l'array delle chiavi (nomi dei campi)
        $vs                     = array();                                      // l'array dei valori (valori dei campi)
        $vm                     = false;                                        // 
        $rm                     = getStaticViewExtension($mc, $c, $t);          // 

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
         * 
         * 
         */

        // ...
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
                    $vs[] = array('s' => $aclId);
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
                 * BT                       | between (il campo deve essere compreso tra i due valori specificati, separati da |)
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
                 * 
                 * 
                 * 
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
                 * 
                 * 
                 * 
                 * 
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
                 * 
                 * 
                 * 
                 * 
                 * 
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

                // ...
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
     * 
     * 
     * 
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
     * 
     * 
     * 
     * 
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
     * 
     * 
     * 
     * 
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
     * TODO documentare
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

