<?php

    /**
     * test delle funzioni del filesystem
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
	$tx	= 'array di partenza: ' . PHP_EOL . PHP_EOL;

    // generazione di un array di stringhe pseudocasuali
	$d1	= array(
		    array(
			'col1' => ( md5( microtime( true ) * rand( 0, 9 ) ) ),
			'col2' => ( md5( microtime( true ) * rand( 0, 9 ) ) ),
			'col3' => ( md5( microtime( true ) * rand( 0, 9 ) ) )
		    ),
		    array(
			'col1' => ( md5( microtime( true ) * rand( 0, 9 ) ) ),
			'col2' => ( md5( microtime( true ) * rand( 0, 9 ) ) ),
			'col3' => ( md5( microtime( true ) * rand( 0, 9 ) ) )
		    )
		);

	$tx	.= print_r( $d1, true );

    // definizione del nome del file
	$f	= DIR_TMP . time() . '.test';

    // test scrittura su file
	$r	= array2csvFile( $d1, $f );

    // output
	$tx	.= PHP_EOL;
	$tx	.= 'contenuto del file ' . $f . ': ' . PHP_EOL . PHP_EOL;
	$tx	.= readStringFromFile( $f );

	$d2	= csv2array( readFromFile( $f ) );

    // output
	$tx	.= PHP_EOL;
	$tx	.= 'array letto dal file ' . $f . ': ' . PHP_EOL . PHP_EOL;
	$tx	.= print_r( $d2, true );

    // test di cancellazione
	emptyDir( DIR_TMP );

    // output
	build( $tx );
