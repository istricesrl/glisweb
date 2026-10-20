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
	$tx	.= '<h1>test</h1>'
		. '<form action="" method="post">'
		. '<div><label for="test[nome]">nome</label></div>'
		. '<div><input type="text" name="test[nome]" /></div>'
		. '<div><label for="test[mail]">mail</label></div>'
		. '<div><input type="text" name="test[mail]" /></div>'
		. '<div><input type="submit" /></div>'
		. '</form>';

    // array $_REQUEST
	$tx	.= '<h2>array $_REQUEST[\'__view__\']</h2>';
	$tx	.= '<pre>' . print_r( $_REQUEST['__view__'], true ) . '</pre>';

    // array $_REQUEST
	$tx	.= '<h2>array $_REQUEST[\'__info__\']</h2>';
	$tx	.= '<pre>' . print_r( $_REQUEST['__info__'], true ) . '</pre>';

    // array $_REQUEST
	$tx	.= '<h2>array $_REQUEST[\'__err__\']</h2>';
	$tx	.= '<pre>' . print_r( $_REQUEST['__err__'], true ) . '</pre>';

    // output
	$tx	.= '</body>';
	$tx	.= '</html>';

    // output
	buildHTML( $tx );
