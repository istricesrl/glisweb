<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'popup';

    // tendina anagrafica
	$ct['etc']['select']['popup_pagine'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM popup_pagine_view'
    );

    // tendina pollice per presenza del popup sulla pagina o meno
	$ct['etc']['select']['se_presente'] = array(
	    array( 'id' => NULL, '__label__' => '&#xf00c;' ),
	    array( 'id' => 1, '__label__' => '&#xf05e;' )
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
