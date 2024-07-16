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

    // debug
     error_reporting( E_ALL );
     ini_set( 'display_errors', TRUE );

    /**
     * raccolta dati
     * =============
     * 
     * 
     */

    // cerco le anagrafiche da includere nel report
    if( isset( $_REQUEST['id'] ) ) {

        $etc['dati']['anagrafiche'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT *, concat_ws( " ", codice, denominazione, cognome, nome ) AS __label__ FROM anagrafica WHERE id = ?',
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

    } else {

        $whr = NULL;
        $ijn = NULL;
        $cnd = array();

        if( isset( $_REQUEST['__categoria__'] ) && ! empty( $_REQUEST['__categoria__'] ) ) {

            if( isset( $_REQUEST['__stato__'] ) && ! empty( $_REQUEST['__stato__'] ) ) {

                $etc['dati']['anagrafiche'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT anagrafica.*, concat_ws( " ", anagrafica.codice, anagrafica.denominazione, anagrafica.cognome, anagrafica.nome ) AS __label__ FROM anagrafica
                    INNER JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id AND categorie_anagrafica_path_check( anagrafica_categorie.id_categoria, ? ) 
                    INNER JOIN categorie_anagrafica ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
                    INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_anagrafica = anagrafica.id
                    INNER JOIN indirizzi ON indirizzi.id = anagrafica_indirizzi.id_indirizzo
                    INNER JOIN comuni ON comuni.id = indirizzi.id_comune
                    INNER JOIN provincie ON provincie.id = comuni.id_provincia
                    INNER JOIN regioni ON regioni.id = provincie.id_regione
                    WHERE categorie_anagrafica.se_cliente IS NOT NULL OR categorie_anagrafica.se_lead IS NOT NULL
                    AND regioni.id_stato = ?
                    AND anagrafica.data_archiviazione IS NULL
                    ORDER BY anagrafica.denominazione, anagrafica.cognome, anagrafica.nome',
                    array(
                        array( 's' => $_REQUEST['__categoria__'] ),
                        array( 's' => $_REQUEST['__stato__'] )
                    )
                );
    
            } else {

                $etc['dati']['anagrafiche'] = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT anagrafica.*, concat_ws( " ", anagrafica.codice, anagrafica.denominazione, anagrafica.cognome, anagrafica.nome ) AS __label__ FROM anagrafica
                    INNER JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id AND categorie_anagrafica_path_check( anagrafica_categorie.id_categoria, ? ) 
                    INNER JOIN categorie_anagrafica ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
                    WHERE categorie_anagrafica.se_cliente IS NOT NULL OR categorie_anagrafica.se_lead IS NOT NULL
                    AND anagrafica.data_archiviazione IS NULL
                    ORDER BY anagrafica.denominazione, anagrafica.cognome, anagrafica.nome',
                    array(
                        array( 's' => $_REQUEST['__categoria__'] )
                    )
                );
    
            }

    
        } else {

            $etc['dati']['anagrafiche'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT anagrafica.*, concat_ws( " ", anagrafica.codice, anagrafica.denominazione, anagrafica.cognome, anagrafica.nome ) AS __label__ FROM anagrafica
                INNER JOIN anagrafica_categorie ON anagrafica.id = anagrafica_categorie.id_anagrafica
                INNER JOIN categorie_anagrafica ON anagrafica_categorie.id_categoria = categorie_anagrafica.id
                WHERE categorie_anagrafica.se_cliente IS NOT NULL OR categorie_anagrafica.se_lead IS NOT NULL
                ORDER BY anagrafica.denominazione, anagrafica.cognome, anagrafica.nome'
            );

        }

    }

    // debug
    // die( print_r( $etc['dati']['anagrafiche'], true ) );

    // per ogni anagrafica, seleziono le attività pertinenti
    foreach( $etc['dati']['anagrafiche'] as $k => $a ) {

        // seleziono le attività pertinenti
        $etc['dati']['anagrafiche'][ $k ]['attivita'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM attivita WHERE id_cliente = ? ORDER BY coalesce( data_attivita, data_programmazione ) ASC',
            array(
                array( 's' => $a['id'] )
            )
        );

    }

    /**
     * contenuti del documento
     * =======================
     * 
     * 
     */

    // titolo del documento
    $etc['txt']['titolo']                       = 'rapporto di gestione commerciale del ' . date( 'd/m/Y' );

    /**
     * configurazione del documento
     * ============================
     * 
     * 
     */

    // dimensioni pagina
    $etc['pag']['size']['h']		            = 297;								                // altezza del foglio
    $etc['pag']['size']['w']		            = 210;								                // larghezza del foglio
    $etc['pag']['size']['f']		            = 'A4';								                // formato del foglio
    $etc['pag']['size']['o']		            = 'P';								                // orientamento del foglio
    $etc['pag']['size']['u']		            = 'mm';								                // unità di misura del foglio
    $etc['pag']['margin']['t']		            = 15;								                // margine superiore
    $etc['pag']['margin']['l']		            = 15;								                // margine sinistro
    $etc['pag']['margin']['r']		            = 15;								                // margine destro
    $etc['pag']['margin']['b']		            = 15;								                // margine inferiore
    $etc['pag']['spacer']['base']		        = 5;								                // spaziatore standard

    // tipografia
    $etc['fnt']['base']['family']		        = 'helvetica';						                // famiglia del font base
    $etc['fnt']['base']['style']		        = '';						                        // stile del font base
    $etc['fnt']['base']['size']		            = 10;								                // dimensione del font base

    $etc['fnt']['intestazione'][0]['family']    = 'helvetica';						                // famiglia del font base
    $etc['fnt']['intestazione'][0]['style']	    = 'B';						                        // stile del font base
    $etc['fnt']['intestazione'][0]['size']	    = 12;								                // dimensione del font base

    $etc['fnt']['intestazione'][1]['family']    = 'helvetica';						                // famiglia del font base
    $etc['fnt']['intestazione'][1]['style']	    = 'I';						                        // stile del font base
    $etc['fnt']['intestazione'][1]['size']	    = 12;								                // dimensione del font base

    $etc['fnt']['intestazione'][2]['family']    = 'helvetica';						                // famiglia del font base
    $etc['fnt']['intestazione'][2]['style']	    = '';						                        // stile del font base
    $etc['fnt']['intestazione'][2]['size']	    = 10;								                // dimensione del font base

    // spessori linee
    $etc['thk']['base']		                    = .3;								                // spessore linea standard
    $etc['thk']['sottile']	                    = .15;								                // spessore linea sottile

    // colori
    $etc['rgb']['nero']		                    = array( 0, 0, 0 );					                // il nero
    $etc['rgb']['grigio_medio']		            = array( 128, 128, 128 );			                // grigio
    $etc['rgb']['bianco']		                = array( 255, 255, 255 );			                // il bianco

    // bordi delle celle
    $etc['tbl']['celle']['intestazione']		= array( 'B' => array( 'width' => $etc['thk']['base'], 'color' => $etc['rgb']['nero'], 'dash' => false ) );
    $etc['tbl']['celle']['dati']		        = array( 'B' => array( 'width' => $etc['thk']['sottile'], 'color' => $etc['rgb']['grigio_medio'], 'dash' => false ) );

    // linee
    $etc['lne']['taglio']                       = array( 'width' => $etc['thk']['sottile'], 'dash' => '10,5', 'color' => $etc['rgb']['grigio_medio'] );

    // immagini
    $etc['img']['logo_gimi']['path']            = DIR_BASE . 'src/templates/athena/img/logoGimi.jpg';
    $etc['img']['logo_gimi']['w']               = '50';
    $etc['img']['logo_gimi']['h']               = '50';

    /**
     * elaborazione impostazioni
     * =========================
     * nessun valore o impostazione va modificato oltre questo punto
     */

    // creazione del PDF
	$pdf                                        = new TCPDF( $etc['pag']['size']['o'], $etc['pag']['size']['u'], $etc['pag']['size']['f'] );

    // nome del file di output
    $etc['out']['file']['name']                 = string2rewrite( $etc['txt']['titolo'] ) . '.pdf';

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
    twigRenderText( $etc['txt'], $etc['dati'] );

    /**
     * impostazione della pagina
     * =========================
     * nessun valore o impostazione va modificato oltre questo punto
     */

    // titolo del documento
    $pdf->SetTitle( $etc['txt']['titolo'] );

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

    /**
     * composizione del documento
     * ==========================
     * 
     * 
     * 
     */

    // per ogni anagrafica
    foreach( $etc['dati']['anagrafiche'] as $a ) {

        // inizio pagina
        $pdf->AddPage();

        // tipografia intestazione
        $pdf->SetFont(
            $etc['fnt']['intestazione'][0]['family'],
            $etc['fnt']['intestazione'][0]['style'],
            $etc['fnt']['intestazione'][0]['size']
        );

        // intestazione (larghezza, altezza, testo, bordo, newline [0 -> nessuna, 1 -> tutto a sx, 2 -> sotto la cella precedente], allineamento)
        $pdf->Cell( 0, 0, trim( $a['__label__'] ), '', 2, 'L' );

        // tipografia testo
        $pdf->SetFont(
            $etc['fnt']['base']['family'],
            $etc['fnt']['base']['style'],
            $etc['fnt']['base']['size']
        );

        // descrizione del cliente
        $pdf->MultiCell( $etc['pag']['spacer']['col'] * 8, 0, $a['note'], '', 'L' );

        // spazio sotto al titolo
        $pdf->SetXY( $etc['pag']['margin']['l'], $pdf->GetY() + $etc['pag']['spacer']['row'] );

        // scrivo gli eventi del cliente
        foreach( $a['attivita'] as $e ) {

            // tipografia testo
            $pdf->SetFont(
                $etc['fnt']['base']['family'],
                $etc['fnt']['base']['style'],
                $etc['fnt']['base']['size']
            );

            // cella con la data di programmazione
            $pdf->Cell( $etc['pag']['spacer']['col'] * 2, 0, $e['data_programmazione'], '', 0, 'L' );

            // cella con la data dell'attività
            $pdf->Cell( $etc['pag']['spacer']['col'] * 2, 0, $e['data_attivita'], '', 0, 'L' );

            // cella con la descrizione dell'attività
            $pdf->MultiCell( $etc['pag']['spacer']['col'] * 8, 0, trim( implode( "\n", array( $e['nome'], trim( implode( "\n", array( $e['note_programmazione'], $e['note'] ) ) ) ) ) ), '', 'L' );

            // spazio sotto al titolo
            $pdf->SetXY( $etc['pag']['margin']['l'], $pdf->GetY() + $etc['pag']['spacer']['row'] / 2 );

        }

    } 

    /**
     * debug e verifiche
     * =================
     * 
     * 
     */

    // debug
    // die( print_r( $etc['txt'], true ) );

    /**
     * output del documento
     * ====================
     * 
     * 
     */

    // output
	if( isset( $_REQUEST['d'] ) ) {
	    $pdf->Output( $etc['out']['file']['name'], 'D' );           // invia l'output al browser per il download diretto
	} elseif( isset( $_REQUEST['f'] ) ) {
	    $pdf->Output( $etc['out']['file']['name'], 'I' );           // salva il file localmente
	} elseif( isset( $_REQUEST['fi'] ) ) {
	    $pdf->Output( $etc['out']['file']['name'], 'FI' );          // salva il file localmente e invia l'output al browser
	} else {
	    $pdf->Output( $etc['out']['file']['name'] );                // invia l'output al browser
	}
