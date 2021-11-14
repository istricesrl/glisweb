<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

    // controllo autorizzazioni
	if( true ) {

        // normalizzazione
        $_REQUEST['__mese__'] = sprintf( '%02d', $_REQUEST['__mese__'] );

        // risultato
        $ct['ore'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT '.
            'attivita.data_attivita, attivita.ore, '.
            'anagrafica.codice AS codice_dipendente, '.
            'tipologie_attivita_inps.codice AS codice_inps '.
            'FROM attivita '.
            'INNER JOIN anagrafica ON anagrafica.id = attivita.id_anagrafica '.
            'INNER JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'INNER JOIN tipologie_attivita_inps ON tipologie_attivita_inps.id = attivita.id_tipologia_inps '.
            'WHERE attivita.data_attivita BETWEEN ? AND ? '.
            'ORDER BY attivita.id_anagrafica ASC, attivita.data_attivita ASC, tipologie_attivita.id ASC ',
            array(
                    array( 's' => $_REQUEST['__anno__'].'-'.$_REQUEST['__mese__'].'-01' ),
                    array( 's' => date( 'Y-m-t', strtotime( $_REQUEST['__anno__'].'-'.$_REQUEST['__mese__'].'-01' ) ) 
                )
            )
        );

        // inizializzazione
        $attivita = array();

        // passaggio ad albero
        foreach( $ct['ore'] as $ora ) {
            if( isset( $attivita[ $ora['codice_dipendente'] ][ $ora['data_attivita'] ][ $ora['codice_inps'] ] ) ) {
                $attivita[ $ora['codice_dipendente'] ][ $ora['data_attivita'] ][ $ora['codice_inps'] ] += $ora['ore'];
            } else {
                $attivita[ $ora['codice_dipendente'] ][ $ora['data_attivita'] ][ $ora['codice_inps'] ] = $ora['ore'];
            }
        }

        // debug
//			 die( 'risultato: '.print_r( $ct['fatturati'], true ) );
//			 die( print_r( 'where: '.$where)  );
//			 die( print_r($params,true) );
//			 die( print_r($_REQUEST,true) );
//			 die( 'fatturati: '.print_r( $ct['fatturati'], true ) );
//           die( print_r( $ct['ore'], 1 ) );
//           die( print_r( $attivita, 1 ) );

        // inizializzazioni
        $dipendente = NULL;

        // headers
        $filename = 'ore.'.$_REQUEST['__anno__'].'.'.$_REQUEST['__mese__'].'.xml';
        header("Content-Type: text/html/force-download");
        header("Content-Disposition: attachment; filename=".$filename.".xml");

        // inizializzo l'oggetto XML
		$xml = new XMLWriter();

	    // specifico il file di destinazione
		$xml->openURI( 'php://output' );

	    // inizio il documento
		$xml->startDocument( '1.0', 'UTF-8' );

	    // attivo l'indentazione
		$xml->setIndent( true );
		$xml->setIndentString( '  ' );

	    // root element
		$xml->startElement( 'Fornitura' );

        // esportazione
        foreach( $attivita as $dipendente => $giornate ) {

            // inizio nuovo dipendente
            $xml->startElement( 'Dipendente' );
            $xml->writeAttribute( 'CodAziendaUfficiale', $cf['zucchetti']['profile']['azienda'] );
            $xml->writeAttribute( 'CodDipendenteUfficiale', $dipendente );

            // attività del dipendente
            $xml->startElement( 'Movimenti' );
            $xml->writeAttribute( 'GenerazioneAutomaticaDaTeorico', 'N' );

            // elenco attività del dipendente per giornata
            foreach( $giornate as $giornata => $codici ) {

                // elenco attività del dipendente per codice
                foreach( $codici as $codice => $lavoro ) {

                    // spacchetto le ore in ore e minuti
                    $aLavoro = explode( '.', trim( str_replace( ',', '.', $lavoro ), ' 0' ) );
                    $ore = $aLavoro[0];
                    $minuti = ( isset( $aLavoro[1] ) ) ? ( $aLavoro[1] * 60 / 10 ) : 0;

                    // inizio nodo attività
                    $xml->startElement( 'Movimento' );

                    // CodGiustificativoUfficiale
                    $xml->writeElement( 'CodGiustificativoUfficiale', $codice );

                    // Data
                    $xml->writeElement( 'Data', $giornata );

                    // NumOre
                    $xml->writeElement( 'NumOre', $ore );

                    // NumMinuti
                    $xml->writeElement( 'NumMinuti', $minuti );
                    
                    // GiornoDiRiposo
                    // $xml->writeElement( 'GiornoDiRiposo', '' ); // TODO

                    // GiornoChiusuraStraordinari
                    // $xml->writeElement( 'GiornoChiusuraStraordinari', '' ); // TODO

                    // fine nodo attività
                    $xml->endElement();

                }

            }

            // fine attività del dipendente
            $xml->endElement();

            // fine del dipendente
            if( $dipendente !== NULL ) {
                $xml->endElement();
            }

        }
        
	    // fine del root element
		$xml->endElement();

	    // fine del document
		$xml->endDocument();

	    // scrittura su file
		$xml->flush();

        /*

        // esportazione
		if( ! empty( $ct['anagrafica'] ) ) {

            // debug
            // die( print_r($ct['anagrafica'] ) );

			header('Content-Type: text/csv');
			header('Content-Disposition: attachment; filename="esportazione contatti mail.csv"');

			$csv[0] = array( 'contatto', 'tipologia', 'indirizzo', 'civico', 'cap', 'comune', 'provincia', 'latitudine', 'longitudine' );

            foreach($ct['anagrafica'] as $anagrafica ) {

                $csv[] = array(
                    $anagrafica['contatto'],
                    $anagrafica['tipologia'],
                    $anagrafica['indirizzo'],
                    $anagrafica['civico'],
                    $anagrafica['cap'],
                    $anagrafica['comune'],
                    $anagrafica['provincia'],
                    $anagrafica['latitudine'],
                    $anagrafica['longitudine']
                ); 

			}

			$fp = fopen('php://output', 'wb');
			foreach ($csv as $line) {fputcsv($fp, $line, ',');}
			fclose($fp);


			} else { buildText( 'nessun risultato per la ricerca effettuata' ); }

		*/

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
