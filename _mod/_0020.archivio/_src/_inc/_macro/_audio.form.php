<?php

    /**
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'audio';

    // tendina tipologie embed
    // valori fissi come in _mod/_VI000.video, perché la tabella embed non è più nello schema ( 2026-09-25 )
	$ct['etc']['select']['embed'] = array(
	    array( 'id' => '1', '__label__' => 'HTML5' ),
	);


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
