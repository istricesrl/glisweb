<?php

    /**
     * macro form progetti produzione tools
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'valutazioni';

	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => NULL
	    )
	);


	require DIR_SRC_INC_MACRO . '_default.form.php';

	require DIR_SRC_INC_MACRO . '_default.tools.php';
