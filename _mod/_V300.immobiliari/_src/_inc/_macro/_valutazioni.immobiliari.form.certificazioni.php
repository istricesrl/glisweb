<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */


	// tabella gestita
    $ct['form']['table'] = 'valutazioni';

    // tendina per le certificazioni
    $ct['etc']['select']['certificazioni'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM certificazioni_view'
    );

    // tendina emittenti
	$ct['etc']['select']['emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

 