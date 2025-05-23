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
    if( isset( $_REQUEST['__etichette__']['codice'] ) ) {

        // ...
        $img = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT immagini.path, metadati.testo AS codice_alternativo FROM immagini 
                INNER JOIN prodotti ON immagini.id_prodotto = prodotti.id 
                INNER JOIN articoli ON articoli.id_prodotto = prodotti.id 
                LEFT JOIN metadati ON metadati.id_articolo = articoli.id AND metadati.nome = "codice_alternativo"
                WHERE articoli.id = ? AND immagini.path IS NOT NULL 
                ORDER BY immagini.id DESC LIMIT 1',
            array(
                array( 's' => $_REQUEST['__etichette__']['codice'] )
            )
        );

        // debug
        // die( print_r( $img, true ) );

        // ...
        $codice = ( ! empty( $img['codice_alternativo'] ) ) ? $img['codice_alternativo'] : $_REQUEST['__etichette__']['codice'];

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

        // aggiunta di una pagina
        $pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

        // immagine articolo ( path, x, y, w, h, type, link, align, resize, dpi, palign, ismask, imgmask, border, fitbox )
        $pdf->image( DIR_BASE . $img['path'], 3, 3, 15, 15, NULL, NULL, 'T', false, 300, '', false, false, 1, true );

        // logo Eurosnodi ( path, x, y, w, h, type, link, align, resize, dpi, palign, ismask, imgmask, border, fitbox )
        $pdf->image( DIR_BASE . 'var/contenuti/logo_Eurosnodi.png', 22.5, 13, 12, 12, NULL, NULL, 'T', false, 300, '', false, false, 1, true );

        // codice
        $pdf-> setXY( 24, 2 );
        $pdf->setTextColor( 0, 0, 0 );
        $pdf->SetFillColor(  255, 255, 255 );
        $pdf -> SetFont( 'helvetica', 'B', $fntSizeCodice );
        $pdf-> Cell( 30, 10, strtoupper( $codice ), '','', 'R', 1 );

        // etichetta quantità
        $pdf-> setXY( 34, 14 );
        $pdf->setTextColor( 0, 0, 0 );
        $pdf->SetFillColor(  255, 255, 255 );
        $pdf -> SetFont( 'helvetica', 'B', 9 );
        $pdf-> Cell( 20, 8, 'QTY:', '','', 'R', 1 );

        // quantità
        $pdf-> setXY( 34, 20 );
        $pdf->setTextColor( 0, 0, 0 );
        $pdf->SetFillColor(  255, 255, 255 );
        $pdf -> SetFont( 'helvetica', 'B', 20 );
        $pdf-> Cell( 20, 7, strtoupper( $_REQUEST['__etichette__']['quantita'] ), '','', 'R', 1 );

        // data
        $pdf-> setXY( 3, 22 );
        $pdf->setTextColor( 0, 0, 0 );
        $pdf->SetFillColor(  255, 255, 255 );
        $pdf -> SetFont( 'helvetica', '', 9 );
        $pdf-> Cell( 25, 8, date( 'd/m/Y' ), '','', 'L', 1 );

        // invia l'output al browser
        $pdf->Output( time().'.pdf');

    } else {

        // debug
        die( 'ID articolo non passato' );

    }
