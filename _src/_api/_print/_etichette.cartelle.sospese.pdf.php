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
    require '../../_config.php';

    // oggetto del documento
	$dobj = 'etichette cartelle sospese';

    if( isset( $_REQUEST['id'] )  ){
        $anagrafiche = mysqlQuery( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE id = ?', array( array( 's' => $_REQUEST['id'] ) ) );
    } else {
        $anagrafiche = mysqlQuery( $cf['mysql']['connection'],'SELECT * FROM anagrafica_view WHERE se_cliente = 1');
    }
    
    if( empty(  $anagrafiche  ) ){
        die( print_r( "dati assenti", true ) );
    }
    // creazione del PDF
	$pdf = new TCPDF( 'L', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // inizializzazione del nome del file
	$pdf->SetTitle($dobj.'.pdf');

    // tipografia
	$w		= 297;								// altezza del foglio
	$h		= 210;								// larghezza del foglio
	$ml		= 0;								// margine sinistro
	$mt		= 5;								// margine superiore
	$mr		= 5;								// margine destro
	$fnt		= 'helvetica';							// font base
    $fntl		= 8;								// dimensione del font base
	$fnts		= 10;								// dimensione del font base
    $fntm       = 12;
    $fntt		= 40;								// dimensione del font titolo
	$stdsp		= 5;								// spaziatore standard
    $litsp      = 2;
    $lth		= .3;								// spessore linea standard
	$lts		= .15;								// spessore linea sottile
	$rgb0		= array( 0, 0, 0 );						// il nero
	$rgb1		= array( 128, 128, 128 );					// grigio
	$rgb9		= array( 255, 255, 255 );					// il bianco
    $rgBlu      = array( 26, 99, 154 );
    $rgCel      = array( 0, 156, 204 ); 
    $hBox       = 7;


    
    // bordi delle celle
	$brdh		= array(
	    'B' => array( 'width' => $lth, 'color' => $rgb9 )
	);
	$brdc		= array(
	    'B' => array( 'width' => $lts, 'color' => $rgb1 ),
        'T' => array( 'width' => $lts, 'color' => $rgb1 )
	);


    // carattere di base
	$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

    // tipografia derivata
	$lh		    = $pdf->getStringHeight( $w, 'a' );				// altezza stimata della linea di testo
	$wport		= $w - ( $ml + $mr );						// larghezza dell'area del testo
	$col		= $wport / 12;							// larghezza colonna base

    // rimozione di header e footer
	$pdf->SetPrintHeader( false );							// se stampare l'header
	$pdf->SetPrintFooter( false );							// se stampare il footer

    // imposto i margini
	$pdf->SetMargins( 0, 0, 0 );						// left, top, right
	$pdf->SetHeaderMargin( 0 );							// margine dell'intestazione
	$pdf->SetFooterMargin( 0 );							// margine del footer

    // set default monospaced font
	$pdf->SetDefaultMonospacedFont( PDF_FONT_MONOSPACED );				// imposta il font a larghezza fissa

    // set auto page breaks
	$pdf->SetAutoPageBreak( true );						// se aggiungere automaticamente pagine

    // set image scale factor
	$pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );					// fattore di conversione da pixel a millimetri

    $pdf->AddPage();

    $i = $mt;
    foreach( $anagrafiche as $a) {

        $pdf-> setXY($ml, $i);
        $pdf->setTextColor(255,255,255);
        $pdf->SetFillColor(  0, 0, 0 );
        $pdf -> SetFont($fnt, 'B', $fnts);
        $pdf->setCellPaddings( 15, '', '',  '');
        $pdf-> Cell($w/4, $hBox, substr(strtoupper(str_replace(' ','',$a['__label__'])), 0, 16) , $brdh,'', 'L', 1 );
   #Cell(w, h = 0, txt = '', border = 0, ln = 0, align = '', fill = 0, link = nil, stretch = 0, ignore_min_height = false, calign = 'T', valign = 'M') 
        $pdf->setTextColor(  0, 0, 0 );
        $pdf -> SetFont($fnt, '', $fnts); 
        $pdf-> Cell($w - $w/4, $hBox, $a['__label__'], $brdc,1, 'C' );

        $i += $hBox ;
    }
  


// output
	if( isset( $_REQUEST['d'] ) ) {
	    $pdf->Output($dobj.'.pdf' , 'D' );					// invia l'output al browser per il download diretto
	} elseif( isset( $_REQUEST['f'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'I' );				// salva il file localmente
	} elseif( isset( $_REQUEST['fi'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'FI' );				// salva il file localmente e invia l'output al browser
	} else {
	    $pdf->Output($dobj.'.pdf');								// invia l'output al browser
	}