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
            'AND anagrafica.codice IS NOT NULL '.
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
        header('Content-Type: text/html; charset=utf-8');
        header('Content-Disposition: attachment; filename='.$filename);

        // inizializzo l'oggetto XML
		$xml = new XMLWriter();

	    // specifico il file di destinazione
		$xml->openURI( DIR_TMP . microtime( true ) . '.xml' );

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
            $xml->writeAttribute( 'CodDipendenteUfficiale', sprintf( '%07d', $dipendente ) );

            // attività del dipendente
            $xml->startElement( 'Movimenti' );
            $xml->writeAttribute( 'GenerazioneAutomaticaDaTeorico', 'N' );

            // elenco attività del dipendente per giornata
            foreach( $giornate as $giornata => $codici ) {

                // elenco attività del dipendente per codice
                foreach( $codici as $codice => $lavoro ) {

                    // spacchetto le ore in ore e minuti
                    $aLavoro = explode( ',', sprintf( '%0.2f', trim( str_replace( ',', '.', $lavoro ) ), ' ' ) );
                    $ore = sprintf( '%0d', ( $aLavoro[0] ) );
                    $minuti = sprintf( '%0d', ( isset( $aLavoro[1] ) ) ? ( $aLavoro[1] * 60 / 100 ) : 0 );

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

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
