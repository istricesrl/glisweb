<?php

    /**
     * macro form task
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
	$ct['form']['table'] = 'task';

    // tendina priorita
	$ct['etc']['select']['id_priorita'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM priorita_view' );
    
    // tendina collaboratori
	$ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1' );
	
    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_lead = 1 OR se_cliente = 1 OR se_prospect = 1' );

     // tendina anni
	foreach( range( date( 'Y' ) + 1, 2017 ) as $y ) {
	    $ct['etc']['select']['anni'][] = array( 'id' => $y, '__label__' => $y );
	}

    // tendina settimane
	foreach( range( 1, 52 ) as $w ) {
	    $ct['etc']['select']['settimane'][] = array( 'id' => $w, '__label__' => $w . ' / ' . substr( int2month( ceil( $w / 4.348125 ) ), 0, 3 ) );
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
