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
	$ct['form']['table'] = 'tipologie_periodi';

    // tendina luoghi genitore
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

		$ct['etc']['select']['tipologie_periodi'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM tipologie_periodi_view WHERE id <> ?',
			array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
		);

	} else {

		$ct['etc']['select']['tipologie_periodi'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM tipologie_periodi_view'
		);

	}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
