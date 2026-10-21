<?php
/**
     * macro form articoli
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
    $ct['form']['table'] = 'reparti';

    // tendina unità dell'iva
	$ct['etc']['select']['iva'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, concat( __label__, if( timestamp_archiviazione IS NULL, "", " ( aliquota archiviata )" ) ) AS __label__ '.
        'FROM iva_view WHERE timestamp_archiviazione IS NULL OR id = ? ORDER BY __label__',
        array( array( 's' => ( isset( $_REQUEST[ $ct['form']['table'] ]['id_iva'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id_iva'] : NULL ) ) );

    // tendina unità del settore
	$ct['etc']['select']['settori'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM settori_view' );

  

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';