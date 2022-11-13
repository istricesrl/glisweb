<?php

    /**
     * macro form ticket
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

    // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 'SELECT id, __label__ FROM tipologie_todo_view WHERE se_ticket = 1' );

    // tendina collaboratori
	$ct['etc']['select']['anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );
	
    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_view' );


    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );
/*
    // tendina categorie attivita
	$ct['etc']['select']['categorie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_attivita_view WHERE se_ticket = 1'
	);
*/
    // settaggio di cliente, indirizzo, mastro attivita letti dal progetto
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
