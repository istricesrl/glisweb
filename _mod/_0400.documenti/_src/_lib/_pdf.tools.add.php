<?php

    /**
     * Sedi del documento: risoluzione e riparazione al volo.
     *
     * `documenti.id_sede_emittente` / `id_sede_destinatario` vengono valorizzate una volta sola,
     * al momento dell'emissione, da `trovaIdSedeLegale()`. Se in quel momento l'anagrafica non ha
     * ancora un indirizzo utilizzabile il campo resta NULL, e la stampa muore in
     * `generaContenutiDocumento()` ( `_mod/_0400.documenti/_src/_lib/_mysql.utils.add.php` ), dove
     * la query filtra su `anagrafica_indirizzi.id` e con NULL non torna righe: "richiesto
     * indirizzo sede destinatario". Aggiungere l'indirizzo in anagrafica DOPO non ripara niente,
     * perché nessun flusso torna indietro a riempire il puntatore: quel documento resta non
     * stampabile per sempre, mentre i successivi della stessa anagrafica escono senza problemi.
     *
     * Le due funzioni qui sotto chiudono il buco a valle, in stampa, e sono idempotenti: al
     * secondo giro la sede è valida e non si scrive niente.
     *
     * @file
     */
    if( ! function_exists( 'documentoIdSedeStampabile' ) ) {

        /**
         * `anagrafica_indirizzi.id` di un'anagrafica utilizzabile come sede di un documento
         *
         * Gli INNER JOIN replicano quelli della query di stampa ( comune → provincia → regione →
         * stato ): un indirizzo senza comune verrebbe scartato lì, quindi non va scelto qui. È la
         * differenza con `trovaIdSedeLegale()`, che guarda solo `id_ruolo IN ( 1, 4 )` e può
         * restituire una riga che poi la stampa non sa rendere.
         *
         * L'ORDER BY preferisce comunque le sedi legali e di fatturazione, e a parità prende la
         * più vecchia, per stabilità fra ristampe.
         *
         * @param       integer         $idAnagrafica
         * @return      integer|null
         */
        function documentoIdSedeStampabile( $idAnagrafica ) {

            global $cf;

            if( empty( $idAnagrafica ) ) {
                return null;
            }

            return mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT anagrafica_indirizzi.id
                   FROM anagrafica_indirizzi
                   INNER JOIN comuni ON comuni.id = anagrafica_indirizzi.id_comune
                   INNER JOIN provincie ON provincie.id = comuni.id_provincia
                   INNER JOIN regioni ON regioni.id = provincie.id_regione
                   INNER JOIN stati ON stati.id = regioni.id_stato
                  WHERE anagrafica_indirizzi.id_anagrafica = ?
                  ORDER BY ( anagrafica_indirizzi.id_ruolo IN ( 1, 4 ) ) DESC, anagrafica_indirizzi.id ASC
                  LIMIT 1',
                array( array( 's' => $idAnagrafica ) )
            );

        }

    }

    if( ! function_exists( 'sedeStampabileAnagrafica' ) ) {

        /**
         * riga della sede di un'anagrafica, nei campi che servono alla stampa
         *
         * Restituisce sempre le stesse chiavi — tipologia, indirizzo, civico, cap, comune,
         * provincia, sigla_stato — qualunque sia lo schema sotto, così i generatori che la
         * chiamano non devono sapere da dove arriva il dato.
         *
         * Dalla migrazione del 2026-07-10 l'indirizzo sta per esteso su `anagrafica_indirizzi` ed
         * è quella la fonte: `indirizzi` resta la tabella deduplicata, collegata da
         * `id_indirizzo`, ma non è più il posto da cui si legge. Sui deploy fermi allo schema
         * precedente le colonne inline non esistono e si ripiega sulla lettura storica dal
         * collegato — vedi `anagraficaIndirizziInline()`.
         *
         * Di norma una sede senza comune non è stampabile e viene scartata. Con `$tollerante` la
         * catena comune → stato passa in LEFT JOIN e la sede torna anche incompleta, con quei
         * campi vuoti: è il comportamento storico delle `_packing` sulla sede del destinatario,
         * dove un indirizzo parziale sulla bolla è meglio di nessun indirizzo.
         *
         * @param       integer     $idAnagrafica
         * @param       boolean     $soloSedeLegale     limita alle righe con ruolo di sede legale
         * @param       boolean     $tollerante         restituisce anche le sedi senza comune
         * @return      array                           riga della sede, vuota se non ce n'è una completa
         */
        function sedeStampabileAnagrafica( $idAnagrafica, $soloSedeLegale = false, $tollerante = false ) {

            global $cf;

            if( empty( $idAnagrafica ) ) {
                return array();
            }

            $join = ( $tollerante ) ? 'LEFT JOIN ' : 'INNER JOIN ';

            if( anagraficaIndirizziInline() ) {

                return mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT tipologie_indirizzi.nome AS tipologia, anagrafica_indirizzi.indirizzo, '.
                    'anagrafica_indirizzi.civico, anagrafica_indirizzi.cap, '.
                    'comuni.nome AS comune, provincie.sigla AS provincia, '.
                    'stati.iso31661alpha2 AS sigla_stato '.
                    'FROM anagrafica_indirizzi '.
                    ( ( $soloSedeLegale ) ? 'INNER JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo ' : '' ).
                    'LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = anagrafica_indirizzi.id_tipologia '.
                    $join.'comuni ON comuni.id = anagrafica_indirizzi.id_comune '.
                    $join.'provincie ON provincie.id = comuni.id_provincia '.
                    $join.'regioni ON regioni.id = provincie.id_regione '.
                    $join.'stati ON stati.id = regioni.id_stato '.
                    'WHERE anagrafica_indirizzi.id_anagrafica = ? '.
                    ( ( $soloSedeLegale ) ? 'AND ruoli_indirizzi.se_sede_legale = 1 ' : '' ),
                    array( array( 's' => $idAnagrafica ) )
                );

            }

            return mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT tipologie_indirizzi.nome AS tipologia, indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, '.
                'comuni.nome AS comune, provincie.sigla AS provincia, '.
                'stati.iso31661alpha2 AS sigla_stato '.
                'FROM anagrafica_indirizzi '.
                ( ( $soloSedeLegale ) ? 'INNER JOIN ruoli_indirizzi ON ruoli_indirizzi.id = anagrafica_indirizzi.id_ruolo ' : '' ).
                $join.'indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo '.
                $join.'tipologie_indirizzi ON tipologie_indirizzi.id = indirizzi.id_tipologia '.
                $join.'comuni ON comuni.id = indirizzi.id_comune '.
                $join.'provincie ON provincie.id = comuni.id_provincia '.
                $join.'regioni ON regioni.id = provincie.id_regione '.
                $join.'stati ON stati.id = regioni.id_stato '.
                'WHERE anagrafica_indirizzi.id_anagrafica = ? '.
                ( ( $soloSedeLegale ) ? 'AND ruoli_indirizzi.se_sede_legale = 1 ' : '' ),
                array( array( 's' => $idAnagrafica ) )
            );

        }

    }

    if( ! function_exists( 'assicuraSediDocumento' ) ) {

        /**
         * ripara, se serve, `documenti.id_sede_emittente` e `id_sede_destinatario`
         *
         * Una sede memorizzata è tenuta buona solo se punta ancora a un indirizzo DELL'ANAGRAFICA
         * del documento e completo di comune: così si intercettano anche i puntatori azzerati
         * dalla chiave esterna ON DELETE SET NULL e quelli rimasti appesi a un'anagrafica diversa
         * dopo una fusione di schede.
         *
         * La scrittura è necessaria — non basta calcolare il valore in memoria — perché
         * `generaContenutiDocumento()` rilegge il documento dal database.
         *
         * @param       integer     $idDocumento
         * @return      array       array( 'emittente' => id|null, 'destinatario' => id|null )
         */
        function assicuraSediDocumento( $idDocumento ) {

            global $cf;

            $sedi = array( 'emittente' => null, 'destinatario' => null );

            if( empty( $idDocumento ) ) {
                return $sedi;
            }

            $doc = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT id, id_emittente, id_sede_emittente, id_destinatario, id_sede_destinatario
                   FROM documenti WHERE id = ?',
                array( array( 's' => $idDocumento ) )
            );

            if( empty( $doc ) ) {
                return $sedi;
            }

            foreach( array( 'emittente', 'destinatario' ) as $ruolo ) {

                $idAnagrafica = $doc[ 'id_' . $ruolo ];
                $idSede       = $doc[ 'id_sede_' . $ruolo ];

                // la sede già memorizzata è ancora utilizzabile?
                $valida = null;
                if( ! empty( $idSede ) && ! empty( $idAnagrafica ) ) {
                    $valida = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT anagrafica_indirizzi.id
                           FROM anagrafica_indirizzi
                           INNER JOIN comuni ON comuni.id = anagrafica_indirizzi.id_comune
                           INNER JOIN provincie ON provincie.id = comuni.id_provincia
                           INNER JOIN regioni ON regioni.id = provincie.id_regione
                           INNER JOIN stati ON stati.id = regioni.id_stato
                          WHERE anagrafica_indirizzi.id = ? AND anagrafica_indirizzi.id_anagrafica = ?',
                        array( array( 's' => $idSede ), array( 's' => $idAnagrafica ) )
                    );
                }

                if( ! empty( $valida ) ) {
                    $sedi[ $ruolo ] = $valida;
                    continue;
                }

                // ne cerco una valida sull'anagrafica del documento
                $nuova = documentoIdSedeStampabile( $idAnagrafica );

                if( empty( $nuova ) ) {
                    // niente da fare: l'indirizzo in anagrafica manca davvero
                    continue;
                }

                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE documenti SET id_sede_' . $ruolo . ' = ? WHERE id = ?',
                    array( array( 's' => $nuova ), array( 's' => $idDocumento ) )
                );

                logWrite(
                    'sede ' . $ruolo . ' del documento #' . $idDocumento . ' riparata in stampa: '
                    . ( empty( $idSede ) ? 'NULL' : '#' . $idSede ) . ' -> #' . $nuova
                    . ' ( anagrafica #' . $idAnagrafica . ' )',
                    'documenti',
                    LOG_NOTICE      // a LOG_DEBUG il messaggio verrebbe filtrato da LOG_CURRENT_LEVEL
                );

                $sedi[ $ruolo ] = $nuova;

            }

            return $sedi;

        }

    }

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
        $dati['doc']['oggetto'] = $dati['doc']['tipologia'] . ' n. ' . numeroDocumentoFattura( $dati['doc']['numero'], $dati['doc']['sezionale'] ?? '', $dati['doc']['data'] ) . ' del ' . strftime( '%d %B %Y', strtotime( $dati['doc']['data'] ) );

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

            // lo sconto della riga si scrive accanto alla descrizione: quantita' per prezzo unitario danno il prezzo prima
            // dello sconto, il totale e' gia' scontato
            if( ! empty( $row['sconto_netto'] ) && $row['sconto_netto'] > 0 ) {
                $row['nome'] .= ' ( sconto ' . number_format( $row['sconto_netto'], 2, ',', '.' ) . ' € )';
            }

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

        // contributi alle casse previdenziali e ritenute, come nella fattura elettronica ( _fattura.xml.php ): il contributo
        // si aggiunge al totale e la sua IVA va nel dettaglio IVA, la ritenuta si toglie dal totale e da' il netto a pagare
        $totaleDocumento = $dati['doc']['tot']['importo_lordo_totale'];
        $pdf->SetFont( $fnt, '', $fnts );										// font, stile, dimensione
        foreach( $dati['doc']['casse'] ?? array() as $cassa ) {
            $pdf->Cell( $col * 7, 0, 'contributo ' . ( $cassa['nome_cassa'] ?? $cassa['codice_cassa'] ) . ' ' . number_format( $cassa['aliquota'], 2, ',', '.' ) . '% su ' . number_format( $cassa['imponibile'], 2, ',', '.' ) . ' €', 0, 0, 'L', false, '', 1 );
            $pdf->Cell( $col * 2, 0, $cassa['importo'].' €', 0, 0, 'R', false, '', 0 );
            $pdf->Cell( $col * 1, 0, $cassa['importo_iva'].' €', 0, 0, 'R', false, '', 0 );
            $pdf->Cell( $col * 2, 0, sprintf( '%0.2f', $cassa['importo'] + $cassa['importo_iva'] ).' €', 0, 1, 'R', false, '', 0 );
            if( isset( $dati['doc']['iva'][ $cassa['id_iva'] ] ) ) {
                $dati['doc']['iva'][ $cassa['id_iva'] ]['tot'] = sprintf( '%0.2f', $dati['doc']['iva'][ $cassa['id_iva'] ]['tot'] + $cassa['importo_iva'] );
            } elseif( ! empty( $cassa['id_iva'] ) ) {
                $dati['doc']['iva'][ $cassa['id_iva'] ] = array( 'codice' => $cassa['codice_iva'], 'nome' => $cassa['nome_iva'], 'tot' => $cassa['importo_iva'] );
            }
            $totaleDocumento += $cassa['importo'] + $cassa['importo_iva'];
        }
        if( ! empty( $dati['doc']['casse'] ) ) {
            $pdf->SetFont( $fnt, 'B', $fnts );
            $pdf->Cell( $col * 10, 0, 'totale documento', 0, 0, 'L', false, '', 0 );
            $pdf->Cell( $col * 2, 0, sprintf( '%0.2f', $totaleDocumento ).' €', 0, 1, 'R', false, '', 0 );
            $pdf->SetFont( $fnt, '', $fnts );
        }
        $totaleRitenute = 0;
        foreach( $dati['doc']['ritenute'] ?? array() as $ritenuta ) {
            $pdf->Cell( $col * 10, 0, ( $ritenuta['nome_ritenuta'] ?? $ritenuta['codice_ritenuta'] ) . ' ' . number_format( $ritenuta['aliquota'], 2, ',', '.' ) . '%', 0, 0, 'L', false, '', 1 );
            $pdf->Cell( $col * 2, 0, '-' . $ritenuta['importo'].' €', 0, 1, 'R', false, '', 0 );
            $totaleRitenute += $ritenuta['importo'];
        }
        if( ! empty( $dati['doc']['ritenute'] ) ) {
            $pdf->SetFont( $fnt, 'B', $fnts );
            $pdf->Cell( $col * 10, 0, 'netto a pagare', 0, 0, 'L', false, '', 0 );
            $pdf->Cell( $col * 2, 0, sprintf( '%0.2f', $totaleDocumento - $totaleRitenute ).' €', 0, 1, 'R', false, '', 0 );
        }

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

    function generaCopertinaMissionePdf( &$pdf, $dati, $cnf = array() ) {

        /**
         * SEZIONE DI CONFIGURAZIONE
         * qui vengono dichiarati e impostati i valori e i dati che verranno
         * poi visualizzati nel PDF
         */

        // oggetto del documento
        $dati['doc']['oggetto'] = $dati['doc']['tipologia'] . ' n. ' . $dati['doc']['codice'] . ' del ' .  @strftime( '%d %B %Y', strtotime( $dati['doc']['data'] ) );

        // titolo del documento
        $pdf->SetTitle( $dati['doc']['oggetto'] );

        // dimensioni pagina
        $etc['pag']['size']['h']		            = 297;								                // altezza del foglio
        $etc['pag']['size']['w']		            = 210;								                // larghezza del foglio
        $etc['pag']['margin']['t']		            = 15;								                // margine superiore
        $etc['pag']['margin']['l']		            = 15;								                // margine sinistro
        $etc['pag']['margin']['r']		            = 15;								                // margine destro
        $etc['pag']['margin']['b']		            = 15;								                // margine inferiore
        $etc['pag']['spacer']['base']		        = 5;								                // spaziatore standard

        // tipografia
        $etc['fnt']['base']['family']		        = 'helvetica';						                // famiglia del font base
        $etc['fnt']['base']['style']		        = '';						                        // stile del font base
        $etc['fnt']['base']['size']		            = 10;								                // dimensione del font base

        $etc['fnt']['orari']['family']		        = 'helvetica';						                // famiglia del font base
        $etc['fnt']['orari']['style']		        = 'B';						                        // stile del font base
        $etc['fnt']['orari']['size']		        = 10;								                // dimensione del font base

        $etc['fnt']['intestazione'][0]['family']    = 'helvetica';						                // famiglia del font base
        $etc['fnt']['intestazione'][0]['style']	    = 'B';						                        // stile del font base
        $etc['fnt']['intestazione'][0]['size']	    = 24;								                // dimensione del font base

        $etc['fnt']['intestazione'][1]['family']    = 'helvetica';						                // famiglia del font base
        $etc['fnt']['intestazione'][1]['style']	    = 'B';						                        // stile del font base
        $etc['fnt']['intestazione'][1]['size']	    = 12;								                // dimensione del font base

        $etc['fnt']['intestazione'][2]['family']    = 'helvetica';						                // famiglia del font base
        $etc['fnt']['intestazione'][2]['style']	    = '';						                        // stile del font base
        $etc['fnt']['intestazione'][2]['size']	    = 10;								                // dimensione del font base

        $etc['fnt']['copia']['family']		        = 'helvetica';						                // famiglia del font base
        $etc['fnt']['copia']['style']		        = '';						                        // stile del font base
        $etc['fnt']['copia']['size']		        = 9;								                // dimensione del font base

        // spessori linee
        $etc['thk']['base']		                    = .3;								                // spessore linea standard
        $etc['thk']['sottile']	                    = .15;								                // spessore linea sottile

        // colori
        $etc['rgb']['nero']		                    = array( 0, 0, 0 );					                // il nero
        $etc['rgb']['grigio_medio']		            = array( 128, 128, 128 );			                // grigio
        $etc['rgb']['grigio']		                = array( 128, 128, 128 );			                // grigio
        $etc['rgb']['bianco']		                = array( 255, 255, 255 );			                // il bianco

        // bordi delle celle
        $etc['tbl']['celle']['intestazione']		= array( 'B' => array( 'width' => $etc['thk']['base'], 'color' => $etc['rgb']['nero'], 'dash' => false ) );
        $etc['tbl']['celle']['dati']		        = array( 'B' => array( 'width' => $etc['thk']['sottile'], 'color' => $etc['rgb']['grigio'], 'dash' => false ) );

        // padding delle celle
        $etc['tbl']['celle']['base']['pad']['T']    = 2;
        $etc['tbl']['celle']['base']['pad']['B']    = 2;
        $etc['tbl']['celle']['base']['pad']['L']    = 2;
        $etc['tbl']['celle']['base']['pad']['R']    = 2;

        $etc['tbl']['celle']['head']['pad']['T']    = 0;
        $etc['tbl']['celle']['head']['pad']['B']    = 0;
        $etc['tbl']['celle']['head']['pad']['L']    = 2;
        $etc['tbl']['celle']['head']['pad']['R']    = 2;

        // linee
        $etc['lne']['taglio']                       = array( 'width' => $etc['thk']['sottile'], 'dash' => '10,5', 'color' => $etc['rgb']['grigio_medio'] );

        // testi
        $etc['txt']['intestazione'][0]              = 'copertina missione';

        // immagini
        $etc['img']['logo']['path']                 = DIR_BASE . 'src/templates/athena/img/logoMasi.jpg';
        $etc['img']['logo']['w']                    = '50';
        $etc['img']['logo']['h']                    = '50';

        // barcode
        $etc['bcd']['principale'] = array(
            'position' => '',
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
            'fontsize' => 16,
            'stretchtext' => 0
        );

        /**
         * ELABORAZIONE IMPOSTAZIONI
         * nessun valore o impostazione va modificato oltre questo punto
         */

        // unisco le impostazioni custom a quelle di base
        $etc = array_replace_recursive( $etc, $cnf );

        // centro orizzontale della pagina
        $etc['pag']['center']['x']                  = $etc['pag']['size']['w'] / 2;

        // centro verticale della pagina
        $etc['pag']['center']['y']                  = $etc['pag']['size']['h'] / 2;

        // larghezza dell'area del testo
        $etc['pag']['size']['text_area']['w']		= $etc['pag']['size']['w'] - ( $etc['pag']['margin']['l'] + $etc['pag']['margin']['r'] );

        // altezza dell'area del testo
        $etc['pag']['size']['text_area']['h']		= $etc['pag']['size']['h'] - ( $etc['pag']['margin']['t'] + $etc['pag']['margin']['b'] );

        // larghezza colonna base
        $etc['pag']['spacer']['col']		        = $etc['pag']['size']['text_area']['w'] / 12;

        // altezza riga base
        $etc['pag']['spacer']['row']		        = $etc['pag']['size']['text_area']['h'] / 36;

        // altezza stimata della linea di testo
        $etc['fnt']['base']['line']['height']		= $pdf->getStringHeight( $etc['pag']['size']['h'], 'a' );

        // rendering dei testi
        twigRenderText( $etc['txt'], $dati );

        // debug
        // die( print_r( $dati, true ) );
        // die( print_r( $etc['txt'], true ) );

        /**
         * IMPOSTAZIONE PAGINA
         * nessun valore o impostazione va modificato oltre questo punto
         */

        // carattere di base
        $pdf->SetFont( $etc['fnt']['base']['family'], $etc['fnt']['base']['style'], $etc['fnt']['base']['size'] );

        // imposto il PDF per non stampare l'header e il footer
        $pdf->SetPrintHeader( false );
        $pdf->SetPrintFooter( false );

        // imposto i margini
        $pdf->SetMargins( $etc['pag']['margin']['l'], $etc['pag']['margin']['t'], $etc['pag']['margin']['r'] );

        // margine dell'intestazione
        $pdf->SetHeaderMargin( 0 );

        // margine del footer
        $pdf->SetFooterMargin( 0 );

        // imposto il font monospaziato di default
        $pdf->SetDefaultMonospacedFont( PDF_FONT_MONOSPACED );

        // imposto l'aggiunta automatica di pagine quando il contenuto raggiunge il margine inferiore
        $pdf->SetAutoPageBreak( true, $etc['pag']['margin']['b'] );

        // fattore di conversione da pixel a millimetri
        $pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );

        // aggiunta della prima pagina
        $pdf->AddPage();

        /**
         * INIZIO INSERIMENTO CONTENUTI
         * nessuna logica va aggiunta oltre questo punto, nessun valore va modificato oltre questo punto
         * d'ora in poi vengono solo aggiunti gli elementi al PDF
         */

        // posizione barcode
        $pdf->SetXY( $etc['pag']['margin']['l'] + $etc['pag']['spacer']['col'] * 0, $etc['pag']['margin']['t'] );

        // barcode
        $pdf->write1DBarcode( $dati['doc']['codice'], 'C128', '', '', '', 25, 0.4, $etc['bcd']['principale'], 'N');

        // posizione dell'intestazione
        $pdf->SetXY( $etc['pag']['margin']['l'] + $etc['pag']['spacer']['col'] * 5, $etc['pag']['margin']['t'] );

        // stile intestazione
        $pdf->SetFont( $etc['fnt']['intestazione'][0]['family'], $etc['fnt']['intestazione'][0]['style'], $etc['fnt']['intestazione'][0]['size'] );

        // padding delle celle
        $pdf->setCellPaddings(
            $etc['tbl']['celle']['head']['pad']['L'],	// left
            $etc['tbl']['celle']['head']['pad']['T'],	// top
            $etc['tbl']['celle']['head']['pad']['R'],	// right
            $etc['tbl']['celle']['head']['pad']['B']	// bottom
        );

        // intestazione riga 1
        $pdf->Cell(
            $etc['pag']['spacer']['col'] * 5,           // larghezza
            0,                                          // altezza
            $etc['txt']['intestazione'][0],             // testo
            '',                                         // bordo
            2,                                          // newline (0 -> nessuna, 1 -> tutto a sx, 2 -> sotto la cella precedente)
            'L'                                         // allineamento
        );

        // stile intestazione 2
        $pdf->SetFont( $etc['fnt']['intestazione'][1]['family'], $etc['fnt']['intestazione'][1]['style'], $etc['fnt']['intestazione'][1]['size'] );

        // intestazione riga 2
        $pdf->Cell(
            $etc['pag']['spacer']['col'] * 5,           // larghezza
            0,                                          // altezza
            $dati['doc']['data'],                       // testo
            '',                                         // bordo
            2,                                          // newline (0 -> nessuna, 1 -> tutto a sx, 2 -> sotto la cella precedente)
            'L'                                         // allineamento
        );

        // posizione tabella righe
        $pdf->SetXY( $etc['pag']['margin']['l'] + $etc['pag']['spacer']['col'] * 0, $etc['pag']['margin']['t'] + $etc['pag']['spacer']['row'] * 4 );

        // stile intestazione tabella righe
        $pdf->SetFont( $etc['fnt']['intestazione'][1]['family'], $etc['fnt']['intestazione'][1]['style'], $etc['fnt']['intestazione'][1]['size'] );

        // padding delle celle
        $pdf->setCellPaddings(
            $etc['tbl']['celle']['base']['pad']['L'],	// left
            $etc['tbl']['celle']['base']['pad']['T'],	// top
            $etc['tbl']['celle']['base']['pad']['R'],	// right
            $etc['tbl']['celle']['base']['pad']['B']	// bottom
        );

        // intestazione tabella righe
        $pdf->Cell( $etc['pag']['spacer']['col'] * 3, 0, 'collocazione', $etc['tbl']['celle']['intestazione'], '', 'C' );
        $pdf->Cell( $etc['pag']['spacer']['col'] * 1, 0, 'codice', $etc['tbl']['celle']['intestazione'], '', 'C' );
        $pdf->Cell( $etc['pag']['spacer']['col'] * 6, 0, 'descrizione', $etc['tbl']['celle']['intestazione'], 0, 'L' );
        $pdf->Cell( $etc['pag']['spacer']['col'] * 2, 0, 'q.tà', $etc['tbl']['celle']['intestazione'], 1, 'R' );

        // stile riga tabella
        $pdf->SetFont( $etc['fnt']['base']['family'], $etc['fnt']['base']['style'], $etc['fnt']['base']['size'] );

        // stile linea riga tabella
        $pdf->SetLineStyle( $etc['tbl']['celle']['dati'] );

        // righe del documento
        foreach( $dati['doc']['missione']['righe'] as $row ) {

            // calcolo altezza della riga
            $trh = $pdf->GetStringHeight( $etc['pag']['spacer']['col'] * 6, trim( $row['descrizione'] ), false, true, '', 'B' );

            // riga della tabella
            $pdf->Cell( $etc['pag']['spacer']['col'] * 3, $trh, $row['collocazione_breve'], $etc['tbl']['celle']['dati'], 0, 'C', false, '', 0, false, 'T', 'T' );
            $pdf->Cell( $etc['pag']['spacer']['col'] * 1, $trh, ( ! empty( $row['codice_articolo'] ) ) ? $row['codice_articolo'] : $row['id_articolo'], $etc['tbl']['celle']['dati'], 0, 'C', false, '', 0, false, 'T', 'T' );
            $pdf->MultiCell( $etc['pag']['spacer']['col'] * 6, $trh, $row['descrizione'], $etc['tbl']['celle']['dati'], 'L', false, 0 );
            $pdf->Cell( $etc['pag']['spacer']['col'] * 2, $trh, $row['qta_da_prelevare'], $etc['tbl']['celle']['dati'], 1, 'R', false, '', 0, false, 'T', 'T' );

        }

    }

    /**
     * genera il PDF di un documento e lo salva nel percorso indicato
     *
     * E' il punto d'ingresso unico delle stampe dei documenti: riceve l'id del documento e il percorso dove salvare
     * il file, raccoglie i dati con generaContenutiDocumento(), sceglie il modello, disegna, salva e annota
     * l'attivita' di stampa. Gli endpoint di /print/ e chi allega un documento a una mail non fanno altro che
     * chiamarla e poi, se serve, inviare il file al browser.
     *
     * Il modello si sceglie dalla colonna stampa_pdf della tipologia del documento; se e' vuota si guarda quella
     * della tipologia genitore, poi il modello predefinito del chiamante ( $etc['predefinito'], p.es. 'ddt' per
     * l'endpoint ddt.pdf ), e in mancanza anche di quello si usa il modello generico. Il nome del modello
     * diventa il nome della funzione che disegna: 'nota.credito' -> generaNotaCreditoPdf(). Per personalizzare la
     * stampa di una tipologia in un deploy basta quindi scrivere la propria funzione in
     * mod/0400.documenti/src/lib/pdf.tools.add.php e mettere il suo nome in stampa_pdf, oppure passare il modello
     * in $etc['modello'].
     *
     * @param       integer     $idDocumento    l'ID del documento
     * @param       string      $percorso       il percorso del file da scrivere, assoluto o relativo a DIR_BASE
     * @param       array       $etc            le impostazioni passate al modello; 'modello' forza il modello,
     *                                          'predefinito' lo indica quando la tipologia non ne dichiara uno
     *
     * @return      string|boolean              il percorso completo del file scritto, oppure false
     *
     */
    function generaDocumentoPdf( $idDocumento, $percorso, $etc = array() ) {

        // ...
        global $cf;

        // dati del documento
        $dati = generaContenutiDocumento( $idDocumento );

        // il documento deve esistere
        if( empty( $dati['doc']['id'] ) ) {
            logWrite( 'documento #' . $idDocumento . ' non trovato, stampa non generata', 'documenti', LOG_ERR );
            return false;
        }

        // modello forzato dal chiamante, poi quello della tipologia, poi quello della tipologia genitore
        $modello = ( ! empty( $etc['modello'] ) ) ? $etc['modello'] : $dati['doc']['stampa_pdf'];
        if( empty( $modello ) && ! empty( $dati['doc']['id_genitore_tipologia'] ) ) {
            $modello = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT stampa_pdf FROM tipologie_documenti WHERE id = ?',
                array( array( 's' => $dati['doc']['id_genitore_tipologia'] ) )
            );
        }

        // poi il predefinito del chiamante
        if( empty( $modello ) && ! empty( $etc['predefinito'] ) ) {
            $modello = $etc['predefinito'];
        }

        // il modello diventa il nome della funzione che disegna
        $funzione = 'genera' . str_replace( ' ', '', ucwords( str_replace( '.', ' ', $modello ) ) ) . 'Pdf';

        // un modello senza funzione ripiega sul generico, ma lo si dice: e' quasi sempre un refuso in stampa_pdf
        if( empty( $modello ) || ! function_exists( $funzione ) ) {
            if( ! empty( $modello ) ) {
                logWrite( 'modello di stampa ' . $modello . ' senza la funzione ' . $funzione . ', uso il generico', 'documenti', LOG_ERR );
            }
            $funzione = 'generaDocumentoGenericoPdf';
        }

        // il modello non e' un'impostazione del disegno
        unset( $etc['modello'], $etc['predefinito'] );

        // disegno il documento
        $pdf = new TCPDF( 'P', 'mm', 'A4' );
        $funzione( $pdf, $dati, $etc );

        // percorso completo e cartella
        $percorso = getFullPath( $percorso );
        checkFolder( dirname( $percorso ) );

        // salvo il file
        $pdf->Output( $percorso, 'F' );

        // l'attivita' si annota solo se il file c'e' davvero
        if( ! file_exists( $percorso ) ) {
            logWrite( 'stampa del documento #' . $idDocumento . ' non scritta in ' . $percorso, 'documenti', LOG_ERR );
            return false;
        }

        // annoto l'attivita' di stampa
        registraStampaDocumento( $idDocumento );

        // restituisco il percorso del file
        return $percorso;

    }

    /**
     * annota l'attivita' di stampa di un documento
     *
     * Scrive un'attivita' di tipologia 23 ( stampa ) collegata al documento, con l'account e l'anagrafica
     * dell'utente collegato se c'e'. Va chiamata DOPO aver scritto il file: un'attivita' annotata prima della
     * generazione resta anche quando la generazione fallisce.
     *
     * @param       integer     $idDocumento    l'ID del documento
     * @param       string      $nome           il nome dell'attivita'
     * @param       integer     $idTipologia    la tipologia dell'attivita' ( 23 stampa PDF, 24 esportazione XML )
     *
     * @return      integer|boolean             l'ID dell'attivita' inserita, oppure false
     *
     */
    function registraStampaDocumento( $idDocumento, $nome = 'stampa documento', $idTipologia = 23 ) {

        // ...
        global $cf;

        // inserisco l'attivita'
        $idAttivita = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => NULL,
                'id_tipologia' => $idTipologia,
                'id_documento' => $idDocumento,
                'id_anagrafica' => ( isset( $_SESSION['account']['id_anagrafica'] ) ) ? $_SESSION['account']['id_anagrafica'] : NULL,
                'id_account' => ( isset( $_SESSION['account']['id'] ) ) ? $_SESSION['account']['id'] : NULL,
                'data_attivita' => date( 'Y-m-d' ),
                'ora_inizio' => date( 'H:i:s' ),
                'ora_fine' => date( 'H:i:s' ),
                'nome' => $nome,
                'id_account_inserimento' => ( isset( $_SESSION['account']['id'] ) ) ? $_SESSION['account']['id'] : NULL,
                'timestamp_inserimento' => time()
            ),
            'attivita',
            false
        );

        // aggiorno la vista statica
        if( ! empty( $idAttivita ) && function_exists( 'updateAttivitaViewStatic' ) ) {
            updateAttivitaViewStatic( $idAttivita );
        }

        return $idAttivita;

    }

    /**
     * modello generico di stampa di un documento
     *
     * Disegna intestazione ( logo, codice a barre, emittente, destinatario, oggetto ), la tabella delle righe, i
     * totali, i dati del trasporto e le note. E' il modello di ripiego di generaDocumentoPdf() ed e' la base dei
     * modelli delle singole tipologie, che cambiano solo la configurazione: le colonne della tabella in
     * $etc['tbl']['colonne'] e le sezioni da mostrare in $etc['sez']. Ogni colonna e' un array con:
     *
     * chiave       | contenuto
     * -------------|-----------------------------------------------------------------------------------------------
     * campo        | la chiave della riga da stampare
     * titolo       | l'intestazione della colonna
     * w            | la larghezza, in dodicesimi dell'area del testo
     * align        | l'allineamento ( L, C, R )
     * formato      | 'importo' per due decimali e il simbolo dell'euro, 'quantita' per togliere gli zeri in coda
     *
     * Le righe che cominciano con un asterisco hanno lo sfondo grigio, e la quantita' delle righe che hanno
     * sottorighe e' in grassetto.
     *
     * @param       object      $pdf            l'oggetto TCPDF
     * @param       array       $dati           i dati del documento, da generaContenutiDocumento()
     * @param       array       $cnf            le impostazioni che sostituiscono quelle di base
     *
     * @return      void
     *
     */
    function generaDocumentoGenericoPdf( &$pdf, $dati, $cnf = array() ) {

        /**
         * SEZIONE DI CONFIGURAZIONE
         * qui vengono dichiarati e impostati i valori e i dati che verranno
         * poi visualizzati nel PDF
         */

        // dimensioni pagina
        $etc['pag']['size']['h']		            = 297;								                // altezza del foglio
        $etc['pag']['size']['w']		            = 210;								                // larghezza del foglio
        $etc['pag']['margin']['t']		            = 15;								                // margine superiore
        $etc['pag']['margin']['l']		            = 15;								                // margine sinistro
        $etc['pag']['margin']['r']		            = 15;								                // margine destro
        $etc['pag']['margin']['b']		            = 15;								                // margine inferiore
        $etc['pag']['spacer']['base']		        = 5;								                // spaziatore standard

        // tipografia
        $etc['fnt']['base']['family']		        = 'helvetica';						                // famiglia del font base
        $etc['fnt']['base']['style']		        = '';						                        // stile del font base
        $etc['fnt']['base']['size']		            = 10;								                // dimensione del font base

        // spessori linee
        $etc['thk']['base']		                    = .3;								                // spessore linea standard
        $etc['thk']['sottile']	                    = .15;								                // spessore linea sottile

        // colori
        $etc['rgb']['nero']		                    = array( 0, 0, 0 );					                // il nero
        $etc['rgb']['grigio']		                = array( 128, 128, 128 );			                // grigio
        $etc['rgb']['evidenza']		                = 230;								                // sfondo delle righe con l'asterisco
        $etc['rgb']['bianco']		                = 255;								                // sfondo delle altre righe

        // bordi delle celle
        $etc['tbl']['celle']['intestazione']		= array( 'B' => array( 'width' => $etc['thk']['base'], 'color' => $etc['rgb']['nero'], 'dash' => false ) );
        $etc['tbl']['celle']['dati']		        = array( 'B' => array( 'width' => $etc['thk']['sottile'], 'color' => $etc['rgb']['grigio'], 'dash' => false ) );

        // colonne della tabella delle righe
        $etc['tbl']['colonne'] = array(
            array( 'campo' => 'codice_articolo', 'titolo' => 'codice', 'w' => 2, 'align' => 'L' ),
            array( 'campo' => 'articolo', 'titolo' => 'descrizione', 'w' => 4, 'align' => 'L' ),
            array( 'campo' => 'quantita', 'titolo' => 'q.tà', 'w' => 1, 'align' => 'R', 'formato' => 'quantita' ),
            array( 'campo' => 'udm', 'titolo' => 'udm', 'w' => 1, 'align' => 'C' ),
            array( 'campo' => 'importo_netto_unitario', 'titolo' => 'prezzo', 'w' => 2, 'align' => 'R', 'formato' => 'importo' ),
            array( 'campo' => 'importo_netto_totale', 'titolo' => 'importo', 'w' => 2, 'align' => 'R', 'formato' => 'importo' )
        );

        // sezioni da mostrare
        $etc['sez']['barcode']                      = true;								                // codice a barre del documento
        $etc['sez']['totali']                       = true;								                // totali e riepilogo IVA
        $etc['sez']['trasporto']                    = true;								                // vettore, causale, colli, resa
        $etc['sez']['note']                         = true;								                // note per il cliente

        // testi
        $etc['txt']['oggetto']                      = '{{ doc.oggetto }}';				                // oggetto del documento
        $etc['txt']['note']                         = 'note per il cliente: ';			                // etichetta delle note

        // immagini
        $etc['img']['logo']['w']                    = 2;								                // larghezza del logo, in colonne
        $etc['img']['logo']['h']                    = 5;								                // altezza del logo, in righe

        // barcode
        $etc['bcd']['principale'] = array(
            'position' => 'R',
            'align' => 'C',
            'stretch' => false,
            'fitwidth' => true,
            'cellfitalign' => '',
            'border' => false,
            'hpadding' => 'auto',
            'vpadding' => 'auto',
            'fgcolor' => array( 0, 0, 0 ),
            'bgcolor' => false,
            'text' => true,
            'font' => 'helvetica',
            'fontsize' => 8,
            'stretchtext' => 4
        );

        /**
         * ELABORAZIONE IMPOSTAZIONI
         * nessun valore o impostazione va modificato oltre questo punto
         */

        // le colonne si sostituiscono intere: unite chiave per chiave ne resterebbero di quelle di base
        if( isset( $cnf['tbl']['colonne'] ) ) {
            $etc['tbl']['colonne'] = array();
        }

        // unisco le impostazioni custom a quelle di base
        $etc = array_replace_recursive( $etc, $cnf );

        // larghezza dell'area del testo
        $etc['pag']['size']['text_area']['w']		= $etc['pag']['size']['w'] - ( $etc['pag']['margin']['l'] + $etc['pag']['margin']['r'] );

        // larghezza colonna base
        $etc['pag']['spacer']['col']		        = $etc['pag']['size']['text_area']['w'] / 12;

        // rendering dei testi
        twigRenderText( $etc['txt'], $dati );

        // titolo del documento
        $pdf->SetTitle( $etc['txt']['oggetto'] );

        // scorciatoie
        $col = $etc['pag']['spacer']['col'];
        $ml = $etc['pag']['margin']['l'];
        $mt = $etc['pag']['margin']['t'];
        $stdsp = $etc['pag']['spacer']['base'];

        /**
         * IMPOSTAZIONE PAGINA
         * nessun valore o impostazione va modificato oltre questo punto
         */

        // carattere di base
        $pdf->SetFont( $etc['fnt']['base']['family'], $etc['fnt']['base']['style'], $etc['fnt']['base']['size'] );

        // imposto il PDF per non stampare l'header e il footer
        $pdf->SetPrintHeader( false );
        $pdf->SetPrintFooter( false );

        // imposto i margini
        $pdf->SetMargins( $ml, $mt, $etc['pag']['margin']['r'] );

        // margine dell'intestazione
        $pdf->SetHeaderMargin( 0 );

        // margine del footer
        $pdf->SetFooterMargin( 0 );

        // imposto il font monospaziato di default
        $pdf->SetDefaultMonospacedFont( PDF_FONT_MONOSPACED );

        // imposto l'aggiunta automatica di pagine quando il contenuto raggiunge il margine inferiore
        $pdf->SetAutoPageBreak( true, $etc['pag']['margin']['b'] );

        // fattore di conversione da pixel a millimetri
        $pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );

        // aggiunta della prima pagina
        $pdf->AddPage();

        // altezza stimata della linea di testo
        $lh = $pdf->getStringHeight( $col, 'a' );

        /**
         * INIZIO INSERIMENTO CONTENUTI
         */

        // logo dell'emittente
        if( ! empty( $dati['sri']['logo'] ) && file_exists( $dati['sri']['logo'] ) ) {
            $pdf->image( $dati['sri']['logo'], $ml, $mt, $col * $etc['img']['logo']['w'], $lh * $etc['img']['logo']['h'], NULL, NULL, 'T', false, 300, '', false, false, 1, true );
        }

        // codice a barre del documento
        if( ! empty( $etc['sez']['barcode'] ) && ! empty( $dati['doc']['codice'] ) ) {
            $pdf->SetY( $mt + 5 );
            $pdf->write1DBarcode( $dati['doc']['codice'], 'C128', '', '', '', 18, 0.4, $etc['bcd']['principale'], 'N' );
        }

        // emittente, accanto al logo
        $righe = documentoRigheSoggetto( $dati['src'], ( isset( $dati['sri'] ) ) ? $dati['sri'] : array() );
        $x = $ml + ( ( ! empty( $dati['sri']['logo'] ) ) ? $col * $etc['img']['logo']['w'] + 5 : 0 );
        $y = $mt;
        foreach( $righe as $i => $riga ) {
            $pdf->SetFont( '', ( ( $i == 0 ) ? 'B' : '' ) );
            $pdf->Text( $x, $y, $riga );
            $y += $lh;
        }

        // destinatario, a destra sotto il codice a barre
        $y = max( $y, $mt + $lh * $etc['img']['logo']['h'] ) + 10;
        if( ! empty( $dati['dst'] ) ) {
            $righe = documentoRigheSoggetto( $dati['dst'], ( isset( $dati['dsi'] ) ) ? $dati['dsi'] : array() );
            foreach( $righe as $i => $riga ) {
                $pdf->SetFont( '', ( ( $i == 0 ) ? 'B' : '' ) );
                $pdf->SetXY( $ml, $y );
                $pdf->Cell( $etc['pag']['size']['text_area']['w'], 0, $riga, 0, 0, 'R' );
                $y += $lh;
            }
        }

        // oggetto
        $pdf->SetXY( $ml, $y + $stdsp );
        $pdf->SetFont( '', 'B' );
        $pdf->Cell( $col * 2, 0, 'oggetto:', 0, 0, 'L' );
        $pdf->SetFont( '', '' );
        $pdf->Cell( $col * 10, 0, $etc['txt']['oggetto'], 0, 1, 'L' );
        $pdf->SetY( $pdf->GetY() + $stdsp );

        // tabella delle righe
        documentoTabellaRighe( $pdf, $dati['doc']['righe'], $etc );

        // totali e riepilogo IVA
        if( ! empty( $etc['sez']['totali'] ) && ! empty( $dati['doc']['tot']['importo_lordo_totale'] ) && $dati['doc']['tot']['importo_lordo_totale'] != 0 ) {

            $pdf->SetY( $pdf->GetY() + $stdsp );

            // riepilogo per aliquota
            if( ! empty( $dati['doc']['iva'] ) ) {
                foreach( $dati['doc']['iva'] as $iva ) {
                    $pdf->Cell( $col * 8, 0, 'imponibile ' . ( ( isset( $iva['descrizione'] ) ) ? $iva['descrizione'] : '' ) . ' ' . $iva['imponibile_tot'] . ' €', 0, 0, 'R' );
                    $pdf->Cell( $col * 4, 0, 'IVA ' . $iva['tot'] . ' €', 0, 1, 'R' );
                }
            }

            // totali
            $pdf->Cell( $col * 8, 0, 'totale imponibile', 0, 0, 'R' );
            $pdf->Cell( $col * 4, 0, $dati['doc']['tot']['importo_netto_totale'] . ' €', 0, 1, 'R' );
            $pdf->Cell( $col * 8, 0, 'totale IVA', 0, 0, 'R' );
            $pdf->Cell( $col * 4, 0, $dati['doc']['tot']['importo_iva_totale'] . ' €', 0, 1, 'R' );
            $pdf->SetFont( '', 'B' );
            $pdf->Cell( $col * 8, 0, 'totale documento', 0, 0, 'R' );
            $pdf->Cell( $col * 4, 0, $dati['doc']['tot']['importo_lordo_totale'] . ' €', 0, 1, 'R' );
            $pdf->SetFont( '', '' );

        }

        // dati del trasporto
        if( ! empty( $etc['sez']['trasporto'] ) && ! empty( $dati['doc']['trasporto'] ) ) {

            $pdf->SetY( $pdf->GetY() + $stdsp );

            $trasporto = array();
            if( ! empty( $dati['doc']['trasporto']['causale'] ) ) {
                $trasporto[] = 'causale: ' . $dati['doc']['trasporto']['causale'];
            }
            if( ! empty( $dati['doc']['trasporto']['vettore'] ) ) {
                $v = $dati['doc']['trasporto']['vettore'];
                $trasporto[] = 'vettore: ' . trim( $v['nome'] . ' ' . $v['cognome'] . ' ' . $v['denominazione'] );
            }
            if( ! empty( $dati['doc']['trasporto']['colli'] ) ) {
                $c = $dati['doc']['trasporto']['colli'];
                $trasporto[] = 'colli: ' . $c['numero'] . ( ( ! empty( $c['peso'] ) && $c['udm_diverse'] == 1 ) ? ', peso ' . documentoFormatoQuantita( $c['peso'] ) . ' ' . $c['udm_peso'] : '' );
            }
            if( ! empty( $dati['doc']['trasporto']['resa'] ) ) {
                $r = $dati['doc']['trasporto']['resa'];
                $trasporto[] = 'consegna: ' . trim( $r['tipologia'] . ' ' . $r['indirizzo'] . ', ' . $r['civico'] . ' - ' . $r['cap'] . ' ' . $r['comune'] . ' ' . $r['provincia'] );
            }

            foreach( $trasporto as $riga ) {
                $pdf->Cell( $col * 12, 0, $riga, 0, 1, 'L' );
            }

        }

        // note per il cliente
        if( ! empty( $etc['sez']['note'] ) && ! empty( $dati['doc']['note'] ) ) {
            $pdf->SetY( $pdf->GetY() + $stdsp );
            $pdf->SetFont( '', 'B' );
            $pdf->Cell( $col * 12, 0, $etc['txt']['note'], 0, 1, 'L' );
            $pdf->SetFont( '', '' );
            $pdf->MultiCell( $col * 12, 0, $dati['doc']['note'], 0, 'L' );
        }

    }

    /**
     * modello di stampa del documento di trasporto
     *
     * Il generico con le colonne dei magazzini al posto dei prezzi, come il DDT di sempre.
     *
     * @param       object      $pdf            l'oggetto TCPDF
     * @param       array       $dati           i dati del documento, da generaContenutiDocumento()
     * @param       array       $cnf            le impostazioni che sostituiscono quelle di base
     *
     * @return      void
     *
     */
    function generaDdtPdf( &$pdf, $dati, $cnf = array() ) {

        // colonne della tabella delle righe
        $etc['tbl']['colonne'] = array(
            array( 'campo' => 'articolo', 'titolo' => 'descrizione', 'w' => 4, 'align' => 'L' ),
            array( 'campo' => 'quantita', 'titolo' => 'q.tà', 'w' => 1, 'align' => 'R', 'formato' => 'quantita' ),
            array( 'campo' => 'udm', 'titolo' => 'udm', 'w' => 1, 'align' => 'C' ),
            array( 'campo' => 'mastro_provenienza', 'titolo' => 'magazzino scarico', 'w' => 3, 'align' => 'L' ),
            array( 'campo' => 'mastro_destinazione', 'titolo' => 'magazzino carico', 'w' => 3, 'align' => 'L' )
        );

        // il DDT non ha totali
        $etc['sez']['totali'] = false;

        // disegno col modello generico
        generaDocumentoGenericoPdf( $pdf, $dati, documentoUnisciImpostazioni( $etc, $cnf ) );

    }

    /**
     * modello di stampa dell'ordine
     *
     * Il generico con codice, descrizione, quantita' e magazzino di scarico; i totali compaiono solo se l'ordine
     * ha un importo.
     *
     * @param       object      $pdf            l'oggetto TCPDF
     * @param       array       $dati           i dati del documento, da generaContenutiDocumento()
     * @param       array       $cnf            le impostazioni che sostituiscono quelle di base
     *
     * @return      void
     *
     */
    function generaOrdinePdf( &$pdf, $dati, $cnf = array() ) {

        // colonne della tabella delle righe
        $etc['tbl']['colonne'] = array(
            array( 'campo' => 'codice_articolo', 'titolo' => 'codice', 'w' => 2, 'align' => 'L' ),
            array( 'campo' => 'articolo', 'titolo' => 'descrizione', 'w' => 5, 'align' => 'L' ),
            array( 'campo' => 'quantita', 'titolo' => 'q.tà', 'w' => 1, 'align' => 'R', 'formato' => 'quantita' ),
            array( 'campo' => 'udm', 'titolo' => 'udm', 'w' => 1, 'align' => 'C' ),
            array( 'campo' => 'importo_netto_totale', 'titolo' => 'importo', 'w' => 3, 'align' => 'R', 'formato' => 'importo' )
        );

        // disegno col modello generico
        generaDocumentoGenericoPdf( $pdf, $dati, documentoUnisciImpostazioni( $etc, $cnf ) );

    }

    if( ! function_exists( 'generaNotaCreditoPdf' ) ) {

        /**
         * modello di stampa della nota di credito
         *
         * Il generico con prezzi e totali; l'oggetto ricorda il documento stornato quando c'e' un riferimento.
         *
         * Protetta da function_exists() perche' un deploy puo' gia' avere una sua generaNotaCreditoPdf() nella libreria
         * custom ( polmasi ) e includere questa dopo, per avere le altre funzioni dello standard.
         *
         * @param       object      $pdf            l'oggetto TCPDF
         * @param       array       $dati           i dati del documento, da generaContenutiDocumento()
         * @param       array       $cnf            le impostazioni che sostituiscono quelle di base
         *
         * @return      void
         *
         */
        function generaNotaCreditoPdf( &$pdf, $dati, $cnf = array() ) {

            // l'oggetto riporta il riferimento al documento stornato
            $etc['txt']['oggetto'] = '{{ doc.oggetto }}{% if doc.riferimento %} - rif. {{ doc.riferimento }}{% endif %}';

            // disegno col modello generico
            generaDocumentoGenericoPdf( $pdf, $dati, documentoUnisciImpostazioni( $etc, $cnf ) );

        }

    }

    /**
     * modello di stampa della fattura pro forma
     *
     * Il generico con prezzi e totali, e la dicitura che il documento non ha valore fiscale.
     *
     * @param       object      $pdf            l'oggetto TCPDF
     * @param       array       $dati           i dati del documento, da generaContenutiDocumento()
     * @param       array       $cnf            le impostazioni che sostituiscono quelle di base
     *
     * @return      void
     *
     */
    function generaProformaPdf( &$pdf, $dati, $cnf = array() ) {

        // l'oggetto avverte che il documento non e' fiscale
        $etc['txt']['oggetto'] = '{{ doc.oggetto }} - documento privo di valore fiscale';

        // disegno col modello generico
        generaDocumentoGenericoPdf( $pdf, $dati, documentoUnisciImpostazioni( $etc, $cnf ) );

    }

    /**
     * modello di stampa dell'offerta
     *
     * Il generico con prezzi e totali, senza codice a barre e senza dati del trasporto.
     *
     * @param       object      $pdf            l'oggetto TCPDF
     * @param       array       $dati           i dati del documento, da generaContenutiDocumento()
     * @param       array       $cnf            le impostazioni che sostituiscono quelle di base
     *
     * @return      void
     *
     */
    function generaOffertaPdf( &$pdf, $dati, $cnf = array() ) {

        // sezioni da mostrare
        $etc['sez']['barcode'] = false;
        $etc['sez']['trasporto'] = false;

        // disegno col modello generico
        generaDocumentoGenericoPdf( $pdf, $dati, documentoUnisciImpostazioni( $etc, $cnf ) );

    }

    /**
     * unisce le impostazioni di un modello a quelle del chiamante
     *
     * Le colonne della tabella si sostituiscono intere, come fa generaDocumentoGenericoPdf(): unite chiave per
     * chiave, tre colonne del chiamante lascerebbero in fondo le restanti del modello.
     *
     * @param       array       $etc            le impostazioni del modello
     * @param       array       $cnf            le impostazioni del chiamante
     *
     * @return      array                       le impostazioni unite
     *
     */
    function documentoUnisciImpostazioni( $etc, $cnf ) {

        if( isset( $cnf['tbl']['colonne'] ) ) {
            $etc['tbl']['colonne'] = array();
        }

        return array_replace_recursive( $etc, $cnf );

    }

    /**
     * righe di intestazione di un soggetto del documento
     *
     * Restituisce denominazione, indirizzo, comune, partita IVA, codice fiscale e SDI o PEC di emittente o
     * destinatario, scartando quelle vuote: i documenti senza sedi richieste hanno la sede fatta di NULL, e
     * l'indirizzo diventa " , ".
     *
     * @param       array       $soggetto       la riga di anagrafica ( src o dst )
     * @param       array       $sede           la sua sede ( sri o dsi )
     *
     * @return      array                       le righe da stampare
     *
     */
    function documentoRigheSoggetto( $soggetto, $sede ) {

        $righe = array(
            ( isset( $soggetto['denominazione_fiscale'] ) ) ? $soggetto['denominazione_fiscale'] : NULL,
            ( isset( $sede['indirizzo_fiscale'] ) ) ? $sede['indirizzo_fiscale'] : NULL,
            ( isset( $sede['comune_indirizzo_fiscale'] ) ) ? $sede['comune_indirizzo_fiscale'] : NULL,
            ( ! empty( $soggetto['partita_iva'] ) ) ? 'P.IVA ' . $soggetto['partita_iva'] : NULL,
            ( ! empty( $soggetto['codice_fiscale'] ) ) ? 'cod.fisc. ' . $soggetto['codice_fiscale'] : NULL,
            ( ! empty( $soggetto['codice_sdi'] ) && $soggetto['codice_sdi'] != '0000000' ) ? 'SDI ' . $soggetto['codice_sdi'] : NULL
        );

        // PEC in mancanza dello SDI
        if( empty( $righe[5] ) && ! empty( $soggetto['id'] ) ) {
            $pec = anagraficaGetPEC( $soggetto['id'] );
            $righe[5] = ( ! empty( $pec ) ) ? 'PEC ' . $pec : NULL;
        }

        // tolgo le righe vuote o fatte di sola punteggiatura
        return array_values( array_filter( $righe, function( $r ) { return trim( $r, " ,\t" ) !== ''; } ) );

    }

    /**
     * tabella delle righe di un documento
     *
     * Disegna intestazione e righe secondo le colonne di $etc['tbl']['colonne'], ripetendo l'intestazione a ogni
     * cambio pagina.
     *
     * @param       object      $pdf            l'oggetto TCPDF
     * @param       array       $righe          le righe del documento
     * @param       array       $etc            le impostazioni del modello
     *
     * @return      void
     *
     */
    function documentoTabellaRighe( &$pdf, $righe, $etc ) {

        $col = $etc['pag']['spacer']['col'];
        $limite = $etc['pag']['size']['h'] - $etc['pag']['margin']['b'];

        // intestazione
        $intestazione = function() use ( &$pdf, $etc, $col ) {
            $pdf->SetFont( '', 'B' );
            foreach( $etc['tbl']['colonne'] as $i => $c ) {
                $pdf->Cell( $col * $c['w'], 0, $c['titolo'], $etc['tbl']['celle']['intestazione'], ( ( $i == count( $etc['tbl']['colonne'] ) - 1 ) ? 1 : 0 ), $c['align'] );
            }
            $pdf->SetFont( '', '' );
        };

        $intestazione();

        foreach( (array) $righe as $riga ) {

            // testi delle celle
            $testi = array();
            foreach( $etc['tbl']['colonne'] as $c ) {
                $v = ( isset( $riga[ $c['campo'] ] ) ) ? $riga[ $c['campo'] ] : '';
                if( isset( $c['formato'] ) && $c['formato'] == 'importo' && $v !== '' && $v !== NULL ) {
                    $v = sprintf( '%0.2f', $v ) . ' €';
                } elseif( isset( $c['formato'] ) && $c['formato'] == 'quantita' ) {
                    $v = documentoFormatoQuantita( $v );
                }
                $testi[] = $v;
            }

            // altezza della riga, la massima fra le celle
            $trh = 0;
            foreach( $etc['tbl']['colonne'] as $i => $c ) {
                $trh = max( $trh, $pdf->getStringHeight( $col * $c['w'], $testi[ $i ] ) );
            }

            // cambio pagina con ripetizione dell'intestazione
            if( $pdf->GetY() + $trh > $limite ) {
                $pdf->AddPage();
                $intestazione();
            }

            // riempimento delle righe con l'asterisco
            $pdf->SetFillColor( ( substr( trim( (string) ( isset( $riga['nome'] ) ? $riga['nome'] : '' ) ), 0, 1 ) == '*' ) ? $etc['rgb']['evidenza'] : $etc['rgb']['bianco'] );

            // celle
            foreach( $etc['tbl']['colonne'] as $i => $c ) {
                $pdf->SetFont( '', ( ( $c['campo'] == 'quantita' && ! empty( $riga['sottorighe'] ) ) ? 'B' : '' ) );
                $pdf->MultiCell( $col * $c['w'], $trh, $testi[ $i ], $etc['tbl']['celle']['dati'], $c['align'], true, ( ( $i == count( $etc['tbl']['colonne'] ) - 1 ) ? 1 : 0 ) );
            }
            $pdf->SetFont( '', '' );

        }

    }

    /**
     * formatta una quantita' togliendo gli zeri decimali in coda
     *
     * @param       string      $q              la quantita'
     *
     * @return      string                      la quantita' formattata
     *
     */
    function documentoFormatoQuantita( $q ) {

        if( ! is_numeric( $q ) ) {
            return (string) $q;
        }

        return rtrim( rtrim( sprintf( '%0.3f', $q ), '0' ), '.' );

    }

    /*
     * NB: qui stavano, dal 15/09/2026 e per poche ore, due fallback di `anagraficaGetLogo()` e
     * `anagraficaGetPEC()`, messi perche' le due funzioni vivevano in `_mod/_0010.anagrafica/` e
     * dove quel modulo non c'e' ogni stampa di documento moriva. Sono stati tolti lo stesso
     * giorno perche' la cura vera e' un'altra ed e' stata applicata: le quattro funzioni generiche
     * dell'anagrafica sono andate nel core, in `_src/_lib/_mysql.utils.php`, dove le vede
     * qualunque deploy. Se un giorno tornassero in un modulo, questo file e' il posto dove il
     * difetto si ripresenta per primo.
     */

    /*
     * NB: qui stava, per un pomeriggio, autorizzaStampaDocumento() - la regola "roots, oppure il
     * destinatario e i suoi familiari, oppure il token" estratta da _documento.default.php e messa
     * in comune fra tutti gli endpoint di stampa. E' stata tolta il 15/09/2026, e il motivo vale
     * piu' del codice: QUESTO FILE E' STANDARD, e una regola piu' larga scritta qui sarebbe salita
     * nei disallineamenti e da li' nel framework, diventando la regola di tutti i deploy. Cioe'
     * proprio la decisione che Fabio aveva appena preso al contrario - nello standard stampa lo
     * staff, chi ha bisogno di far stampare ai clienti amplia in custom - ottenuta per inerzia
     * invece che per scelta.
     *
     * Il suffisso `.add.php` inganna, perche' sembra la convenzione del custom: la convenzione e'
     * il PERCORSO senza underscore, non il suffisso. La controparte custom di questo file e'
     * mod/0400.documenti/src/lib/pdf.tools.add.php, ed e' li' che va il codice di progetto.
     *
     * Gli endpoint di questo modulo usano ora checkTaskPrivilege( 'GESTIONE_DOCUMENTI' ), che e' la
     * regola standard; _documento.default.php si tiene la sua, che e' quella per l'intestatario.
     */
