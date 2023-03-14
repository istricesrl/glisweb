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
        $nFile = str_replace( array( '.xlsx', '.xls' ), '.csv', $file );

        // converto l'array in CSV
        array2csvFile( $arr, $nFile, FILE_WRITE_OVERWRITE, ';' );

        // restituisco il nome del file creato
        return $nFile;

    }

    function array2xlsFile( $file, $data ) {

        // normalizzo il percorso
        fullPath( $file );

        // ...
        $spreadSheet = new \PhpOffice\PhpSpreadsheet\Spreadsheet();
        $workSheet = $spreadSheet->getActiveSheet();

        // prelevo le intestazioni dalla prima riga
        $sheet = array( array_keys( $data[0] ) );

        // debug
        // die( '<pre>' . print_r( $sheet, true ) . '</pre>' );

        array_walk( $data, function( &$row, $key ) { $row = array_values( $row ); } );

        // debug
        // die( '<pre>' . print_r( $data, true ) . '</pre>' );

        // ...
        $sheet = array_merge( $sheet, $data );

        // debug
        // die( '<pre>' . print_r( $sheet, true ) . '</pre>' );

        // scrivo l'intestazione
        $workSheet->fromArray( $sheet, NULL, 'A1' );

        // creo il writer
        // $writer = \PhpOffice\PhpSpreadsheet\IOFactory::createWriter( $spreadSheet, "Xlsx" );
        $writer = new \PhpOffice\PhpSpreadsheet\Writer\Xlsx( $spreadSheet );

        // debug
        // header('Content-Disposition: attachment; filename="myfile.xlsx"');
        // header('Cache-Control: max-age=0');
        // $writer->save( 'php://output' );

        // debug
        // die( $file );

        // scrivo i dati
        $writer->save( $file );

    }

    function xlsDate2timestamp( $d ) {
        if( is_numeric( $d ) ) {
            return ( $d - 25569 ) * 86400;
        } else {
            $date = explode( '/', $d );
            if( strlen( $date[2] ) == 4 ) {
                return strtotime( $date[2] . '-' . $date[1] . '-' . $date[0] );
            } else {
                return strtotime( $date[0] . '-' . $date[1] . '-' . $date[2] );
            }
        }
    }

    function xlsNumber2mysql( $d ) {
        $dot = strpos( '.', $d );
        $com = strpos( ',', $d );
        if( ! empty( $com ) && empty( $dot ) ) {
            $d = str_replace( ',', '.', $d );
        } elseif( ! empty( $com ) && ! empty( $dot ) ) {
            if( $dot < $com ) {
                $d = str_replace( ',', '.', str_replace( '.', NULL, $d ) );
            } else {
                $d = str_replace( ',', NULL, $d );
            }
        }
    }
