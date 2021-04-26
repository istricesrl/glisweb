<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */
	$base = '/task/';
	
    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    ),
	    'anagrafica' => array(
		'label' => 'esportazione anagrafica'
	    ),
	    'catalogo' => array(
		'label' => 'esportazione catalogo'
	    )
	);

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';