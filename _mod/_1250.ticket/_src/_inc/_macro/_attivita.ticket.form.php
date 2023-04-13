<?php

    /**
     * macro form anagrafica
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
	$ct['form']['table'] = 'attivita';
    
    // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );

    // tendina tipologia
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
#        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_ticket = 1' );
        'SELECT id, __label__ FROM tipologie_attivita_view WHERE se_sistema IS NULL ORDER BY __label__' );

    // tendina clienti
	$ct['etc']['select']['clienti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' );

    // tendina esiti
	$ct['etc']['select']['esiti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM esiti_attivita_view' );
/*
    // tendina categorie attivita
	$ct['etc']['select']['categorie_attivita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_attivita_view'
	);
*/
    // tendina progetti
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE ( timestamp_chiusura IS NULL OR id = ? ) ORDER BY __label__', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) );
	} else {
	    $ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE timestamp_chiusura IS NULL ORDER BY __label__' );
	}

    // tendina todo/ticket
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM ticket_view WHERE id_progetto = ? AND ( timestamp_completamento IS NULL OR id = ? )', 
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ), 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ) 
            );
	} else {
	    $ct['etc']['select']['todo'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM ticket_view' );
	}

    // tendina indirizzi
    $ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM indirizzi_view' );
    

	if( isset( $_REQUEST['__preset__']['attivita']['id_todo']  ) ){
	    $todo = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM ticket_view WHERE id = ?', 
        array( array( 's' => $_REQUEST['__preset__']['attivita']['id_todo'] ) ) );
        
        if( ! empty($todo['id_cliente']) ){
            $_REQUEST['__preset__']['attivita']['id_cliente'] = $todo['id_cliente'];
        }
        
        if( ! empty($todo['id_progetto']) ){
	        $_REQUEST['__preset__']['attivita']['id_progetto'] = $todo['id_progetto'];
        }

        if( ! empty($todo['id_indirizzo']) ){
	        $_REQUEST['__preset__']['attivita']['id_indirizzo'] = $todo['id_indirizzo'];
        }

        if( ! empty($todo['id_mastro_attivita_default']) ){
	        $_REQUEST['__preset__']['attivita']['id_mastro_provenienza'] = $todo['id_mastro_attivita_default'];
        }

        if( !empty($todo['data_programmazione'] ) ){
            $_REQUEST['__preset__']['attivita']['data_programmazione'] = $todo['data_programmazione'];
        }

        if( !empty($todo['ora_inizio_programmazione'] ) ){
            $_REQUEST['__preset__']['attivita']['ora_inizio_programmazione'] = $todo['ora_inizio_programmazione'];
        }
        
        if( !empty($todo['ora_fine_programmazione'] ) ){
            $_REQUEST['__preset__']['attivita']['ora_fine_programmazione'] = $todo['ora_fine_programmazione'];
        }
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

 