<?php

    /**
     * gestione dei flussi dati
     *
     * in questo file vengono gestiti i dati in ingresso e in uscita dal framework
     *
     * introduzione
     * ============
     * Il framework gestisce i dati in ingresso e in uscita tramite la funzione controller() che viene invocata qui
     * in base ai blocchi dati ricevuti tramite uno dei seguenti canali:
     * 
     * - input tramite file di testo
     * - input tramite chiamate REST
     * - input tramite form HTTP (GET/POST)
     * 
     * L'input tramite file di testo è gestito in /_src/_config/_740.controller.php, mentre le chiamate REST vengono
     * gestite da /_src/_api/_rest.php; entrambe queste modalità vengono ricondotte poi alla terza, che è quella
     * standard di gestione dei dati tramite il framework.
     * 
     * In sostanza, se vogliamo che il framework processi un insieme di dati, è sufficiente che gli passiamo, tramite
     * uno dei metodi visti sopra, un array contenente in chiave il nome dell'entità cui i dati si riferiscono, e i dati
     * stessi andranno rappresentati come un array associativo. Si supponga ad esempio di voler inserire una riga
     * nella tabella "test" con i campi "id" e "nome", l'array che dovrò passare alla controller sarà:
     * 
     * ```
     * $_REQUEST['test'] = array(
     *    'id' => 1,
     *   'nome' => 'root'
     * );
     * ```
     * il quale può banalmente provenire tramite POST da un semplice form HTML che contenga i campi "id" e "nome",
     * ad esempio:
     * 
     * ```
     * <form method="post" action="...">
     *  <input type="text" name="test[id]" value="1" />
     *  <input type="text" name="test[nome]" value="root" />
     *  <input type="submit" value="Invia" />
     * </form>
     * ```
     * 
     * oppure in alternativa tramite una chiamata REST, con metodo POST, contenente del JSON nel body, effettuata
     * tramite cURL (è importante specificare il tipo di contenuto come application/json):
     * 
     * ```
     * curl -X POST -H "Content-Type: application/json" -d '{"test":{"id":1,"nome":"root"}}' https://.../api/rest
     * ```
     * 
     * Infine è possibile caricare i dati da un file CSV, che deve essere posizionato nella cartella /var/spool/import
     * e il cui nome deve rispettare la nomenclatura <metodo>.<tabella>.csv, ad esempio:
     * 
     * ```
     * post.test.csv
     * ```
     * 
     * con il seguente contenuto di esempio:
     * 
     * ```
     * id;nome
     * 1;root
     * 2;admin
     * 3;guest
     * ```
     * 
     * Per ulteriori dettagli su questi metodi si consiglia di leggere attentamente la documentazione relativa ai
     * file _src/_config/_740.controller.php e _src/_api/_rest.php.
     *
     * il concetto di entità
     * =====================
     * All'interno del framework è definita come un'entità l'insieme di logiche che riguardano la gestione di un
     * determinato oggetto o concetto del mondo reale; solitamente fra queste logiche è presente anche una tabella
     * MySQL che serve a memorizzare i dati relativi all'entità stessa. Un esempio di entità è l'anagrafica, che
     * si basa sulla tabella anagrafica.
     * 
     * entità virtuali
     * ---------------
     * Non tutte le entità sono necessariamente collegate a una tabella MySQL; alcune infatti sono talmente simili
     * a un'entità già dotata di una tabella che è possibile utilizzare quest'ultima come base per la memorizzazione,
     * oltre che dell'entità reale, anche di quelle virtuali che si appoggiano ad essa.
     *
     * entità collegate e vincoli di chiave esterna
     * --------------------------------------------
     * La controller() segue ricorsivamente i vincoli di chiave esterna presenti sul database (a meno che il loro
     * nome non termini con _nofollow) il che permette di gestire le entità collegate in modo automatico. Tramite la
     * ricorsione le azioni vengono infatti propagate a tutte le entità collegate, senza bisogno di specificarlo
     * manualmente ogni volta. Questo comportamento, benché molto comodo, può causare problemi di performance nel caso
     * in cui le entità collegate siano molte o molto grandi; in questi casi è possibile disabilitare la ricorsione
     * utilizzando il suffisso _nofollow nel nome della chiave esterna,
     *
     * argomenti della funzione controller()
     * =====================================
     * 
     * 
     *
     * 
     * 
     * 
     * 
     * l'array $_REQUEST['__info__']
     * -----------------------------
     *
     *
     *
     *
     *
     *
     *
     *
     * l'array $_REQUEST['__err__']
     * ----------------------------
     *
     *
     *
     *
     *
     * 
     * 
     *
     * modalità di ingresso dei dati
     * =============================
     *
     * 
     * 
     * 
     * 
     * la chiave speciale __method__
     * -----------------------------
     * 
     * 
     * 
     * 
     * 
     * la chiave speciale __table__
     * ----------------------------
     * 
     *
     * 
     * 
     * 
     * la chiave speciale __reset__
     * ----------------------------
     * 
     * 
     *
     *
     *
     * modalità di uscita dei dati
     * ===========================
     *
     *
     *
     *
     *
     *
     *
     * insiemi di dati, il concetto di vista
     * -------------------------------------
     *
     *
     *
     *
     *
     *
     * richiesta di campi specifici
     * ----------------------------
     *
     *
     *
     *
     *
     *
     *
     * filtri sugli insiemi di dati
     * ----------------------------
     *
     *
     *
     *
     *
     *
     * l'array $_REQUEST['__view__']
     * -----------------------------
     *
     *
     *
     *
     * 
     * 
     * la modalità __report
     * --------------------
     * 
     * 
     *
     *
     *
     *
     *
     * ricerca negli insiemi di dati
     * -----------------------------
     * 
     * 
     * http://glisweb.videoarts.eu/api/test?test[__fields__][]=id&test[__fields__][]=nome&test[__search__]=root
     *
     *
     *
     *
     *
     *
     *
     *
     * raggruppamento degli insiemi di dati
     * ------------------------------------
     * 
     * 
     * 
     * http://glisweb.videoarts.eu/api/test?test[__group__][]=nome&test[__group__][]=id
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
     * ordinamento degli insiemi di dati
     * ---------------------------------
     * 
     * 
     * http://glisweb.videoarts.eu/api/test?test[__sort__][nome]=ASC
     *
     *
     *
     *
     *
     *
     * persistenza di filtri e ordinamenti in $_SESSION
     * ------------------------------------------------
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
     *
     *
     *
     *
     * TODO documentare
     *
     */

    // debug
    // print_r( $_REQUEST );
    // print_r( $_POST );
    // print_r( $_GET );
    // var_dump( $cf['ws']['table'] ?? null );

    /**
     * controller dati
     * ===============
     * 
     * 
     */

    // timer
    timerCheck( $cf['speed'], '-> inizio lavoro controller' );

    // esamino la coda
    foreach( $_REQUEST as $k => &$v ) {

        // verifico se l'elemento è un blocco dati o un dato singolo
        if( is_array( $v ) ) {

            // verifico se il blocco è speciale o contiene dati
            if( checkNomeBloccoDati( $k ) ) {

                // log
                logWrite( 'blocco dati ricevuto: ' . $k . '/' . $_SERVER['REQUEST_METHOD'], 'controller' );

                // parametri aggiuntivi
                $pi = $ci = array();

                // attivazione controller
                $cf['controller']['status'][ $k ] = controller(
                    $cf['mysql']['connection'],                             // connessione al database
                    $cf['memcache']['connection'],                          // connessione a memcache
                    $v,                                                     // blocco dati di lavoro
                    $k,                                                     // nome dell'entità su cui lavorare
                    $_SERVER['REQUEST_METHOD'],                             // metodo da applicare
                    NULL,                                                   // campo per la ricorsione
                    $_REQUEST['__err__'][ $k ],                             // array per gli errori
                    $_REQUEST['__info__'][ $k ],                            // array per le informazioni
                    $pi,                                                    // ...
                    $ci,                                                    // ...
                    $cf['speed']                                            // ...
                );

                // timer
                timerCheck( $cf['speed'], '-> fine elaborazione blocco ' . $k );

            }

        }

    }

    // scollego $v
    unset( $v );

    /**
     * collegamenti e scorciatoie
     * ==========================
     * 
     * 
     */

    // connetto i dati della request all'array $cf
    $cf['request']                          = &$_REQUEST;

    // collegamento all'array $ct
    $ct['request']                          = &$cf['request'];

    // collegamenti speciali
    $ct['get']                              = &$_GET;
    $ct['post']                             = &$_POST;

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     * 
     */

    // debug
    // print_r( $_SESSION );
    // print_r( $_REQUEST );
    // print_r( $_REQUEST['__err__'] );
    // print_r( $_REQUEST['__info__'] );
    // if( isset( $cf['ws']['table'] ) ) {
    //    var_dump( $cf['ws']['table'] );
    //     die( print_r( $_REQUEST[ $cf['ws']['table'] ], true ) );
    // }
    // die();
