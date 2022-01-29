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
    $ct['form']['table'] = 'immagini';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		'label' => NULL
	    )
	);

    $ct['page']['contents']['metro']['azioni'][] = array(
		'ws' => $ct['site']['url'] . '_src/_api/_task/_images.resize.php?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
		'icon' => NULL,
		'fa' => 'fa-image',
		'title' => 'scalatura immagine',
		'text' => 'forza la scalatura di questa immagine'
	    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';