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
    // i valori dell'enum embed di audio e video, che ha preso il posto della tabella embed ( 2026-09-25 )
	$ct['etc']['select']['embed'] = array(
	    array( 'id' => 'html5', '__label__' => 'HTML5' ),
	);


    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
