<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'immagini';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '03.elaborazioni' => array(
			'label' => 'elaborazioni'
		),
	    '05.static' => array(
			'label' => 'viste statiche'
		)
	);

    // ...
    $ct['page']['contents']['metro']['03.elaborazioni'][] = array(
		'ws' => '/task/IM000.immagini/images.resize?id=' . $_REQUEST[ $ct['form']['table'] ]['id'],
		'icon' => NULL,
		'fa' => 'fa-image',
		'title' => 'scalatura immagine',
		'text' => 'forza la scalatura di questa immagine'
	);


    // gestione default
	require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

