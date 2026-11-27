<?php

    /**
     * 
     * richiede ad es. ?id=1&target=PROD
     * 
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata un redirect
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['id'] ) ) {

        // ID del redirect
        $status['id'] = $_REQUEST['id'];

        // verifico se è aspecificato il target
        if( ! empty( $_REQUEST['target'] ) && ! empty( $_REQUEST['target'] ) ) {

            // target del redirect
            $status['target'] = $_REQUEST['target'];

            // server target
            if( isset( $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'] ) ) {

                // server
                $server = $cf['mysql']['servers'][ $cf['mysql']['profiles'][ $_REQUEST['target'] ]['servers'][0] ];

                // inizializzo la connessione al database target
                $cTarget = mysqli_init();

                // riduco il tempo massimo di connessione: senza, un target irraggiungibile tiene ferma la modale per
                // default_socket_timeout ( 60 secondi ) prima di rispondere ( segnalato da gimbe il 09/11/2026 )
                mysqli_options( $cTarget, MYSQLI_OPT_CONNECT_TIMEOUT, 5 );

                // connessione al database target
                // NOTA su PHP 8 mysqli_real_connect() lancia un'eccezione invece di restituire false
                try {
                    if( ! @mysqli_real_connect(
                        $cTarget,
                        $server['address'],
                        $server['username'],
                        $server['password'],
                        $server['db'],
                        ( ( ! empty( $server['port'] ) ) ? (int) $server['port'] : NULL )
                    ) ) {
                        $cTarget = false;
                    }
                } catch( Exception $e ) {
                    $cTarget = false;
                }

                // verifico la connessione target
                if( ! empty( $cTarget ) ) {

                    // recupero il redirect
                    $source = mysqlSelectRow(
                        $cf['mysql']['connection'],
                        'SELECT * FROM redirect WHERE id = ?',
                        array( array( 's' => $_REQUEST['id'] ) ) 
                    );

                    // controllo se la riga esiste
                    if( ! empty( $source ) ) {

                        // inserisco il redirect
                        $idRedirect = mysqlInsertRow(
                            $cTarget,
                            $source,
                            'redirect'
                        );

                        // verifica inserimento redirect
                        if( ! empty( $idRedirect ) ) {

                            // status
                            $status['info'][] = 'inserito il redirect ' . $idRedirect;

                        } else {

                            // status
                            $status['err'][] = 'impossibile inserire il redirect ' . $_REQUEST['id'];

                        }

                    } else {

                        // status
                        $status['err'][] = 'dati non trovati per il redirect ' . $_REQUEST['id'];
                        
                    }

                } else {

                    // status
                    $status['err'][] = 'connessione remota non disponibile (' . mysqli_connect_errno() . ' ' . mysqli_connect_error() . ')';

                }

            } else {

                // status
                $status['err'][] = 'server non disponibile';

            }

        } else {

            // status
            $status['err'][] = 'target del redirect non passato';
    
        }

    } else {

        // status
        $status['err'][] = 'ID del redirect non passato';

    }

    // esito complessivo: la modale di pubblicazione mostra la spunta solo se e' OK, altrimenti gli errori
    $status['esito'] = ( empty( $status['err'] ) ) ? 'OK' : 'KO';

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
