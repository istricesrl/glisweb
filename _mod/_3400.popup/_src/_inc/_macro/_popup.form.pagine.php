<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'popup';

    // tendina pagine
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_sito'] ) ){       
        $ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pagine_view WHERE id_sito = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_sito'] ) )
        );
    }
    else{
        $ct['etc']['select']['pagine'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pagine_view'
        );
    }
   
	

    // tendina pollice per presenza del popup sulla pagina o meno
	$ct['etc']['select']['se_presente'] = array(
	    array( 'id' => NULL, '__label__' => 'sì' ),
	    array( 'id' => 1, '__label__' => 'no' )
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
