<?php

    /**
     * macro form mail_out
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
    $ct['form']['table'] = 'mail_out';

    // sotto tabella gestita
    $ct['form']['subtable'] = 'file';
    
    // tendina ruolo immagini
	$ct['etc']['select']['ruoli_file'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_file_view WHERE se_mail = 1'
	);

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // memoria di lavoro
    if( isset( $_SESSION['__work__']['mailattach']['items'] ) ) {
        if( isset( $_POST[ $ct['form']['table'] ]['file']) ) {
            unset( $_SESSION['__work__']['mailattach'] );
        } else {
            $counter = 0;
            foreach( $_SESSION['__work__']['mailattach']['items'] as $item ) {
                $_REQUEST[ $ct['form']['table'] ]['file'][] = array(
                    'ordine' => $counter += 10,
                    'id_mail_out' => $_REQUEST[ $ct['form']['table'] ]['id'],
                    'nome' => $item['label'],
                    'id_ruolo' => 1,
                    'path' => $item['path']
                );
            }
        }
    }

    // debug
    // print_r( $_SESSION['__work__']['mailattach']['items'] );
    // print_r( $_REQUEST );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
