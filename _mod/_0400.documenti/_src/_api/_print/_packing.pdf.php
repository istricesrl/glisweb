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
	require_once '../../../../../_src/_config.php';

    // recupero i dati del documento
	$doc = mysqlSelectRow(
        $cf['mysql']['connection'],
	    'SELECT documenti.*,  '.
	    'tipologie_documenti.codice AS codice_tipologia '.
	    'FROM documenti '.
	    'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
	    'WHERE documenti.id = ?',
	    array( array( 's' => $_REQUEST['__documento__'] ) )
	);

    // annoto l'attività di stampa
    if( isset( $cnf['estensione'] ) ) {
        $idAttivitaStampa = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id_tipologia' => ( ( $cnf['estensione'] == 'pdf' ) ? 23 : ( ( $cnf['estensione'] == 'xml' ) ? 24 : 22 ) ),
                'id_documento' => $_REQUEST['__documento__'],
                'data_attivita' => date('Y-m-d'),
                'nome' => 'stampa documento',
                'ora_inizio' => date( 'H:i:s' ),
                'ora_fine' => date( 'H:i:s' )
            ),
            'attivita'
        );
    }

    // inizializzo il totale
    $doc['tot']['importo_netto_totale'] = 0;
    $doc['tot']['importo_iva_totale'] = 0;
    $doc['tot']['importo_lordo_totale'] = 0;

    // carico le righe del documento
    $doc['righe']['grezze'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT documenti_articoli_view.*, articoli.peso, count(agg.id) AS aggregate, '.
        'udm.sigla AS udm FROM documenti_articoli_view '.
        'LEFT JOIN udm ON udm.id = documenti_articoli_view.id_udm '.
        'LEFT JOIN documenti_articoli_view AS agg ON agg.id_genitore = documenti_articoli_view.id LEFT JOIN articoli ON articoli.id = documenti_articoli_view.id_articolo '.
        'WHERE documenti_articoli_view.id_packing_list = ? GROUP BY documenti_articoli_view.id
		 ORDER BY documenti_articoli_view.ordine_collo, documenti_articoli_view.id_articolo',
        array( array( 's' => $doc['id'] ) )
    );


	// organizzo le righe in base al bancale
	foreach( $doc['righe']['grezze'] as $row ) {
		if( isset( $_REQUEST['__bancali__'] ) ) {
			$doc['righe']['ordinate'][ $row['ordine_collo'] ][] = $row;
		} else {
			$doc['righe']['ordinate'][0][] = $row;
		}
	}

	// dettagli bancali
	$doc['bancali']['grezzi'] = mysqlQuery(
		$cf['mysql']['connection'],
		'SELECT colli.* FROM colli 
		INNER JOIN documenti_articoli ON documenti_articoli.id_collo = colli.id 
		WHERE documenti_articoli.id_packing_list = ? GROUP BY colli.id ORDER BY colli.ordine',
		array( array( 's' => $doc['id'] ) )
	);

	foreach( $doc['bancali']['grezzi'] as $row ) {
		if( isset( $_REQUEST['__bancali__'] ) ) {
			$doc['bancali']['ordinati'][ $row['id'] ][] = $row;
		} else {
			$doc['bancali']['ordinati'][0][] = $row;
		}
	}

	// debug
	// die( print_r($doc['righe'],true) );

	// ...
	// die( print_r($doc['bancali'],true) );

    // recupero i dati dell'emittente
	$src = mysqlSelectRow(
        $cf['mysql']['connection'],
	    'SELECT * FROM anagrafica WHERE id = ?',
	    array( array( 's' => $doc['id_emittente'] ) )
	);

    // recupero il logo dell'azienda emittente
	$lge = anagraficaGetLogo( $doc['id_emittente'] );

    // denominazione fiscale
    $src['denominazione_fiscale'] = trim( $src['nome'] . ' ' . $src['cognome'] . ' ' . $src['denominazione'] );



    // recupero i dati della sede dell'emittente
    $sri = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT tipologie_indirizzi.nome AS tipologia, indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, '.
        'comuni.nome AS comune, provincie.sigla AS provincia, '.
        'stati.iso31661alpha2 AS sigla_stato '.
        'FROM anagrafica_indirizzi '.
        'INNER JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo '.
        'INNER JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia '.
        'INNER JOIN comuni ON comuni.id = indirizzi.id_comune '.
        'INNER JOIN provincie ON provincie.id = comuni.id_provincia '.
        'INNER JOIN regioni ON regioni.id = provincie.id_regione '.
        'INNER JOIN stati ON stati.id = regioni.id_stato '.
        'WHERE anagrafica_indirizzi.id_anagrafica = ? ',
        array( array( 's' => $src['id'] ) )
    );

    // indirizzo fiscale
    if( empty($sri) ){
		// die( print_r('indirizzo assente per '. $src['denominazione_fiscale']) );
		$sri['indirizzo_fiscale'] = '';
	 } else {
		 $sri['indirizzo_fiscale'] = $sri['tipologia'] . ' ' . $sri['indirizzo'] . ', ' . $sri['civico'];
 
	 }
    $sdef['linee'][] = $src['denominazione_fiscale'];
    $sdef['linee'][] = $sri['indirizzo_fiscale'];
	$sdef['linee'][] = $sri['cap'] . ' ' . $sri['comune'] . ' (' . $sri['provincia'] . ')';
    $sdef['linee'][] = 'P.IVA ' . $src['partita_iva'];
	$sdef['linee'][] = 'cod.fisc. ' . $src['codice_fiscale'];
	// if( ! empty( $emittente['codice_sdi'] ) ) {
	//     $sdef['linee'][] = 'SDI ' . $src['codice_sdi'];
	// } else {
	//     $sdef['linee'][] = 'PEC ' . anagraficaGetPEC( $doc['id_emittente'] );
	// }
	$sde = $sdef['linee'];

    // recupero i dati del destinatario
	$dst = mysqlSelectRow(
        $cf['mysql']['connection'],
	    'SELECT * FROM anagrafica WHERE id = ?',
	    array( array( 's' => $doc['id_destinatario'] ) )
	);

    // denominazione fiscale
    $dst['denominazione_fiscale'] = trim( $dst['nome'] . ' ' . $dst['cognome'] . ' ' . $dst['denominazione'] );

    // recupero i dati della sede dell'emittente
    $dsi = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT tipologie_indirizzi.nome AS tipologia, indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, '.
        'comuni.nome AS comune, provincie.sigla AS provincia, '.
        'stati.iso31661alpha2 AS sigla_stato '.
        'FROM anagrafica_indirizzi '.
        'LEFT JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo '.
        'LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia '.
        'LEFT JOIN comuni ON comuni.id = indirizzi.id_comune '.
        'LEFT JOIN provincie ON provincie.id = comuni.id_provincia '.
        'LEFT JOIN regioni ON regioni.id = provincie.id_regione '.
        'LEFT JOIN stati ON stati.id = regioni.id_stato '.
        'WHERE anagrafica_indirizzi.id_anagrafica = ? ',
        array( array( 's' => $dst['id'] ) )
    );

	if( empty($dsi) ){
		// die( print_r('indirizzo assente per '. $src['denominazione_fiscale']) );
		$dsi['indirizzo_fiscale'] = '';
	 } else {
		$dsi['indirizzo_fiscale'] = $dsi['tipologia'] . ' ' . $dsi['indirizzo'] . ', ' . $dsi['civico'];
	 }

    $sdec['linee'][] = $dst['denominazione_fiscale'];
    $sdec['linee'][] = $dsi['indirizzo_fiscale'];
	$sdec['linee'][] = $dsi['cap'] . ' ' . $dsi['comune'] . ' (' . $dsi['provincia'] . ')';
    $sdec['linee'][] = 'P.IVA ' . $dst['partita_iva'];
	$sdec['linee'][] = 'cod.fisc. ' . $dst['codice_fiscale'];
	// if( isset($dst['codice_sdi']) && ! empty( $dst['codice_sdi'] ) ) {
	//     $sdec['linee'][] = 'SDI ' . $dst['codice_sdi'];
	// } else {
	//     $sdec['linee'][] = 'PEC ' . anagraficaGetPEC( $doc['id_emittente'] );
	// }
	$sdec['linee'][] = 'cod. cliente ' . $dst['codice'];
	$sdc = $sdec['linee'];

    // oggetto del documento
	// $dobj = 'DDT n. ' . $doc['numero'] . ' del ' . strftime( '%d %B %Y', strtotime( $doc['data'] ) );
    $dobj = $doc['nome'];
  
    // recupero i dati dell'azienda emittente
	$emittente = mysqlSelectRow( $cf['mysql']['connection'],
	    'SELECT * FROM anagrafica_view WHERE id = ?',
	    array( array( 's' => $doc['id_emittente'] ) )
	);

  
    // recupero i dati del destinatario
	$cliente = mysqlSelectRow( $cf['mysql']['connection'],
	    'SELECT * FROM anagrafica_view WHERE id = ?',
	    array( array( 's' => $doc['id_destinatario'] ) )
	);

	$pesoNettoMerce = 0;
  
    // creazione del PDF
	$pdf = new TCPDF( 'P', 'mm', 'A4' );						// portrait, millimetri, A4 (x->210 y->297)

    $pdf->SetTitle( $dobj.' di .pdf');

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

    // testi
	$tx[0] = "";
	$tx[1] = $doc['note'];
	$tx[8] = "";
	$tx[9] = "";
	$tx[10] = "ALLEGATO A";
	$tx[11] = "DETTAGLIO RIGHE";

       // carattere di base
	$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

    // tipografia derivata
	$lh		= $pdf->getStringHeight( $w, 'a' );				// altezza stimata della linea di testo
	$wport		= $w - ( $ml + $mr );						// larghezza dell'area del testo
	$col		= $wport / 12;							// larghezza colonna base

    // impostazioni del logo
	$lgw		= $col * 2;							// larghezza del logo
	$lgh		= $lh * 5;//count( $sde );						// altezza del logo
	$lgn		= 'T';								// posizione del testo dopo il logo

    // rimozione di header e footer
	$pdf->SetPrintHeader( false );							// se stampare l'header
	$pdf->SetPrintFooter( true );							// se stampare il footer

    // imposto i margini
	$pdf->SetMargins( $ml, $mt, $mr );						// left, top, right
	$pdf->SetHeaderMargin( 0 );							// margine dell'intestazione
	$pdf->SetFooterMargin( 0 );							// margine del footer

    // set default monospaced font
	$pdf->SetDefaultMonospacedFont( PDF_FONT_MONOSPACED );				// imposta il font a larghezza fissa

    // set auto page breaks
	$pdf->SetAutoPageBreak( true, $mt );						// se aggiungere automaticamente pagine

    // set image scale factor
	$pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );					// fattore di conversione da pixel a millimetri

	// ...
	foreach( $doc['righe']['ordinate'] as $bancale => $righe ) {

		// aggiunta di una pagina
		$pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

		// define barcode style
		$style = array(
			'position' => 'R',
			'align' => 'C',
			'stretch' => false,
			'fitwidth' => true,
			'cellfitalign' => '',
			'border' => false,
			'hpadding' => 'auto',
			'vpadding' => 'auto',
			'fgcolor' => array(0,0,0),
			'bgcolor' => false,
			'text' => true,
			'font' => 'helvetica',
			'fontsize' => 8,
			'stretchtext' => 4
		);

		// codice a barre del DDT
		if( ! empty( $doc['codice'] ) ) {
			$pdf->SetX( $ml + ( $col * 9 ) );					// x
			$pdf->SetY( $mt + $stdsp );						// y
			$pdf->write1DBarcode( $doc['codice'], 'C128', '', '', '', 18, 0.4, $style, 'N');
		}

		// inserisco il logo in alto a sinistra
		$pdf->image( $lge, $ml, $mt, $lgw, $lgh, NULL, NULL, $lgn, false, 300, '', false, false, 1, true );		// x, y, w, h, type, link, align, resize

		// intestazione azienda emittente
		// $pdf->SetY( $mt + $stdsp );						// y
		$tmp = $pdf->GetX() + $stdsp;								// margine provvisorio in base alla larghezza del logo
		$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
		foreach( $sde as $k => $sdel ) {
			if( $k !== key( $sde ) ) { $pdf->SetFont( $fnt, '', $fnts ); }		// font, stile, dimensione
			$pdf->Text( $tmp, $pdf->GetY(), $sdel, false, false, true, 0, 1 );		// x, y, testo, outline, clip, fill, border, newline
		}

		// spazio sotto l'intestazione
		$pdf->SetY( $pdf->GetY() + $stdsp * 2 );

		// intestazione cliente
		$tmp = $pdf->GetX();								// margine provvisorio in base alla larghezza del logo
		$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
		foreach( $sdc as $k => $sdcl ) {
			if( $k !== key( $sdc ) ) { $pdf->SetFont( $fnt, '', $fnts ); }		// font, stile, dimensione
			$pdf->Text( $tmp, $pdf->GetY(), $sdcl, false, false, true, 0, 1, 'R' );	// x, y, testo, outline, clip, fill, border, newline, allineamento
		}

		// spazio sotto l'intestazione
		$pdf->SetY( $pdf->GetY() + $stdsp * 2 );

		// oggetto del documento
		$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
		$pdf->Cell( $col * 2, 0, 'oggetto:', 0, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione
		$pdf->Cell( $col * 11, 0, $dobj, 0, 1 );					// larghezza, altezza, testo, bordo, newline, allineamento

		// spazio sotto l'oggetto
		$pdf->SetY( $pdf->GetY() + $stdsp );

		// primo paragrafo
		$pdf->MultiCell( $wport, $lh, $tx[0] );						// w, h, testo

		// spazio sotto il primo paragrafo
		$pdf->SetY( $pdf->GetY() + $stdsp );

		// intestazione tabella di dettaglio
		$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
		$pdf->Cell( $col * 1, 0, 'num.', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 2, 0, 'cod.', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 6, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 2, 0, 'peso netto', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 1, 0, 'q.tà', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento

		// contatore delle eventuali righe aggregate per generare l'eventuale allegato "dettaglio aggregate"
		$countAggregate = 0;

		// tabella di dettaglio
		$pdf->SetFont( $fnt, '', $fnts );										// font, stile, dimensione
		foreach( $righe as $row ) {
			$trh = $pdf->GetStringHeight( $col * 6,$row['articolo'] , false, true, '', 'B' );				// 
		$pdf->SetFont( $fnt, '', $fnts );
			// controllo se la riga di dettaglio entra nella parte rimanente del foglio
			if(($pdf->GetY()+$trh ) > ($pdf-> GetPageHeight() -15) ){
				$pdf->AddPage(); 
				// intestazione tabella nel nuovo foglio
				$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
				$pdf->Cell( $col * 1, 0, 'num.', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
				$pdf->Cell( $col * 2, 0, 'cod.', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
				$pdf->Cell( $col * 6, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
				$pdf->Cell( $col * 2, 0, 'peso', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
				$pdf->Cell( $col * 1, 0, 'q.tà', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
						// reimposto il font
				$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

										}
			if( substr($row['nome'],0,1) === '*' ){$pdf->SetFillColor(230, 230, 230);} 
			else {	    $pdf->SetFillColor(255, 255, 255);}
			// $pdf->MultiCell( $col * 4, $lh,$row['articolo'], $brdc, 'L', 1, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline

			// scrivo in grassetto le righe che sono aggregazioni di righe
			if($row['aggregate']>0 ){	$pdf->SetFont( $fnt, 'B', $fnts ); }

	//	    if( $row['nome'][0] === '*' ){$pdf->SetFillColor(255, 0, 0);} 
	$pdf->Cell( $col * 1, $trh, $row['ordine_collo'], $brdc, 0, 'L', 1, '', 0, 1, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
	$pdf->Cell( $col * 2, $trh, $row['id_articolo'], $brdc, 0, 'L', 1, '', 0, 1, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
	$pdf->MultiCell( $col * 6, $lh,$row['articolo'], $brdc, 'L', 1, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline
	$pdf->Cell( $col * 2, $trh, ($row['peso']*$row['quantita']), $brdc, 0, 'R', 1, '', 0, 1, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
	$pdf->Cell( $col * 1, $trh, $row['quantita'], $brdc, 1, 'R', 1, '', 0, 1, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento

			$countAggregate += $row['aggregate'];
			$pesoNettoMerce += ($row['peso']*$row['quantita']);
		
		}

	// spazio sotto la tabella di dettaglio
	$pdf->SetY( $pdf->GetY() + $stdsp );



		// intestazione tabella di dettaglio
		$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
		$pdf->Cell( $col * 1, 0, 'num.', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 3, 0, 'cod.', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 1, 0, 'largh.', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 1, 0, 'lung.', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 1, 0, 'alt.', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 2, 0, 'peso netto', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 2, 0, 'peso lordo', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
		$pdf->Cell( $col * 1, 0, 'volume', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento


		$dett = $doc['bancali']['ordinati'][$bancale];

		foreach( $dett as $row ) {
			$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione
			$pdf->Cell( $col * 1, $lh, $row['ordine'], $brdc, 0, 'L', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 3, $lh, $row['codice'], $brdc, 0, 'L', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 1, $lh, $row['larghezza'], $brdc, 0, 'R', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 1, $lh, $row['lunghezza'], $brdc, 0, 'R', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 1, $lh, $row['altezza'], $brdc, 0, 'R', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 2, $lh, $pesoNettoMerce, $brdc, 0, 'R', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 2, $lh, $row['peso'], $brdc, 0, 'R', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->Cell( $col * 1, $lh, ($row['larghezza']*$row['lunghezza']*$row['altezza'])/100000, $brdc, 1, 'R', 1 );	// larghezza, altezza, testo, bordo, newline, allineamento			
		}

	// spazio sotto la tabella IVA
	$pdf->SetY( $pdf->GetY() + $stdsp );

	if (strlen($tx[1])>0){

		// note per il cliente
			$pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
			$pdf->Cell( $col * 12, 0, 'note per il cliente: ', 0, 1, 'L' );		// larghezza, altezza, testo, bordo, newline, allineamento
			$pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione
			$pdf->MultiCell( $wport, $lh, $tx[1], 0, 'JL' );					// w, h, testo

			// spazio sotto le note per il cliente
			$pdf->SetY( $pdf->GetY() + $stdsp );
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

