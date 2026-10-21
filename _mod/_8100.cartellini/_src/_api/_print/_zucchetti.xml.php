<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

    /**
     * Controllo autorizzazioni
     * ========================
     *
     * ⚠ Fix 2026-09-15: stesso segnaposto `if( true )` mai chiuso. Questo endpoint ha una query
     * sua che unisce `attivita` e `anagrafica` e produce l'export delle ore per la busta paga,
     * con i codici dipendente: non passa da `controller()`, quindi l'ACL per tabella non lo
     * protegge e serve il privilegio d'area. Il modulo non e' attivo su nessun deploy: la
     * correzione e' preventiva.
     */
	checkTaskPrivilege( 'GESTIONE_ANAGRAFICA' );

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
        header('Content-Type: application/xml; charset=utf-8');
        header('Content-Disposition: attachment; filename='.$filename);

        // root element, in forma di array per array2xml()
        // NOTA fino al 2026-09-25 il tracciato veniva scritto con XMLWriter; array2xml() produce lo stesso file byte per byte
        // ( verificato con più dipendenti, un solo movimento, nessun dipendente, & < > nei codici e & < > " negli attributi );
        // l'unica differenza possibile è una " nel testo di un elemento, che XMLWriter scriveva &quot;, stesso testo per l'XML
        $fornitura = array( 'Fornitura' => array() );

        // esportazione
        foreach( $attivita as $dipendente => $giornate ) {

            // attività del dipendente
            $movimenti = array( '@' => array( 'GenerazioneAutomaticaDaTeorico' => 'N' ) );

            // elenco attività del dipendente per giornata
            foreach( $giornate as $giornata => $codici ) {

                // elenco attività del dipendente per codice
                foreach( $codici as $codice => $lavoro ) {

                    // spacchetto le ore in ore e minuti
                    // NOTA %0.2F non segue la locale e usa sempre il punto: con %0.2f e la virgola i minuti tornavano giusti solo
                    // dove la locale mette la virgola ( PHP 7 con it_IT ), altrove 7,75 ore diventavano 7 ore e 0 minuti ( 2026-09-25 )
                    $aLavoro = explode( '.', sprintf( '%0.2F', trim( str_replace( ',', '.', $lavoro ) ) ) );
                    $ore = sprintf( '%0d', ( $aLavoro[0] ) );
                    $minuti = sprintf( '%0d', ( isset( $aLavoro[1] ) ) ? ( $aLavoro[1] * 60 / 100 ) : 0 );

                    // nodo attività
                    $movimenti['Movimento'][] = array(
                        'CodGiustificativoUfficiale' => $codice,
                        'Data' => $giornata,
                        'NumOre' => $ore,
                        'NumMinuti' => $minuti
                        // 'GiornoDiRiposo' => '', // TODO
                        // 'GiornoChiusuraStraordinari' => '', // TODO
                    );

                }

            }

            // nuovo dipendente
            $fornitura['Fornitura']['Dipendente'][] = array(
                '@' => array(
                    'CodAziendaUfficiale' => $cf['zucchetti']['profile']['azienda'],
                    'CodDipendenteUfficiale' => sprintf( '%07d', $dipendente )
                ),
                'Movimenti' => $movimenti
            );

        }

        // output del tracciato
        // NOTA fino al 2026-09-25 il file veniva scritto in DIR_TMP e non arrivava mai al client, che riceveva gli header del
        // download e un corpo vuoto; all'origine ( commit 760a119f0 ) XMLWriter scriveva su php://output
        echo array2xml( $fornitura );

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
