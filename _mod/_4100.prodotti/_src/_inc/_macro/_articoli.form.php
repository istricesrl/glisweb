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
    $ct['form']['table'] = 'articoli';

    // tendina prodotti
	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM prodotti_view' );

    // tendina colori
	$ct['etc']['select']['colori'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM colori_view' );

    // tendina id_tipologia_pubblicazione
	$ct['etc']['select']['tipologie_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);

    // tendina taglie
	$ct['etc']['select']['taglie'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM taglie_view' );

    // tendina unità di misura
	$ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM udm_view' );

    // tendina reparti
	$ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM reparti_view' );    

    if( isset( $_REQUEST['__preset__']['articoli']['id_prodotto']  ) ){
        // unità di misura di default
        $ct['etc']['value']['udm'] = mysqlSelectValue(
            $cf['mysql']['connection'], 
            'SELECT id_udm FROM prodotti WHERE id = ?',
            array( array( 's' => $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_prodotto'] ) ) );
    
        // dettagli tipologia
        $ct['etc']['value']['tipologia'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT tipologie_prodotti.* FROM tipologie_prodotti LEFT JOIN prodotti ON prodotti.id_tipologia = tipologie_prodotti.id WHERE prodotti.id = ?',
            array( array( 's' => $_REQUEST['__preset__'][ $ct['form']['table'] ]['id_prodotto'] ) ));
    }

    
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_prodotto']  ) ){
        // dettagli tipologia
        $ct['etc']['value']['tipologia'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT tipologie_prodotti.* FROM tipologie_prodotti LEFT JOIN prodotti ON prodotti.id_tipologia = tipologie_prodotti.id WHERE prodotti.id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_prodotto'] ) ));
    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
