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

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
			'label' => 'esportazioni'
		),
	    'importazioni' => array(
			'label' => 'importazioni'
		)
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['importazioni'][] = array(
	    'modal' => array( 'id' => 'importa_documenti', 'include' => 'inc/documenti.tools.modal.import.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-upload',
	    'title' => 'importazione documenti',
	    'text' => 'importa le testate dei documenti in formato CSV'
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
