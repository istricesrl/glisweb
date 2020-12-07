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

    /*
    // tendina tipologie pubblicazione
	$ct['etc']['select']['tipologie_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);
    */
    
    // tendina anagrafica
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view' );

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ) {
	    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
	        $cf['cache']['index'],
	        $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 OR id = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) ) );
	} else {
	    $ct['etc']['select']['id_anagrafica_collaboratori'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1' );
	}

    // tendina tipologia
	$ct['etc']['select']['id_tipologia'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_view' );

    // tendina clienti
	$ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_lead = 1 OR se_cliente = 1 OR se_prospect = 1' );

    // tendina esiti
	$ct['etc']['select']['id_esito'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM esiti_attivita_view' );

    // tendina interesse
	$ct['etc']['select']['id_interesse'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_interesse_view' );

    // tendina soddisfazione
	$ct['etc']['select']['id_soddisfazione'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_soddisfazione_view' );

    // tendina progetti
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE ( timestamp_chiusura IS NULL OR id = ? ) ORDER BY __label__', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) );
	} else {
	    $ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE timestamp_chiusura IS NULL ORDER BY __label__' );
	}

    // tendina task
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_progetto'] ) ) {
	    $ct['etc']['select']['id_task'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM task_view WHERE id_progetto = ? AND ( timestamp_completamento IS NULL OR id = ? )', array( array( 's' => $_REQUEST[ $ct['etc']['table'] ]['id_progetto'] ), array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_task'] ) ) );
	} else {
	    $ct['etc']['select']['id_task'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM task_view' );
	}

	if( isset( $_REQUEST['__preset__']['attivita']['id_task']  ) ){
	    $task = mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM task_view WHERE id = ?', 
	    array( array( 's' => $_REQUEST['__preset__']['attivita']['id_task'] ) ) );
	    $_REQUEST['__preset__']['attivita']['id_cliente'] = $task['id_cliente'];
	    $_REQUEST['__preset__']['attivita']['id_progetto'] = $task['id_progetto'];
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
