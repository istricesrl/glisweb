<?php

    /**
     * 
     */
    function xlsIncrementCol( $col, $inc ) {

        $old = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::columnIndexFromString( $col );
        $new = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex( $old + $inc );

        return $new;

    }

    function xls2csv( $file ) {

        // normalizzo il percorso
        fullPath( $file );

        // apro il documento per leggere il numero di righe
        $xls = \PhpOffice\PhpSpreadsheet\IOFactory::load( $file );

        // converto il foglio attivo in un array
        $arr = $xls->getActiveSheet()->toArray();

        // nuovo file
        $nFile = str_replace( array( '.xls', '.xlsx' ), '.csv', $file );

        // converto l'array in CSV
        array2csvFile( $arr, $nFile );

        // restituisco il nome del file creato
        return $nFile;

    }