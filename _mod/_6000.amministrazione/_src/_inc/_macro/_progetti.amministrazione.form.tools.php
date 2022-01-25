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
	$ct['form']['table'] = 'progetti';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'azioni' => array(
		'label' => 'azioni'
	    )
	);
/*
    // modal per la conferma di invio richiesta sostituzione
    $ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'elimina', 'include' => 'inc/progetti.produzione.form.tools.modal.elimina.html' ),
        'icon' => NULL,
	    'fa' => 'fa-trash',
	    'title' => 'elimina progetto',
	    'text' => 'elimina il progetto e gli oggetti to-do e attività collegati'
    );
*/
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

