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
    $ct['form']['table'] = 'anagrafica';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
		'label' => 'esportazioni'
	    )
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
    
	// macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';