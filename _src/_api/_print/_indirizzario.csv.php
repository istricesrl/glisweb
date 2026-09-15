<?php

    // inclusione del framework
	require '../../_config.php';

    /**
     * Controllo autorizzazioni
     * ========================
     *
     * ⚠ Fix 2026-09-15 — QUESTO ENDPOINT CONSEGNAVA LA RUBRICA INTERA A CHIUNQUE. Verificato su un
     * deploy reale ( Polmasi, una polisportiva ) **da anonimo, senza nessuna sessione**:
     * `GET /print/indirizzario.csv` rispondeva `200` con **3,5 MB** di nomi, indirizzi, civici,
     * CAP, comuni e province di tutti gli iscritti, minori compresi. Non serviva nemmeno un
     * parametro.
     *
     * La causa era il segnaposto `if( true )` con il ramo `else` gia' scritto e mai raggiungibile:
     * il controllo era previsto e non e' mai stato messo.
     *
     * Si usa lo stesso meccanismo introdotto il 05/09 per gli endpoint `/task/`:
     * `checkTaskPrivilege()`, che verifica il privilegio, logga il tentativo nel canale `security`,
     * risponde 403 ed esce. `GESTIONE_ANAGRAFICA` e' attribuito a `roots` e a `staff`, quindi chi
     * usa davvero l'esportazione non se ne accorge; `users` non ce l'ha.
     *
     * ⚠ NON basta "essere autenticati" qui, come invece basta in `_default.csv.php`: quello passa
     * da `controller()` e si prende l'ACL per tabella, questo ha una query sua e l'ACL non lo
     * vede. La stessa distinzione vale per `_anagrafica.csv.php`.
     */
	checkTaskPrivilege( 'GESTIONE_ANAGRAFICA' );

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
