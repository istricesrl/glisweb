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
	$ct['form']['table'] = 'controlli';

    // tendina anagrafiche
    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM progetti_view' );

    // tendina questionari
    $ct['etc']['select']['questionari'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM questionari_view' );

    // tendina audit
    $ct['etc']['select']['audit'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM audit_view' );

    if( isset( $_REQUEST[$ct['form']['table']]['id_questionario'] ) ){
        $ct['etc']['select']['domande'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM questionari_domande WHERE id_questionario = ?',
            array( array( 's' => $_REQUEST[$ct['form']['table']]['id_questionario'] ) )
        );
    }
    
  
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
