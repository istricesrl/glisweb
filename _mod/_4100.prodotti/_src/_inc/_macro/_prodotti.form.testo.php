<?php

    /**
     * macro form prodotti testo
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
	$ct['form']['table'] = 'prodotti';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'contenuti';

	// macro di default per l'entità pagine
	require DIR_SRC_INC_MACRO . '_default.form.multilingua.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
