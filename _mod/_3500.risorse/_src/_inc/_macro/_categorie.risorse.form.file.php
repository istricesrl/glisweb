<?php

    /**
     * macro form categorie risorse file
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
	$ct['form']['table'] = 'categorie_risorse';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'file';

    // tendina ruolo immagini
	$ct['etc']['select']['ruoli_file'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_file_view WHERE se_categorie_risorse = 1'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
