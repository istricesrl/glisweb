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
//	$base = '/task/';
	$base = $ct['site']['url'] . '/_mod/_6600.contratti/_src/_api/_task/';

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
	#   'url' =>  $base . '_contratti.duplicate.php?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
		'modal' => array('id' => 'duplica-contratto', 'include' => 'inc/contratti.form.tools.modal.duplica.contratto.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'variazione contratto',
	    'text' => 'crea un duplicato del contratto per inserire variazioni'
	);

	// macro di default per l'entità contratti
	require '_contratti.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

	require DIR_SRC_INC_MACRO . '_default.tools.php';
