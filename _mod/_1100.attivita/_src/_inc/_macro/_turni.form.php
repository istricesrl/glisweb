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
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM contratti_view'
    );

    // tendina anagrafica
    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1'
    );

    // se è settato un contratto ricavo l'anagrafica corrispondente
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_contratto'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_contratto'] ) ){
        $ct['etc']['id_anagrafica'] = mysqlSelectValue(
                 $cf['mysql']['connection'],
                'SELECT id_anagrafica FROM contratti WHERE id = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_contratto'] ) )
            );
    }


    // tendina turni
    foreach( range( 1, 9 ) as $turno ) {
        $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
    }
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
