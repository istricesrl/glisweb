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
    $ct['form']['table'] = 'attivita';

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

    $ct['page']['contents']['metro']['05.static'][] = array(
        'lws' => '/task/AT000.attivita/attivita.view.static.popolazione?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
        'icon' => NULL,
        'fa' => 'fa-refresh',
        'title' => 'ripopola attivita view static',
        'text' => 'ripopola la view static delle attivita'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.form.php';
