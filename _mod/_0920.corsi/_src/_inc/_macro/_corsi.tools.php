<?php

    /**
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

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'cache' => array(
		'label' => 'gestione delle cache'
	    ),
	    'mail' => array(
		'label' => 'gestione delle mail'
	    ),
	    'sms' => array(
		'label' => 'gestione degli SMS'
	    ),
	    'log' => array(
		'label' => 'gestione di log e storage'
	    ),
		'static' => array(
			'label' => 'gestione delle viste statiche'
		)
	);

    // aggiornamento cache
    $ct['page']['contents']['metro']['cache'][] = array(
        'ws' => $base . 'report.corsi.popolazione.start',
        'icon' => NULL,
        'fa' => 'fa-clock-o',
        'title' => 'aggiornamento report corsi',
        'text' => 'forza l\'aggiornamento del report corsi'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
    