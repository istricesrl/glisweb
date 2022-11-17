<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'contratti';

	// gestione richiesta in lista d'attesa
	if( isset( $_REQUEST['idAttesa'] ) ) {
		if( ! isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) || empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
			$_REQUEST[ $ct['form']['table'] ]['id_progetto'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_progetto FROM anagrafica_progetti WHERE id = ?', array( array( 's' => $_REQUEST['idAttesa'] ) ) );
			$ct['etc']['richiedente'] = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_anagrafica FROM anagrafica_progetti WHERE id = ?', array( array( 's' => $_REQUEST['idAttesa'] ) ) );
		} else {
			// TODO qui archiviare la richiesta
		}
	}

    // tendina ruoli progetti
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
    );

    // tendina ruoli progetti
	$ct['etc']['select']['ruoli_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_anagrafica_view WHERE se_contratti = 1'
    );

    // tendina emittenti
	$ct['etc']['select']['agenzia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static '
    );
    
    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view '
    );

	// tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_iscrizione = 1'
    );

	$ct['etc']['gestita'] = mysqlSelectCachedValue(
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id FROM anagrafica_view WHERE se_gestita = 1'
	);

	/*
	if( isset( $_SESSION['__work__'] ) ){

		if( isset( $_SESSION['__work__']['id_anagrafica'] ) ){
            $_REQUEST['__preset__'][ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'] = $_SESSION['__work__']['id_anagrafica'];
		}

		if( isset( $_SESSION['__work__']['id_progetto'] ) ){
            $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_progetto'] = $_SESSION['__work__']['id_progetto'];
		}
	}*/

    // ...
    if( isset( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] ) ) {
		arraySortBy( 'data_inizio', $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
    	$ct['etc']['sub']['primo_rinnovo']['key'] = $_REQUEST[ $ct['form']['table'] ]['rinnovi'][0];
	}

	// ...
	$ct['etc']['sub']['primo_rinnovo']['key'] = 0;

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
