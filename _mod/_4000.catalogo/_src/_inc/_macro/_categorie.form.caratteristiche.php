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

    // sotto tabella gestita
	$ct['form']['subtable'] = 'categorie_prodotti_caratteristiche';

    // tendina id caratteristiche
	$ct['etc']['select']['id_caratteristiche'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM categorie_prodotti_caratteristiche_view'
    );
    
	// tendina icona per caratteristica/opzione presente o meno
	$ct['etc']['select']['se_non_presente'] = array(
	    array( 'id' => NULL, '__label__' => '&#xf00c;' ),
	    array( 'id' => 1, '__label__' => '&#xf00d;' )
	);

	// tendina icona per caratteristica/opzione visibile in menù o meno
	$ct['etc']['select']['se_visibile'] = array(
	    array( 'id' => 1, '__label__' => '&#xf00c;' ),
	    array( 'id' => NULL, '__label__' => '&#xf00d;' )
	);

    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>