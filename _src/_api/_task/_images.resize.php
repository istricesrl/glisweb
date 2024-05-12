<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'inizio operazioni di scalatura';

    // chiave di lock
	if( ! isset( $status['token'] ) ) {
	    $status['token'] = getToken( __FILE__ );
	}

    // se è specificato un ID, forzo la richiesta
    if( isset( $_REQUEST['id'] ) ) {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );
        
    } else {

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini '.
#            'INNER JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo '.
            'SET immagini.token = ? WHERE ( '.
            'immagini.timestamp_scalamento IS NULL '.
            'OR immagini.timestamp_scalamento < immagini.timestamp_aggiornamento '.
            'OR immagini.timestamp_aggiornamento IS NULL ) '.
            'AND token IS NULL '.
#           'ORDER BY immagini.timestamp_scalamento ASC, ruoli_immagini.ordine_scalamento ASC, immagini.ordine ASC '.
            'ORDER BY immagini.timestamp_scalamento ASC, immagini.ordine ASC '.
            'LIMIT 1',
            array(
                array( 's' => $status['token'] )
            )
	    );

    }

    // prelevo un'immagine dalla coda
    $im = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT immagini.* '.
        'FROM immagini '.
        'WHERE token = ? ',
        array( array( 's' => $status['token'] ) )
    );

    // se c'è almeno un'immagine da scalare'
    if( ! empty( $im ) ) {

        // imposto i path
        $im1 = $im['path'];
        $im2 = ( ! empty( $im['path_alternativo'] ) ) ? $im['path_alternativo'] : ( ( empty( $im['orientamento'] ) ) ? $im['path'] : NULL );
        $wgh = $im['taglio'];

        // completo i path
        fullPath( $im1 );
        fullPath( $im2 );

	    // controllo che il file esista
		if( file_exists( $im1 ) ) {

		    // se l'immagine non è nella cartella immagini, la copio
			if( ! file_exists( DIR_VAR_IMMAGINI . basename( $im1 ) ) ) {
			    copyFile( $im1, DIR_VAR_IMMAGINI . basename( $im1 ) );
			}

		    // determino le dimensioni dell'immagine
			$dm = imageSize( $im1 );

		    // adatto lo scalamento all'orientamento dell'immagine
			$j = $dm['o'];
			$k = ( $j == 'l' ) ? 'p' : 'l';

		    // array dei formati
			$ks = array_flip( $cf['image']['formats'][ $j ] );

		    // creo la versione webp
			imageConvert( $im1, 'webp' );

		    // scalo e taglio l'immagine per i vari formati
			foreach( $cf['image']['formats'][ $j ] as $d1 => $d1a ) {

			    $dst = DIR_VAR_IMMAGINI . $d1 . $j . '/' . basename( $im1 );
			    imageResize( $im1, $d1, $dst );
			    $webp = imageConvert( $dst, 'webp' );
			    copyFile( $webp, DIR_VAR_IMMAGINI . basename( $webp ) );

            }

		    // scalo e taglio l'immagine per formati alternativi
            // TODO non va bene ! empty() usare file_exists o qualcosa del genere perché $im2 contiene il path base se è vuota
			if( ! empty( $im2 ) ) {

			    foreach( $cf['image']['formats'][ $k ] as $d1 => $d1a ) {

                    if( ! empty( $im['path_alternativo'] ) ) {

                        $dst = DIR_VAR_IMMAGINI . $d1 . $k . '/' . basename( $im1 );
                        imageResize( $im2, $d1, $dst );
                        imageConvert( $dst, 'webp' );

                        $status[ $im1 ]['scalature'][ $k ][ $d1a ] = $dst;

                    } else {

                        if( isset( $ks[ $d1a ] ) ) {

                            $dst = DIR_VAR_IMMAGINI . $d1 . $k . '/' . basename( $im1 );
                            imageResize( $im2, $d1a, $dst );

                            imageCut(
                                $dst,
                                $d1,
                                $dst,
                                $wgh
                            );
                            imageConvert( $dst, 'webp' );

                            $status[ $im1 ]['tagli'][ $k ][ $d1 ] = $dst;

                        }

                    }

			    }

			}

            // risultato
            $status = array_replace_recursive(
                mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM __report_immagini_scalate__' )
                ,
                $status
            );

            // log
            logWrite( 'scalamento di ' . $im1 . ' completato', 'image' );

        } else {

            // status
            $status['err'][] = 'immagine inesistente ' . $im1;

            // log
            logWrite( 'immagine inesistente ' . $im1, 'image', LOG_ERR );
            
        }

        // aggiornamento database
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE immagini SET token = NULL, timestamp_scalamento = unix_timestamp(), '.
            'timestamp_aggiornamento = unix_timestamp() WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );

    } else {

        // chiudo il ciclo
        $iter = $task['iterazioni'];

        // status
        $status['info'][] = 'nessuna immagine da scalare';

        // log
        logWrite( 'nessuna immagine in coda da scalare', 'image' );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
