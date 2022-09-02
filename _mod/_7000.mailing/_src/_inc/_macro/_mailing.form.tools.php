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

    // tabella della vista
    $ct['form']['table'] = 'mailing';

    // percorsi
	$base = '/task/7000.mailing/';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'invio' => array(
		'label' => 'gestione invio'
	    )
	);

    // debug
    // print_r( $_REQUEST[ $ct['form']['table'] ] );

    // se è pianificato l'invio
    if( ! empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_invio'] ) ) {

        // aggiorna data e ora
        $ct['page']['contents']['metro']['invio'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . 'genera.elenco.destinatari?idMailing='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-share-square-o',
            'title' => 'prepara invio',
            'text' => 'avvia la preparazione delle mail'
        );

    }

    // duplica pagina
	$ct['page']['contents']['metro']['invio'][] = array(
        'modal' => array('id' => 'invia', 'include' => 'inc/mailing.form.tools.invio.test.html' ),
	    'icon' => NULL,
        'fa' => 'fa-share-square',
	    'title' => 'invio di test',
	    'text' => 'invia una mail di test'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';