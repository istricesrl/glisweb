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
	$cellw		= $wport / 45;							// larghezza cella base

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

    /**
     * scrive una cella di titolo
     * 
     * NOTA:
     * void Cell (float $w, [float $h = 0], [string $txt = ''], [mixed $border = 0], [int $ln = 0], [string $align = ''], [int $fill = 0], [mixed $link = ''], [int $stretch = 0])
     * float $w: Cell width. If 0, the cell extends up to the right margin.
     * float $h: Cell height. Default value: 0.
     * string $txt: String to print. Default value: empty string.
     * mixed $border: Indicates if borders must be drawn around the cell. The value can be either a number:
     *  0: no border (default)
     *  1: frame
     * or a string containing some or all of the following characters (in any order):
     *  L: left
     *  T: top
     *  R: right
     *  B: bottom
     * int $ln: Indicates where the current position should go after the call. Possible values are:
     *  0: to the right (or left for RTL languages)
     *  1: to the beginning of the next line
     *  2: below
     * string $align: Allows to center or align the text. Possible values are:
     *  L or empty string: left align (default value)
     *  C: center
     *  R: right align
     *  J: justify
     * int $fill: Indicates if the cell background must be painted (1) or transparent (0). Default value: 0.
     * mixed $link: URL or identifier returned by AddLink().
     * int $stretch: stretch carachter mode:
     *  0 = disabled
     *  1 = horizontal scaling only if necessary
     *  2 = forced horizontal scaling
     *  3 = character spacing only if necessary
     *  4 = forced character spacing
     * 
     */
    function pdfTitolo( $pdf, $testo, $fFamily = 'helvetica', $fSize = 12, $fWeight = 'B', $border = 0, $newline = 1, $align = 'L' ) {

        $pdf->SetFont( $fFamily, $fWeight, $fSize);
        $pdf->Cell( 0, 0, $testo, $border, $newline, $align );

    };
    
    function pdfSottoTitolo( $pdf, $testo, $fFamily = 'helvetica', $fSize = 10, $fWeight = 'B', $border = 0, $newline = 1, $align = 'L' ) {
        pdfTitolo( $pdf, $testo, $fFamily, $fSize, $fWeight, $border, $newline, $align );
    }
    
    function pdfFormCellTxt( $pdf, $testo, $nCols = 0, $colWidth = 0, $fFamily = 'helvetica', $fSize = 10, $fWeight = '', $border = 0, $newline = 1, $align = 'L' ) {

        $pdf->SetFont( $fFamily, $fWeight, $fSize );
        $pdf->Cell( ( $nCols * $colWidth ), 0, $testo, $border, $newline, $align );

    }

    function pdfFormCellLine( $pdf, $testo, $nRows, $nCols = 0, $colWidth = 0, $fFamily = 'helvetica', $fSize = 10, $fWeight = '', $border = 0, $newline = 1, $align = 'L' ) {



    }

    /**
     * $testi = array(
     *   array( 'cols' => 5, 'testo' => 'testo', 'weight' => 'B' )
     * )
     */
    function pdfFormCellTxtRow( $pdf, $testi, $colWidth = 0, $fFamily = 'helvetica', $fSize = 8, $fWeight = '', $border = 0, $newline = 1, $align = 'L' ) {

        $nElements = count( $testi );
        $element = 0;
        $cells = array();

        foreach( $testi as $testo ) {

            $element++;

            $thisFamily = ( isset( $testo['family'] ) ) ? $testo['family'] : $fFamily;
            $thisWeight = ( isset( $testo['weight'] ) ) ? $testo['weight'] : $fWeight;
            $thisSize = ( isset( $testo['size'] ) ) ? $testo['size'] : $fSize;
            $thisBorder = ( isset( $testo['border'] ) ) ? $testo['border'] : 1;

            $pdf->SetFont( $thisFamily, $thisWeight, $thisSize );
            $pdf->Cell( ( $testo['cols'] * $colWidth ), 0, $testo['testo'], $border, ( $element == $nElements ) ? $newline : 0, $align );

            if( $element < $nElements ) {
                $pdf->Cell( $colWidth, 0, '', $border, 0 );
            }

            $cells[] = array( 'cols' => $testo['cols'], 'border' => $thisBorder );

        }

        pdfFormCellRow( $pdf, $cells, $colWidth );

    }

    function pdfFormCellRow( $pdf, $blocchi, $colWidth = 0, $fFamily = 'helvetica', $fSize = 10, $fWeight = '', $border = 1, $newline = 1, $align = 'L' ) {

        $nElements = count( $blocchi );
        $element = 0;

        foreach( $blocchi as $blocco ) {

            $element++;

            $thisFamily = ( isset( $blocco['family'] ) ) ? $blocco['family'] : $fFamily;
            $thisWeight = ( isset( $blocco['weight'] ) ) ? $blocco['weight'] : $fWeight;
            $thisSize = ( isset( $blocco['size'] ) ) ? $blocco['size'] : $fSize;
            $thisBorder = ( isset( $blocco['border'] ) ) ? $blocco['border'] : $border;

            $pdf->SetFont( $thisFamily, $thisWeight, $thisSize );

            for( $cell = 1; $cell <= $blocco['cols']; $cell++ ) {
                $pdf->Cell( $colWidth, 0, '', $thisBorder, ( $element == $nElements && $cell == $blocco['cols'] ) ? $newline : 0, $align );
            }

            if( $element < $nElements ) {
                $pdf->Cell( $colWidth, 0, '', 0, 0 );
            }

        }

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
    
    
    pdfTitolo( $pdf, 'rapporto di intervento di assistenza tecnica' );
    
    
    pdfSottoTitolo( $pdf, "1.dati cliente" );
    // treriga("città", "prov", "cap");
    // riga("nome e cognome o denominazione",$pdf, $fnt, $fnts);
    // pdfFormCellTxt( $pdf, 'nome e cognome o denominazione' );

    pdfFormCellTxtRow(
        $pdf,
        array(
            array( 'cols' => 45, 'testo' => 'nome e cognome o denominazione' )
        ),
        $cellw
    );

    // pdfFormCellTxt( $pdf, 'indirizzo  sede intervento' );

    //mysqlQuery();
    //spazio();
    //riga("indirizzo  sede intervento",$pdf, $fnt, $fnts);
    //spazio();
    //trecella("richiesta ricevuta da", "in data","alle ore",$col1=4,$col2 = 4, $col3 = 4, $pdf, $fnt, $fnts, $col, $lh );
    //spazio();
    //trecella("città", "prov", "cap", 8, 1, 3, $col1=4,$col2 = 4, $col3 = 4, $pdf, $fnt, $fnts, $col, $lh);

    pdfFormCellTxtRow(
        $pdf,
        array(
            array( 'cols' => 45, 'testo' => 'indirizzo sede intervento' )
        ),
        $cellw
    );

    pdfFormCellTxtRow(
        $pdf,
        array(
            array( 'cols' => 28, 'testo' => 'richiesta ricevuta da' ),
            array( 'cols' => 10, 'testo' => 'in data' ),
            array( 'cols' => 5, 'testo' => 'alle ore' )
        ),
        $cellw
    );

    // ...

    pdfFormCellTxtRow(
        $pdf,
        array(
            array( 'cols' => 12, 'testo' => 'codice contratto' ),
            array( 'cols' => 23, 'testo' => '', 'border' => 0 ),
            array( 'cols' => 8, 'testo' => 'ore residue' )
        ),
        $cellw
    );

    /*
    pdfFormCellRow(
        $pdf,
        array(
            array( 'cols' => 28 ),
            array( 'cols' => 10 ),
            array( 'cols' => 5 )
        ),
        $cellw
    );
    */

    //qui inserimento della query
    //trecella();
    //spazio();
    //trecella("codice fiscale", "partita IVA", "codice", $col1=4,$col2 = 4, $col3 = 4, $pdf, $fnt, $fnts, $col, $lh);
    //spazio();
    //bicella("telefono", "email o PEC",$col1=7, $col2=5, $pdf, $fnt, $fnts, $col, $lh);
    //spazio();
    //riga("codice contratto",$pdf, $fnt, $fnts);
    //spazio();
    //pdfSottoTitolo( $pdf, "2.descrizione del problema" );
    //spazio(4);
    //pdfSottoTitolo( $pdf, "3.appuntamento");
    
    
    
    
    
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