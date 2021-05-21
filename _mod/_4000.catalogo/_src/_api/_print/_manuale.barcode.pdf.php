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
	$dobj = 'manuale barcode';

    // elenco dei prodotti
    $prodotti = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM prodotti_view' );
  
   // per ogni prodotto recupero i suoi articoli
    if( $prodotti ){

        foreach($prodotti as &$p){

            $p['articoli'] =  mysqlQuery(     $cf['mysql']['connection'], 
                                                'SELECT * FROM articoli_view WHERE id_prodotto = ?',
                                                array( array('s' => $p['id'] ) ) );

        }
    }

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
	$pdf->SetAutoPageBreak( false );						// se aggiungere automaticamente pagine

    // set image scale factor
	$pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );					// fattore di conversione da pixel a millimetri

    // aggiunta di una pagina
	$pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

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
