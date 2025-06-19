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
	$dobj = 'cartellini articoli';

   // $logo = anagraficaGetLogo(2);

    // elenco dei prodotti
    if( isset( $_REQUEST['missione'] ) ){
        $missioni  = mysqlQuery( $cf['mysql']['connection'], 'SELECT documenti.* FROM documenti WHERE id = ? ', array( array('s' => $_REQUEST['missione'] ) ) );
    }

    // creazione del PDF
	$pdf = new TCPDF( 'L', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // inizializzazione del nome del file
	$pdf->SetTitle($dobj.'.pdf');

    // tipografia
	$w		= 297;								// altezza del foglio
	$h		= 210;								// larghezza del foglio
	$ml		= 15;								// margine sinistro
	$mt		= 15;								// margine superiore
	$mr		= 15;								// margine destro
	$fnt		= 'helvetica';							// font base
	$fnts		= 10;								// dimensione del font base
    $fntt		= 18;								// dimensione del font titolo
	$stdsp		= 5;								// spaziatore standard
    $litsp      = 2;
    $lth		= .3;								// spessore linea standard
	$lts		= .15;								// spessore linea sottile
	$rgb0		= array( 0, 0, 0 );						// il nero
	$rgb1		= array( 128, 128, 128 );					// grigio
	$rgb9		= array( 255, 255, 255 );					// il bianco
    $rgBlu      = array( 26, 99, 154 );
    $hBox       = 40;
    $wBox       = 62;


    $startX = ($w - ($wBox  ) * 4) / 2 - 10;
    $startY = ($h - ($hBox  + $stdsp ) * 4) / 2;
    
    // bordi delle celle
	$brdh		= array(
	    'B' => array( 'width' => $lth, 'color' => $rgb0 )
	);
	$brdc		= array(
	    'B' => array( 'width' => $lts, 'color' => $rgb1 )
	);

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
	$pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

    $x = $startX;
    $y = $startY;
    
    //print_r($missioni);
// convert TTF font to TCPDF format and store it on the fonts folder
//$fontname = TCPDF_FONTS::addTTFfont('var/www/html/glisweb/var/contenuti/AllertaStencil-Regular.ttf', 'TrueTypeUnicode');

// use the font
//$pdf->SetFont($fontname, '', 14, '', false);

    for( $i = 0; $i < count($missioni); $i++){

        // angoli di stampa
        // angolo in alto a sinistra
        $pdf->Line($x , $y - $litsp , $x , $y - $stdsp);
        $pdf->Line($x - $litsp, $y   , $x - $stdsp , $y  );

        // angolo in alto a destra
        $pdf->Line($x + $wBox , $y - $litsp , $x + $wBox, $y - $stdsp);
        $pdf->Line($x + $wBox + $litsp, $y  , $x + $wBox  + $stdsp , $y  );

        // angolo in basso a sinistra 
        $pdf->Line($x , $y + ($hBox) + $litsp , $x , $y + ($hBox) +$stdsp);
        $pdf->Line($x - $litsp, $y + ($hBox)  , $x - $stdsp , $y + ($hBox)  );

        // angolo in basso a destra
        $pdf->Line($x + $wBox , $y + ($hBox) + $litsp , $x + $wBox, $y + ($hBox) +$stdsp);
        $pdf->Line($x + $wBox + $litsp, $y + ($hBox)  , $x + $wBox + $stdsp , $y + ($hBox)  );

        // linea di piega sinistra 
        $pdf->Line($x - $litsp, $y + $hBox , $x - $stdsp, $y + $hBox);

        $pdf->SetLineStyle(array('width' => 0.000000015, 'color' => array(200, 200, 200)));

        // rettangolo guida
        $pdf-> Rect( $x, $y, $wBox, $hBox );	

        // rettangolo blu
        // $pdf-> Rect( $x - $stdsp, $y + $hBox, $wBox + $stdsp * 2 , $fnts + $stdsp, 'F', '',  array(26, 99, 154));

        // linea di piega destra 
        $pdf->Line($x + $wBox + $litsp, $y + $hBox , $x + $wBox + $stdsp, $y + $hBox);

        // rettangolo guida
     //   $pdf-> Rect( $x, $y, $wBox, $hBox * 2);	
      //  $pdf-> Rect( $x , $y + $hBox , $wBox, $hBox );

        // trasform
        ///$pdf->setXY( $x + $wBox/2 + 1  , $y + $hBox/2 );
        $pdf->setXY( $x + $wBox/3, $y + $hBox/3 );
        
        // $pdf->StartTransform();

        // $pdf->Rotate(180);
        
        $pdf->write1DBarcode($missioni[$i]['codice'], 'C128', '', '', '', $fnts + 5 ,0.17, $style);
            
        // if( !empty($missioni[$i]['codice_produttore']) ){
        //     $pdf->setXY($x + $wBox/2 + 13 , $pdf->getY() - $fnts - $stdsp  );
        //     $pdf-> Cell($wBox, '','codice produttore: '.$missioni[$i]['codice_produttore'],'',1, 'C' ); 
        // }

        // $pdf->setXY($x + $wBox/2 + 11 , $y + $hBox - 3.5 );
        // $pdf->SetFont( $fnt, 'B', 4 );	
        // $pdf-> Cell($wBox, '',date('d/m/Y H:i'),'',1, 'R' ); 

        // Stop Transformation
        // $pdf->StopTransform();

        // $pdf -> setTextColor( 255, 255, 255 );
        // $pdf-> SetFillColor( 26, 99, 154);
        // Cell(w, h = 0, txt = '', border = 0, ln = 0, align = '', fill = 0, link = nil, stretch = 0, ignore_min_height = false, calign = 'T', valign = 'M') 
      
        //$pdf->setXY( $x - $stdsp/2, $y  + $hBox );
        // $pdf->SetFont( $fnt, 'B', 12 );	    
        // $pdf -> Cell($wBox + $stdsp, $fnts + $stdsp,'   ', '','', '');
        // $pdf->setXY( $x  , $y  + $hBox );

        // $pdf-> MultiCell($wBox , $fnts + $stdsp, $missioni[$i]['h1_prodotto'].' '. $missioni[$i]['h1'], '', 'C', '1', '1','','','','','','20',$fnts + $stdsp , 'M' );
        // MultiCell(w, h, txt, border = 0, align = 'J', fill = 0, ln = 1, x = '', y = '', reseth = true, stretch = 0, ishtml = false, autopadding = true, maxh = 0) ⇒ Object

        // $pdf -> setTextColor( 26, 99, 154 );
        // $pdf->setXY( $x + $litsp, $pdf->getY() + $litsp );
        // $pdf->SetFont( $fnt, '', 10 );	
        // $pdf-> MultiCell($wBox - $litsp*2, '', trim(strip_tags($missioni[$i]['abstract_prodotto'])).' '.trim(strip_tags($missioni[$i]['abstract'])), '', 'JL', '', '');

        // $pdf-> setXY( $x - $litsp, $y + $hBox * 2 - 12);
        // $pdf-> SetFont( $fnt, 'B', $fntt );	
        // $pdf-> Cell( $wBox , '','€ '.number_format( ( $missioni[$i]['prezzo'] * ( 100 + $missioni[$i]['aliquota'] ) / 100 ), 2, ',', '.' ), '', 1 ,'R' );
        // $pdf-> SetFont( $fnt, '', 5 );	
        // $pdf-> setX( $x );
        // $pdf-> Cell($wBox - $litsp, '','inclusa '.$missioni[$i]['descrizione_iva'],'',1, 'R' );
      
        // logo
        //$pdf->setXY( $x - $litsp, $y + $hBox * 2 - 12);
        //$pdf-> Image($logo, $x + $litsp , $y + $hBox * 2 - 10, 7, 7);
  

       // if( ($i + 1) % 3 == 0){
         if( ( $x + $wBox * 2 + ( $stdsp * 4  ) ) > $w  ) {   
            if( $y + ( $hBox * 3 ) > $h) { 
                $pdf -> AddPage();
                $y = $startY ;
            } else {
                $y += $hBox * 2 +  $stdsp * 4; 
            }
            $x = $startX;
        
        } else {

            $x +=  $wBox + ( $stdsp * 4  ) ;
            
        }

       

    }

      // output
	if( isset( $_REQUEST['d'] ) ) {
	    $pdf->Output($dobj.'.pdf' , 'D' );					// invia l'output al browser per il download diretto
	} elseif( isset( $_REQUEST['f'] ) ) {
	    $pdf->Output( $dobj.'.pdf','F' );				// salva il file localmente
	} elseif( isset( $_REQUEST['fi'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'FI' );				// salva il file localmente e invia l'output al browser
	} else {
	    $pdf->Output($dobj.'.pdf');								// invia l'output al browser
	}

