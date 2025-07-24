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
    if( isset( $_REQUEST['mastro'] ) ) {

        // ...
        $etichetta = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM mastri_view WHERE id = ?',
            array(
                array( 's' => $_REQUEST['mastro'] )
            )
        );

        // debug
        // die( print_r( $etichette, true ) );

        // ...
        $fntSizeCodice = 16;

        // creazione del PDF
        $pdf = new TCPDF( 'L', 'mm', array( 200, 40 ) );						// portrait, millimetri, A4 (x->210 y->297)

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

        // aggiunta di una pagina
        $pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

        // codice
        $pdf-> setXY( 0, 0 );
        $pdf->setTextColor( 0, 0, 0 );
        $pdf->SetFillColor(  255, 255, 255 );
        $pdf -> SetFont( 'helvetica', 'B', $fntSizeCodice );
        // $pdf-> Cell( 200, 10, strtoupper( $etichetta['__label__'] ), '','', 'C', 1 );

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
            'bgcolor' => false,
            'text' => true,
            'font' => 'helvetica',
            'fontsize' => 16,
            'stretchtext' => 0
        );

        // posizione del codice a barre
        $pdf->setXY( 55, 10 );

        // codice del collo
        $pdf->write1DBarcode( $etichetta['codice'], 'C128', '', '', '', 25, 0.4, $style, 'N');

        // invia l'output al browser
        $pdf->Output( time().'.pdf');

    } else {

        // debug
        die( 'ID articolo non passato' );

    }
