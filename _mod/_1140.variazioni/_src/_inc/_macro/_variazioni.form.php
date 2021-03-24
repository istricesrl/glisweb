<?php

    /**
     * macro form variazioni
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
	$ct['form']['table'] =  'variazioni_attivita';

    // tendina anagrafica
	$ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1' );

    // tendina tipologia
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_variazioni_attivita_view' );

    // tendina tipologia inps
	$ct['etc']['select']['tipologie_inps'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_attivita_inps_view' );

    
    if( !isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['variazioni.form.approvazione']
        );
    }
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
