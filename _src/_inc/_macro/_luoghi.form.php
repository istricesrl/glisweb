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
	$ct['form']['table'] = 'luoghi';

    // tendina luoghi genitore
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

		$ct['etc']['select']['luoghi'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM luoghi_view WHERE id <> ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
		);

	} else {

		$ct['etc']['select']['luoghi'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM luoghi_view'
		);

	}

    // tendina comuni
	$ct['etc']['select']['indirizzi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM indirizzi_view'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
