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
	$ct['form']['subtable'] = 'immagini';

    // tendina ruolo immagini
	$ct['etc']['select']['ruoli_immagini'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_immagini_view'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
