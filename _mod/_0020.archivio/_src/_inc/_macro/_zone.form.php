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
	$ct['form']['table'] = 'zone';

    // tendina tipologie indirizzi
	$ct['etc']['select']['tipologie_zone'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_zone_view'
	);

        // tendina luoghi genitore
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

		$ct['etc']['select']['zone'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM zone_view WHERE id <> ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
		);

	} else {

		$ct['etc']['select']['zone'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM zone_view'
		);

	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
