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

    // base di chiamata dei WS
    $base = '/task/0920.corsi/';

    // tabella gestita
	$ct['form']['table'] = 'progetti';
 
    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'cache' => array(
		'label' => 'gestione delle cache'
	    ),
	    'gestione' => array(
		'label' => 'gestione massiva corsi'
		)
	);

    // aggiornamento cache
    $ct['page']['contents']['metro']['cache'][] = array(
        'ws' => $base . 'report.corsi.popolazione?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
        'callback' => 'location.reload()',
        'icon' => NULL,
        'fa' => 'fa-clock-o',
        'title' => 'aggiornamento report corsi',
        'text' => 'forza l\'aggiornamento del report corsi per questo corso'
    );

    // aggiornamento cache
    $ct['page']['contents']['metro']['cache'][] = array(
        'ws' => $base . 'report.lezioni.corsi.popolazione.start?idCorso=' . $_REQUEST[ $ct['form']['table'] ]['id'],
        'callback' => 'location.reload()',
        'icon' => NULL,
        'fa' => 'fa-clock-o',
        'title' => 'aggiornamento report lezioni corsi',
        'text' => 'forza l\'aggiornamento del report lezioni per questo corso'
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
