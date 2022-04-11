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
    $ct['form']['table'] = 'risorse';

    // tendina tipologie
    $ct['etc']['select']['tipologie'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM tipologie_risorse_view' 
    );

    // tendina categorie
    $ct['etc']['select']['categorie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM categorie_risorse_view' 
    );

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][] = array('id' => $mese, '__label__' => int2month( $mese ) );
	}

    // tendina giorni
	foreach( range( 1, 31 ) as $giorno ) {
	    $ct['etc']['select']['giorni'][] = array( 'id' => $giorno.'', '__label__' =>  $giorno  );
	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
