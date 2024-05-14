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
     * legge un file CSV e restituisce un array associativo
     *
     *
     * @todo documentare
     *
     */
    function csvFile2array( $file ) {

        // leggo il contenuto grezzo del file
        $grezzo = readFromFile( $file );

        // faccio il parsing CSV di ogni riga
        $lavorato = csv2array( $grezzo );

        // restituisco l'array associativo
        return ($lavorato );
    }

    /**
     * legge un array di stringe CSV e lo trasforma in un array associativo
     * 
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
     * scrive un file CSV a partire da un array associativo
     *
     *
     * @todo servirebbe una versione con un parametro solo $data che ritorna la stringa CSV
     * @todo documentare
     *
     */
    function array2csvFile( $data, $file, $mode = FILE_WRITE_OVERWRITE ) {

	$h = openFile( $file, $mode );

	fputcsv( $h, array_keys( $data[0] ) );

	foreach( $data as $row ) {
	    fputcsv( $h, $row );
	}

    }

    /**
     * trasforma un array associativo in un array di stringhe CSV
     *
     *
     * @todo documentare
     *
     */
    function array2csv( $data ) {

        $csv = array();

        array_unshift( $data, array_keys( $data[0] ) );

        $h = fopen('php://memory', 'r+');

        foreach( $data as $row ) {
            fputcsv( $h, $row );
        }

        rewind($h);

        while( $buf = fgets($h) ) {
            $csv[] = $buf;
        }

        fclose($h);
        return $csv;

    }
