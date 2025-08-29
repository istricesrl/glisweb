<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     * TODO commentare
     *
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../_config.php';
    }

    // scrivo una stringa di test
    logger( 'task di test cron eseguito il ' . date( 'Y-m-d H:i:s' ), 'test' );

    // status
    $status = array(
        'status' => 'OK',
        'message' => 'task di test cron eseguito correttamente'
    );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
