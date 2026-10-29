<?php

    /**
     * 
     */
    function xlsIncrementCol( $col, $inc ) {

        $old = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::columnIndexFromString( $col );
        $new = \PhpOffice\PhpSpreadsheet\Cell\Coordinate::stringFromColumnIndex( $old + $inc );

        return $new;

    }

    /**
     * apre un foglio di calcolo da leggere, con le difese contro i file costruiti apposta
     *
     * Il framework legge con PhpSpreadsheet anche file caricati dagli utenti ( importazioni ), e sulle versioni
     * fino alla 1.30.6 un file costruito apposta puo' fare tre cose: leggere file o chiamare indirizzi interni con
     * un'entita' esterna che sfugge al controllo XmlScanner ( CVE-2026-108358 ), esaurire CPU e memoria con un ODS
     * dalle righe ripetute all'infinito ( CVE-2026-108359 ), far chiamare al server un indirizzo qualsiasi con
     * un'immagine collegata ( CVE-2026-108360; fino alla 1.25 senza nessun controllo ). La versione corretta, la
     * 1.30.7, vuole PHP 7.4, quindi sui deploy fermi a PHP 7.3 le difese stanno qui:
     *
     * difesa                                       | contro
     * ---------------------------------------------|--------------------------------------------------------
     * solo i reader Xlsx, Xls e Csv                | il DoS dell'ODS, e i reader Html, Xml, Gnumeric e Slk
     * libxml senza DTD e senza entita' esterne     | l'XXE, anche quando XmlScanner viene aggirato
     * http, https, ftp, ftps e phar spenti         | la chiamata di un'immagine collegata, e i phar:// nei
     *   durante la lettura                         | percorsi
     *
     * Le difese valgono anche con la 1.30.7, e non tolgono niente a quello che il framework legge: i dati, gli
     * stili e i formati delle celle. Le impostazioni globali toccate si rimettono com'erano alla fine.
     *
     * Un file che non si puo' leggere ( formato non ammesso, file rovinato, difese che scattano ) non solleva
     * eccezioni: la funzione scrive il motivo nel log xls e restituisce false, che il chiamante deve controllare prima
     * di usare il risultato.
     *
     * @param       string      $file           il file da aprire
     *
     * @return      mixed                       lo Spreadsheet, oppure false se il file non si puo' leggere
     *
     */
    function xlsLoad( $file ) {

        // impostazioni da rimettere alla fine
        $opzioni = \PhpOffice\PhpSpreadsheet\Settings::getLibXmlLoaderOptions();
        $entita = ( PHP_VERSION_ID < 80000 ) ? libxml_disable_entity_loader( true ) : NULL;
        $spenti = array_intersect( array( 'http', 'https', 'ftp', 'ftps', 'phar' ), stream_get_wrappers() );

        // niente DTD, niente entita' esterne, niente rete
        \PhpOffice\PhpSpreadsheet\Settings::setLibXmlLoaderOptions( 0 );
        foreach( $spenti as $w ) {
            stream_wrapper_unregister( $w );
        }

        try {
            $reader = \PhpOffice\PhpSpreadsheet\IOFactory::createReaderForFile( $file, array( 'Xlsx', 'Xls', 'Csv' ) );
            $xls = $reader->load( $file );
        } catch( \Throwable $e ) {
            logger( 'impossibile leggere ' . $file . ': ' . $e->getMessage(), 'xls', LOG_ERR );
            $xls = false;
        }

        // impostazioni com'erano
        foreach( $spenti as $w ) {
            stream_wrapper_restore( $w );
        }
        \PhpOffice\PhpSpreadsheet\Settings::setLibXmlLoaderOptions( $opzioni );
        if( $entita !== NULL ) {
            libxml_disable_entity_loader( $entita );
        }

        return $xls;

    }

    function xls2csv( $file ) {

        // normalizzo il percorso
        fullPath( $file );

        // apro il documento per leggere il numero di righe ( vedi xlsLoad() )
        $xls = xlsLoad( $file );
        if( $xls === false ) {
            return false;
        }

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

    function xlsDate2timestamp( $d, $f = 'dd/mm/YYYY' ) {

        logger( 'data da elaborare: ' . $d, __FUNCTION__ );

        $r = NULL;

        if( is_numeric( $d ) ) {

            $r = ( $d - 25569 ) * 86400;

        } else {

            $date = explode( '/', $d );

            logger( 'array degli elementi: ' . print_r( $date, true ), __FUNCTION__ );

            if( $f == 'dd/mm/YYYY' ) {
                $rd = $date[2] . '-' . $date[1] . '-' . $date[0];
            } elseif( $f == 'YYYY/mm/dd' ) {
                $rd = $date[0] . '-' . $date[1] . '-' . $date[2];
            } elseif( $f == 'mm/dd/YYYY' ) {
                $rd = $date[2] . '-' . $date[0] . '-' . $date[1];
            }

            logger( 'data riarrangiata: ' . $rd, __FUNCTION__ );

            $r = strtotime( $rd );

        }

        logger( 'data elaborata: ' . $r, __FUNCTION__ );

        return $r;

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
