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
	$ct['form']['table'] = 'attivita';

    // tendina interesse
	$ct['etc']['select']['id_interesse'] = array(
        array( 'id' => '1', '__label__' => '1' ),
        array( 'id' => '2', '__label__' => '2' ),
        array( 'id' => '3', '__label__' => '3' ),
        array( 'id' => '4', '__label__' => '4' ),
        array( 'id' => '5', '__label__' => '5' ),
        array( 'id' => '6', '__label__' => '6' ),
        array( 'id' => '7', '__label__' => '7' ),
        array( 'id' => '8', '__label__' => '8' ),
        array( 'id' => '9', '__label__' => '9' ),
        array( 'id' => '10', '__label__' => '10' )
    );


    // tendina soddisfazione
	$ct['etc']['select']['id_soddisfazione'] = array(
        array( 'id' => '1', '__label__' => '1' ),
        array( 'id' => '2', '__label__' => '2' ),
        array( 'id' => '3', '__label__' => '3' ),
        array( 'id' => '4', '__label__' => '4' ),
        array( 'id' => '5', '__label__' => '5' ),
        array( 'id' => '6', '__label__' => '6' ),
        array( 'id' => '7', '__label__' => '7' ),
        array( 'id' => '8', '__label__' => '8' ),
        array( 'id' => '9', '__label__' => '9' ),
        array( 'id' => '10', '__label__' => '10' )
    );

    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1' );
        
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
