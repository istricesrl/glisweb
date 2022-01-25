<?php

    /**
     * macro form progetti produzione tools
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

	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);
/**
 * NOTA valutare se fare una versione standard del modulo

    // modal per la conferma di invio richiesta sostituzione
    $ct['page']['contents']['metro']['general'][] = array(
        'modal' => array('id' => 'stampa', 'include' => 'inc/todo.form.stampe.modal.html' ),
        'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'stampa modulo assistenza',
	    'text' => 'stampa tutto o parte del modulo assistenza'
    );

 */

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

