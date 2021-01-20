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
	$ct['form']['table'] = 'pianificazioni';

    // tendina delle entita che è possibile gestire
    $ct['etc']['select']['entita'] = array(
        array( 'id' => 'turni', '__label__' => 'turni' )
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
