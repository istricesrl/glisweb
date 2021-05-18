<?php

    /**
     * macro form todo
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
	$ct['form']['table'] = 'todo';

    // tendina priorita
	$ct['etc']['select']['id_priorita'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM priorita_view' );

    // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_attivita_view' );
    
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

    // tendina progetti
	$ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_view' );

    // tendina categorie attivita
	$ct['etc']['select']['categorie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_attivita_view'
	);

    // tendina mastri attivita
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view'
    );

     // tendina anni
	foreach( range( date( 'Y' ) + 1, 2017 ) as $y ) {
	    $ct['etc']['select']['anni'][] = array( 'id' => $y, '__label__' => $y );
	}

    // tendina settimane
	foreach( range( 1, 52 ) as $w ) {
	    $ct['etc']['select']['settimane'][] = array( 'id' => $w, '__label__' => $w . ' / ' . substr( int2month( ceil( $w / 4.348125 ) ), 0, 3 ) );
	}

    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );

    // settaggio di cliente e indirizzo letti dal progetto
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ){
        $ct['etc']['id_cliente'] = mysqlSelectValue(
                 $cf['mysql']['connection'],
                'SELECT id_cliente FROM progetti WHERE id = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
            );

        $ct['etc']['id_indirizzo'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_indirizzo FROM progetti WHERE id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) )
        );
    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
