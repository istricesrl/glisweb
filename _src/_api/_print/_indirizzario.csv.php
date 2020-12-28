<?php

    // inclusione del framework
	require '../../_config.php';

    // controllo autorizzazioni
	if( true ) {

	    $where = array();
	    $join = array();
	    $params = array();
	    $from = '';

	    // se è indicata la categoria
	    if ( isset( $_REQUEST['__categoria__'] ) ) {
            if( ! empty( $_REQUEST['__categoria__'] ) ) {
                $where[] = 'anagrafica_categorie.id_categoria = ?';
                $params[] = array( 's' => $_REQUEST['__categoria__'] );  
                $join[] = 'LEFT JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id ';
            }
        }

        // condizioni
        $where = implode(' AND ', $where);
        $join = implode(' ', $join); 

        // risultato
        $ct['anagrafica'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT indirizzi.id, indirizzi.longitudine, indirizzi.latitudine, '.
            'concat_ws( " ", anagrafica.denominazione, anagrafica.cognome, anagrafica.nome ) AS contatto, '.
            'tipologie_indirizzi.nome AS tipologia, '.
            'indirizzi.indirizzo, indirizzi.civico, indirizzi.cap, '.
            'comuni.nome AS comune, provincie.sigla AS provincia '.
            'FROM indirizzi '.
            'INNER JOIN anagrafica_indirizzi ON anagrafica_indirizzi.id_indirizzo = indirizzi.id '.
            'INNER JOIN anagrafica ON anagrafica.id = anagrafica_indirizzi.id_anagrafica '.
            'INNER JOIN comuni ON comuni.id = indirizzi.id_comune '.
            'INNER JOIN provincie ON provincie.id = comuni.id_provincia '.
            'LEFT JOIN tipologie_indirizzi ON tipologie_indirizzi.id = anagrafica_indirizzi.id_tipologia '.
            $join.
            ( ( ! empty( $where ) ) ? ' WHERE '.$where. ' ' : NULL ).
            'ORDER BY anagrafica.denominazione, anagrafica.cognome, anagrafica.nome ',
            $params
        );

		// debug
//			 die( 'risultato: '.print_r( $ct['fatturati'], true ) );
//			 die( print_r( 'where: '.$where)  );
//			 die( print_r($params,true) );
//			 die( print_r($_REQUEST,true) );
//			 die( 'fatturati: '.print_r( $ct['fatturati'], true ) );
		    // se sono presenti dati

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

		

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
