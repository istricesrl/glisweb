<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // percorsi
	$base = '/task/6500.casse/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '0-utility' => array(
		'label' => 'utility'
	    ),
	    '1-test' => array(
		'label' => 'test'
	    )
	);

    // aggiorna data e ora
	$ct['page']['contents']['metro']['0-utility'][] = array(
	    'host' => 'http://localhost',
	    'ws' => $base . 'utl.date.set',
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'aggiorna data e ora',
	    'text' => 'aggiorna data e ora (la cassa deve essere chiusa)'
	);

    // stampa scontrino di test
	$ct['page']['contents']['metro']['1-test'][] = array(
	    'host' => 'http://localhost',
	    'ws' => $base . 'utl.test.zero',
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'stampa scontrino di test',
	    'text' => 'stampa uno scontrino di test a zero euro'
	);

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';
