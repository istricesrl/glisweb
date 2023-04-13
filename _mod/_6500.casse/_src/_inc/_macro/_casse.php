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
	    'rendiconti' => array(
		'label' => 'rendiconti'
	    ),
	    'chiusure' => array(
		'label' => 'chiusure'
	    )
	);

    // stampa rendiconto fiscale
	$ct['page']['contents']['metro']['rendiconti'][] = array(
	    'host' => 'http://localhost',
	    'ws' => $base . 'rdc.fiscale.giorno',
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'rendiconto fisc. giornaliero',
	    'text' => 'stampa il rendiconto fiscale giornaliero'
	);

    // stampa chiusura fiscale
	$ct['page']['contents']['metro']['chiusure'][] = array(
	    'host' => 'http://localhost',
	    'ws' => $base . 'cls.fiscale.giorno',
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'chiusura cassa',
	    'text' => 'effettua la chiusura fiscale giornaliera'
	);

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';
