<?php

    // inclusione del framework
	require '../../../../../_src/_config.php';

    // controllo autorizzazioni
	if( true ) {

		// controllo parametri
		if( empty( $_REQUEST['__lista__'] ) ) {

			// errore
			buildText( 'nessuna lista specificata' );

		} else {

			$lista = array( 'id_lista' => $_REQUEST['__lista__'] );

			controller(
				$cf['mysql']['connection'],
				$cf['memcache']['connection'],
				$lista,
				'liste_mail'
			);

			// print_r( $lista );

			remapArray(
				$lista,
				array(
					'id_anagrafica' => 'id',
					'anagrafica_nome' => 'nome',
					'anagrafica_cognome' => 'cognome',
					'anagrafica_denominazione' => 'denominazione',
					'anagrafica_codice' => 'codice',
					'anagrafica_codice_fiscale' => 'codice_fiscale',
					'mail' => 'mail',
					'lista' => 'lista'
				)
			);

			// print_r( $lista );

			// TODO usare array2csvFile()
            // buildCsv( array2csvString( $lista, ';' ), 'iscritti.csv' );

		}

	} else {

	    // errore
		buildText( 'non autorizzato' );

	}
