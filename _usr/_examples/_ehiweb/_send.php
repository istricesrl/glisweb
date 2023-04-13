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
	$tx = 'invio SMS di prova';

    // debug
    // print_r( $cf['sms']['profile'] );

    // prelevo i dati del server
    $srv = $cf['sms']['servers']['ehiweb'];

    // invio SMS
    $r = ehiwebSend(
        'testo SMS di prova',
        '+393294349095',
        $srv['username'],
        $_REQUEST['pw'],
        array( 'GlisWeb' => "GLISWEB" ),
        $srv['id_api']
    );

    // output
	build( $tx );
