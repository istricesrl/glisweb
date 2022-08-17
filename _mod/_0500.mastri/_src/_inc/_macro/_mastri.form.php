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
	$ct['form']['table'] = 'mastri';

    // tendina tipologia mastri
    $ct['etc']['select']['tipologie_mastri'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_mastri_view'
	);

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {

        // tendina genitore
        $ct['etc']['select']['genitori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM mastri_view  WHERE id <> ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );

    } else {

        // tendina genitore
        $ct['etc']['select']['genitori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM mastri_view'
        );

    }

    // tendina anagrafica
    $ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM anagrafica_view'
    );

    // tendina account
    $ct['etc']['select']['account'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM account_view'
    );

    // tendina indirizzo anagrafica
    $ct['etc']['select']['id_anagrafica_indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_indirizzi_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
