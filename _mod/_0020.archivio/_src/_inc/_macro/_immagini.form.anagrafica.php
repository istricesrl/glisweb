<?php

    /**
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'immagini';

    // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery( 
        $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static' 
    );

    // tendina ruoli
	$ct['etc']['select']['ruoli_anagrafica'] = mysqlQuery( 
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM ruoli_immagini_anagrafica_view' 
    );
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
