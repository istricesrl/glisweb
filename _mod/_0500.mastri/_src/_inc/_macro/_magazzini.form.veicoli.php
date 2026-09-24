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
	$ct['form']['table'] = 'mastri';

    // tendina tipologie veicoli
    $ct['etc']['select']['tipologie_veicoli'] = tendinaTipologieVeicoli();

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
