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
    $ct['form']['table'] = 'categorie_prodotti';
    
    // tendina id_genitore
	$ct['etc']['select']['id_genitore'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_prodotti_view'
    );
    
     // tendina template
	$ct['etc']['select']['template'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_prodotti_view'
    );
    
     // tendina schema_html
	$ct['etc']['select']['schema_html'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_prodotti_view'
    );
    
     // tendina id_tipologia_pubblicazione
	$ct['etc']['select']['id_tipologia_pubblicazione'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_prodotti_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
