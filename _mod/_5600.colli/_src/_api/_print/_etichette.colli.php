<?php

    /**
     * stampa delle etichette dei colli
     *
     * I colli da stampare si scelgono con un intervallo di codici, di cui si può indicare anche un estremo
     * solo; almeno un criterio va passato, altrimenti si stamperebbero le etichette di tutti i colli esistenti.
     *
     * parametro                | criterio
     * -------------------------|--------------------------------------------------------------------------
     * __etichette__[dal]       | il codice è maggiore o uguale al valore indicato...
     * __etichette__[al]        | il codice è minore o uguale al valore indicato
     * __etichette__[codice]    | il codice inizia per il valore indicato ( prefisso, LIKE )
     *
     * ...ma dal **compilato da solo vale come prefisso**, non come estremo: chi cerca le etichette di un
     * collo o di una serie ne scrive il codice e basta, senza doverlo ripetere nei due estremi, ed è il modo
     * in cui la maschera lo usa. Con anche al compilato torna a essere l'estremo inferiore dell'intervallo.
     *
     * Il parametro codice è quello storico, che continua ad arrivare da _colli.crea.php ( il pulsante "crea
     * colli e stampa etichette" passa il prefisso della serie appena creata ); se c'è, delimita comunque
     * l'intervallo e dal mantiene il proprio significato di estremo.
     *
     * https://tcpdf.org/examples/example_009/
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../../_src/_config.php';

    // valori passati
    $codice = ( isset( $_REQUEST['__etichette__']['codice'] ) ) ? trim( $_REQUEST['__etichette__']['codice'] ) : '';
    $dal    = ( isset( $_REQUEST['__etichette__']['dal'] ) )    ? trim( $_REQUEST['__etichette__']['dal'] )    : '';
    $al     = ( isset( $_REQUEST['__etichette__']['al'] ) )     ? trim( $_REQUEST['__etichette__']['al'] )     : '';

    // dal compilato da solo non è l'estremo di un intervallo aperto, è il codice cercato: vale come prefisso
    if( $dal !== '' && $al === '' && $codice === '' ) {
        $codice = $dal;
        $dal = '';
    }

    // criteri di ricerca dei colli
    $criteri = array();
    $parametri = array();
    $descrizione = array();

    // prefisso del codice
    if( $codice !== '' ) {
        $criteri[] = 'codice LIKE ?';
        $parametri[] = array( 's' => $codice . '%' );
        $descrizione[] = 'con codice che inizia per ' . $codice;
    }

    // estremo iniziale dell'intervallo
    if( $dal !== '' ) {
        $criteri[] = 'codice >= ?';
        $parametri[] = array( 's' => $dal );
    }

    // estremo finale dell'intervallo
    if( $al !== '' ) {
        $criteri[] = 'codice <= ?';
        $parametri[] = array( 's' => $al );
    }

    // descrizione dell'intervallo, per i messaggi di errore
    if( $dal !== '' && $al !== '' ) {
        $descrizione[] = 'da ' . $dal . ' a ' . $al;
    } elseif( $dal !== '' ) {
        $descrizione[] = 'da ' . $dal . ' in poi';
    } elseif( $al !== '' ) {
        $descrizione[] = 'fino a ' . $al;
    }

    // ...
    if( ! empty( $criteri ) ) {

        // numero massimo di etichette per stampa, oltre il quale si chiede di restringere i criteri
        $massimo = ( isset( $cf['etichette']['colli']['massimo'] ) ) ? (int) $cf['etichette']['colli']['massimo'] : 500;

        // colli da stampare, in ordine di codice, con una riga in più per accorgersi di aver superato il massimo
        $colli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT colli.*, tipologie_colli.nome AS tipologia FROM colli LEFT JOIN tipologie_colli ON tipologie_colli.id = colli.id_tipologia'
                . ' WHERE ' . implode( ' AND ', $criteri )
                . ' ORDER BY codice LIMIT ' . ( $massimo + 1 ),
            $parametri
        );

        // debug
        // die( print_r( $colli, true ) );

        // senza colli il PDF sarebbe una pagina bianca, che non dice all'operatore che cosa è andato storto
        if( empty( $colli ) ) {
            die( 'nessun collo trovato ' . htmlspecialchars( implode( ', ', $descrizione ) ) );
        }

        // meglio fermarsi che mandare in stampa un numero imprevisto di etichette
        if( count( $colli ) > $massimo ) {
            die( 'i criteri indicati selezionano più di ' . $massimo . ' colli ( ' . htmlspecialchars( implode( ', ', $descrizione ) ) . ' ): restringere l\'intervallo' );
        }

        // senza il runlevel del modulo non c'è il formato dell'etichetta ( vedi _src/_config/_370.etichette.php )
        if( ! isset( $cf['etichette']['colli'] ) ) {
            die( 'formato dell\'etichetta non disponibile: il modulo 5600.colli non è attivo' );
        }

        // misure dell'etichetta, scalate sul formato in uso
        $etichetta = scalaEtichetta( $cf['etichette']['colli'] );

        // creazione del PDF
        $pdf = new TCPDF( 'L', 'mm', $etichetta['formato'] );					// landscape, millimetri, formato dell'etichetta fisica

        // rimozione di header e footer
        $pdf->SetPrintHeader( false );							// se stampare l'header
        $pdf->SetPrintFooter( false );							// se stampare il footer

        // imposto i margini
        $pdf->SetMargins( 0, 0, 0 );						// left, top, right
        $pdf->SetHeaderMargin( 0 );							// margine dell'intestazione
        $pdf->SetFooterMargin( 0 );							// margine del footer

        // set image scale factor
        $pdf->setImageScale( PDF_IMAGE_SCALE_RATIO );					// fattore di conversione da pixel a millimetri

        // set auto page breaks
        $pdf->SetAutoPageBreak( false );						// se aggiungere automaticamente pagine

        // per ogni collo
        foreach( $colli as $collo ) {

            // die( print_r( $collo, true ) );

            // aggiunta di una pagina
            $pdf->AddPage();								// richiesto perché si è disattivato l'automatismo

            // set font
            $pdf->SetFont('helvetica', '', $etichetta['caratteri']['tipologia'] );	// font, stile, dimensione

            // altezza del contenuto: nome della tipologia, interlinea e barcode ( che comprende il suo testo );
            // NB: getCellHeight() vuole il corpo in unità utente, che è quello che restituisce getFontSize(),
            // non i punti di SetFont() — passargli i punti gonfia il contenuto e manda la Y sotto zero, che
            // per SetY() significa "a partire dal fondo pagina", cioè contenuto stampato fuori dall'etichetta
            $contenuto = $pdf->getCellHeight( $pdf->getFontSize() )
                       + $etichetta['verticali']['interlinea']
                       + $etichetta['verticali']['barcode'];

            // posizione verticale di partenza: centrata sull'etichetta oppure appesa al margine superiore
            if( isset( $etichetta['allineamento'] ) && $etichetta['allineamento'] == 'centrato' ) {
                $pdf->SetY( max( 0, ( $pdf->getPageHeight() - $contenuto ) / 2 ) );
            } else {
                $pdf->SetY( $etichetta['verticali']['margine'] );
            }

           $pdf-> Cell( $pdf->getPageWidth(), '', $collo['tipologia'] , '', 1 ,'C' );

            // define barcode style
            // NB: con fitwidth TCPDF restringe la larghezza a quella effettiva del barcode ma lascia la x
            // dov'era, quindi senza cellfitalign il barcode resta appeso al bordo sinistro dell'etichetta
            $style = array(
                'position' => '',
                'align' => 'C',
                'stretch' => false,
                'fitwidth' => true,
                'cellfitalign' => ( isset( $etichetta['allineamento'] ) && $etichetta['allineamento'] == 'centrato' ) ? 'C' : '',
                'border' => false,
                'hpadding' => 'auto',
                'vpadding' => 'auto',
                'fgcolor' => array(0,0,0),
                'bgcolor' => false, //array(255,255,255),
                'text' => true,
                'font' => 'helvetica',
                'fontsize' => $etichetta['caratteri']['barcode'],
                'stretchtext' => 4
            );

            // posizione verticale del codice
            $pdf->SetY( $pdf->GetY() + $etichetta['verticali']['interlinea'] );

            // codice del collo
            $pdf->write1DBarcode( $collo['codice'], 'C128', '', '', '', $etichetta['verticali']['barcode'], 0.4, $style, 'N');

        }

        // invia l'output al browser
        $pdf->Output( time().'.pdf');

    } else {

        // debug
        die( 'nessun criterio di ricerca passato: indicare almeno un codice, nel campo "dal codice" o in quello "al codice"' );

    }
