<?php

    /**
     * macro form prodotti caratteristiche
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
	$ct['form']['table'] = 'prodotti';

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id']  ) ){
        // dettagli tipologia
        $ct['etc']['value']['tipologia'] = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT tipologie_prodotti.* FROM tipologie_prodotti LEFT JOIN prodotti ON prodotti.id_tipologia = tipologie_prodotti.id WHERE prodotti.id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ));
    }

    // tendina caratteristiche
	$ct['etc']['select']['caratteristiche'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM caratteristiche_prodotti_view'
    );
/*
    // tendina stagioni
	$ct['etc']['select']['stagioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM stagioni_prodotti_view'
    );
*/    
	// tendina icona per caratteristica/opzione presente o meno
	$ct['etc']['select']['se_non_presente'] = array(
	    array( 'id' => NULL, '__label__' => 'sì' ),
	    array( 'id' => 1, '__label__' => 'no' )
	);

	// tendina icona per caratteristica/opzione visibile in menù o meno
	$ct['etc']['select']['se_visibile'] = array(
	    array( 'id' => 1, '__label__' => 'sì' ),
	    array( 'id' => NULL, '__label__' => 'no' )
	);
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
