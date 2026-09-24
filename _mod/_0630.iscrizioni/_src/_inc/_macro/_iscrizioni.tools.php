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

	$ct['page']['contents']['metro']['cache'][] = array(
		'lws' => $base . 'iscrizioni.view.static.popolazione',
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'ripopola iscrizioni view static',
		'text' => 'ripopola la view static delle iscrizioni'
	);

	$ct['page']['contents']['metro']['cache'][] = array(
		'ws' => $base . 'iscrizioni.view.static.pulizia',
		'icon' => NULL,
		'fa' => 'fa-refresh',
		'title' => 'pulizia iscrizioni view static',
		'text' => 'pulisce la view static delle iscrizioni'
	);

	$ct['page']['contents']['metro']['cache'][] = array(
		'ws' => $base . 'iscrizioni.view.static.svuotamento',
		'icon' => NULL,
		'fa' => 'fa-trash',
		'title' => 'svuotamento iscrizioni view static',
		'text' => 'svuota la view static delle iscrizioni'
	);

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';

