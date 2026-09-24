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
	$ct['form']['table'] = 'contratti';

    // base di chiamata dei WS
    $base = '/task/0630.iscrizioni/';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'general' => array(
        'label' => NULL
        ),
        'cache' => array(
        'label' => 'gestione delle cache'
        ),
        'gestione' => array(
        'label' => 'gestione iscrizione'
        )
    );

    // aggiornamento cache
    $ct['page']['contents']['metro']['gestione'][] = array(
        'ws' => $base . 'iscrizioni.disiscrizione',
	    'icon' => NULL,
	    'fa' => 'fa-ban',
	    'title' => 'disiscrizione con rimborso',
	    'text' => 'termina l\'iscrizione al corso e genera un buono per le lezioni non godute'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';

