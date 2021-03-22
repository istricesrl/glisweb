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
	    'title' => 'rimuovi oggetti futuri',
	    'text' => 'rimuove gli oggetti futuri già esistenti in caso di modifica'
	);

    // modal per fermare la pianificazione originaria
    $ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'ferma', 'include' => 'inc/pianificazioni.form.tools.modal.ferma.html' ),
        'icon' => NULL,
        'fa' => 'fa-archive',
        'title' => 'ferma pianificazione',
        'text' => 'interrompe la pianificazione'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
