<?php

    /**
     * macro form prodotti
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

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];
 
    // tendina produttori
	$ct['etc']['select']['produttori'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM anagrafica_view WHERE se_produttore = 1' 
    );

    // tendina marchi
	$ct['etc']['select']['marchi'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM marchi_view' 
    );

     // tendina tipologie
	$ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_prodotti_view' 
    );
    
     // tendina id_tipologia_pubblicazione
	$ct['etc']['select']['tipologie_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);

    // tendina unità di misura
	$ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'], 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM udm_view' );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
