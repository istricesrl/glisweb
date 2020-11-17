<?php

    /**
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
     */
    function csv2array( $data ) {

	$csv = array_map( 'str_getcsv', $data );
	array_walk( $csv, function( &$a ) use ( $csv ) {
	    $a = array_combine( $csv[0], $a );
	});

	array_shift( $csv );

	return( $csv );

    }

    /**
     *
     * @todo servirebbe una versione con un parametro solo $data che ritorna la stringa CSV
     * @todo documentare
     *
     */
    function array2csv( $data, $file ) {

	$h = openFile( $file );
	fputcsv( $h, array_keys( $data[0] ) );
	foreach( $data as $row ) {
	    fputcsv( $h, $row );
	}

    }
