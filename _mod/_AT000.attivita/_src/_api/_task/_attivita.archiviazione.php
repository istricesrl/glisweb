<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // debug
     ini_set('display_errors', 1);
     ini_set('display_startup_errors', 1);
     error_reporting(E_ALL);

    // inizializzo l'array del risultato
	$status = array();

	// ...
	if( isset( $_REQUEST['id'] ) ) {

        $status['esito'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE attivita SET data_archiviazione = now() WHERE data_archiviazione IS NULL AND id = ?',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );
    
        if( $status['esito'] ) {
            updateAttivitaViewStatic( $_REQUEST['id'] );
        }

    } elseif( isset( $_REQUEST['inizio'] ) && isset( $_REQUEST['fine'] ) ) {

        if( ! empty( $_REQUEST['inizio'] ) && ! empty( $_REQUEST['fine'] ) ) {

            $status['candidati'] = mysqlQuery(
                $cf['mysql']['connection'],
                    'SELECT attivita.id FROM attivita
                        WHERE data_archiviazione IS NULL
                        AND coalesce(data_programmazione, data_attivita) >= ?
                        AND coalesce(data_programmazione, data_attivita) <  ?',
                array(
                    array( 's' => $_REQUEST['inizio'] ),
                    array( 's' => $_REQUEST['fine'] )
                )
            );

            $status['info'][] = 'parametri ricevuti: inizio ' . $_REQUEST['inizio'] . ' - fine ' . $_REQUEST['fine'];

            foreach( $status['candidati'] as $riga ) {

                $esito = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE attivita SET data_archiviazione = now() WHERE id = ?',
                    array(
                        array( 's' => $riga['id'] )
                    )
                );

                if( $esito ) {
                    updateAttivitaViewStatic( $riga['id'] );
                }

            }

        } else {

            $status['esito'] = false;
            $status['err'][] = 'Parametri mancanti';

        }

    } else {

        $status['esito'] = false;
        $status['err'][] = 'Parametri mancanti';

    }

	// output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
