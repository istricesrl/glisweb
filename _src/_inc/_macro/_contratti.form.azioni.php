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
	$base = '/task/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'variazione' => array(
		'label' => ''
	    )
	);

    // duplica contratto
	$ct['page']['contents']['metro']['variazione'][] = array(
	    'host' => 'http://localhost',
	    'ws' => $base . 'duplica.contratto',
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'variazione contratto',
	    'text' => 'crea un duplicato del contratto per inserire variazioni'
	);
    // debug
	// print_r( $_SESSION );
	// echo DIRECTORY_CACHE . 'twig';

?>
