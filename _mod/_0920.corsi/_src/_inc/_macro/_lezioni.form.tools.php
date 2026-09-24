<?php

    /**
     * macro form todo tools
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
	$ct['form']['table'] = 'todo';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		'label' => 'azioni'
	    )
	);

/**
 * NOTA il meccanismo di cancellazione va gestito come per i progetti senza coda

    // modal per la conferma di invio richiesta sostituzione
    $ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'elimina', 'include' => 'inc/todo.form.tools.modal.elimina.html' ),
        'icon' => NULL,
	    'fa' => 'fa-trash',
	    'title' => 'elimina todo',
	    'text' => 'elimina la todo e gli oggetti collegati'
    );

 */    

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

