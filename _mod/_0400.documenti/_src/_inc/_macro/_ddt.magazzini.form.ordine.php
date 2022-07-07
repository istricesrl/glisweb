<?php

	// debug
	// print_r( $_REQUEST );

    // tabella gestita
	$ct['form']['table'] = 'documenti';

    // tendina articoli
	$ct['etc']['select']['id_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM articoli_view'
	);

    // tendina udm
	$ct['etc']['select']['id_udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM udm_view'
	);

	// tendina mastri
	$ct['etc']['select']['id_mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 1'
	);

    // macro di default per l'entità DDT
	require DIR_BASE . '_mod/_0400.documenti/_src/_inc/_macro/_ddt.magazzini.form.default.php';

    // tabella status evasione
    $ct['etc']['evasione'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT codice_prodotto, prodotto, quantita_ordinata, quantita_evasa, quantita_da_evadere, udm '.
        'FROM __report_evasione_ordini__ WHERE id_ordine = ? ORDER BY quantita_da_evadere DESC',
        array( array( 's' => $ct['etc']['ordine']['id'] ) )
    );

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

		// TODO aggiunta riga da stringone
		if( isset( $_REQUEST['__evasione__'] ) ) {

			// TODO spacchettare l'ID che è composto da idMagazzinoProvenienza|idArticolo|idMatricola
			$evasione = explode( '|', $_REQUEST['__evasione__']['id_giacenza'] );

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

		$ct['etc']['note'] = mysqlSelectValue(
			$cf['mysql']['connection'],
			'SELECT note_invio FROM documenti INNER JOIN relazioni_documenti ON relazioni_documenti.id_documento_collegato = documenti.id WHERE documenti.id_tipologia = 7 AND  relazioni_documenti.id_documento = ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
		);
		}
    // print_r( $ct['etc']['evasione'] );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
