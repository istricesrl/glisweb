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

		$ct['etc']['note'] = mysqlSelectValue(
			$cf['mysql']['connection'],
			'SELECT note_invio FROM documenti INNER JOIN relazioni_documenti ON relazioni_documenti.id_documento_collegato = documenti.id WHERE documenti.id_tipologia = 7 AND  relazioni_documenti.id_documento = ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
		);

	}

	// print_r( $ct['etc']['evasione'] );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
