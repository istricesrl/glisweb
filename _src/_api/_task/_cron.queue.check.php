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

    // sblocco i cron
    $status['cron'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE cron SET token = NULL WHERE token IS NOT NULL AND timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // sblocco i job
    $status['job']['background'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE job SET token = NULL WHERE token IS NOT NULL AND timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // porto in background i job fermi in foreground
    $status['job']['foreground'] = mysqlSelectRow(
        $cf['mysql']['connection'],
        'UPDATE job SET se_foreground = NULL WHERE timestamp_completamento IS NULL AND timestamp_esecuzione < ?',
        array(
            array( 's' => strtotime( '-10 minutes' ) )
        )
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
