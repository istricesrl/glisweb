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

    // oggetto del documento
	$dobj = 'coupon';



     //  print_r( fullPath( $img ));
    // full path
    $cp = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM coupon_view  WHERE id = ?', array( array( 's' => $_REQUEST['id'] ) ) );


   
    if( empty( $_REQUEST['id'] ) ){

        die( print_r( 'coupon assente', true ) );

    }



    //die( print_r( empty($articoli[0]['ric']) , true ) );
    

    // creazione del PDF
	$pdf = new TCPDF( 'P', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // inizializzazione del nome del file
	$pdf->SetTitle($dobj.'.pdf');

    // tipografia
	$h		= 297;								// altezza del foglio
	$w		= 210;								// larghezza del foglio
	$ml		= 20;								// margine sinistro
	$mt		= 40;								// margine superiore
	$mr		= 20;								// margine destro
	$fnt		= 'helvetica';							// font base
    $fntl		= 8;								// dimensione del font base
	$fnts		= 12;								// dimensione del font base
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
    $hBox       = $w;
    $wBox       = $h / 2;
    $bluSpace      = 53;

    $ml =  ($w-$wBox)/2;
    $mr = $ml;
    $mt = $h - $hBox;
    $startX = $ml;
    $startY = $ml;
    
    // bordi delle celle
	$brdh		= array(
	    'B' => array( 'width' => $lth, 'color' => $rgb0 )
	);
	$brdc		= array(
	    'B' => array( 'width' => $lts, 'color' => $rgb1 )
	);
    $brdb		= array(
	    'B' => array( 'width' => $lts, 'color' => $rgBlu ),
        'T' => array( 'width' => $lts, 'color' => $rgBlu ),
        'L' => array( 'width' => $lts, 'color' => $rgBlu ),
        'R' => array( 'width' => $lts, 'color' => $rgBlu )
	);

    // stiel del barcode
    $style = array(
        'position' => '',
        'align' => 'L',
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

    // aggiunta di una pagina
	
    $x = $startX;
    $y = $startY;
    
    //print_r($articoli);
// convert TTF font to TCPDF format and store it on the fonts folder
//$fontname = TCPDF_FONTS::addTTFfont('var/www/html/glisweb/var/contenuti/AllertaStencil-Regular.ttf', 'TrueTypeUnicode');

// use the font
//$pdf->SetFont($fontname, '', 14, '', false);


        $pdf->AddPage();								// richiesto perché si è disattivato l'automatismo
        $pdf-> setXY( $mt, $ml);

        $imgS = $wBox / 2;
       // $pdf->image( $img, $w / 2 - $stdsp, $h/2 + $stdsp * 3 ,  $imgS,  $imgS, NULL, NULL, 'T', false, 10, '', false, false, 0, true );		
   


        $pdf->write1DBarcode($_REQUEST['id'], 'C128', '', '', '', $fnts  ,0.17, $style);
       $pdf -> setXY(0, $pdf -> getY() + $stdsp );


       $pdf -> setTextColor( 26, 99, 154 );
       $pdf->SetFont( $fnt, 'B', 15 );	
       $pdf-> Cell( $w , '','ecco il tuo codice coupon '.( $cp['sconto_percentuale'] > 0 ? 'del '.$cp['sconto_percentuale'].'% di sconto sul prossimo acquisto' : 'di €'.$cp['sconto_fisso'].' sul prossimo acquisto') , '', 1 ,'C' );
  
 

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

