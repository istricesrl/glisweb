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
    $ct['form']['table'] = 'popup';

    // tendina tipologie pubblicazioni
	$ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazione_view'
	);

    // tendina tipologie popup
	$ct['etc']['select']['tipologie_popup'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_popup_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
