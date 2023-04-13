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
	$tx = 'accodamento SMS di prova';

    // accodo l'SMS di prova
	queueSms(
	    $cf['mysql']['connection'],
	    strtotime( '+3 years' ),
	    array( 'GlisWeb' => "GLISWEB" ),
	    array( 'Fabio Mosti' => '+393294349095' ),
	    'testo SMS di prova',
	    'ehiweb'
	);

    // output
	build( $tx );
