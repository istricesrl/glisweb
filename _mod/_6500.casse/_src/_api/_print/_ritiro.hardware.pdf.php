<?php

// inclusione del framework
require '../../../../../_src/_config.php';

// dati
if(  isset( $_REQUEST['__documento__'] ) ){

    $documento = mysqlSelectRow(  $cf['mysql']['connection'], 'SELECT documenti_view.*, todo_completa_view.progetto FROM documenti_view LEFT JOIN todo_completa_view ON documenti_view.id_todo = todo_completa_view.id WHERE documenti_view.id = ?', 
    array( 
        array( 's' => $_REQUEST['__documento__'] ) ) 
        );

    $documento['righe'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM documenti_articoli_view WHERE id_documento = ?', array( array( 's' => $_REQUEST['__documento__'] ) ) );

}
$azienda = mysqlSelectRow( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE se_gestita = 1');

if( $azienda ){ 
    $logo = anagraficaGetLogo( $azienda['id'] );  
    $sede = anagraficaGetSedeLegale( $azienda['id']  );
}

    // stiel del barcode
    $style = array(
        'position' => '',
        'align' => 'C',
        'stretch' => false,
        'fitwidth' => true,
        'cellfitalign' => 'L',
        'border' => false,
        'hpadding' => 'auto',
        'vpadding' => 'auto',
        'fgcolor' => array(0,0,0),
        'bgcolor' => false, //array(255,255,255),
        'text' => true,
        'font' => 'helvetica',
        'fontsize' => 6
    );

if( $documento['tipologia'] == 'consegna' ){
    // impostazione documento
    $info['doc']['title']                       = 'PDF consegna hardware'.( isset( $todo ) ? ' todo #'.$todo['id'] : '' );
} else {
    // impostazione documento
    $info['doc']['title']                       = 'PDF ritiro hardware'.( isset( $todo ) ? ' todo #'.$todo['id'] : '' );
}

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
if( $documento['tipologia'] == 'consegna' ){
    pdfFormCellPdfTitle( $pdf, $info, 'modulo di consegna hardware - copia cliente', 15 );
} else {
    pdfFormCellPdfTitle( $pdf, $info, 'modulo di ritiro hardware - copia cliente', 15 );
}
$pdf -> setX( $x );
if( $documento['tipologia'] == 'consegna' ){
    pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso alla riconsegna di materiale hardware');
} else {
    pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso al ritiro di materiale hardware');
}


} else {

    if( $documento['tipologia'] == 'consegna' ){
        pdfFormCellPdfTitle( $pdf, $info, 'modulo di consegna hardware - copia cliente', 15 );
        pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso alla riconsegna di materiale hardware');
    } else {
        pdfFormCellPdfTitle( $pdf, $info, 'modulo di ritiro hardware - copia cliente', 15 );
        pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso al ritiro di materiale hardware');
    }

}

pdfSetRelativeY( $pdf, 5);
pdfFormCellTitle( $pdf, $info, 'dati dell\'assistenza' );
pdfSetRelativeY( $pdf, 1);

if( isset( $documento ) ){
    pdfFormCellLabel( $pdf, $info, $documento['cliente'] );
    pdfSetRelativeY( $pdf, 5);
    pdfFormCellLabel( $pdf, $info, $documento['progetto'] );
    pdfSetRelativeY( $pdf, 5);
    $pdf->write1DBarcode('TODO.'.str_pad( $documento['id_todo'] ,11,"0", STR_PAD_LEFT), 'C128', '', '', '', 15 ,0.17, $style);
    pdfSetRelativeY( $pdf, 10);

}

    // tabella attivita
    $margin = $pdf->getMargins();
    $w = $pdf->getPageWidth();
    $col = ( $w - $margin['right'] - $margin['left'] )/12;
    
    pdfSetFontStyle( $pdf, $info['style']['text']['small_bold'] );
        // intestazione tabella di dettaglio
    //$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
    $pdf->Cell( $col * 6, $info['form']['bar']['height'], 'descrizione',  $info['cell']['thick'], 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 5, $info['form']['bar']['height'], 'matricola',  $info['cell']['thick'], 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col, $info['form']['bar']['height'], 'quantità',  $info['cell']['thick'], 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
    pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
    
    
    $i = 1;

    if( isset( $documento['righe'] ) && count( $documento['righe']) > 0 ){

        foreach( $documento['righe'] as $r){

            $pdf->Cell( $col * 6, $info['form']['bar']['height'], $r['nome'], $info['cell']['thin'] , 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 5, $info['form']['bar']['height'], $r['label_matricola'], $info['cell']['thin'] , 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col, $info['form']['bar']['height'], $r['quantita'], $info['cell']['thin'] , 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento

        }

        
    } else {

        for( $i = 1; $i <= 20; $i++){

            $pdf->Cell( $col * 6, $info['form']['bar']['height'], '' , ( $i == 20 ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 5, $info['form']['bar']['height'], '', ( $i == 20 ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col, $info['form']['bar']['height'], '', ( $i == 20  ? $info['cell']['thick'] : $info['cell']['thin']) , 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
    
        }

    }

    
    






//pdfSetRelativeY( $pdf, 100);
$pdf -> setY( 250 );
    if( $documento['tipologia'] == 'consegna' ){
        pdfFormCellTitle( $pdf, $info, 'accettazione consegna hardware' );
    } else {
        pdfFormCellTitle( $pdf, $info, 'accettazione ritiro hardware' );
    }      
        pdfSetRelativeY( $pdf, 5 );
pdfSetRelativeY( $pdf, $info['form']['row']['spacing'] );
        $boxY = $pdf->GetY();

        pdfFormBox( $pdf, $info, "luogo e data", 12, 3, pdfFormCalcX( $info, 0 ), $boxY );
        if( $documento['tipologia'] == 'consegna' ){
            pdfFormBox( $pdf, $info, "timbro e firma accettazione consegna", 21, 3, pdfFormCalcX( $info, 12), $boxY );
        } else {
            pdfFormBox( $pdf, $info, "timbro e firma accettazione ritiro", 21, 3, pdfFormCalcX( $info, 12), $boxY );
        }

        pdfFormBox( $pdf, $info, "firma del tecnico", 12, 3, pdfFormCalcX( $info, 33 ), $boxY );
// aggiunta di una pagina
$pdf->AddPage();



// impostazione stili
$info['style']['text']['default']           = array( 'font' => 'helvetica', 'size' => 8, 'weight' => '' );




if( isset( $logo ) ){
// inserisco il logo in alto a sinistra
$pdf->image( $logo, 15, 15, 10, 10, NULL, NULL, 'T', false, 10, '', false, false, 0, true );		// x, y, w, h, type, link, align, resize
$x = $pdf -> getX() + 2;
$pdf -> setX( $x );
if( $documento['tipologia'] == 'consegna' ){
    pdfFormCellPdfTitle( $pdf, $info, 'modulo di consegna hardware - copia negozio', 15 );
} else {
    pdfFormCellPdfTitle( $pdf, $info, 'modulo di ritiro hardware - copia negozio', 15 );
}
$pdf -> setX( $x );
if( $documento['tipologia'] == 'consegna' ){
    pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso alla riconsegna di materiale hardware');
} else {
    pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso al ritiro di materiale hardware');
}


} else {

    if( $documento['tipologia'] == 'consegna' ){
        pdfFormCellPdfTitle( $pdf, $info, 'modulo di consegna hardware - copia negozio', 15 );
        pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso alla riconsegna di materiale hardware');
    } else {
        pdfFormCellPdfTitle( $pdf, $info, 'modulo di ritiro hardware - copia negozio', 15 );
        pdfFormCellLabel( $pdf, $info, 'modulo per la raccolta del consenso al ritiro di materiale hardware');
    }

}

pdfSetRelativeY( $pdf, 5);
pdfFormCellTitle( $pdf, $info, 'dati dell\'assistenza' );
pdfSetRelativeY( $pdf, 1);

if( isset( $documento ) ){
    pdfFormCellLabel( $pdf, $info, $documento['cliente'] );
    pdfSetRelativeY( $pdf, 5);
    pdfFormCellLabel( $pdf, $info, $documento['progetto'] );
    pdfSetRelativeY( $pdf, 5);
    $pdf->write1DBarcode('TODO.'.str_pad( $documento['id_todo'] ,11,"0", STR_PAD_LEFT), 'C128', '', '', '', 15 ,0.17, $style);
    pdfSetRelativeY( $pdf, 10);

}

    // tabella attivita
    $margin = $pdf->getMargins();
    $w = $pdf->getPageWidth();
    $col = ( $w - $margin['right'] - $margin['left'] )/12;
    
    pdfSetFontStyle( $pdf, $info['style']['text']['small_bold'] );
        // intestazione tabella di dettaglio
    //$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
    $pdf->Cell( $col * 6, $info['form']['bar']['height'], 'descrizione',  $info['cell']['thick'], 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 5, $info['form']['bar']['height'], 'matricola',  $info['cell']['thick'], 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col, $info['form']['bar']['height'], 'quantità',  $info['cell']['thick'], 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
    pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
    
    
    $i = 1;

    if( isset( $documento['righe'] ) && count( $documento['righe']) > 0 ){

        foreach( $documento['righe'] as $r){

            $pdf->Cell( $col * 6, $info['form']['bar']['height'], $r['nome'], $info['cell']['thin'] , 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 5, $info['form']['bar']['height'], $r['label_matricola'], $info['cell']['thin'] , 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col, $info['form']['bar']['height'], $r['quantita'], $info['cell']['thin'] , 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento

        }

        
    } else {

        for( $i = 1; $i <= 20; $i++){

            $pdf->Cell( $col * 6, $info['form']['bar']['height'], '' , ( $i == 20 ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 5, $info['form']['bar']['height'], '', ( $i == 20 ? $info['cell']['thick'] : $info['cell']['thin']) , 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col, $info['form']['bar']['height'], '', ( $i == 20  ? $info['cell']['thick'] : $info['cell']['thin']) , 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
    
        }

    }

    
    






//pdfSetRelativeY( $pdf, 100);
$pdf -> setY( 250 );
    if( $documento['tipologia'] == 'consegna' ){
        pdfFormCellTitle( $pdf, $info, 'accettazione consegna hardware' );
    } else {
        pdfFormCellTitle( $pdf, $info, 'accettazione ritiro hardware' );
    }      
        pdfSetRelativeY( $pdf, 5 );
pdfSetRelativeY( $pdf, $info['form']['row']['spacing'] );
        $boxY = $pdf->GetY();

        pdfFormBox( $pdf, $info, "luogo e data", 12, 3, pdfFormCalcX( $info, 0 ), $boxY );
        if( $documento['tipologia'] == 'consegna' ){
            pdfFormBox( $pdf, $info, "timbro e firma accettazione consegna", 21, 3, pdfFormCalcX( $info, 12), $boxY );
        } else {
            pdfFormBox( $pdf, $info, "timbro e firma accettazione ritiro", 21, 3, pdfFormCalcX( $info, 12), $boxY );
        }

        pdfFormBox( $pdf, $info, "firma del tecnico", 12, 3, pdfFormCalcX( $info, 33 ), $boxY );
// output
$pdf->Output($info['doc']['title'].'.pdf' );								// invia l'output al browser