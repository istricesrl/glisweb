<?php

    /**
     * macro form pagine
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

    // tendina id caratteristiche
	$ct['etc']['select']['id_caratteristiche'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM caratteristiche_view'
    );
 
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
