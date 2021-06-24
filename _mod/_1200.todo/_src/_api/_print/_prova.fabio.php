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

    // definizione colori
    $info['colors']['nero']                     = array( 0, 0, 0 );
    $info['colors']['grigio']                   = array( 128, 128, 128 );
    $info['colors']['bianco']                   = array( 255, 255, 255 );

    // impostazione stili
    $info['style']['page']                      = array( 'w' => 210, 'h' => 297, 'mt' => 15, 'ml' => 15, 'mr' => 15 );
    $info['style']['text']['title']             = array( 'font' => 'helvetica', 'size' => 10, 'weight' => 'B' );
    $info['style']['text']['label']             = array( 'font' => 'helvetica', 'size' => 8, 'weight' => '' );

    // impostazione linee
    $info['lines']['thick']                     = array( 'thickness' => .3, 'color' => 'nero' );
    $info['lines']['thin']                      = array( 'thickness' => .15, 'color' => 'grigio' );

    // impostazione form
    $info['form']['columns']                    = 45;
    $info['form']['row']['height']              = 10;

    // prelievo dati dal database

    // creazione del PDF
	$pdf = pdfInit( $info );

    // ESEMPIO #1 testo nella griglia senza larghezza fissa
    pdfFormCellBar( $pdf, $info, 'prova' );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #2 testo nella griglia con larghezza fissa
    pdfFormCellBar( $pdf, $info, 'prova', 10 );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #3 etichetta
    pdfFormCellLabel( $pdf, $info, 'prova', 10 );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #4 etichetta con impostazione di stile
    pdfFormCellLabel( $pdf, $info, 'prova', 10, 'label' );

    // vado giù
    pdfSetRelativeY( $pdf, 10 );

    // ESEMPIO #5 riga completa con etichette e celle
    pdfFormCellRow( $pdf, $info, array(
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

    // ESEMPIO #6 riga completa con etichette e celle, con vuoto al centro
    pdfFormCellRow( $pdf, $info, array(
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

    // ESEMPIO #7 titolo
    pdfFormCellTitle( $pdf, $info, 'esempio di titolo' );

    // ESEMPIO #8 riga completa con etichette e celle e stili imposti
    pdfFormCellRow( $pdf, $info, array(
        array(
            'width' => 10,
            'label' => array( 'text' => 'prova', 'style' => 'label' ),
            'bar' => array( 'text' => 'test' )
        ),
        array(
            'width' => 34,
            'label' => array( 'text' => 'prova1', 'style' => 'label' ),
            'bar' => array( 'text' => 'test1' )
        )
    ) );

    // ESEMPIO #9 line multi cell con testo
    pdfFormCellTitle( $pdf, $info, 'esempio di blocco linee' );
    pdfFormLineRow( $pdf, $info, 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', 35, 5 );

    // ESEMPIO #10 titolo dopo la line multi cell
    pdfFormCellTitle( $pdf, $info, 'esempio dopo la line multicell' );

    // output
    $pdf->Output( 'prova.pdf' );								// invia l'output al browser
