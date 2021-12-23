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

/*

// elimino i log
	if( isset( $_REQUEST['patch'] ) ) {

        // nome della patch
        $patch = DIR_USR_DATABASE_PATCH . $_REQUEST['patch'] . '.sql';

        // applico la patch
        $query = readStringFromFile( $patch );
        $qRes = mysqlQuery( $cf['mysql']['connection'], $query );

        // log
        if( $qRes !== false ) {
            writeToFile( $query, DIR_VAR_LOG_MYSQL_PATCH . 'done/' . basename( $patch ) );
            logWrite( 'applicata patch ' . $patch, 'mysql/patch' );
            $status['info'][] = 'applicata patch ' . $patch;
            if( file_exists( DIR_VAR_LOG_MYSQL_PATCH . 'fail/' . basename( $patch ) ) ) {
                deleteFile( DIR_VAR_LOG_MYSQL_PATCH . 'fail/' . basename( $patch ) );
            }
        } else {
            writeToFile( $query, DIR_VAR_LOG_MYSQL_PATCH . 'fail/' . basename( $patch ) );
            logWrite( 'impossibile applicare la patch ' . $patch, 'mysql/patch', LOG_CRIT );
            $status['err'][] = 'impossibile applicare la patch ' . $patch;
        }

	} else {
        $status['info'][] = 'nessuna patch specificata';
	}

    */

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
