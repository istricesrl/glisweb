<?php

    /**
     * macro form cartellini
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
	$ct['form']['table'] = 'cartellini';

    // tendina anagrafica
	$ct['etc']['select']['id_anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT anagrafica_view_static.id, anagrafica_view_static.__label__ FROM account '. 
        'LEFT JOIN anagrafica_view_static ON anagrafica_view_static.id = account.id_anagrafica ');
    
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
