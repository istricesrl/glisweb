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

    // percorsi
	$base = '/task/0400.documenti/';

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
	    'modal' => array( 'id' => 'importa_iscritti', 'include' => 'inc/iscritti.tools.modal.import.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-upload',
	    'title' => 'importazione iscritti',
	    'text' => 'importa iscritti in formato CSV'
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
