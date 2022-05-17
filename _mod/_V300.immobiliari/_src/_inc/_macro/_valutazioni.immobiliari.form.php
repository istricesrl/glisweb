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
    $ct['form']['table'] = 'valutazioni';


    // tendina ruoli anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
    );

    // tendina ruoli immobili
	$ct['etc']['select']['immobili'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM immobili_view'
    );

    // tendina ruoli disponibilita
	$ct['etc']['select']['disponibilita'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM disponibilita_view WHERE se_immobili = 1' 
    );    

    // tendina ruoli condizioni
	$ct['etc']['select']['condizioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM condizioni_view WHERE se_immobili = 1'
    );   

    // tendina ruoli classi energetiche
	$ct['etc']['select']['classi_energetiche'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM classi_energetiche_view'
    );   

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
