<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */
    
    // tabella gestita
	$ct['form']['table'] = 'job';
	$ct['etc']['jobfile'] = '_mod/_4100.prodotti/_src/_api/_job/_prodotti.importazione.php';

    // svuoto il campo custom __job__ per evitare che venga riproposto il file appena caricato
	if( isset( $_REQUEST['__job__'] ) ) {
	    unset( $_REQUEST['__job__'] );
	}

    // prelevare dal database tutti i job che hanno questo job file
	$ct['etc']['jobs'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM job_view WHERE job = ? AND timestamp_completamento IS NULL', array( array( 's' => $ct['etc']['jobfile'] ) ) );
	foreach( $ct['etc']['jobs'] as &$jb ) { $jb['workspace'] = json_decode( $jb['workspace'] ); }
