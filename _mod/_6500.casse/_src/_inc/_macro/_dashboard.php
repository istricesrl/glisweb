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
	    'utils' => array(
		'label' => 'utility e test'
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

    // stampa scontrino di test
	$ct['page']['contents']['metro']['utils'][] = array(
	    'host' => 'http://localhost',
	    'ws' => $base . 'sct.test.zero',
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'stampa scontrino di test',
	    'text' => 'stampa uno scontrino di test a zero euro'
	);

    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';

?>
