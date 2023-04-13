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
        $articoli = mysqlQuery( $cf['mysql']['connection'], 'SELECT articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto,  contenuti.h1, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto  WHERE articoli_view.id_prodotto = ?', array( array( 's' => $_REQUEST['prodotto'] ) ) );
    } elseif( isset( $_REQUEST['articolo'] ) ){
        $articoli = mysqlQuery( $cf['mysql']['connection'], 'SELECT articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto,  contenuti.h1, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto  WHERE articoli_view.id = ?', array( array( 's' => $_REQUEST['articolo'] ) ) );
    } else {
        $articoli  = mysqlQuery( $cf['mysql']['connection'], 'SELECT articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto,  contenuti.h1, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto ');
    }
   
    if( isset( $_REQUEST['start'] ) && isset( $_REQUEST['end'] )  ){
        $q = 'SELECT articoli_view.*, contenuti_prodotto.h1 AS h1_prodotto, contenuti_prodotto.abstract AS abstract_prodotto,  contenuti.h1, contenuti.abstract, prezzi.prezzo, iva.aliquota, iva.descrizione AS descrizione_iva FROM articoli_view LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1 LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id LEFT JOIN iva ON iva.id = prezzi.id_iva LEFT JOIN contenuti AS contenuti_prodotto ON contenuti_prodotto.id_prodotto = articoli_view.id_prodotto LEFT JOIN prodotti ON prodotti.id = articoli_view.id_prodotto ';

        if( !empty( $_REQUEST['start'] ) && !empty( $_REQUEST['end'] ) ){
            $q .= ' WHERE (articoli_view.timestamp_inserimento >= ? OR articoli_view.timestamp_aggiornamento >= ? OR prodotti.timestamp_inserimento >= ? OR prodotti.timestamp_aggiornamento >= ?) AND '.
                    ' (articoli_view.timestamp_inserimento <= ? OR articoli_view.timestamp_aggiornamento <= ? OR prodotti.timestamp_inserimento <= ? OR prodotti.timestamp_aggiornamento <= ?)  ';
            $p = array(array( 's' => $_REQUEST['start'] ),array( 's' => $_REQUEST['start'] ), array( 's' => $_REQUEST['start'] ), array( 's' => $_REQUEST['start'] ),  array( 's' => $_REQUEST['end'] ),array( 's' => $_REQUEST['end'] ), array( 's' => $_REQUEST['end'] ), array( 's' => $_REQUEST['end'] )        );
            $articoli  = mysqlQuery( $cf['mysql']['connection'], $q, $p);
    
        } elseif( !empty( $_REQUEST['start'] ) && empty( $_REQUEST['end'] ) ){
            $q .= ' WHERE (articoli_view.timestamp_inserimento >= ? OR articoli_view.timestamp_aggiornamento >= ? OR prodotti.timestamp_inserimento >= ? OR prodotti.timestamp_aggiornamento >= ?)  ';
            $p = array(array( 's' => $_REQUEST['start'] ),array( 's' => $_REQUEST['start'] ), array( 's' => $_REQUEST['start'] ), array( 's' => $_REQUEST['start'] )  );
            $articoli  = mysqlQuery( $cf['mysql']['connection'], $q, $p);
        } else {
            $q .= ' WHERE (articoli_view.timestamp_inserimento <= ? OR articoli_view.timestamp_aggiornamento <= ? OR prodotti.timestamp_inserimento <= ? OR prodotti.timestamp_aggiornamento <= ?)  ';
            $p = array( array( 's' => $_REQUEST['end'] ),array( 's' => $_REQUEST['end'] ), array( 's' => $_REQUEST['end'] ), array( 's' => $_REQUEST['end'] )        );
            $articoli  = mysqlQuery( $cf['mysql']['connection'], $q, $p);
        }
       
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
    
    //print_r($articoli);
// convert TTF font to TCPDF format and store it on the fonts folder
//$fontname = TCPDF_FONTS::addTTFfont('var/www/html/glisweb/var/contenuti/AllertaStencil-Regular.ttf', 'TrueTypeUnicode');

// use the font
//$pdf->SetFont($fontname, '', 14, '', false);

    for( $i = 0; $i < count($articoli); $i++){

        // angoli di stampa
        // angolo in alto a sinistra
        $pdf->Line($x , $y - $litsp , $x , $y - $stdsp);
        $pdf->Line($x - $litsp, $y   , $x - $stdsp , $y  );

        // angolo in alto a destra
        $pdf->Line($x + $wBox , $y - $litsp , $x + $wBox, $y - $stdsp);
        $pdf->Line($x + $wBox + $litsp, $y  , $x + $wBox  + $stdsp , $y  );

        // angolo in basso a sinistra 
        $pdf->Line($x , $y + ($hBox*2) + $litsp , $x , $y + ($hBox*2) +$stdsp);
        $pdf->Line($x - $litsp, $y + ($hBox*2)  , $x - $stdsp , $y + ($hBox*2)  );

        // angolo in basso a destra
        $pdf->Line($x + $wBox , $y + ($hBox*2) + $litsp , $x + $wBox, $y + ($hBox*2) +$stdsp);
        $pdf->Line($x + $wBox + $litsp, $y + ($hBox*2)  , $x + $wBox + $stdsp , $y + ($hBox*2)  );

        // linea di piega sinistra 
        $pdf->Line($x - $litsp, $y + $hBox , $x - $stdsp, $y + $hBox);

        $pdf->SetLineStyle(array('width' => 0.000000015, 'color' => array(200, 200, 200)));
        // rettangolo guida
        $pdf-> Rect( $x, $y, $wBox, $hBox * 2);	

        // rettangolo blu
        $pdf-> Rect( $x - $stdsp, $y + $hBox, $wBox + $stdsp * 2 , $fnts + $stdsp, 'F', '',  array(26, 99, 154));

        // linea di piega destra 
        $pdf->Line($x + $wBox + $litsp, $y + $hBox , $x + $wBox + $stdsp, $y + $hBox);



        // rettangolo guida
     //   $pdf-> Rect( $x, $y, $wBox, $hBox * 2);	
      //  $pdf-> Rect( $x , $y + $hBox , $wBox, $hBox );

        // trasform
        ///$pdf->setXY( $x + $wBox/2 + 1  , $y + $hBox/2 );
        $pdf->setXY( $x + $wBox/2 + 22, $y + $hBox/2 );
        
        $pdf->StartTransform();

        $pdf->Rotate(180);
        
        $pdf->write1DBarcode($articoli[$i]['id'], 'C128', '', '', '', $fnts + 5 ,0.17, $style);
            
        if( !empty($articoli[$i]['codice_produttore']) ){
            $pdf->setXY($x + $wBox/2 + 13 , $pdf->getY() - $fnts - $stdsp  );
            $pdf-> Cell($wBox, '','codice produttore: '.$articoli[$i]['codice_produttore'],'',1, 'C' ); 
        }

        $pdf->setXY($x + $wBox/2 + 11 , $y + $hBox - 3.5 );
        $pdf->SetFont( $fnt, 'B', 4 );	
        $pdf-> Cell($wBox, '',date('d/m/Y H:i'),'',1, 'R' ); 

        // Stop Transformation
        $pdf->StopTransform();

        $pdf -> setTextColor( 255, 255, 255 );
       // $pdf-> SetFillColor( 26, 99, 154);
        #Cell(w, h = 0, txt = '', border = 0, ln = 0, align = '', fill = 0, link = nil, stretch = 0, ignore_min_height = false, calign = 'T', valign = 'M') 
      
        //$pdf->setXY( $x - $stdsp/2, $y  + $hBox );
        $pdf->SetFont( $fnt, 'B', 12 );	    
      //  $pdf -> Cell($wBox + $stdsp, $fnts + $stdsp,'   ', '','', '');
        $pdf->setXY( $x  , $y  + $hBox );

        $pdf-> MultiCell($wBox , $fnts + $stdsp, $articoli[$i]['h1_prodotto'].' '. $articoli[$i]['h1'], '', 'C', '1', '1','','','','','','20',$fnts + $stdsp , 'M' );
#MultiCell(w, h, txt, border = 0, align = 'J', fill = 0, ln = 1, x = '', y = '', reseth = true, stretch = 0, ishtml = false, autopadding = true, maxh = 0) ⇒ Object

        $pdf -> setTextColor( 26, 99, 154 );
        $pdf->setXY( $x + $litsp, $pdf->getY() + $litsp );
        $pdf->SetFont( $fnt, '', 10 );	
        $pdf-> MultiCell($wBox - $litsp*2, '', trim(strip_tags($articoli[$i]['abstract_prodotto'])).' '.trim(strip_tags($articoli[$i]['abstract'])), '', 'JL', '', '');

        $pdf-> setXY( $x - $litsp, $y + $hBox * 2 - 12);
        $pdf-> SetFont( $fnt, 'B', $fntt );	
        $pdf-> Cell( $wBox , '','€ '.number_format( ( $articoli[$i]['prezzo'] * ( 100 + $articoli[$i]['aliquota'] ) / 100 ), 2, ',', '.' ), '', 1 ,'R' );
        $pdf-> SetFont( $fnt, '', 5 );	
        $pdf-> setX( $x );
        $pdf-> Cell($wBox - $litsp, '','inclusa '.$articoli[$i]['descrizione_iva'],'',1, 'R' );
      
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
	    $pdf->Output( $dobj.'.pdf', 'I' );				// salva il file localmente
	} elseif( isset( $_REQUEST['fi'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'FI' );				// salva il file localmente e invia l'output al browser
	} else {
	    $pdf->Output($dobj.'.pdf');								// invia l'output al browser
	}

