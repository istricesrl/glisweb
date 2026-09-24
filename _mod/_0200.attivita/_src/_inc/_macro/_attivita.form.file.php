<?php

    /**
     * macro form pagine
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

    // sotto tabella gestita
	$ct['form']['subtable'] = 'file';

    // tendina ruolo file
	$ct['etc']['select']['ruoli_file'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_file_view WHERE se_mail = 1'
	);

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // integro gli allegati
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['id_todo'] ) ) {

        // ...
        $allegatiTodo = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM file WHERE id_todo = ?',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_todo'] )
            )
        );

        // ...
        $_REQUEST[ $ct['form']['table'] ]['file'] = ( isset( $_REQUEST[ $ct['form']['table'] ]['file'] ) )
            ?
            array_merge(
                $_REQUEST[ $ct['form']['table'] ]['file']
                ,
                $allegatiTodo
            )
            :
            $allegatiTodo
        ;

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
