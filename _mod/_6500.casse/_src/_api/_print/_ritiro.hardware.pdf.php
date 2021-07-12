<?php

// inclusione del framework
    require '../../../../../_src/_config.php';

    
// impostazione documento
$info['doc']['title']                       = 'PDF ritiro hardware'.( isset( $todo ) ? ' todo #'.$todo['id'] : '' );

// definizione colori
$info['colors']['nero']                     = array( 0, 0, 0 );
$info['colors']['grigio']                   = array( 128, 128, 128 );
$info['colors']['bianco']                   = array( 255, 255, 255 );

// impostazione stili
$info['style']['page']                      = array( 'w' => 210, 'h' => 297, 'mt' => 10, 'ml' => 15, 'mr' => 15 );
$info['style']['text']['title']             = array( 'font' => 'helvetica', 'size' => 10, 'weight' => 'B' );
$info['style']['text']['label']             = array( 'font' => 'helvetica', 'size' => 7, 'weight' => '' );
$info['style']['text']['small']             = array( 'font' => 'helvetica', 'size' => 6, 'weight' => '' );
$info['style']['text']['small_bold']        = array( 'font' => 'helvetica', 'size' => 8, 'weight' => 'B' );

// impostazione linee
$info['lines']['thick']                     = array( 'thickness' => .3, 'color' => $info['colors']['nero'] );
$info['lines']['thin']                      = array( 'thickness' => .15, 'color' => $info['colors']['grigio'] );

// impostazione form
$info['form']['columns']                    = 45;
$info['form']['row']['height']              = 9;

// prelievo dati dal database

// creazione del PDF
$pdf = pdfInit( $info );


// impostazione stili
$info['style']['text']['default']           = array( 'font' => 'helvetica', 'size' => 8, 'weight' => '' );
    



if( isset( $logo ) ){
    // inserisco il logo in alto a sinistra
    $pdf->image( $logo, 15, 15, 10, 10, NULL, NULL, 'T', false, 10, '', false, false, 0, true );		// x, y, w, h, type, link, align, resize
    $x = $pdf -> getX() + 2;
    $pdf -> setX( $x );
    pdfFormCellPdfTitle( $pdf, $info, 'rapporto di intervento di assistenza tecnica', 15 );
    $pdf -> setX( $x );
    pdfFormCellLabel( $pdf, $info, 'modulo ritiro materiale hardware', 10);

} else {

        pdfFormCellPdfTitle( $pdf, $info, 'rapporto di intervento di assistenza tecnica', 15 );
        pdfFormCellLabel( $pdf, $info, 'modulo ritiro materiale hardware', 10);
}

pdfSetRelativeY( $pdf, 15);
pdfFormCellTitle( $pdf, $info, 'dati dell\'assistenza' );
        pdfSetRelativeY( $pdf, 2);
        // tabella attivita
        $margin = $pdf->getMargins();
        $w = $pdf->getPageWidth();
        $col = ( $w - $margin['right'] - $margin['left'] )/12;
        
        pdfSetFontStyle( $pdf, $info['style']['text']['small_bold'] );
         // intestazione tabella di dettaglio
        //$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 6, 0, 'descrizione',  $info['cell']['thick'], 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 5, 0, 'matricola',  $info['cell']['thick'], 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col, 0, 'quantità',  $info['cell']['thick'], 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
        
        
        $i = 1;

        if( isset($elenco_attivita) && count($elenco_attivita) > 0 ){

            $totore = 0;
            foreach( $elenco_attivita as $a){

                $pdf->Cell( $col * 2, 0, ( $a['data_attivita'] == NULL ? '' : date_format( date_create($a['data_attivita']) , 'd/m/Y') ) , ( $i == count( $elenco_attivita ) ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 9, 0, $a['testo'], ( $i == count( $elenco_attivita ) ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col, 0, $a['ore'], ( $i == count( $elenco_attivita ) ? $info['cell']['thick'] : $info['cell']['thin']) , 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $totore += $a['ore'];
                $i++;
            }
    
         
        } else {

            for( $i = 1; $i <= 35; $i++){

                $pdf->Cell( $col * 6, 0, '' , ( $i == 35 ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 5, 0, '', ( $i == 35 ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col, 0, '', ( $i == 35  ? $info['cell']['thick'] : $info['cell']['thin']) , 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
       
            }
    
        }

        
        






pdfSetRelativeY( $pdf, 95);
pdfSetRelativeY( $pdf, $info['form']['row']['spacing'] );
            $boxY = $pdf->GetY();

            pdfFormBox( $pdf, $info, "luogo e data", 12, 3, pdfFormCalcX( $info, 0 ), $boxY );
            pdfFormBox( $pdf, $info, "timbro e firma accettazione ritiro", 21, 3, pdfFormCalcX( $info, 12), $boxY );
            pdfFormBox( $pdf, $info, "firma del tecnico", 12, 3, pdfFormCalcX( $info, 33 ), $boxY );
// aggiunta di una pagina
//$pdf->AddPage();

    // output
$pdf->Output( 'modulo ritiro hardware.pdf' );								// invia l'output al browser