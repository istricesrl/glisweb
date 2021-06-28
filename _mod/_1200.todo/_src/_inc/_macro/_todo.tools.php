<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		'label' => 'azioni'
	    )
	);

    // eliminazione todo per progetti che non prevedono todo nei giorni festivi
    $ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'elimina', 'include' => 'inc/todo.tools.modal.elimina.festivi.html' ),
        'icon' => NULL,
        'fa' => 'fa-trash',
        'title' => 'elimina todo giorni festivi',
        'text' => 'elimina le todo pianificate in giorni di festività'
    );

    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
