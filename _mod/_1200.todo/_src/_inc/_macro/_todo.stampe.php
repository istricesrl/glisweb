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
	$ct['form']['table'] = 'valutazioni';

	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);

/*
    // modal per la conferma di invio richiesta sostituzione
    $ct['page']['contents']['metro']['general'][] = array(
        'url' => $cf['site']['url'].'_mod/_1200.todo/_src/_api/_print/_modulo.assistenza.php',
        'target' => '_blank',
        'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'stampa modulo assistenza',
	    'text' => 'stampa tutto o parte del modulo assistenza'
    );
*/

    require DIR_SRC_INC_MACRO . '_default.tools.php';

