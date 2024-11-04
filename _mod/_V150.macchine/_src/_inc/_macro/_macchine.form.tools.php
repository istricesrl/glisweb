<?php

    // tabella gestita
	$ct['form']['table'] = 'asset';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
            'label' => 'esportazioni'
        ),
        'importazioni' => array(
            'label' => 'importazioni'
        ),
        'comandi' => array(
		    'label' => 'comandi'
        )
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
