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
	$ct['form']['table'] =  '__templates__';

    $ct['form']['__filesystem_mode__'] = 1;

    // macro di default
	require DIR_MOD . '_3000.contenuti/_src/_inc/_macro/_template.pagine.form.default.php';
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // debug
    // print_r( $_REQUEST[ $ct['form']['table'] ] );
