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
	$ct['form']['table'] = 'pagine';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'contenuti';

	// macro di default per l'entità pagine
	require DIR_MOD . '_3000.contenuti/_src/_inc/_macro/_pagine.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
