<?php

    /**
     * gestione delle chiamate alle API REST
     *
     * l'infrastruttura di API REST del framework
     * ==========================================
     *
     *
     *
     *
     * ottenere una collezione di dati
     * -------------------------------
     * GET /api/<entità>
     *
     *
     *
     * creare un nuovo oggetto
     * -----------------------
     * POST /api/<entità>
     *
     *
     *
     * ottenere uno specifico oggetto
     * ------------------------------
     * GET /api/<entità>/<id>
     *
     *
     *
     * ottenere uno specifico oggetto in view mode
     * -------------------------------------------
     * GET /api/<entità>/<id>?<entità>[__view_mode__]=1
     *
     *
     *
     * aggiornare uno specifico oggetto
     * --------------------------------
     * PUT /api/<entità>/<id>
     *
     *
     *
     * eliminare uno specifico oggetto
     * -------------------------------
     * DELETE /api/<entità>/<id>
     *
     *
     *
     *
     * filtrare la collezione
     * ----------------------
     * GET /api/<entità>?<entità>[<campo>]=<valore>
     *
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $_REQUEST );
	// print_r( $_GET );
	// die();

    // TODO
	if( isset( $_REQUEST['__ws__'] ) ) {

		// ...
		if( isset( $_SERVER['HTTP_ACCEPT'] ) ) {
			
			// entità su cui si sta lavorando
			$cf['ws']['table']			= $_REQUEST['__ws__'];

			// ID dell'entità su cui si sta lavorando
			$cf['ws']['id']				= $_REQUEST['__id__'];

			// codifica del contenuto in arrivo
			$cf['ws']['incoming']		= ( isset( $_SERVER['CONTENT_TYPE'] ) ) ? $_SERVER['CONTENT_TYPE'] : NULL;

			// codifica del contenuto richiesto
			$cf['ws']['accept']			= $_SERVER['HTTP_ACCEPT'];

			// ricezione dell'input
			$cf['ws']['input']			= file_get_contents('php://input');

			// charset dell'input
			$cf['ws']['charset']		= ( function_exists( 'mb_detect_encoding' ) ) ? mb_detect_encoding( $cf['ws']['input'] ) : 'UTF-8';

			// ip chiamante
			$cf['ws']['from']			= $_SERVER['REMOTE_ADDR'];

			// debug
			// die( print_r( $cf['ws'], true ) );

			// inizializzazione di $_REQUEST[ $cf['ws']['table'] ]
			if( ! isset( $_REQUEST[ $cf['ws']['table'] ] ) || ! is_array( $_REQUEST[ $cf['ws']['table'] ] ) ) {
				$_REQUEST[ $cf['ws']['table'] ] = array();
			}

			// report mode
			if( substr( $cf['ws']['table'], 0, 8 ) == '__report' ) {
				$_REQUEST[ $cf['ws']['table'] ]['__report_mode__'] = 1;
			}

			// passo i dati al controller
			switch( $cf['ws']['incoming'] ) {

				case 'application/json':

					$data = json_decode( $cf['ws']['input'], true );
					if( is_array( $data ) && ! empty( $data ) ) {
						$_REQUEST[ $cf['ws']['table'] ] = array_replace_recursive(
						$_REQUEST[ $cf['ws']['table'] ],
						$data
						);
					}
					$incoming = print_r( $_REQUEST[ $cf['ws']['table'] ], true );
	/*
					$incoming = json_decode( $cf['ws']['input'] , true );
					if( is_array( $incoming ) ) {
						$_REQUEST[ $cf['ws']['table'] ] = array_replace_recursive(
						$_REQUEST[ $cf['ws']['table'] ],
						$incoming
						);
					}
	*/
				break;

				case 'application/x-www-form-urlencoded':

					parse_str( $cf['ws']['input'], $_REQUEST[ $cf['ws']['table'] ] );
					$incoming = print_r( $_REQUEST[ $cf['ws']['table'] ], true );
					break;
					default:
		#			$_REQUEST[ $cf['ws']['table'] ] = array();
					$incoming = 'formato non riconosciuto: ' . $cf['ws']['incoming'];

				break;

			}

			// debug
	#		$incoming = $_REQUEST[ $cf['ws']['table'] ];
	#		echo $cf['ws']['table'] . PHP_EOL;
	#		die( print_r( $cf['ws'], true ) );
	#		die( print_r( $_REQUEST, true ) );

	#	    // se il metodo è GET i dati dovrebbero arrivare da $_GET e *mai* dal body della richiesta!
	#		if( $r['method'] == METHOD_GET ) {
	#		    $r['data'] = $_GET;
	#		}

			// faccio convergere l'ID sulla $_REQUEST
			if( isset( $_REQUEST['__id__'] ) && ! empty( $_REQUEST['__id__'] ) ) {
				$_REQUEST[ $cf['ws']['table'] ]['id'] = $_REQUEST['__id__'];
			}

			// paginazione
			// TODO farla un po' meglio
			if( ! isset( $cf['ws']['all'] ) ) {
				$_REQUEST['__info__'][ $cf['ws']['table'] ]['__pager__']['page'] = 0;
				$_REQUEST['__info__'][ $cf['ws']['table'] ]['__pager__']['rows'] = 100;
			}

			// debug
			// print_r( $_SERVER['REDIRECT_URL'] );
			// die( print_r( $_REQUEST, true ) );
			// die( $_SERVER['CONTENT_TYPE'] );
			// die( $_SERVER['HTTP_ACCEPT'] );
			// die( print_r( $cf['ws'], true ) );
			// die( 'input: ' . $cf['ws']['input'] );
			// die( 'incoming ' . $cf['ws']['incoming'] . ': ' . $incoming );
			// die( print_r( $cf['ws'], true ) );

			// runlevel da saltare
			$cf['lvls']['skip'] = array(
				'130', '135', '140', '145', '190',
				'300', '310', '320', '330', '340', '345', '360', '365', '370', '380', '385',
				'400', '420',
				'520', '525', '550', '555', '580', '585',
				'610', '615', '620', '625', '640', '645', '650', '655', '660', '665', '680', '685',
				'770', '775', '780',
				'920', '925', '950', '960', '980', '990'
			);

			// debug
			// print_r( $_REQUEST[ $cf['ws']['table'] ] );
            // die( print_r( $cf['ws'], true ) );

			// inclusione del framework
			require '../_config.php';

			// timer
			timerCheck( $cf['speed'], 'inizio eleborazione API REST' );

			// log
			logWrite( $_REQUEST['__ws__'] . '/' . $_SERVER['REQUEST_METHOD'] . '/' . print_r( $cf['ws'], true ), 'rest' );

			// output
			$response = $_REQUEST[ $cf['ws']['table'] ];

			// debug
			// print_r( $response );

			// codice di stato HTTP generato in base all'esito delle operazioni del controller
			if( isset( $cf['controller']['status'][ $cf['ws']['table'] ] ) ) {

				http_response_code( $cf['controller']['status'][ $cf['ws']['table'] ] );

				if( $cf['controller']['status'][ $cf['ws']['table'] ] > 299 ) {
					$response = array( 'errors' => $_REQUEST['__err__'] );
				}
		
			}

			// debug
			// print_r( $_REQUEST[ $cf['ws']['table'] ] );
			// print_r( $cf['ws'] );
			// die( print_r( $cf['ws'], true ) );
			// print_r( $cf['controller'] );
			// print_r( $_REQUEST['__err__'][ $cf['ws']['table'] ] );

			// genero l'output
			switch( $cf['ws']['accept'] ) {
				case 'application/json':
					buildJson( $response );
				break;
				default:
					http_response_code( 406 );
				break;
			}

			// timer
			timerCheck( $cf['speed'], 'fine esecuzione framework' );

			// log
			appendToFile( 'fine esecuzione framework' . PHP_EOL, FILE_LATEST_RUN );

			// calcolo tempi
			$tms = array_keys( $cf['speed'] );
			$run = end( $tms );
			$flt = floatval( str_replace( ',', '.', substr( $run, 1 ) ) );

			// log
			if( $flt > 0.75 || memory_get_usage( true ) > ( 1024 * 1024 * 15 ) ) {
				writeToFile(
					$_SERVER['REQUEST_URI'] . PHP_EOL . PHP_EOL .
					'tempo di completamento per gli step di esecuzione del framework:' . PHP_EOL . PHP_EOL .
					print_r( $cf['speed'], true ) . PHP_EOL . 'tempo totale di esecuzione: ' . $flt . PHP_EOL .
					'memoria utilizzata ' . writeByte( memory_get_usage( true ) ) .
					' (picco ' . writeByte( memory_get_peak_usage( true ) ) . ')' . PHP_EOL,
					DIR_VAR_LOG_SLOW . microtime( true ) . '.' . $_SERVER['REMOTE_ADDR'] . '.log'
				);
			}

		} else {

			// risposta con errore
			http_response_code( 400 );

		}

	} else {

	    // risposta con errore
		http_response_code( 400 );

	}
