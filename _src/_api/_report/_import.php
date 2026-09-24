<?php

    /**
     * report sull'importazione di file da /var/spool/import/'
     * 
     * Questo report innesca l'importazione di file presenti nella cartella /var/spool/import/.
     * e visualizza un report dettagliato della lavorazione.
     * 
     * 
     * TODO documentare
     * 
     */

    // debug
    // ini_set( 'display_errors', 1 );
    // ini_set( 'display_startup_errors', 1 );
    // error_reporting( E_ALL );

    // modalità batch
    define( 'CRON_RUNNING', true );

    // inclusione del framework
    require '../../_config.php';

    // header
    header( 'Content-type: text/plain' );

    // report
    print_r( $cf['import']['info'] ?? [] );
    print_r( $cf['import']['err'] ?? [] );
    print_r( $cf['import']['rows'] ?? [] );
    print_r( $cf['import']['images'] ?? [] );
