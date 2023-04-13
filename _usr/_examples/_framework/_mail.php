<?php

    /**
     * test delle variabili
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
	require '../../../_src/_config.php';

    // output
	$tx	= NULL;

    // numero di mail in coda
	$t	= mysqlSelectValue( $cf['mysql']['connection'], 'SELECT count( id ) FROM mail_out' );

    // debug
	// var_dump( $t );

    // accodamento o evasione
	if( $t == 0 ) {

	    // output
		$tx	= 'accodamento mail...';

	    // accodamento
		queueMail(
		    $cf['mysql']['connection'],
		    strtotime( '+1 minute' ),
		    array( 'GlisWeb' => 'noreply@' . $cf['site']['fqdn'] ),
		    $cf['mail']['postmaster'],
		    'prova mail GlisWeb',
		    'Testo della mail di prova'
		);

	    // NOTA $cf['mail']['postmaster'] è un array in forma di array( 'nome' => 'mail )

	} else {

	    // output
		$tx	= 'evasione mail...';

	    // mando il task in modalità interattiva
		define( 'CRON_RUNNING', true );

	    // forzo la timestamp di invio
		mysqlQuery(
		    $cf['mysql']['connection'],
		    'UPDATE mail_out SET timestamp_invio = NULL ORDER BY id DESC LIMIT 1'
		);

	    // evasione
		require DIR_SRC_API_TASK . '_mail.queue.send.php';

	}

    // output
	build( $tx );
