<?php

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        require '../../_config.php';
    }

    // inizializzo l'array del risultato
    $status = array();

    // file da copiare
    $status['files'] = array(
        'https://dataserver.istricesrl.com/geografia/01.update.stati.csv',
        'https://dataserver.istricesrl.com/geografia/02.update.regioni.csv',
        'https://dataserver.istricesrl.com/geografia/03.update.provincie.csv',
        'https://dataserver.istricesrl.com/geografia/04.update.comuni.csv'
    );

    // scarico l'XLS
    foreach( $status['files'] as $file ) {
        copyFile( $file, DIR_VAR_SPOOL_IMPORT . '/' . basename( $file ) );
    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
