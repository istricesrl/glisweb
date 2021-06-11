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
	$base = $ct['site']['url'] . '/_mod/_6600.contratti/_src/_api/_task/';

	// tendina giorni
    $ct['etc']['select']['giorni'] = array( 
        array( 'id' => '1', '__label__' => 'lunedi' ),
        array( 'id' => '2', '__label__' => 'martedi' ),
        array( 'id' => '3', '__label__' => 'mercoledi' ),
        array( 'id' => '4', '__label__' => 'giovedi' ),
        array( 'id' => '5', '__label__' => 'venerdi' ),
        array( 'id' => '6', '__label__' => 'sabato' ),
        array( 'id' => '7', '__label__' => 'domenica' )
    );

    // tendina turni
	foreach( range( 1, 9 ) as $turno ) {
	    $ct['etc']['select']['turni'][] =  array( 'id' => $turno, '__label__' => $turno );
	}

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

	// duplica orari giorno
	$ct['page']['contents']['metro']['variazione'][] = array(
		'modal' => array('id' => 'duplica-giorno', 'include' => 'inc/contratti.form.tools.modal.duplica.giorno.html' ),
		'icon' => NULL,
		'fa' => 'fa-files-o',
		'title' => 'duplicazione giorno',
		'text' => 'duplica gli orari di un determinato giorno e turno di lavoro'
	);

	// duplica orari turno
	$ct['page']['contents']['metro']['variazione'][] = array(
		'modal' => array('id' => 'duplica-turno', 'include' => 'inc/contratti.form.tools.modal.duplica.turno.html' ),
		'icon' => NULL,
		'fa' => 'fa-files-o',
		'title' => 'duplicazione turno',
		'text' => 'duplica gli orari di un determinato turno di lavoro in un nuovo turno'
	);

	// macro di default per l'entità contratti
	require '_contratti.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

	require DIR_SRC_INC_MACRO . '_default.tools.php';
