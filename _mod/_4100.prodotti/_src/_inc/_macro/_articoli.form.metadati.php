<?php

    /**
     * macro form prodotti metadati
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
	$ct['form']['table'] = 'articoli';

    // sotto tabella gestita
    $ct['form']['subtable'] = 'metadati';
    
    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
