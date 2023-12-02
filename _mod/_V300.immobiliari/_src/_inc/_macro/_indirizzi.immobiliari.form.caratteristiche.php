<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'indirizzi';
    
    // tendina caratteristiche
	$ct['etc']['select']['caratteristiche'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM caratteristiche_view WHERE se_indirizzo = 1'
	);
   
    $ct['etc']['select']['sn'] = array(
        array( 'id' => NULL, '__label__' => 'no' ),
        array( 'id' => 1, '__label__' => 'sì' )
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    