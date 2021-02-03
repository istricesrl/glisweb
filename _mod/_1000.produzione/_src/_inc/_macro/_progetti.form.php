<?php

    /**
     * macro form progetti
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'progetti';
    
    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_cliente = 1' );

    // tendina anagrafica per referenti e operatori (TODO vedere se filtrare sui referenti del cliente)
    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 OR se_referente = 1' );


    // tendina indirizzi
	$ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );

    // tendina tipologie progetti
	$ct['etc']['select']['tipologie_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_progetti_view'
    );
    
    // tendina ruoli progetti
	$ct['etc']['select']['ruoli_progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_progetti_view'
    );
    
     // tendina funzioni
	$ct['etc']['select']['funzioni'] = array(
	    array( 'id' => NULL, '__label__' => 'titolare' ),
	    array( 'id' => 1, '__label__' => 'sostituto' )
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
