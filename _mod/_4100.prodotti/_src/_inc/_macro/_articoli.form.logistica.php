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
	$ct['form']['table'] = 'articoli';

    // tendina caratteristiche
	$ct['etc']['select']['ruoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_mastri_view'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
