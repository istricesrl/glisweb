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
    function csvFile2array( $file, $s = ",", $c = "\"", $e = '\\' ) {

        // leggo il contenuto grezzo del file
        $grezzo = readFromFile( $file );

        // faccio il parsing CSV di ogni riga
        $lavorato = csv2array( $grezzo, $s, $c, $e );

        // restituisco l'array associativo
        return( $lavorato );

    }

    /**
     * converte un array di stringhe CSV in un array associativo
     * 
     * prende in input un array di stringhe CSV e restituisce un array di array
     * associativi usando la prima riga per le intestazioni; la riga delle intestazioni
     * viene eliminata e non viene restituita fra i dati; le righe CSV devono avere
     * i campi separati da virgola, e tutti i campi di testo delimitati dalle doppie
     * virgolette
     * 
     * 
     * @todo documentare
     *
     */
    function csv2array( $data, $s = ",", $c = "\"", $e = '\\' ) {

        foreach( $data as &$row ) {
            $row = str_getcsv( $row, $s, $c, $e );
            $row = array_combine( $data[0], $row );
        }

        array_shift( $data );

        return $data;

    }

    /**
     *
     * @todo servirebbe una versione con un parametro solo $data che ritorna la stringa CSV
     * @todo documentare
     *
     * function array2csv( $data, $file ) {
	 * $h = openFile( $file );
     * fputcsv( $h, array_keys( $data[0] ) );
     * foreach( $data as $row ) {
     * fputcsv( $h, $row );
     * }
     * }
     * 
     */
    function array2csvFile( $data, $file, $mode = FILE_WRITE_OVERWRITE ) {

        $h = openFile( $file, $mode );
    
        $h = openFile( $file );
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
