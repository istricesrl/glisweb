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
	$ct['form']['table'] = 'indirizzi';

    // tendina tipologie indirizzi
	$ct['etc']['select']['tipologie_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_indirizzi_view'
    );    
    
    // tendina comuni
	$ct['etc']['select']['comuni'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM comuni_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
