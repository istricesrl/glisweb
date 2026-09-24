<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'pianificazioni';

    // tendina tipologie anagrafica
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

	// tendina condizioni_pagamento
	$ct['etc']['select']['condizioni_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM condizioni_pagamento_view'
	);

	// esigibilità iva
	$ct['etc']['select']['esigibilita'] = array(
		array( 'id' => 'I', '__label__'=> 'I - immediata' ),
		array( 'id' =>'D', '__label__'=> 'D - differita' ),
		array( 'id' =>'S', '__label__'=> 'S - scissione dei pagamenti')
	); 

    // tendina mittenti
	$ct['etc']['select']['id_emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
	);

    // tendina destinatari
	$ct['etc']['select']['id_destinatari'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
	);

    // tendina indirizzi mittenti
    if( isset( $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] ) ){

		// tendina sedi
		$ct['etc']['select']['id_sedi_emittente'] = tendinaSediAnagrafica( $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] );

		// tendina IBAN
		$ct['etc']['select']['id_iban'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM iban_view WHERE id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['model_id_emittente'] ) )
		);

	} 

	// tendina indirizzi destinatari
    if( isset( $_REQUEST[ $ct['form']['table'] ]['model_id_destinatario'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['model_id_destinatario'] ) ){
	    $ct['etc']['select']['id_sedi_destinatario'] = tendinaSediAnagrafica( $_REQUEST[ $ct['form']['table'] ]['model_id_destinatario'] );
	} 

    // tendina fine mese
	$ct['etc']['select']['fine_mese'] = array( 
	    array( 'id' => '1', '__label__' => 'fine mese' )
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
