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
	$dobj = 'etichette ritiro';

   // $logo = anagraficaGetLogo(2);

    // elenco dei prodotti
    if( isset( $_REQUEST['__documento__'] ) ){
        $righe = mysqlQuery( $cf['mysql']['connection'], 'SELECT documenti_articoli_view.*, matricole.serial_number, matricole.nome AS matricola FROM documenti_articoli_view LEFT JOIN matricole ON matricole.id = documenti_articoli_view.matricola WHERE documenti_articoli_view.id_documento = ?', array( array( 's' => $_REQUEST['__documento__'] ) ) );
        $documento = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT documenti_view.*, todo_completa_view.nome AS nome_todo, todo_completa_view.testo AS testo_todo, todo_completa_view.progetto AS progetto_todo FROM documenti_view LEFT JOIN todo_completa_view ON todo_completa_view.id = documenti_view.id_todo WHERE documenti_view.id = ? ', array( array( 's' => $_REQUEST['__documento__']  ) ) );

    
        if( empty( $righe ) ){
            die( print_r( "nessun hardware da stampare", true ) );
        }
    } 


  
 //   die(print_r($righe));
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
$info['style']['page']['orentation'] = 'L';
// prelievo dati dal database
$info['doc']['title'] = $dobj;
// creazione del PDF
$pdf = pdfInit( $info );
    // creazione del PDF
	//$pdf = new TCPDF( 'L', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    // inizializzazione del nome del file


    // tipografia
	$w		    = 297;								// altezza del foglio
	$h		    = 210;								// larghezza del foglio
	$ml		    = 21;								// margine sinistro
	$mt		    = 8;								// margine superiore
	$mr		    = 21;								// margine destro
	$fnt		= 'helvetica';							// font base
	$fnts		= 10;								// dimensione del font base
    $fntt		= 15;								// dimensione del font titolo
	$stdsp		= 5;								// spaziatore standard
    $litsp      = 3;
    $lth		= .3;								// spessore linea standard
	$lts		= .15;								// spessore linea sottile
	$rgb0		= array( 0, 0, 0 );						// il nero
	$rgb1		= array( 128, 128, 128 );					// grigio
	$rgb9		= array( 255, 255, 255 );					// il bianco
    $rgBlu      = array( 26, 99, 154 );
    $hBox       = 95;
    $wBox       = 50;
    $hBarr      = 15;

    $startX = $ml;
    $startY = $mt;
    



    // bordi delle celle
	$brdh		= array(
	    'B' => array( 'width' => $lth, 'color' => $rgb0 )
	);
	$brdc		= array(
	    'B' => array( 'width' => $lts, 'color' => $rgb1 )
	);

    // stiel del barcode
    $style = array(
       
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
//	$pdf->AddPage('L');								// richiesto perché si è disattivato l'automatismo

    $x = $startX;
    $y = $startY;
    
    // scalamento inzio stampa per rispario carta
    if( isset( $_REQUEST['__start__'] ) && $_REQUEST['__start__'] > 0 ){

       // $y = ( $_REQUEST['__start__'] % 2 == 0 ? $startY : $startY + $hBox  );
        //$x =  $_REQUEST['__start__']/2  * $wBox;

        if( $_REQUEST['__start__'] % 2 == 0 ){
            $y = $startY;
            $x +=  $_REQUEST['__start__']/2  * $wBox;
        } else {
            $y = $startY + $hBox;
            $x =  $_REQUEST['__start__']/2  * $wBox;
        }
    } 



   // $pdf->SetLineStyle(array('width' => 0.000000015, 'color' => array(0, 0, 0)));
    foreach( $righe as $r){

        // angoli di stampa
        // angolo in alto a sinistra

       
        // rettangolo guida
        //$pdf-> Rect( $x, $y, $wBox, $hBox );	
        //$pdf-> Rect( $x , $y + $hBox , $wBox, $hBox );
        $pdf -> setXY( $x + $litsp, $y + $litsp );
        
        // carattere di base
	    $pdf->SetFont( $fnt, 'B', $fntt );						// font, stile, dimensione
        $pdf->MultiCell( $wBox - $stdsp, '', $documento['cliente'], '', 'L', '', '1', '', '', true);


    
        $pdf->SetFont( $fnt, '', $fntt / 2);		
        $pdf -> setXY( $x + $litsp, $pdf -> getY()  );
        $pdf-> Cell($wBox, '','ritirato il '.date('d/m/Y', $documento['timestamp_inserimento'] ),'',1, 'L' ); 
    
        $pdf -> Line( $x + $litsp, $pdf -> getY() + $litsp, $x + $wBox - $litsp , $pdf -> getY() + $litsp );

        $pdf->SetFont( $fnt, '', $fnts );				
        $pdf -> setXY( $x + $litsp, $pdf -> getY() + $stdsp );
        $pdf->MultiCell( $wBox - $stdsp, '', $r['serial_number'], '', 'L', '');
        $pdf -> setXY( $x + $litsp, $pdf -> getY() );
        $pdf->SetFont( $fnt, 'B', $fnts );
        $pdf->MultiCell( $wBox - $stdsp, '', $r['matricola'], '', 'L', '');
        $pdf -> setXY( $x + $litsp, $pdf -> getY() );
        $pdf->SetFont( $fnt, '', $fnts );
        $pdf->MultiCell( $wBox - $stdsp, '', $r['nome'], '', 'L', '', 1);

        if( !empty($r['label_matricola']) ){
            $pdf -> setXY( $x, $pdf -> getY() + $litsp );
            $pdf->write1DBarcode($r['label_matricola'], 'C128', '', '', '', $hBarr ,0.267, $style, 'N');
        }

        $pdf -> Line( $x + $litsp, $pdf -> getY() + $litsp, $x + $wBox - $litsp , $pdf -> getY() + $litsp );

        $pdf -> setXY( $x + $litsp, $pdf -> getY() + $stdsp );
        $pdf->SetFont( $fnt, 'B', $fnts );		
        $pdf->MultiCell( $wBox - $stdsp, '', $documento['nome_todo'], '', 'L', '', 1);
        $pdf->SetFont( $fnt, '', $fnts-2 );		
        $pdf -> setXY( $x + $litsp, $pdf -> getY() );

        $remSp = ( $startX + $hBox ) - $pdf -> getY() - $hBarr*2.5;
        $pdf->MultiCell( $wBox - $stdsp, $remSp, $documento['testo_todo'].'', '', 'L', '', 1,'','',true,'','','',  $remSp);
// MultiCell($w, $h, $txt, $border=0, $align='J', $fill=0, $ln=1, $x='', $y='', $reseth=true, $stretch=0, $ishtml=false, $autopadding=true, $maxh=0)

        $pdf -> setXY( $x, $y + $hBox - $hBarr - $stdsp);
        $pdf->write1DBarcode( 'TODO.'.str_pad( $documento['id_todo'],10,"0", STR_PAD_LEFT), 'C128', '', '', '',$hBarr  ,0.285, $style, 'N');

       // if( ($i + 1) % 3 == 0){
         /*  OLD OK
         if( ( $x + $wBox * 2 ) > $w  ) {   
            if( $y +  $hBox * 2  > $h) { 
                $pdf -> AddPage();
                $y = $startY ;
            } else {
                $y += $hBox + $litsp; 
            }
            $x = $startX;
        } else {
            $x +=  $wBox;
        }
        */
        
         if( ( $y + $hBox * 2 ) > $h  ) {   
           if( $x +  $wBox * 2  > $w) { 
                $pdf -> AddPage('L');
                $x = $startX ;
            } else {
                $x += $wBox ; 
            }
            $y = $startY;
        } else {
            $y +=  $hBox;
        }
    }




    if( isset( $_REQUEST['__all__'] ) &&  $_REQUEST['__all__'] == 1 ){
        $pdf->AddPage('P');					// portrait, millimetri, A4 (x->210 y->297)

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
    
    pdfSetRelativeY( $pdf, 10);
    pdfSetRelativeX( $pdf, 15);
    pdfFormCellTitle( $pdf, $info, 'dati dell\'assistenza' );
    pdfSetRelativeY( $pdf, 1);
    
    if( isset( $documento ) ){
        pdfSetRelativeX( $pdf, 15);
        pdfFormCellLabel( $pdf, $info, $documento['cliente'] );
        pdfSetRelativeY( $pdf, 5);
        pdfSetRelativeX( $pdf, 15);
        pdfFormCellLabel( $pdf, $info, $documento['progetto_todo'] );
        pdfSetRelativeY( $pdf, 5);
        pdfSetRelativeX( $pdf, 15);
        $pdf->write1DBarcode('TODO.'.str_pad( $documento['id_todo'] ,11,"0", STR_PAD_LEFT), 'C128', '', '', '', 15 ,0.17, $style);
        pdfSetRelativeY( $pdf, 10);
    
    }
    
        // tabella attivita
        $margin = 15;
        $w = $pdf->getPageWidth();
        $col = ( $w - 30 )/12;
        pdfSetRelativeX( $pdf, 15);
        pdfSetFontStyle( $pdf, $info['style']['text']['small_bold'] );
            // intestazione tabella di dettaglio
        //$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 6, $info['form']['bar']['height'], 'descrizione',  $info['cell']['thick'], 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 5, $info['form']['bar']['height'], 'matricola',  $info['cell']['thick'], 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col, $info['form']['bar']['height'], 'quantità',  $info['cell']['thick'], 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
        
        
        $i = 1;
    
        if( isset( $righe ) && count( $righe) > 0 ){
    
            foreach( $righe as $r){
                pdfSetRelativeX( $pdf, 15);
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
    pdfSetRelativeX( $pdf, 15);
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
    $pdf->AddPage('P');
    
    
    
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
    
    pdfSetRelativeY( $pdf, 10);
    pdfSetRelativeX( $pdf, 15);
    pdfFormCellTitle( $pdf, $info, 'dati dell\'assistenza' );
    pdfSetRelativeY( $pdf, 1);
    
    if( isset( $documento ) ){
        pdfSetRelativeX( $pdf, 15);
        pdfFormCellLabel( $pdf, $info, $documento['cliente'] );
        pdfSetRelativeY( $pdf, 5);
        pdfSetRelativeX( $pdf, 15);
        pdfFormCellLabel( $pdf, $info, $documento['progetto_todo'] );
        pdfSetRelativeY( $pdf, 5);
        pdfSetRelativeX( $pdf, 15);
        $pdf->write1DBarcode('TODO.'.str_pad( $documento['id_todo'] ,11,"0", STR_PAD_LEFT), 'C128', '', '', '', 15 ,0.17, $style);
        pdfSetRelativeY( $pdf, 10);
    
    }
    
        // tabella attivita
        $margin = 15;
        $w = $pdf->getPageWidth();
        $col = ( $w - 30 )/12;
        pdfSetRelativeX( $pdf, 15);
        pdfSetFontStyle( $pdf, $info['style']['text']['small_bold'] );
            // intestazione tabella di dettaglio
        //$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 6, $info['form']['bar']['height'], 'descrizione',  $info['cell']['thick'], 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 5, $info['form']['bar']['height'], 'matricola',  $info['cell']['thick'], 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col, $info['form']['bar']['height'], 'quantità',  $info['cell']['thick'], 1, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        pdfSetFontStyle( $pdf, $info['style']['text']['default'] );
        
        
        $i = 1;
    
        if( isset( $righe ) && count( $righe) > 0 ){
    
            foreach( $righe as $r){
                pdfSetRelativeX( $pdf, 15);
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
    pdfSetRelativeX( $pdf, 15);
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
    }

      // output
/*	if( isset( $_REQUEST['d'] ) ) {
	    $pdf->Output($dobj.'.pdf' , 'D' );					// invia l'output al browser per il download diretto
	} elseif( isset( $_REQUEST['f'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'I' );				// salva il file localmente
	} elseif( isset( $_REQUEST['fi'] ) ) {
	    $pdf->Output( $dobj.'.pdf', 'FI' );				// salva il file localmente e invia l'output al browser
	} else {
	    $pdf->Output($dobj.'.pdf');								// invia l'output al browser
	}
*/
 // output
 $pdf->Output($info['doc']['title'].'.pdf' );								// invia l'output al browser
