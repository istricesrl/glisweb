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
    if( isset( $_REQUEST['prodotto'] ) ){
        $articoli = mysqlQuery( $cf['mysql']['connection'], 'SELECT metadati.testo AS meta, articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto, contenuti_prodotto.testo AS testo_prodotto,  contenuti.h1, contenuti.testo, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto LEFT JOIN metadati ON metadati.id_articolo = articoli_view.id AND metadati.id_lingua = 1 AND metadati.nome = "utilizzo" WHERE articoli_view.id_prodotto = ?', array( array( 's' => $_REQUEST['prodotto'] ) ) );
    } elseif( isset( $_REQUEST['articolo'] ) ){
        $articoli = mysqlQuery( $cf['mysql']['connection'], 'SELECT metadati.testo AS meta, articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto, contenuti_prodotto.testo AS testo_prodotto,  contenuti.h1, contenuti.testo, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto  LEFT JOIN metadati ON metadati.id_articolo = articoli_view.id AND metadati.id_lingua = 1 AND metadati.nome = "utilizzo" WHERE articoli_view.id = ?', array( array( 's' => $_REQUEST['articolo'] ) ) );
    } else {
        $articoli  = mysqlQuery( $cf['mysql']['connection'], 'SELECT metadati.testo AS meta, articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto,  contenuti_prodotto.testo AS testo_prodotto, contenuti.h1, contenuti.testo, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto  LEFT JOIN metadati ON metadati.id_articolo = articoli_view.id AND metadati.id_lingua = 1 AND metadati.nome = "utilizzo"');
    }


   
    if( count( $articoli ) > 0 ){

        foreach(  $articoli as &$a ){
            $a['caratteristiche'] =  mysqlQuery( $cf['mysql']['connection'], 'SELECT caratteristica FROM articoli_caratteristiche_view  WHERE  id_articolo = ? UNION SELECT caratteristica FROM prodotti_caratteristiche_view WHERE id_prodotto = ?', array( array( 's' => $a['id'] ), array( 's' => $a['id_prodotto'] ) ) );
 
            $img = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT path FROM immagini '.
                'WHERE immagini.id_ruolo = 16 AND immagini.id_prodotto = ? ORDER BY ordine '.
                'LIMIT 1',
                array(
                    array( 's' => $a['id_prodotto'] )
                )
                );
             //  print_r( fullPath( $img ));
            // full path
            $a['immagine'] =  fullPath( $img );
        }
 
    } else {

        die( print_r( 'articoli assenti', true ) );

    }



    

    // creazione del PDF
	$pdf = new TCPDF( 'P', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // inizializzazione del nome del file
	$pdf->SetTitle($dobj.'.pdf');

    // tipografia
	$w		= 297;								// altezza del foglio
	$h		= 210;								// larghezza del foglio
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
    $hBox       = $h;
    $wBox       = $w / 2;
    $bluSpace      = 55;

    $startX = 10;
    $startY = 10;
    
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
	$pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

    $x = $startX;
    $y = $startY;
    
    //print_r($articoli);
// convert TTF font to TCPDF format and store it on the fonts folder
//$fontname = TCPDF_FONTS::addTTFfont('var/www/html/glisweb/var/contenuti/AllertaStencil-Regular.ttf', 'TrueTypeUnicode');

// use the font
//$pdf->SetFont($fontname, '', 14, '', false);

    for( $i = 0; $i < count($articoli); $i++){

        $pdf->setXY( $ml + $wBox / 3 * 2 , $mt - $stdsp );
        $pdf->StartTransform();

        $pdf->Rotate(180);
        

        $pdf->write1DBarcode($articoli[$i]['id'], 'C128', '', '', '', $fnts  ,0.17, $style);
        $pdf -> setTextColor( 26, 99, 154 );
        if( !empty($articoli[$i]['codice_produttore']) ){
            $pdf->setXY($mr * 3 + 10, $pdf->getY() + $stdsp  );
            $pdf-> Cell($wBox, '','codice produttore: '.$articoli[$i]['codice_produttore'],'',1, 'C' ); 
        }

        $pdf->setXY($mr * 3 + 7 , $pdf->getY() + $stdsp  );
 //       $pdf->setXY(10 , 10 );
        $pdf->SetFont( $fnt, 'B', 10 );	
        $pdf-> Cell($wBox, '',date('d/m/Y H:i'),'',1, 'R' ); 

        // Stop Transformation
       $pdf->StopTransform();


        $pdf->SetLineStyle(array('width' => 0.000000015, 'color' => array(200, 200, 200)));
        // rettangolo guida
        $pdf-> Rect( $ml, $mt, $wBox, $hBox );	
        $pdf->Line($ml, $mt, $ml, 0);
        $pdf->Line($ml + $wBox, $mt, $ml + $wBox, 0);
       // $pdf->Line($x , $y - $litsp , $x , $y - $stdsp);
        // rettangolo blu
        $pdf-> Rect( $ml / 2, $mt, $wBox + $stdsp * 4 , $bluSpace, 'F', '',  array(26, 99, 154));

        $pdf->SetFont($fnt, 'B', $fntt);
  
        $pdf -> setXY( $x + $ml, $mt + $startY );
        $pdf -> setTextColor( 255, 255, 255 );
        $pdf-> MultiCell( ($wBox - $ml ), $fntt ,ltrim( rtrim( strtoupper ($articoli[$i]['meta']))), '', 'L', '' );
        #MultiCell(w, h, txt, border = 0, align = 'J', fill = 0, ln = 1, x = '', y = '', reseth = true, stretch = 0, ishtml = false, autopadding = true, maxh = 0) ⇒ Object

        $pdf -> setXY( $x + $ml, $pdf->getY() + $stdsp * 2  );
        $pdf -> setTextColor( 26, 99, 154 );
        $pdf->SetFont($fnt, '', $fntm);
        $pdf-> MultiCell( ($wBox - $ml ) / 2, '' ,ltrim( rtrim( strtoupper ($articoli[$i]['h1_prodotto'].' '. $articoli[$i]['h1'])))."\n".ltrim( rtrim( strip_tags( $articoli[$i]['testo_prodotto'].' '. $articoli[$i]['testo']))), '', 'L', '' );
     
        $imgS = $wBox / 2;
        $pdf->image( $articoli[$i]['immagine'], $ml + $stdsp*2 + ($wBox - $ml ) / 2, $bluSpace + $mt + $stdsp,  $imgS,  $imgS, NULL, NULL, 'T', false, 10, '', false, false, 0, true );		
   

        $pdf -> setXY( $x + $ml, $mt + $hBox / 2 + $litsp);
        $pdf->SetFillColor(  26, 99, 154 );

        $pdf -> setTextColor( 255, 255, 255 );
        $pdf->SetFont($fnt, 'B', $fnts);
        $pdf->setCellPadding( 1 );
        $pdf -> Cell( $wBox / 3 * 2, '', 'CARATTERISTICHE', '', 1,  'C',1 );
        #Cell(w, h = 0, txt = '', border = 0, ln = 0, align = '', fill = 0, link = nil, stretch = 0, ignore_min_height = false, calign = 'T', valign = 'M') 
      
        $pdf -> setXY( $x + $ml, $pdf -> getY() + $litsp  );
        $pdf -> setTextColor( 26, 99, 154 );
        $pdf->SetFont($fnt, '', $fntm);

        $pdf->setCellPadding( $litsp );

        $pdf->SetFillColor(  255, 255, 255 );
        foreach( $articoli[$i]['caratteristiche'] as $meta ){
            $pdf -> Cell( $wBox / 3 * 2, $fntm/2 + $litsp, strtoupper ($meta['caratteristica']), $brdb, 1,  'L', 1 );
            $pdf -> setX( $x + $ml);
        }


           // x, y, w, h, type, link, align, resize
       // if( ($i + 1) % 3 == 0){

        $pdf -> setXY( $wBox/2 + $ml - $litsp, $hBox + $stdsp );
        $pdf-> SetFont( $fnt, '', $fnts );	
        $pdf-> Cell($wBox /2, '','PREZZO PC STOP ','','', 'R' );
        $pdf-> setXY( $wBox/2 + $ml - $litsp, $pdf -> getY() + $stdsp );
        $pdf-> SetFont( $fnt, 'B', $fntt );	
        $pdf-> Cell( $wBox /2 , '','€ '.number_format( ( $articoli[$i]['prezzo'] * ( 100 + $articoli[$i]['aliquota'] ) / 100 ), 2, ',', '.' ), '', '' ,'R' );
        $pdf-> SetFont( $fnt, '', $fntl );	
        $pdf-> setXY( $wBox/2 + $ml - $litsp, $pdf -> getY() + $fnts + $stdsp  );
        $pdf-> Cell($wBox /2, '','prezzo (compreso di '.$articoli[$i]['descrizione_iva'].')','',1, 'R' );


            $pdf -> AddPage();
            $y = $startY ;
            $x = $startX;
        


       

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

