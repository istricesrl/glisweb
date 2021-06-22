<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // impostazione documento
    $info['doc']['title']                       = 'PDF di prova';

    // impostazione stili
    $info['style']['page']                      = array( 'w' => 210, 'h' => 297, 'mt' => 15, 'ml' => 15, 'mr' => 15 );
    $info['style']['default']                   = array( 'font' => 'helvetica', 'size' => 10, 'weight' => '' );
    $info['style']['titolo1']                   = array( 'font' => 'helvetica', 'size' => 12, 'weight' => 'B' );

    // prelievo dati dal database

    // creazione del PDF
	$pdf = pdfInit( $info );

    // ESEMPIO #1 testo nella griglia senza larghezza fissa
    pdfFormCellBar( $pdf, 'prova' );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #2 testo nella griglia con larghezza fissa
    pdfFormCellBar( $pdf, 'prova', 10 );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #3 etichetta
    pdfFormCellLabel( $pdf, 'prova', 10 );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #4 riga completa con etichette e celle
    pdfFormCellRow( $pdf, array(
        array(
            'width' => 10,
            'label' => array( 'text' => 'prova' ),
            'bar' => array( 'text' => 'test' )
        ),
        array(
            'width' => 34,
            'label' => array( 'text' => 'prova1' ),
            'bar' => array( 'text' => 'test1' )
        )
    ) );
   
    // vado giù
    pdfSetRelativeY( $pdf, 20 );

    // ESEMPIO #5 riga completa con etichette e celle, con vuoto al centro
    pdfFormCellRow( $pdf, array(
        array(
            'width' => 10,
            'label' => array( 'text' => 'prova' ),
            'bar' => array( 'text' => 'test' )
        ),
        array(
            'width' => 19
        ),
        array(
            'width' => 14,
            'label' => array( 'text' => 'prova1' ),
            'bar' => array( 'text' => 'test1' )
        )
    ) );

    // output
    $pdf->Output( 'prova.pdf' );								// invia l'output al browser
