<?php

    /**
     * gestione dei dati in arrivo
     *
     * in questo file vengono gestiti i dati in ingresso e in uscita dal framework
     *
     * introduzione
     * ============
     * Il compito principale del framework è quello di processare i dati in ingresso,
     * attivando in ogni caso le procedure adeguate per la loro gestione. Per comprendere
     * questo meccanismo è importante capire da dove possono provenire i dati e quali sono le
     * categorie in cui i dati vengono organizzati prima di essere gestiti. Riguardo alle
     * categorie, individuiamo innanzitutto:
     *
     * - dati (coppie chiave/valore)
     *   - dati speciali (la chiave inizia e finisce con un doppio underscore)
     *   - altri dati
     * - blocchi (chiavi che corrispondono a un array)
     *   - blocchi speciali (identificati da chiave che inizia e finisce con doppio underscore)
     *   - blocchi dati, ossia dati corrispondenti a un'entità
     *
     * Per quanto riguarda i canali in ingresso, quelli standard sono tre:
     *
     * - file di testo
     * - chiamate REST
     * - form (POST/GET)
     *
     * Tuttavia i primi due vengono elaborati in modo tale da rientrare nel terzo caso, come
     * vedremo fra poco. Sulla falsariga di questo meccanismo è possibile implementare ulteriori
     * canali di ingresso con estrema facilità.
     *
     * dati e entità
     * =============
     * Un'entità nel framework è un concetto astratto che serve a indicare un insieme di dati con la stessa struttura
     * che rappresentano oggetti omogenei del mondo reale. Un'entità è normalmente rappresentata nel framework da:
     *
     * - una tabella nel database con nome uguale a <entità>
     * - una view nel database con nome uguale a <entità>_view
     * - una chiave in $cf['auth']['permissions'][<entità>] per la definizione dei permessi
     * - un'API generata automaticamente come /api/<entità>
     *
     * e opzionalmente da:
     *
     * - una tabella di ACL nel database con nome uguale a __acl_<entità>__
     *
     * struttura delle entità
     * ----------------------
     *
     *
     *
     *
     *
     *
     *
     * chiavi riservate
     * ----------------
     *
     *
     *
     *
     *
     *
     * entità collegate
     * ----------------
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
     * modalità di ingresso dei dati
     * =============================
     *
     *
     *
     *
     *
     *
     *
     * input tramite file di testo
     * ---------------------------
     * Il framework supporta l'inserimento di dati da file CSV caricati in /var/spool/import; il file deve contenere i dati in formato CSV
     * separati da punto e virgola, e nella prima riga devono essere riportati i nomi delle colonne della tabella su cui si desidera caricare
     * i dati.
     * 
     * Il sistama è nel file _src/_config/_740.controller.php.
     * 
     * Il sistema di inserimento tramite CSV sfrutta la modalità di gestione oggetti multipli della funzione controller() e richiede che il
     * nome del file renda esplicita l'operazione richiesta e la tabella su cui si desidera lavorare:
     * 
     * <metodo>.<tabella>.csv
     * 
     * 
     * 
     * 
     * TODO ESEMPI DI FILE
     *
     *
     *
     *
     *
     *
     * input tramite chiamate REST
     * ---------------------------
     * TODO ESEMPI DI CHIAMATE CURL DA LIMEA DI COMANDO
     *
     *
     *
     *
     *
     *
     * input tramite form
     * ------------------
     * L'input di dati tramite form è di gran lunga il caso più comune; per un semplice esempio di form che
     * invia un blocco dati ben formato alla controller si veda _usr/_examples/_framework/_form.php.
     *
     *
     *
     *
     *
     *
     * controller per i blocchi dati
     * =============================
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
     *
     *
     *
     *
     *
     * ricerca negli insiemi di dati
     * -----------------------------
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
     * l'array $_REQUEST['__view__']
     * -----------------------------
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
     * @todo finire la documentazione
     *
     * @file
     *
     */

    // debug
	// print_r( $_REQUEST );
	// print_r( $_POST );
	// print_r( $_GET );

    // timer
	timerCheck( $cf['speed'], '-> inizio lavoro controller' );

    // esamino la coda
	foreach( $_REQUEST as $k => &$v ) {

	    // verifico se l'elemento è un blocco dati o un dato singolo
		if( is_array( $v ) ) {

            // verifico se la richiesta è un report
		    $report = ( substr( $k, 0, 8 ) == '__report' ) ? true : false;

            // verifico se il blocco è speciale o contiene dati
			if( ( substr( $k, 0, 2 ) !== '__' || $report !== false ) && strlen( $k ) > 1 ) {

			    // log
				logWrite( 'blocco dati ricevuto: ' . $k . '/' . $_SERVER['REQUEST_METHOD'], 'controller' );

			    // debug
				// echo $k . '/' . $_SERVER['REQUEST_METHOD'] . PHP_EOL;

                // parametri aggiuntivi
                $pi = $ci = array();

			    // attivazione controller
				$cf['controller']['status'][ $k ] = controller(
				    $cf['mysql']['connection'],				// connessione al database
				    $cf['memcache']['connection'],			// connessione a memcache
				    $v,							// blocco dati di lavoro
				    $k,							// nome dell'entità su cui lavorare
				    $_SERVER['REQUEST_METHOD'],				// metodo da applicare
				    NULL,						// campo per la ricorsione
				    $_REQUEST['__err__'][ $k ],				// array per gli errori
				    $_REQUEST['__info__'][ $k ],				// array per le informazioni
                    $pi,
                    $ci,
                    $cf['speed']
				);

			    // debug
                // echo $k;
				// print_r( $_SESSION );
				// print_r( $_REQUEST );
				// print_r( $_REQUEST['__err__'] );
				// print_r( $_REQUEST['__info__'] );
				// if( $k == 'prodotti' ) { print_r( $v ); }
                // if( ! array_key_exists( $k, $_REQUEST['__info__'] ) ) { echo $k . 'non è in ' . print_r( $_REQUEST['__info__'], true ); }

			    // timer
				timerCheck( $cf['speed'], '-> fine elaborazione blocco ' . $k );

			}

		}

	}

    // scollego $v
	unset( $v );

    // connetto i dati della request all'array $cf
	$cf['request']				= &$_REQUEST;

    // collegamento all'array $ct
	$ct['request']				= &$cf['request'];

    // collegamenti speciali
	$ct['get']				= &$_GET;
	$ct['post']				= &$_POST;

    // debug
    // print_r( $_SESSION );
    // print_r( $_REQUEST );
    // print_r( $_REQUEST['__err__'] );
    // print_r( $_REQUEST['__info__'] );
    // die();
