<?php

    function generaFatturaPdf( &$pdf, $dati, $etc = array() ) {

        // intestazione emittente documento
        $sdef['linee'][] = $dati['src']['denominazione_fiscale'];
        $sdef['linee'][] = $dati['sri']['indirizzo_fiscale'];
        $sdef['linee'][] = $dati['sri']['comune_indirizzo_fiscale'];
        if( ! empty( $dati['src']['partita_iva'] ) ) { $sdef['linee'][] = 'P.IVA ' . $dati['src']['partita_iva']; }
        if( ! empty( $dati['src']['codice_fiscale'] ) ) { $sdef['linee'][] = 'cod.fisc. ' . $dati['src']['codice_fiscale']; }
        if( ! empty( $emittente['codice_sdi'] ) ) {
            $sdef['linee'][] = 'SDI ' . $dati['src']['codice_sdi'];
        } elseif( ! empty( anagraficaGetPEC( $dati['doc']['id_emittente'] ) ) ) {
            $sdef['linee'][] = 'PEC ' . anagraficaGetPEC( $dati['doc']['id_emittente'] );
        }

        // intestazione destinatario documento
        $sdec['linee'][] = $dati['dst']['denominazione_fiscale'];
        $sdec['linee'][] = $dati['dsi']['indirizzo_fiscale'];
        $sdec['linee'][] = $dati['dsi']['comune_indirizzo_fiscale'];
        if( isset( $dati['dst']['partita_iva'] ) && ! empty( $dati['dst']['partita_iva'] ) ) { $sdec['linee'][] = 'P.IVA ' . $dati['dst']['partita_iva']; }
        if( isset( $dati['dst']['codice_fiscale'] ) && ! empty( $dati['dst']['codice_fiscale'] ) ) { $sdec['linee'][] = 'cod.fisc. ' . $dati['dst']['codice_fiscale']; }
        if( isset($dati['dst']['codice_sdi']) && ! empty( trim( $dati['dst']['codice_sdi'], '0' ) ) ) {
            $sdec['linee'][] = 'SDI ' . $dati['dst']['codice_sdi'];
        } elseif( ! empty( anagraficaGetPEC( $dati['doc']['id_destinatario'] ) ) ) {
            $sdec['linee'][] = 'PEC ' . anagraficaGetPEC( $dati['doc']['id_destinatario'] );
        }
        $sdc = $sdec['linee'];
    
        // oggetto del documento
        $dati['doc']['oggetto'] = $dati['doc']['tipologia'] . ' n. ' . $dati['doc']['numero'] . ' del ' . strftime( '%d %B %Y', strtotime( $dati['doc']['data'] ) );

        // titolo del documento
        $pdf->SetTitle( $dati['doc']['oggetto'].' di .pdf');

        // tipografia
        $h		    = 297;								                // altezza del foglio
        $w		    = 210;								                // larghezza del foglio
        $ml		    = 15;								                // margine sinistro
        $mt		    = 25;								                // margine superiore
        $mr		    = 15;								                // margine destro
        $fnt		= 'helvetica';						                // font base
        $fnts		= 10;								                // dimensione del font base
        $stdsp		= 5;								                // spaziatore standard
        $lth		= .3;								                // spessore linea standard
        $lts		= .15;								                // spessore linea sottile
        $rgb0		= array( 0, 0, 0 );					                // il nero
        $rgb1		= array( 128, 128, 128 );			                // grigio
        $rgb9		= array( 255, 255, 255 );			                // il bianco

        // bordi delle celle
        $brdh		= array(
                    'B' => array( 'width' => $lth, 'color' => $rgb0 )
        );
        $brdc		= array(
                    'B' => array( 'width' => $lts, 'color' => $rgb1 )
        );

        // tipografia derivata
        $lh		    = $pdf->getStringHeight( $w, 'a' );	                // altezza stimata della linea di testo
        $wport		= $w - ( $ml + $mr );				                // larghezza dell'area del testo
        $col		= $wport / 12;						                // larghezza colonna base

        // impostazioni del logo
        $lgw		= $col * 2;							                // larghezza del logo
        $lgh		= $lh * 5;                                          // altezza del logo
        $lgn		= 'T';								                // posizione del testo dopo il logo

        // sovrascrivo la tipografia di default con $etc['tipografia']
        // TODO

        // testi
        $tx[0] = "Gentile Cliente, per le prestazioni qui di seguito dettagliate richiediamo gentilmente il pagamento come sotto indicato secondo le modalità specificate:\n";
        $tx[1] = $dati['doc']['note'];
        $tx[8] = "Il presente documento non costituisce in maniera assoluta fattura ai sensi dell’art. 21 del D.P.R. 633/72 e quindi non genera esigibilità di imposta per il prestatore.\n";
        $tx[9] = "Trattasi di documento emesso in relazione al pagamento di corrispettivi di operazioni assoggettate ad imposta sul valore aggiunto (art.6, comma 2, del D.P.R. 642/72). Contestualmente al pagamento, verrà emessa regolare fattura con evidenziazione dell’IVA.\n";
        $tx[10] = "ALLEGATO A";
        $tx[11] = "DETTAGLIO RIGHE";

        // sovrascrivo i testi di default con $etc['testi']
        // TODO

        // carattere di base
        $pdf->SetFont( $fnt, '', $fnts );				                // font, stile, dimensione

        // rimozione di header e footer
        $pdf->SetPrintHeader( false );					                // se stampare l'header
        $pdf->SetPrintFooter( true );					                // se stampare il footer

        // imposto i margini
        $pdf->SetMargins( $ml, $mt, $mr );						        // left, top, right
        $pdf->SetHeaderMargin( 0 );							            // margine dell'intestazione
        $pdf->SetFooterMargin( 0 );							            // margine del footer

        // set default monospaced font
        $pdf->SetDefaultMonospacedFont( PDF_FONT_MONOSPACED );			// imposta il font a larghezza fissa

        // set auto page breaks
        $pdf->SetAutoPageBreak( true, $mt );						    // se aggiungere automaticamente pagine

        // set image scale factor
        $pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );					// fattore di conversione da pixel a millimetri

        // aggiunta di una pagina
        $pdf->AddPage();								                // richiesto perché si è disattivato l'automatismo

        // debug
        // var_dump( $dati['sri']['logo'] );

        // inserisco il logo in alto a sinistra
        if( ! empty( $dati['sri']['logo'] ) ) {
            $pdf->image( $dati['sri']['logo'], $ml, $mt, $lgw, $lgh, NULL, NULL, $lgn, false, 300, '', false, false, 1, true );		// x, y, w, h, type, link, align, resize
            $tmp = $pdf->GetX() + $stdsp * 3;								// margine provvisorio in base alla larghezza del logo
        } else {
            $tmp = $ml;
        }

        // intestazione azienda emittente
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        foreach( $sdef['linee'] as $k => $sdel ) {
            if( $k !== key( $sdef['linee'] ) ) { $pdf->SetFont( $fnt, '', $fnts ); }		// font, stile, dimensione
            $pdf->Text( $tmp, $pdf->GetY(), $sdel, false, false, true, 0, 1 );		// x, y, testo, outline, clip, fill, border, newline
        }

        // spazio sotto l'intestazione
        $pdf->SetY( $pdf->GetY() + $stdsp * 3 );

        // intestazione cliente
        $tmp = $pdf->GetX();								// margine provvisorio in base alla larghezza del logo
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        foreach( $sdc as $k => $sdcl ) {
            if( $k !== key( $sdc ) ) { $pdf->SetFont( $fnt, '', $fnts ); }		// font, stile, dimensione
            $pdf->Text( $tmp, $pdf->GetY(), $sdcl, false, false, true, 0, 1, 'R' );	// x, y, testo, outline, clip, fill, border, newline, allineamento
        }

        // linea per la piega
        $pdf->Line( 0, 99, 20, 99, $brdc );

        // spazio sotto l'intestazione
        $pdf->SetY( $pdf->GetY() + $stdsp * 2 );

        // oggetto del documento
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 2, 0, 'oggetto:', 0, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 11, 0, $dati['doc']['oggetto'], 0, 1 );					// larghezza, altezza, testo, bordo, newline, allineamento

        // spazio sotto l'oggetto
        $pdf->SetY( $pdf->GetY() + $stdsp * 3 );

        // primo paragrafo
        $pdf->MultiCell( $wport, $lh, $tx[0] );						// w, h, testo

        // spazio sotto il primo paragrafo
        $pdf->SetY( $pdf->GetY() + $stdsp );

        // intestazione tabella di dettaglio
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'q.tà', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'udm', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'p. unitario', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento

        // contatore delle eventuali righe aggregate per generare l'eventuale allegato "dettaglio aggregate"
        $countAggregate = 0;

        // tabella di dettaglio
        $pdf->SetFont( $fnt, '', $fnts );										// font, stile, dimensione

        // righe della tabella di dettaglio
        foreach( $dati['doc']['righe'] as $row ) {

            $trh = $pdf->GetStringHeight( $col * 4, $row['nome'], false, true, '', 'B' );				// calcolo l'altezza della riga
            $pdf->SetFont( $fnt, '', $fnts );
    /*
            // controllo se la riga di dettaglio entra nella parte rimanente del foglio
            if( ( $pdf->GetY()+$trh ) > ($pdf-> GetPageHeight() - 15)  ) {

                // aggiungo una pagina
                $pdf->AddPage(); 

                // intestazione tabella nel nuovo foglio
                $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
                $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'q.tà', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'udm', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'p. unitario', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'C' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento

                // reimposto il font
                $pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

            }

            if( ! empty( $row['aggregate'] ) ) {
                $pdf->SetFont( $fnt, 'B', $fnts );
                $countAggregate += $row['aggregate'];
            }

            if( substr($row['nome'],0,1) === '*' ) {
                $pdf->SetFillColor(230, 230, 230);
            } else {
                $pdf->SetFillColor(255, 255, 255);
            }
    */
            $pdf->MultiCell( $col * 4, $lh, $row['nome'], $brdc, 'L', 0, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline

    //	    if( $row['nome'][0] === '*' ){$pdf->SetFillColor(255, 0, 0);} 
            $pdf->Cell( $col * 1, $trh, $row['quantita'], $brdc, 0, 'L', 0, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 1, $trh, $row['udm'], $brdc, 0, 'C', 0, '', 0, false, 'T', 'T' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 1, $trh, $row['importo_netto_unitario'] , $brdc, 0, 'R', 0, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 2, $trh, $row['importo_netto_totale'].' €', $brdc, 0, 'R', 0, '', 0, false, 'T', 'T' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 1, $trh, $row['importo_iva_totale'].' €', $brdc, 0, 'R', 0, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 2, $trh, $row['importo_lordo_totale'].' €', $brdc, 1, 'R', 0, '', 0, false, 'T', 'T' );			// larghezza, altezza, testo, bordo, newline, allineamento

        }

        // totale tabella di dettaglio
        $pdf->SetFont( $fnt, 'B', $fnts );										// font, stile, dimensione
        $pdf->Cell( $col * 7, 0, 'totali', 0, 0, 'L', false, '', 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
        $pdf->Cell( $col * 2, 0,  $dati['doc']['tot']['importo_netto_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0,  $dati['doc']['tot']['importo_iva_totale'].' €', 0, 0, 'R', false, '', 0 );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, $dati['doc']['tot']['importo_lordo_totale'].' €', 0, 1, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento

        // spazio sotto la tabella di dettaglio
        $pdf->SetY( $pdf->GetY() + $stdsp );

        // intestazione tabella IVA
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 1, 0, '', $brdh, 0, 'C' );					// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 4, 0, 'dettaglio IVA', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, 'importo', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

        $pdf->SetFont( $fnt, '', $fnts );	
        if( isset($dati['doc']['iva']) ){									// font, stile, dimensione
        foreach( $dati['doc']['iva'] as $iva => $row ) {
            $trh = $pdf->GetStringHeight( $col * 4, $row['nome'], false, true, '', 'B' );				// 
            $pdf->Cell( $col * 1, $trh, $row['codice'], $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// w, h, testo, bordo, allineamento, riempimento, newline
            $pdf->MultiCell( $col * 4, $lh, $row['nome'], $brdc, 'L', false, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline
            $pdf->Cell( $col * 2, $trh, $row['tot'].' €', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
        }
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


        if(sizeof($dati['doc']['pagamenti'])>0){
            // intestazione tabella scadenze
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 2, 0, 'data scadenza', $brdh, 0, 'C' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 6, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 2, 0, 'importo', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

            // tabella scadenze
            $pdf->SetFont( $fnt, '', $fnts );										// font, stile, dimensione
            foreach( $dati['doc']['pagamenti'] as $row ) {
                $nome = $row['nome'] . ( ( ! empty( $row['modalita'] ) ) ? ' tramite ' . $row['modalita'] : NULL ) . ( ( ! empty( $row['iban'] ) ) ? ' su ' . $row['iban'] : NULL );
                $trh = $pdf->GetStringHeight( $col * 6, $nome, false, true, '', 'B' );				// 
                $pdf->Cell( $col * 2, $trh, $row['data_italiana'], $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->MultiCell( $col * 6, $lh, $nome, $brdc, 'L', false, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->Cell( $col * 2, $trh, number_format($row['importo_lordo_totale'], 2, ',', '.' ).' €', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
            }
        }

        if( $countAggregate > 0 ){
            // se sono presenti righe aggregate viene aggiunta la sezione di dettaglio 
            // impostazione margine inferiore della pagina
            $pdf->SetAutoPageBreak( true, $mt );
            $pdf->addPage();
        
            // primo paragrafo
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 11, 0, $tx[10], 0, 1,'C' );					// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->SetFont( $fnt, 'U', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 11, 0, $tx[11], 0, 1 ,'C' );					// larghezza, altezza, testo, bordo, newline, allineamento

            // spazio sotto l'intestazione
            $pdf->SetY( $pdf->GetY() + $stdsp );

            foreach( $dati['doc']['righe'] as $row ) {
            
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione

            $pdf->SetY( $pdf->GetY() + $stdsp * 0.3 );

            if( isset( $row['aggregate'] ) && $row['aggregate'] > 0 ) {

                $aggregate = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT documenti_articoli.*,  '.
                    'iva.aliquota, iva.codice, iva.id AS id_iva, iva.nome AS nome_iva, iva.descrizione AS descrizione_iva, iva.codice AS codice_iva, '.
                    'udm.sigla AS udm FROM documenti_articoli '.
                    'LEFT JOIN reparti ON reparti.id = documenti_articoli.id_reparto '.
                    'LEFT JOIN iva ON iva.id = reparti.id_iva '.
                    'LEFT JOIN udm ON udm.id = documenti_articoli.id_udm '.
                    'WHERE documenti_articoli.id_genitore = ? ORDER BY documenti_articoli.data' ,
                    array( array( 's' => $row['id'] ) )
                );

                $pdf->SetFont( $fnt, 'I', $fnts );						// font, stile, dimensione

                $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'data', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento

                // tabella di dettaglio righe aggregate
                foreach( $aggregate  as $riga){

                    $riga['qtd'] = ( empty( $riga['quantita'] ) ) ? 1 : $riga['quantita'];
            
                    $riga['importo_netto_unitario']         = str_replace( ',', '.', round( ( $riga['importo_netto_totale'] ), 2 ) );
                    $riga['importo_netto_totale']           = str_replace( ',', '.', round( $riga['importo_netto_totale'] * $riga['qtd'] , 2 ) );
                    $riga['importo_iva_totale']             = str_replace( ',', '.', round( $riga['importo_netto_totale'] * ( $riga['aliquota'] / 100 ), 2 ) );
                    $riga['importo_lordo_totale']           = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] + $riga['importo_iva_totale'] ) );
                    $riga['aliquota']                       = str_replace( ',', '.', sprintf( '%0.2f', round( $riga['aliquota'], 2 ) ) );
            
                    $dati['doc']['tot']['importo_netto_totale']     += $riga['importo_netto_totale'];
                    $dati['doc']['tot']['importo_iva_totale']       += $riga['importo_iva_totale'];
                    $dati['doc']['tot']['importo_lordo_totale']     += $riga['importo_lordo_totale'];
            
                    if( isset( $dati['doc']['iva'][ $riga['id_iva'] ]['tot'] ) ) {
                        $dati['doc']['iva'][ $riga['id_iva'] ]['imponibile_tot'] += $riga['importo_netto_totale'];
                        $dati['doc']['iva'][ $riga['id_iva'] ]['tot'] += $riga['importo_iva_totale'];
                    } else {
                        $dati['doc']['iva'][ $riga['id_iva'] ] = array(
                            'tot' => $riga['importo_iva_totale'],
                            'imponibile_tot' => str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] ) ),
                            'nome' => $riga['nome_iva'],
                            'codice' => $riga['codice_iva'],
                            'aliquota' => str_replace( ',', '.', sprintf( '%0.2f', $riga['aliquota'] ) ),
                            'riferimento' => ( ( ! empty( $riga['descrizione_iva'] ) ) ? $riga['descrizione_iva'] : NULL )
                        );
                    }
            
                    $riga['importo_netto_unitario']                     = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_unitario'] ) );
                    $riga['importo_netto_totale']                       = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] ) );
                    $riga['importo_iva_totale']                         = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_iva_totale'] ) );
                    $riga['importo_lordo_totale']                       = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_lordo_totale'] ) );
                    $dati['doc']['iva'][ $riga['id_iva'] ]['imponibile_tot']    = str_replace( ',', '.', sprintf( '%0.2f', round( $dati['doc']['iva'][ $riga['id_iva'] ]['imponibile_tot'], 2 ) ) );
                    $dati['doc']['iva'][ $riga['id_iva'] ]['tot']               = str_replace( ',', '.', sprintf( '%0.2f', round( $dati['doc']['iva'][ $riga['id_iva'] ]['tot'], 2 ) ) );

                    $trh = $pdf->GetStringHeight( $col * 4, $riga['nome'], false, true, '', 'B' );				// 
                    $pdf->SetFont( $fnt, '', $fnts );
                    $pdf->MultiCell( $col * 4, $lh, $riga['nome'], $brdc, 'L', false, 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
                    $pdf->Cell( $col * 2, $trh, date("d/m/Y",strtotime( $riga['data'])), $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 2, $trh, $riga['importo_netto_totale'].' €', $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 1, $trh, $riga['aliquota'] . '%', $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 1, $trh, $riga['importo_iva_totale'].' €', $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 2, $trh, $riga['importo_lordo_totale'].' €', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento

                }

                // totale righe aggregate
                $pdf->SetFont( $fnt, 'B', $fnts );								// font, stile, dimensione
                $pdf->MultiCell( $col * 6, 0, $row['nome'], 0, 'L', false, 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->Cell( $col * 2, 0, $row['importo_netto_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_iva_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_lordo_totale'].' €', 0, 1, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento

            } else {
                $pdf->SetFont( $fnt, 'I', $fnts );						// font, stile, dimensione
                $pdf->Cell( $col * 5, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'data', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        
                // dettaglio riga
                $pdf->SetFont( $fnt, 'B', $fnts );								// font, stile, dimensione
                $pdf->MultiCell( $col * 5, 0, $row['nome'], 0, 'L', false, 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->Cell( $col * 1, 0, date("d/m/Y",strtotime( $row['data'])), 0, 0, 'L', false, '', 0 );	// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_netto_totale'].' €', 0, 0, 'R', false, '', 0 );	// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_iva_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_lordo_totale'].' €', 0, 1, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
        
            }
            $pdf->SetY( $pdf->GetY() + $stdsp *1.5 );
            }

        }

    }

    function generaRicevutaPdf( &$pdf, $dati, $etc = array() ) {

        // intestazione emittente documento
        $sdef['linee'][] = $dati['src']['denominazione_fiscale'];
        $sdef['linee'][] = $dati['sri']['indirizzo_fiscale'];
        $sdef['linee'][] = $dati['sri']['comune_indirizzo_fiscale'];
        if( ! empty( $dati['src']['partita_iva'] ) ) { $sdef['linee'][] = 'P.IVA ' . $dati['src']['partita_iva']; }
        if( ! empty( $dati['src']['codice_fiscale'] ) ) { $sdef['linee'][] = 'cod.fisc. ' . $dati['src']['codice_fiscale']; }
        if( ! empty( $emittente['codice_sdi'] ) ) {
            $sdef['linee'][] = 'SDI ' . $dati['src']['codice_sdi'];
        } elseif( ! empty( anagraficaGetPEC( $dati['doc']['id_emittente'] ) ) ) {
            $sdef['linee'][] = 'PEC ' . anagraficaGetPEC( $dati['doc']['id_emittente'] );
        }

        // instestazione destinatario documento
        $sdec['linee'][] = $dati['dst']['denominazione_fiscale'];
        $sdec['linee'][] = $dati['dsi']['indirizzo_fiscale'];
        $sdec['linee'][] = $dati['dsi']['comune_indirizzo_fiscale'];
        if( isset( $dati['dst']['partita_iva'] ) && ! empty( $dati['dst']['partita_iva'] ) ) { $sdec['linee'][] = 'P.IVA ' . $dati['dst']['partita_iva']; }
        if( isset( $dati['dst']['codice_fiscale'] ) && ! empty( $dati['dst']['codice_fiscale'] ) ) { $sdec['linee'][] = 'cod.fisc. ' . $dati['dst']['codice_fiscale']; }
        if( isset($dati['dst']['codice_sdi']) && ! empty( trim( $dati['dst']['codice_sdi'], '0' ) ) ) {
            $sdec['linee'][] = 'SDI ' . $dati['dst']['codice_sdi'];
        } elseif( ! empty( anagraficaGetPEC( $dati['doc']['id_destinatario'] ) ) ) {
            $sdec['linee'][] = 'PEC ' . anagraficaGetPEC( $dati['doc']['id_destinatario'] );
        }
        $sdc = $sdec['linee'];
    
        // oggetto del documento
        $dati['doc']['oggetto'] = $dati['doc']['tipologia'] . ' n. ' . $dati['doc']['numero'] . ' del ' . strftime( '%d %B %Y', strtotime( $dati['doc']['data'] ) );
    
        // titolo del documento
        $pdf->SetTitle( $dati['doc']['oggetto'].' di .pdf');

        // tipografia
        $h		= 297;								// altezza del foglio
        $w		= 210;								// larghezza del foglio
        $ml		= 15;								// margine sinistro
        $mt		= 25;								// margine superiore
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
    
        // tipografia derivata
        $lh		= $pdf->getStringHeight( $w, 'a' );				// altezza stimata della linea di testo
        $wport		= $w - ( $ml + $mr );						// larghezza dell'area del testo
        $col		= $wport / 12;							// larghezza colonna base
    
        // impostazioni del logo
        $lgw		= $col * 2;							// larghezza del logo
        $lgh		= $lh * 5;//count( $sdef['linee'] );						// altezza del logo
        $lgn		= 'T';								// posizione del testo dopo il logo
    
        // testi
        $tx[0] = "Gentile Cliente, per le prestazioni qui di seguito dettagliate richiediamo gentilmente il pagamento come sotto indicato secondo le modalità specificate:\n";
        $tx[1] = $dati['doc']['note'];
        $tx[8] = "Il presente documento non costituisce in maniera assoluta fattura ai sensi dell’art. 21 del D.P.R. 633/72 e quindi non genera esigibilità di imposta per il prestatore.\n";
        $tx[9] = "Trattasi di documento emesso in relazione al pagamento di corrispettivi di operazioni assoggettate ad imposta sul valore aggiunto (art.6, comma 2, del D.P.R. 642/72). Contestualmente al pagamento, verrà emessa regolare fattura con evidenziazione dell’IVA.\n";
        $tx[10] = "ALLEGATO A";
        $tx[11] = "DETTAGLIO RIGHE";
    
        // carattere di base
        $pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione
    
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
    
        // aggiunta di una pagina
        $pdf->AddPage();								// richiesto perché si è disattivato l'automatismo
    
        // debug
        // var_dump( $dati['sri']['logo'] );

        // inserisco il logo in alto a sinistra
        if( ! empty( $dati['sri']['logo'] ) ) {
            $pdf->image( $dati['sri']['logo'], $ml, $mt, $lgw, $lgh, NULL, NULL, $lgn, false, 300, '', false, false, 1, true );		// x, y, w, h, type, link, align, resize
            $tmp = $pdf->GetX() + $stdsp * 3;								// margine provvisorio in base alla larghezza del logo
        } else {
            $tmp = $ml;
        }

        // intestazione azienda emittente
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        foreach( $sdef['linee'] as $k => $sdel ) {
            if( $k !== key( $sdef['linee'] ) ) { $pdf->SetFont( $fnt, '', $fnts ); }		// font, stile, dimensione
            $pdf->Text( $tmp, $pdf->GetY(), $sdel, false, false, true, 0, 1 );		// x, y, testo, outline, clip, fill, border, newline
        }

        // spazio sotto l'intestazione
        $pdf->SetY( $pdf->GetY() + $stdsp * 3 );

        // intestazione cliente
        $tmp = $pdf->GetX();								// margine provvisorio in base alla larghezza del logo
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        foreach( $sdc as $k => $sdcl ) {
            if( $k !== key( $sdc ) ) { $pdf->SetFont( $fnt, '', $fnts ); }		// font, stile, dimensione
            $pdf->Text( $tmp, $pdf->GetY(), $sdcl, false, false, true, 0, 1, 'R' );	// x, y, testo, outline, clip, fill, border, newline, allineamento
        }

        // linea per la piega
        $pdf->Line( 0, 99, 20, 99, $brdc );

        // spazio sotto l'intestazione
        $pdf->SetY( $pdf->GetY() + $stdsp * 2 );

        // oggetto del documento
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 2, 0, 'oggetto:', 0, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 11, 0, $dati['doc']['oggetto'], 0, 1 );					// larghezza, altezza, testo, bordo, newline, allineamento

        // spazio sotto l'oggetto
        $pdf->SetY( $pdf->GetY() + $stdsp * 3 );

        // primo paragrafo
        $pdf->MultiCell( $wport, $lh, $tx[0] );						// w, h, testo

        // spazio sotto il primo paragrafo
        $pdf->SetY( $pdf->GetY() + $stdsp );

        // intestazione tabella di dettaglio
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'q.tà', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'udm', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'p. unitario', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento

        // contatore delle eventuali righe aggregate per generare l'eventuale allegato "dettaglio aggregate"
        $countAggregate = 0;

        // tabella di dettaglio
        $pdf->SetFont( $fnt, '', $fnts );										// font, stile, dimensione

        // righe della tabella di dettaglio
        foreach( $dati['doc']['righe'] as $row ) {

            $trh = $pdf->GetStringHeight( $col * 4, $row['nome'], false, true, '', 'B' );				// calcolo l'altezza della riga
            $pdf->SetFont( $fnt, '', $fnts );
    /*
            // controllo se la riga di dettaglio entra nella parte rimanente del foglio
            if( ( $pdf->GetY()+$trh ) > ($pdf-> GetPageHeight() - 15)  ) {

                // aggiungo una pagina
                $pdf->AddPage(); 

                // intestazione tabella nel nuovo foglio
                $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
                $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'q.tà', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'udm', $brdh, 0, 'L' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'p. unitario', $brdh, 0, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'C' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );			// larghezza, altezza, testo, bordo, newline, allineamento

                // reimposto il font
                $pdf->SetFont( $fnt, '', $fnts );						// font, stile, dimensione

            }

            if( ! empty( $row['aggregate'] ) ) {
                $pdf->SetFont( $fnt, 'B', $fnts );
                $countAggregate += $row['aggregate'];
            }

            if( substr($row['nome'],0,1) === '*' ) {
                $pdf->SetFillColor(230, 230, 230);
            } else {
                $pdf->SetFillColor(255, 255, 255);
            }
    */
            $pdf->MultiCell( $col * 4, $lh, $row['nome'], $brdc, 'L', 0, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline

    //	    if( $row['nome'][0] === '*' ){$pdf->SetFillColor(255, 0, 0);} 
            $pdf->Cell( $col * 1, $trh, $row['quantita'], $brdc, 0, 'L', 0, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 1, $trh, $row['udm'], $brdc, 0, 'C', 0, '', 0, false, 'T', 'T' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 1, $trh, $row['importo_netto_unitario'] , $brdc, 0, 'R', 0, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 2, $trh, $row['importo_netto_totale'].' €', $brdc, 0, 'R', 0, '', 0, false, 'T', 'T' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 1, $trh, $row['importo_iva_totale'].' €', $brdc, 0, 'R', 0, '', 0, false, 'T', 'T' );				// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 2, $trh, $row['importo_lordo_totale'].' €', $brdc, 1, 'R', 0, '', 0, false, 'T', 'T' );			// larghezza, altezza, testo, bordo, newline, allineamento

        }

        // totale tabella di dettaglio
        $pdf->SetFont( $fnt, 'B', $fnts );										// font, stile, dimensione
        $pdf->Cell( $col * 7, 0, 'totali', 0, 0, 'L', false, '', 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
        $pdf->Cell( $col * 2, 0,  $dati['doc']['tot']['importo_netto_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 1, 0,  $dati['doc']['tot']['importo_iva_totale'].' €', 0, 0, 'R', false, '', 0 );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, $dati['doc']['tot']['importo_lordo_totale'].' €', 0, 1, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento

        // spazio sotto la tabella di dettaglio
        $pdf->SetY( $pdf->GetY() + $stdsp );

        // intestazione tabella IVA
        $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
        $pdf->Cell( $col * 1, 0, '', $brdh, 0, 'C' );					// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 4, 0, 'dettaglio IVA', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
        $pdf->Cell( $col * 2, 0, 'importo', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

        $pdf->SetFont( $fnt, '', $fnts );	
        if( isset($dati['doc']['iva']) ){									// font, stile, dimensione
        foreach( $dati['doc']['iva'] as $iva => $row ) {
            $trh = $pdf->GetStringHeight( $col * 4, $row['nome'], false, true, '', 'B' );				// 
            $pdf->Cell( $col * 1, $trh, $row['codice'], $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// w, h, testo, bordo, allineamento, riempimento, newline
            $pdf->MultiCell( $col * 4, $lh, $row['nome'], $brdc, 'L', false, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline
            $pdf->Cell( $col * 2, $trh, $row['tot'].' €', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
        }
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


        if(sizeof($dati['doc']['pagamenti'])>0){
            // intestazione tabella scadenze
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 2, 0, 'data scadenza', $brdh, 0, 'C' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 6, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->Cell( $col * 2, 0, 'importo', $brdh, 1, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento

            // tabella scadenze
            $pdf->SetFont( $fnt, '', $fnts );										// font, stile, dimensione
            foreach( $dati['doc']['pagamenti'] as $row ) {
                $nome = $row['nome'] . ( ( ! empty( $row['modalita'] ) ) ? ' tramite ' . $row['modalita'] : NULL ) . ( ( ! empty( $row['iban'] ) ) ? ' su ' . $row['iban'] : NULL );
                $trh = $pdf->GetStringHeight( $col * 6, $nome, false, true, '', 'B' );				// 
                $pdf->Cell( $col * 2, $trh, $row['data_italiana'], $brdc, 0, 'C', false, '', 0, false, 'T', 'T' );				// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->MultiCell( $col * 6, $lh, $nome, $brdc, 'L', false, 0 );					// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->Cell( $col * 2, $trh, number_format($row['importo_lordo_totale'], 2, ',', '.' ).' €', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
            }
        }

        if( $countAggregate > 0 ){
            // se sono presenti righe aggregate viene aggiunta la sezione di dettaglio 
            // impostazione margine inferiore della pagina
            $pdf->SetAutoPageBreak( true, $mt );
            $pdf->addPage();
        
            // primo paragrafo
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 11, 0, $tx[10], 0, 1,'C' );					// larghezza, altezza, testo, bordo, newline, allineamento
            $pdf->SetFont( $fnt, 'U', $fnts );						// font, stile, dimensione
            $pdf->Cell( $col * 11, 0, $tx[11], 0, 1 ,'C' );					// larghezza, altezza, testo, bordo, newline, allineamento

            // spazio sotto l'intestazione
            $pdf->SetY( $pdf->GetY() + $stdsp );

            foreach( $dati['doc']['righe'] as $row ) {
            
            $pdf->SetFont( $fnt, 'B', $fnts );						// font, stile, dimensione

            $pdf->SetY( $pdf->GetY() + $stdsp * 0.3 );

            if( isset( $row['aggregate'] ) && $row['aggregate'] > 0 ) {

                $aggregate = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT documenti_articoli.*,  '.
                    'iva.aliquota, iva.codice, iva.id AS id_iva, iva.nome AS nome_iva, iva.descrizione AS descrizione_iva, iva.codice AS codice_iva, '.
                    'udm.sigla AS udm FROM documenti_articoli '.
                    'LEFT JOIN reparti ON reparti.id = documenti_articoli.id_reparto '.
                    'LEFT JOIN iva ON iva.id = reparti.id_iva '.
                    'LEFT JOIN udm ON udm.id = documenti_articoli.id_udm '.
                    'WHERE documenti_articoli.id_genitore = ? ORDER BY documenti_articoli.data' ,
                    array( array( 's' => $row['id'] ) )
                );

                $pdf->SetFont( $fnt, 'I', $fnts );						// font, stile, dimensione

                $pdf->Cell( $col * 4, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'data', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento

                // tabella di dettaglio righe aggregate
                foreach( $aggregate  as $riga){

                    $riga['qtd'] = ( empty( $riga['quantita'] ) ) ? 1 : $riga['quantita'];
            
                    $riga['importo_netto_unitario']         = str_replace( ',', '.', round( ( $riga['importo_netto_totale'] ), 2 ) );
                    $riga['importo_netto_totale']           = str_replace( ',', '.', round( $riga['importo_netto_totale'] * $riga['qtd'] , 2 ) );
                    $riga['importo_iva_totale']             = str_replace( ',', '.', round( $riga['importo_netto_totale'] * ( $riga['aliquota'] / 100 ), 2 ) );
                    $riga['importo_lordo_totale']           = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] + $riga['importo_iva_totale'] ) );
                    $riga['aliquota']                       = str_replace( ',', '.', sprintf( '%0.2f', round( $riga['aliquota'], 2 ) ) );
            
                    $dati['doc']['tot']['importo_netto_totale']     += $riga['importo_netto_totale'];
                    $dati['doc']['tot']['importo_iva_totale']       += $riga['importo_iva_totale'];
                    $dati['doc']['tot']['importo_lordo_totale']     += $riga['importo_lordo_totale'];
            
                    if( isset( $dati['doc']['iva'][ $riga['id_iva'] ]['tot'] ) ) {
                        $dati['doc']['iva'][ $riga['id_iva'] ]['imponibile_tot'] += $riga['importo_netto_totale'];
                        $dati['doc']['iva'][ $riga['id_iva'] ]['tot'] += $riga['importo_iva_totale'];
                    } else {
                        $dati['doc']['iva'][ $riga['id_iva'] ] = array(
                            'tot' => $riga['importo_iva_totale'],
                            'imponibile_tot' => str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] ) ),
                            'nome' => $riga['nome_iva'],
                            'codice' => $riga['codice_iva'],
                            'aliquota' => str_replace( ',', '.', sprintf( '%0.2f', $riga['aliquota'] ) ),
                            'riferimento' => ( ( ! empty( $riga['descrizione_iva'] ) ) ? $riga['descrizione_iva'] : NULL )
                        );
                    }
            
                    $riga['importo_netto_unitario']                     = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_unitario'] ) );
                    $riga['importo_netto_totale']                       = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_netto_totale'] ) );
                    $riga['importo_iva_totale']                         = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_iva_totale'] ) );
                    $riga['importo_lordo_totale']                       = str_replace( ',', '.', sprintf( '%0.2f', $riga['importo_lordo_totale'] ) );
                    $dati['doc']['iva'][ $riga['id_iva'] ]['imponibile_tot']    = str_replace( ',', '.', sprintf( '%0.2f', round( $dati['doc']['iva'][ $riga['id_iva'] ]['imponibile_tot'], 2 ) ) );
                    $dati['doc']['iva'][ $riga['id_iva'] ]['tot']               = str_replace( ',', '.', sprintf( '%0.2f', round( $dati['doc']['iva'][ $riga['id_iva'] ]['tot'], 2 ) ) );

                    $trh = $pdf->GetStringHeight( $col * 4, $riga['nome'], false, true, '', 'B' );				// 
                    $pdf->SetFont( $fnt, '', $fnts );
                    $pdf->MultiCell( $col * 4, $lh, $riga['nome'], $brdc, 'L', false, 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
                    $pdf->Cell( $col * 2, $trh, date("d/m/Y",strtotime( $riga['data'])), $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 2, $trh, $riga['importo_netto_totale'].' €', $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 1, $trh, $riga['aliquota'] . '%', $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );		// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 1, $trh, $riga['importo_iva_totale'].' €', $brdc, 0, 'R', false, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento
                    $pdf->Cell( $col * 2, $trh, $riga['importo_lordo_totale'].' €', $brdc, 1, 'R', false, '', 0, false, 'T', 'T' );	// larghezza, altezza, testo, bordo, newline, allineamento

                }

                // totale righe aggregate
                $pdf->SetFont( $fnt, 'B', $fnts );								// font, stile, dimensione
                $pdf->MultiCell( $col * 6, 0, $row['nome'], 0, 'L', false, 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->Cell( $col * 2, 0, $row['importo_netto_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_iva_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_lordo_totale'].' €', 0, 1, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento

            } else {
                $pdf->SetFont( $fnt, 'I', $fnts );						// font, stile, dimensione
                $pdf->Cell( $col * 5, 0, 'descrizione', $brdh, 0, 'L' );			// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 1, 0, 'data', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. netto', $brdh, 0, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'IVA', $brdh, 0, 'C' );				// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, 'tot. lordo', $brdh, 1, 'R' );				// larghezza, altezza, testo, bordo, newline, allineamento
        
                // dettaglio riga
                $pdf->SetFont( $fnt, 'B', $fnts );								// font, stile, dimensione
                $pdf->MultiCell( $col * 5, 0, $row['nome'], 0, 'L', false, 0 );						// w, h, testo, bordo, allineamento, riempimento, newline
                $pdf->Cell( $col * 1, 0, date("d/m/Y",strtotime( $row['data'])), 0, 0, 'L', false, '', 0 );	// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_netto_totale'].' €', 0, 0, 'R', false, '', 0 );	// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_iva_totale'].' €', 0, 0, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
                $pdf->Cell( $col * 2, 0, $row['importo_lordo_totale'].' €', 0, 1, 'R', false, '', 0 );		// larghezza, altezza, testo, bordo, newline, allineamento
        
            }
            $pdf->SetY( $pdf->GetY() + $stdsp *1.5 );
            }

        }

    }
