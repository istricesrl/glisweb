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
    $ct['form']['table'] = 'turni';

     // tendina contratti
    $ct['etc']['select']['contratti'] = mysqlCachedIndexedQuery(
        $cf['cache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM contratti_view'
    );

    // tendina turni
    foreach( range( 1, 9 ) as $turno ) {
        $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
    }
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
