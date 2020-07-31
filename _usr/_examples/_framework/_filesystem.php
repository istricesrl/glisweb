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

    // generazione di una stringa pseudocasuale
	$t	= md5( microtime( true ) ) . PHP_EOL;

    // definizione del nome del file
	$f	= DIR_TMP . time() . '.test';

    // test scrittura su file
	$r	= writeToFile( $t, $f, $e );

    // test di lettura da file
	if( file_exists( $f ) ) {
	    $tx = 'ho scritto:' . PHP_EOL . readFromFile( $f, READ_FILE_AS_STRING ) . 'su: ' . $f . PHP_EOL;
	} else {
	    $tx = 'esito scrittura: ' . var_export( $r, true ) . PHP_EOL . $e . PHP_EOL;
	}

    // generazione di una stringa pseudocasuale
	$t	= md5( microtime( true ) ) . PHP_EOL;

    // test scrittura su file
	$r	= appendToFile( $t, $f, $e ) . PHP_EOL;

    // test di lettura da file
	if( file_exists( $f ) ) {
	    $tx .= 'ho scritto:' . PHP_EOL . readFromFile( $f, READ_FILE_AS_STRING ) . 'su: ' . $f . PHP_EOL;
	} else {
	    $tx .= 'esito scrittura: ' . var_export( $r, true ) . PHP_EOL . $e . PHP_EOL;
	}

    // test di cancellazione
	emptyDir( DIRECTORY_TEMPORANEA );

    // output
	build( $tx );

?>
