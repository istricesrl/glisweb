<?php

    /**
     * macro form anagrafica
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
	$ct['form']['table'] = 'notizie';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'azioni' => array(
        'label' => NULL
        )
    );



	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
