<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */


	// tabella gestita
	$ct['form']['table'] = 'contratti';
	
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
	    'url' => $base . 'duplica.contratto?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'variazione contratto',
	    'text' => 'crea un duplicato del contratto per inserire variazioni'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
