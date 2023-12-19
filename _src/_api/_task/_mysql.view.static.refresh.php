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
    $status['toRefresh'] = array();
    $status['__status__'] = 'OK';
/*
    // svuoto e ripopolo la tabella
    if( isset( $_REQUEST['__view_static__'] ) && ! empty( $_REQUEST['__view_static__'] ) ) {

        // log
        logWrite( 'richiesta di ripopolamento della view static: ' . $_REQUEST['__view_static__'], 'cache' );

        // aggiungo la tabella richiesta a quelle da elaborare
        $status['toRefresh'][] = $_REQUEST['__view_static__'];

  
    } else {

        // log
        logWrite( 'richiesta di ripopolamento di tutte le view static', 'cache' );

        // svuoto e ripopolo tutte le view statiche
        $status['toRefresh'] = mysqlSelectColumn( 'TABLE_NAME', $cf['mysql']['connection'], 'SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME like "%_static" ORDER BY TABLE_NAME' );	
 
    }

    // eseguo il refresh
    foreach( $status['toRefresh'] as $refresh ) {

        if( getAclPermission( str_replace( '_view_static', NULL, $refresh ), METHOD_DELETE ) ) {

            $truncate = mysqlQuery( $cf['mysql']['connection'], 'TRUNCATE '.$refresh );
            $insert = mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO ' . $refresh . ' SELECT * FROM ' . str_replace( '_static', NULL, $refresh ) );

            if( $truncate === false || $insert === false ) { $status['__status__'] = 'NO'; }
            $status[ str_replace( '_view_static', NULL, $refresh ) ]['__status__'] = !( $truncate === false || $insert === false ) ? 'OK' : 'NO';

        }

    }
*/
    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
