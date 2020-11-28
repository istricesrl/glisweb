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

    // ordinamento degli array per la scrittura
	rksort( $cf );
	rksort( $ct );

    // nascondo le password
	array2censored( $cf );

    // output
	$tx	= NULL;
	$tx	.= '<html>';
	$tx	.= '<head></head>';
	$tx	.= '<body style="font-family: monospace;">';

    // test
	if( ! in_array( $cf['auth']['status'], array( LOGIN_LOGGED, LOGIN_SUCCESS ) ) ) {
	    $tx	.= '<h1>login</h1>'
		. '<form action="" method="post">'
		. '<div><input type="text" name="__login__[user]" /></div>'
		. '<div><input type="password" name="__login__[pasw]" /></div>'
		. '<div><input type="submit" /></div>'
		. '</form>';
	} else {
	    $tx	.= '<h1>logout</h1>'
		. '<form action="" method="post">'
		. '<input type="hidden" name="__logout__" value="1" />'
		. '<div><input type="submit" /></div>'
		. '</form>';
	}

    // array $_SESSION
	$tx	.= '<h2>array $ct[\'session\']</h2>';
	$tx	.= '<pre>' . print_r( $ct['session'], true ) . '</pre>';

    // array $cf
	$tx	.= '<h2>array $cf[\'auth\'][\'status\']</h2>';
	$tx	.= '<pre>' . print_r( $cf['auth']['status'], true ) . '</pre>';

    // output
	$tx	.= '</body>';
	$tx	.= '</html>';

    // output
	buildHTML( $tx );
