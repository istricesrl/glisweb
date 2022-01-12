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
    $ct['form']['table'] = 'tipologie_attivita';

    // tendina per gli articoli
    $ct['etc']['select']['articoli'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM articoli_view'
    );

    // tendina mastri
	$ct['etc']['select']['mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 3'
    );
    

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
