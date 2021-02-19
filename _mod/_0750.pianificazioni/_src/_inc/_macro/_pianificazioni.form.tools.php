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
	$ct['form']['table'] = 'pianificazioni';

    $ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		'label' => 'azioni'
	    )
	);

    // modal per pulire gli oggetti futuri non più conformi
    $ct['page']['contents']['metro']['azioni'][] = array(
	    'modal' => array('id' => 'pulisci', 'include' => 'inc/pianificazioni.form.tools.modal.pulisci.html' ),
        'icon' => NULL,
	    'fa' => 'fa-eraser',
	    'title' => 'rimuovi oggetti non conformi',
	    'text' => 'rimuove gli oggetti già esistenti non più conformi'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
