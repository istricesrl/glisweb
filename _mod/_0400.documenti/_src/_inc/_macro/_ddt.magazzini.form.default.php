<?php

    // die('TEST');
    // print_r( $_REQUEST );
    // print_r( $ct['page']['etc']['tabs'] );

    // ...
    $ct['etc']['ordine']['id'] = NULL;

	// TODO trovare l'ordine collegato se c'è in base al ruolo, al tipo di documento, eccetera
    if( isset( $_REQUEST['documenti']['id'] ) ) {
        $ct['etc']['ordine']['id'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_documento_collegato FROM relazioni_documenti WHERE id_documento = ? LIMIT 1',
            array( array( 's' => $_REQUEST['documenti']['id'] ) )
        );
    }

    // se c'è un ordine collegato
    if( empty( $ct['etc']['ordine']['id'] ) ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['ddt.magazzini.form.ordine']
        );
    }

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

		// TODO aggiunta riga da stringone
		if( isset( $_REQUEST['__evasione__'] ) ) {

			// TODO spacchettare l'ID che è composto da idMagazzinoProvenienza|idArticolo|idMatricola
			$evasione = explode( '|', $_REQUEST['__evasione__']['id_giacenza'] );

			// trovo la quantità massima
			$cap = str_replace( ',', '.', mysqlSelectValue(
				$cf['mysql']['connection'],
				'SELECT totale FROM __report_giacenza_magazzini_foglie_attive__ WHERE id = ?',
				array( array( 's' => $_REQUEST['__evasione__']['id_giacenza'] ) )
			) );
	
			// debug
			// echo $_REQUEST['__evasione__']['quantita'].' vs. '.$cap.PHP_EOL;

			// cap della quantità
			if( $_REQUEST['__evasione__']['quantita'] <= $cap ) {

				// TODO inserire la riga di documenti_articoli con i dati ricavati sopra
				mysqlInsertRow(
					$cf['mysql']['connection'],
					array(
						'id' => NULL,
						'id_documento' => $_REQUEST[ $ct['form']['table'] ]['id'],
						'id_articolo' => $evasione[1],
						'id_matricola' => isset( $evasione[2] ) ? $evasione[2] : NULL,
						'id_udm' => 1,
						'quantita' => $_REQUEST['__evasione__']['quantita'],
						'id_mastro_provenienza' => $evasione[0]
					),
					'documenti_articoli'
				);

			}

		}

	}
