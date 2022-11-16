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

    // documenti
    if( $_REQUEST[ $ct['form']['table'] ]['entita'] == 'documenti' ) {
        require DIR_BASE . '_mod/_0100.pianificazioni/_src/_inc/_macro/_pianificazioni.form.modello.documenti.php';
    }

    // entità
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'rinnovi', '__label__' => 'rinnovi' ),
        array( 'id' => 'documenti', '__label__' => 'documenti' ),
        array( 'id' => 'todo', '__label__' => 'todo' ),
        array( 'id' => 'attivita', '__label__' => 'attività' ),
        array( 'id' => 'documenti_articoli', '__label__' => 'articoli' ),
        array( 'id' => 'pagamenti', '__label__' => 'pagamenti' )
    );

    // tendina udm
	$ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM udm_view'
	);

	// tendina listini
	$ct['etc']['select']['listini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM listini_view '
	);

	// tendina reparti
	$ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM reparti_view '
	);

    // tendina tipologie anagrafica
    $ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM modalita_pagamento_view'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
