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
	$dobj = 'comandi cassa barcode';

    // elenco dei prodotti
    $reparti = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM reparti_view' );
  
    //die(print_r($prodotti));

    // creazione del PDF
	$pdf = new TCPDF( 'P', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // inizializzazione del nome del file
	$pdf->SetTitle($dobj.'.pdf');

    // tipografia
	$h		= 297;								// altezza del foglio
	$w		= 210;								// larghezza del foglio
	$ml		= 15;								// margine sinistro
	$mt		= 15;								// margine superiore
	$mr		= 15;								// margine destro
	$fnt		= 'helvetica';							// font base
	$fnts		= 10;								// dimensione del font base
	$stdsp		= 5;								// spaziatore standard
	$lth		= .3;								// spessore linea standard
	$lts		= .15;								// spessore linea sottile
	$rgb0		= array( 0, 0, 0 );						// il nero
	$rgb1		= array( 128, 128, 128 );					// grigio
	$rgb9		= array( 255, 255, 255 );					// il bianco

    // bordi delle celle
	$brdh		= array(
	    'B' => array( 'width' => $lth, 'color' => $rgb0 )
	);
	$brdc		= array(
	    'B' => array( 'width' => $lts, 'color' => $rgb1 )
	);

    // stiel del barcode
    $style = array(
        'position' => 'M',
        'align' => 'C',
        'stretch' => false,
        'fitwidth' => true,
        //'cellfitalign' => 'C',
        'border' => false,
        'hpadding' => '20',
        'vpadding' => 'auto',
        'fgcolor' => array(0,0,0),
        'bgcolor' => false, //array(255,255,255),
        'text' => true,
        'font' => 'helvetica',
        'fontsize' => 9,
        'stretchtext' => 0
    );

    // carattere di base
	$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

    // tipografia derivata
	$lh		= $pdf->getStringHeight( $w, 'a' );				// altezza stimata della linea di testo
	$wport		= $w - ( $ml + $mr );						// larghezza dell'area del testo
	$col		= $wport / 12;							// larghezza colonna base

    // rimozione di header e footer
	$pdf->SetPrintHeader( false );							// se stampare l'header
	$pdf->SetPrintFooter( false );							// se stampare il footer

    // imposto i margini
	$pdf->SetMargins( $ml, $mt, $mr );						// left, top, right
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

   // $pdf->SetY( $pdf->GetY() + $stdsp  );


    $pdf->SetFont( $fnt, 'B', $fnts * 1.5 );
    $pdf->Cell( $col * 12, 0, 'comandi rapidi cassa', 0, 1, 'C' );

    

    $pdf->SetY( $pdf->GetY() + $stdsp  );
    $pdf->SetFont( $fnt, 'B', $fnts * 1.2  );
    $pdf->Cell( $col * 12, 0, 'metodi di pagamento', 0, 0, 'L' );

    // spazio sotto il nome del prodotto
    $pdf->SetY( $pdf->GetY() + $stdsp * 1.5 );

    $pdf->SetFont( $fnt, 'B', $fnts  );
    // tabella di articoli e relativi barcode
    // intestazione tabella di dettaglio
    $pdf->Cell( $col * 7, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 5, 0, 'barcode', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

    $pdf->SetFont( $fnt, '', $fnts  );

    // reparto di default
    $trh = max( $pdf->GetStringHeight( $col * 7, 'stringa', false, true, '', '' ) + 4,  $fnts + 8) ;					// 
           
    $pdf->Cell( $col * 7 , $trh, 'pagamento in contanti', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.PGM.0001', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->Cell( $col * 7 , $trh, 'pagamento elettronico', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.PGM.0002', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->SetY( $pdf->GetY() + $stdsp  );
    $pdf->SetFont( $fnt, 'B', $fnts * 1.2  );
    $pdf->Cell( $col * 12, 0, 'operazioni', 0, 0, 'L' );

    // spazio sotto il nome del prodotto
    $pdf->SetY( $pdf->GetY() + $stdsp * 1.5 );

    $pdf->SetFont( $fnt, 'B', $fnts  );
    // tabella di articoli e relativi barcode
    // intestazione tabella di dettaglio
    $pdf->Cell( $col * 7, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 5, 0, 'barcode', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

    $pdf->SetFont( $fnt, '', $fnts  );

    // reparto di default
    $trh = max( $pdf->GetStringHeight( $col * 7, 'stringa', false, true, '', '' ) + 4,  $fnts + 8) ;					// 
           
    $pdf->Cell( $col * 7 , $trh, 'aggiungi articolo', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.OPZ.0001', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->Cell( $col * 7 , $trh, 'rimuovi articolo', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.OPZ.0002', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->Cell( $col * 7 , $trh, 'elimina articolo', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.OPZ.0004', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->Cell( $col * 7 , $trh, 'stampa documento', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.OPZ.0003', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->SetY( $pdf->GetY() + $stdsp  );
    $pdf->SetFont( $fnt, 'B', $fnts * 1.2  );
    $pdf->Cell( $col * 12, 0, 'tipologie documento', 0, 0, 'L' );

    // spazio sotto il nome del prodotto
    $pdf->SetY( $pdf->GetY() + $stdsp * 1.5 );

    $pdf->SetFont( $fnt, 'B', $fnts  );
    // tabella di articoli e relativi barcode
    // intestazione tabella di dettaglio
    $pdf->Cell( $col * 7, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 5, 0, 'barcode', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

    $pdf->SetFont( $fnt, '', $fnts  );

    // reparto di default
    $trh = max( $pdf->GetStringHeight( $col * 7, 'stringa', false, true, '', '' ) + 4,  $fnts + 8) ;					// 
           
    $pdf->Cell( $col * 7 , $trh, 'scontrino', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.TPL.0009', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->Cell( $col * 7 , $trh, 'fattura', $brdc, 0, 'L', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
 
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.TPL.0001', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    $pdf->SetY( $pdf->GetY() + $stdsp  );
    $pdf->SetFont( $fnt, 'B', $fnts * 1.2  );
    $pdf->Cell( $col * 12, 0, 'reparti', 0, 0, 'L' );

    // spazio sotto il nome del prodotto
    $pdf->SetY( $pdf->GetY() + $stdsp * 1.5 );

    $pdf->SetFont( $fnt, 'B', $fnts  );
    // tabella di articoli e relativi barcode
    // intestazione tabella di dettaglio
    $pdf->Cell( $col * 2, 0, 'nome', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 2, 0, 'aliquota', $brdh, 0, 'C' );			// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 3, 0, 'note', $brdh, 0, 'L' );
    $pdf->Cell( $col * 5, 0, 'barcode', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

    $pdf->SetFont( $fnt, '', $fnts  );

    if( sizeof( $reparti) > 2 ){ $pdf->AddPage(); }

    // reparto di default
    $trh = max( $pdf->GetStringHeight( $col * 3, 'viene preso automaticamente il reparto di default dell\'articolo', false, true, '', '' ) + 4,  $fnts + 8) ;					// 
           
    $pdf->Cell( $col * 2 , $trh, 'default', $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
    $pdf->Cell( $col * 2 , $trh, 'automatica', $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );
    $pdf->MultiCell( $col * 3,$trh , 'viene preso automaticamente il reparto di default dell\'articolo', $brdc, 'L', false, 0,'','', true, 0, false, true, 0, 'M', false );					// w, h, testo, bordo, allineamento, riempimento, newline
    
    $x = $pdf->GetX();
    $y = $pdf->GetY();
   
    $pdf->write1DBarcode( 'CMD.REP.0000', 'C128', '', '', '', $fnts + 12 ,2, $style);
    $pdf->SetXY($x,$y);
    $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

    foreach( $reparti as $r ){
        $trh = max( $pdf->GetStringHeight( $col * 3, $r['note'], false, true, '', '' ) + 4,  $fnts + 8) ;					// 
           
        $pdf->Cell( $col * 2 , $trh, $r['nome'], $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2 , $trh, $r['aliquota_iva'].' %', $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );
        $pdf->MultiCell( $col * 3,$trh , $r['note'], $brdc, 'L', false, 0,'','', true, 0, false, true, 0, 'M', false );					// w, h, testo, bordo, allineamento, riempimento, newline
        

        $x = $pdf->GetX();
        $y = $pdf->GetY();
       
        $pdf->write1DBarcode( 'CMD.REP.000'.$r['id'], 'C128', '', '', '', $fnts + 12 ,2, $style);
        $pdf->SetXY($x,$y);
        $pdf->Cell( $col * 5, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );
    }
    
    /*
    foreach( $prodotti as $p){

        if( isset( $p['articoli'] ) && ! empty( $p['articoli'] ) ){

            // spazio 
	        $pdf->SetY( $pdf->GetY() + $stdsp * 2 );

            // scrivo il nome del prodotto
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 12, 0, $p['__label__'], 0, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

            // spazio sotto il nome del prodotto
	        $pdf->SetY( $pdf->GetY() + $stdsp * 2 );

            // tabella di articoli e relativi barcode
            // intestazione tabella di dettaglio
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 2, 0, 'nome', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 6, 0, 'barcode', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

            // tabella di dettaglio
            $pdf->SetFont( $fnt, '', $fnts );	
            		


            // font, stile, dimensione
            foreach( $p['articoli'] as $articolo ) {

                $trh = max( $pdf->GetStringHeight( $col * 4, $articolo['testo'], false, true, '', '' ) + 4,  $fnts + 8) ;					// 
           
                $pdf->Cell( $col * 2 , $trh, $articolo['nome'], $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->MultiCell( $col * 4,$trh , $articolo['testo'], $brdc, 'L', false, 0,'','', true, 0, false, true, 0, 'M', false );					// w, h, testo, bordo, allineamento, riempimento, newline
                

                $x = $pdf->GetX();
                $y = $pdf->GetY();
               
                $pdf->write1DBarcode($articolo['id'], 'C128', '', '', '', $fnts + 12 ,2, $style);
                $pdf->SetXY($x,$y);
                $pdf->Cell( $col * 6, $trh, '', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );

            }

        }

    }
*/
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

