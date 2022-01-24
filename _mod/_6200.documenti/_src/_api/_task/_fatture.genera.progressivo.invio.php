<?php

    /**
     * 
     * @todo documentare
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // seleziono l'ultimo progressivo utilizzato
    $status['current'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT coalesce( max( progressivo_invio ), 0 ) FROM documenti'
    );

    // debug
    $status['new'] = base_convert( $status['current'], 36, 10 );
    $status['new']++;
    $status['new'] = base_convert( $status['new'], 10, 36 );

    // propongo un nuovo progressivo
    $status['new'] = strtoupper( str_pad( $status['new'], 5, '0', STR_PAD_LEFT ) );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
