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
	$ct['form']['table'] = 'categorie_prodotti';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'immagini';

    // tendina ruolo immagini
	$ct['etc']['select']['ruoli_immagini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_immagini_view WHERE se_categorie_prodotti = 1'
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
