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
	    require '../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'visualizzazione banner';

    // log
	logWrite( 'richiesta di visualizzazione banner', 'banner' );

    // chiave di lock
	$status['token'] = getToken( __FILE__ );

	// visualizzazione di uno specifico banner
	if( isset( $_REQUEST['id'] ) ) {

		// status
		$status['info'][] = 'visualizzazione di un banner specifico';

        // token della riga
        $status['id'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE banner SET token = ? WHERE id = ? AND token IS NULL',
            array(
                array( 's' => $status['token'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

	} else {

		// status
		$status['info'][] = 'strategia standard di visualizzazione banner';

		// token della riga
        $status['aggiornamento'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE banner SET banner.token = ? WHERE banner.id = ( SELECT banner.id FROM banner LEFT JOIN banner_azioni ON ( banner_azioni.id_banner = banner.id AND banner_azioni.azione = "visualizzazione" ) WHERE banner.token IS NULL GROUP BY banner_azioni.id_banner ORDER BY ( max( banner_azioni.timestamp_azione ) - unix_timestamp( now() ) ) ASC LIMIT 1 ) ',
            array(
                array( 's' => $status['token'] )
            )
        );

	}

	// prelevo un banner dalla coda
	$banner = mysqlSelectRow(
		$cf['mysql']['connection'],
		'SELECT banner.*, immagini.path AS src, contenuti.url_custom AS href FROM banner LEFT JOIN immagini ON immagini.id_banner = banner.id LEFT JOIN contenuti ON contenuti.id_banner = banner.id WHERE banner.token = ?',
		array(
			array( 's' => $status['token'] )
		)
	);

	// se c'è un banner da visualizzare
	if( ! empty( $banner ) && ! empty( $banner['src'] ) ) {

		// status
		$status['info'][] = 'trovato un banner da visualizzare';
		$status['info'][] = 'visualizzo banner #' . $banner['id'];

        // aggiorno le visualizzazioni
        $status['visualizzazione'] = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id_banner' => $banner['id'],
                'azione' => 'visualizzazione',
                'timestamp_azione' => microtime( true ),
                'token' => $status['token']
            ),
            'banner_azioni'
        );

        // rimuovo il token
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE banner SET token = NULL WHERE token = ?',
            array(
                array( 's' => $status['token'] )
            )
        );

        // salvo l'URL in $_SESSION
        // $_SESSION['banner']['token'][ $status['token'] ] = $banner;

        // debug
        // print_r( $banner );
        // print_r( $_SESSION['banner']['token'][ $status['token'] ] );
        $status['id'] = $banner['id'];

        // se esiste un file di immagine...
        if( file_exists( DIR_VAR_CONTENUTI . 'banner/' . $banner['id'] . '.jpg' ) ) {
            $status['src'] = getShortPath( DIR_VAR_CONTENUTI . 'banner/' . $banner['id'] . '.jpg' );
        } else {
            $status['src'] = $banner['src'];
        }

        // se non c'è un href non restituisco il token per il click
        if( empty( $banner['href'] ) ) {
            $status['token'] = NULL;
        }

	} else {

		// status
		$status['info'][] = 'nessun banner da visualizzare';

	}

    // output
	buildJson( $status );
