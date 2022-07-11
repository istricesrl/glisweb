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
	$ct['form']['table'] = 'pianificazioni';

    // tendina tipologie indirizzi
	$ct['etc']['select']['entita'] = array(
        array( 'id' => 'todo', '__label__' => 'todo' ),
        array( 'id' => 'attivita', '__label__' => 'attivita' ),
        array( 'id' => 'rinnovi', '__label__' => 'rinnovi' ),
        array( 'id' => 'documenti', '__label__' => 'documenti' ),
        array( 'id' => 'documenti_articoli', '__label__' => 'righe di documenti' ),
        array( 'id' => 'pagamenti', '__label__' => 'pagamenti' )
    );

    $ct['etc']['select']['periodicita'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM periodicita_view'
    );

    // tendina luoghi genitore
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        $ct['etc']['select']['pianificazioni'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pianificazioni_view WHERE id <> ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );

    } else {

        $ct['etc']['select']['pianificazioni'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM pianificazioni_view'
        );

    }
    
	
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
