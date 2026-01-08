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
     * TODO documentare
     *
     */
    function controller($c, $mc, &$d, $t, $a = METHOD_GET, $p = NULL, &$e = array(), &$i = array(), &$pi = array(), &$ci = array(), $timer = array()) {

        /**
         * inizializzazione delle variabili
         * --------------------------------
         * In questa sezione vengono inizializzate le variabili che verranno poi utilizzate nella funzione.
         * 
         */

        // log
        logWrite("$t/$a", 'controller');

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

            // elaborazione subform
            foreach ($s as $x => $y) {
                controller($c, $mc, $y, $t, $a, NULL, $e, $i[$t][$x], $i['__auth__']);
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

                // filtri per i campi
                foreach ($ks as $fk) {
                    $whr[] = "$fk = ?";
                }

                // unisco la tabella di ACL se presente
                if (!empty($aclTb)) {
                    $q .= " LEFT JOIN $aclTb ON $aclTb.id_entita = $t$rm.id ";
                    $q .= " LEFT JOIN account_gruppi ON ( account_gruppi.id_gruppo = $aclTb.id_gruppo OR gruppi_path_check( $aclTb.id_gruppo, account_gruppi.id_gruppo ) OR $aclTb.id_account = ? )";
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

                // ricerca nella vista
                if (isset($i['__fields__']) && isset($i['__search__']) && !empty($i['__search__'])) {
                    foreach (explode(' ', $i['__search__']) as $tks) {
                        if (!empty($tks)) {
                            $like = "%$tks%";
                            $cond = array();
                            foreach (preg_filter('/^/', "$t$rm.", $i['__fields__']) as $field) {
                                $cond[] = $field . ( ( isFieldNumeric( $mc, $c, $t, $field) ) ? ' =' : ' LIKE' ) . ' ?';
                                $vs[] = array('s' => $like);
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
                                            $whr[] = "$fc = ?";
                                            $vs[] = array('s' => $sv);
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
                $d = mysqlQuery($c, $q, $vs, $e['__codes__']);

                // registro il numero totale di righe
                $i['__pager__']['total'] = mysqlSelectValue($c, 'SELECT found_rows() AS t');
                if (isset($i['__pager__']['rows'])) {
                    $i['__pager__']['pages'] = ceil($i['__pager__']['total'] / $i['__pager__']['rows']);
                }

                // log
                logWrite("view mode / eseguo ($a) la query: $q", 'controller');

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

                // ...
                $i['__status__'] = 200;

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


                $i['__status__'] = 200;

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

                    // di default imposto lo stato a 'OK'
                    $i['__status__'] = 200;

                    // log
                    logWrite("nessuna azione intrapresa per l'entità $t", 'controller');

                } else {

                    // log
                    logWrite("row mode / eseguo ($a) la query: $q", 'controller');

                    // di default imposto lo stato a 'OK'
                    $i['__status__'] = 200;

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
                                        controller($c, $mc, $d[$k][$x], $k, $a, $d['id'], $e, $i[$k][$x], $i['__auth__']);
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

                                    $idx = array_column(mysqlQuery($c, 'SHOW INDEX FROM ' . $ref['TABLE_NAME'] . ' WHERE key_name = "SORTING"'), 'Column_name');
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
                                            controller($c, $mc, $d[$ref['TABLE_NAME']][$ix], $ref['TABLE_NAME'], $a, NULL, $e[$ref['TABLE_NAME']][$ix], $i[$ref['TABLE_NAME']][$ix], $i['__auth__']);
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
                logWrite(print_r($ct, true), 'controllers/' . $t, LOG_ERR);
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

                            $w = mysqlSelectRow($c, "SELECT * FROM $t$rm WHERE id = ?", array(array('s' => $d['id'])));

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

            // restituisco 401 unauthorized
            $i['__status__'] = 401;

        }

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

        if( in_array( $type, $numericTypes, true ) ) {
            return true;
        } else {
            return false;
        }

    }

