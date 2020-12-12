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
	$status['token'] = getToken();

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
            'INNER JOIN ruoli_immagini ON ruoli_immagini.id = immagini.id_ruolo '.
            'SET token = ? WHERE '.
            'timestamp_scalamento IS NULL '.
            'OR timestamp_scalamento < timestamp_aggiornamento '.
            'OR timestamp_aggiornamento IS NULL '.
            'ORDER BY timestamp_scalamento ASC, ruoli_immagini.ordine_scalamento ASC, immagini.ordine ASC '.
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

    // imposto i path
    $im1 = DIR_BASE . $im['path'];
    $im2 = ( ! empty( $im['path_alternativo'] ) ) ? DIR_BASE . $im['path_alternativo'] : ( ( empty( $im['orientamento'] ) ) ? DIR_BASE . $im['path'] : NULL );
    $wgh = $im['taglio'];


    // risultato
	$status = array_replace_recursive(
	    mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM __report_immagini_scalate__' )
	    ,
	    $status
	);

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
