<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['form']['table'] = 'documenti';

    // percorsi
	// $base = $ct['site']['url'].'_mod/_0400.documenti/_src/_api/_print/';
	$base = $ct['site']['url'].'print/0400.documenti/';

    $ct['page']['contents']['metros'] = array(
        'pdf' => array(
        'label' => 'stampe PDF'
        ),
        'xml' => array(
            'label' => 'stampe XML'
        )
    );

    if( isset( $_REQUEST[ $ct['form']['table'] ] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        $ct['page']['contents']['metro']['pdf'][] = array(
            'target' => '_blank' ,
            'url' => $base . 'offerta.pdf?__documento__='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-file-pdf-o',
            'title' => 'stampa PDF',
            'text' => 'stampa l\'offerta in formato PDF'
        );

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   