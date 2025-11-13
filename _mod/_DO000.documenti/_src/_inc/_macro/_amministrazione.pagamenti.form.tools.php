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
    $ct['form']['table'] = 'pagamenti';

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
		),
	    '08.account' => array(
			'label' => 'account'
		),
	    '12.archivium' => array(
			'label' => 'Archivium'
		)
	);

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.form.php';
