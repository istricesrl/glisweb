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
	$dobj = 'prova stampa pdf assistenza';

    // elenco dei prodotti
    $prodotti = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM prodotti_view' );
  
   // per ogni prodotto recupero i suoi articoli


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
        'fontsize' => 10,
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
    
    //spazio
    //$pdf->SetY( $pdf->GetY() + $stdsp * 2 );
    //$pdf->SetY( $pdf->GetY() + $stdsp * 2 );

    function titolo($testo, $pdf, $fnt, $fnts=12){
        //global $pdf, $fnt, $fnts;
        $pdf->SetFont( $fnt, 'B', $fnts);
        $pdf->Cell(0, 5, $testo, 0, 1, 'L');

    };
    
    function sottotitolo($testo,$pdf, $fnt, $fnts=8){
        //global $pdf, $fnt, $fnts;
        $pdf->SetFont( $fnt, 'B', $fnts );
        $pdf->Cell(0, 5, $testo, 0, 1, 'L');
    }
    
    
    function trecella($testo1, $testo2, $testo3, $col1=4, $col2 = 4, $col3 = 4, $pdf, $fnt, $fnts=8, $col, $lh){
        global $pdf, $fnt, $fnts, $col, $lh;
        $pdf->SetFont( $fnt, '', $fnts);						
        $pdf->MultiCell( $col * $col1, $lh, $testo1, '', 'L', false, 0 );
        $pdf->MultiCell( $col * $col2, $lh, $testo2, '', 'C', false, 0 );
        $pdf->MultiCell( $col * $col3, $lh, $testo3, '', 'R', false, 1 );
    };
    
    
    function riga($testo, $pdf, $fnt, $fnts=8){
        //global $pdf, $fnt, $fnts;
        $pdf->SetFont( $fnt, '', $fnts );
        $pdf->Cell(0, 5, $testo, 0, 1, 'L');
    }
    
    function spazio($dim=2){
        global $pdf, $stdsp;
        $pdf->SetY( $pdf->GetY() + $stdsp * $dim );
    };
    
    
    function bicella($testo1, $testo2, $col1=7, $col2=5, $pdf, $fnt, $fnts=8, $col, $lh){
        //global $pdf, $fnt, $fnts, $col, $lh;
        $pdf->SetFont( $fnt, '', $fnts );
        $pdf->MultiCell( $col * $col1, $lh, $testo1, '', 'L', false, 0 );
        $pdf->MultiCell( $col * $col2, $lh, $testo2, '', 'C', false, 0 );
        // $pdf->MultiCell( $col * $col3, $lh, '', 'R', false, 0);
    }
    
    
    titolo("rapporto di intervento di assistenza tecnica",$pdf, $fnt, $fnts);
    
    
    sottotitolo("1.dati cliente", $pdf, $fnt, $fnt);
    // treriga("città", "prov", "cap");
    riga("nome e cognome o denominazione",$pdf, $fnt, $fnts);
    //mysqlQuery();
    spazio();
    riga("indirizzo  sede intervento",$pdf, $fnt, $fnts);
    spazio();
    trecella("richiesta ricevuta da", "in data","alle ore",$col1=4,$col2 = 4, $col3 = 4, $pdf, $fnt, $fnts, $col, $lh );
    spazio();
    trecella("città", "prov", "cap", 8, 1, 3, $col1=4,$col2 = 4, $col3 = 4, $pdf, $fnt, $fnts, $col, $lh);
    //qui inserimento della query
    //trecella();
    spazio();
    trecella("codice fiscale", "partita IVA", "codice", $col1=4,$col2 = 4, $col3 = 4, $pdf, $fnt, $fnts, $col, $lh);
    spazio();
    bicella("telefono", "email o PEC",$col1=7, $col2=5, $pdf, $fnt, $fnts, $col, $lh);
    spazio();
    riga("codice contratto",$pdf, $fnt, $fnts);
    spazio();
    sottotitolo("2.descrizione del problema", $pdf, $fnt, $fnts);
    spazio(4);
    sottotitolo("3.appuntamento", $pdf, $fnt, $fnts);
    
    
    
    
    
    /*
       //tentativo di far passare i parametri $pdf, $fnt (..) 
        function pdfTitolo($testo, $pdf2, $fnt2, $fnts2, $font='B', $size=12){
        $pdf2->SetFont( $fnt2, $font, $fnts2=$size );
        $pdf2->Cell(0, 5, $testo, 0, 1, 'L');
        // return $pdf2
        }
        pdfTitolo("test titolo", $pdf, $fnt, $fnts);
        */
    
    //tentativo sottotitolo
    /*function pdfSottoTitolo($testo, $pdf2, $fnt2, $fnts2, $font='B', $size=8){
        $pdf2->SetFont( $fnt2, $font, $fnts2=$size );
        $pdf2->Cell(0, 5, $testo, 0, 1, 'L');
    }
    
    pdfSottoTitolo("prova sottotitolo", $pdf, $fnt, $fnts);
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