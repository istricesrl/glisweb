<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * https://tcpdf.org/examples/example_009/
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // ...
    if( isset( $_REQUEST['codice'] ) ) {

        // ...
        $colli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM colli WHERE codice LIKE ?',
            array(
                array( 's' => $_REQUEST['codice'] . '%' )
            )
        );

        // debug
        // die( print_r( $colli, true ) );

        // ...
        $fntSizeCodice = ( strlen( $codice ) < 8 ) ? 20 : ( ( strlen( $codice ) < 11 ) ? 14 : 12 );

        // creazione del PDF
        $pdf = new TCPDF( 'L', 'mm', array( 57, 32 ) );						// portrait, millimetri, A4 (x->210 y->297)

        // rimozione di header e footer
        $pdf->SetPrintHeader( false );							// se stampare l'header
        $pdf->SetPrintFooter( false );							// se stampare il footer

        // imposto i margini
        $pdf->SetMargins( 0, 0, 0 );						// left, top, right
        $pdf->SetHeaderMargin( 0 );							// margine dell'intestazione
        $pdf->SetFooterMargin( 0 );							// margine del footer

        // set image scale factor
        $pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );					// fattore di conversione da pixel a millimetri

        // set auto page breaks
        $pdf->SetAutoPageBreak( false );						// se aggiungere automaticamente pagine

        // per ogni collo
        foreach( $colli as $collo ) {

            // aggiunta di una pagina
            $pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

            // set font
            $pdf->SetFont('helvetica', '', $fontSize);				// font, stile, dimensione

            // define barcode style
            $style = array(
                'position' => '',
                'align' => 'C',
                'stretch' => false,
                'fitwidth' => true,
                'cellfitalign' => '',
                'border' => false,
                'hpadding' => 'auto',
                'vpadding' => 'auto',
                'fgcolor' => array(0,0,0),
                'bgcolor' => false, //array(255,255,255),
                'text' => true,
                'font' => 'helvetica',
                'fontsize' => 8,
                'stretchtext' => 4
            );

            // posizione verticale del codice
            $pdf->SetY( 5 );

            // codice del collo
            $pdf->write1DBarcode( $collo['codice'], 'C128', '', '', '', 18, 0.4, $style, 'N');

        }

        // invia l'output al browser
        $pdf->Output( time().'.pdf');

    } else {

        // debug
        die( 'codice di ricerca non passato' );

    }
