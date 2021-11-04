<?php

    /**
     * macro form anagrafica
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
    $ct['form']['table'] = 'pagine';
    
    // tendina gruppi 
	$ct['etc']['select']['gruppi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM gruppi_view'
    );   

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
