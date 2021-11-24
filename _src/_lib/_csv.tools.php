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

        return $data;

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
