<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'tipologie_todo';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $ct['etc']['select']['genitori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_todo_view  WHERE id <> ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );
    } else {
        $ct['etc']['select']['genitori'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_todo_view'
        );
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
