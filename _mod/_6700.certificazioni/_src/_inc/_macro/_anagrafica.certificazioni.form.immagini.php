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
	$ct['form']['table'] = 'anagrafica_certificazioni';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'immagini';

    // tendina ruolo immagini
	$ct['etc']['select']['ruoli_immagini'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_immagini_view WHERE se_certificazioni = 1'
	);

  // tendina lingue
  $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

  $ct['etc']['select']['orientamenti'] = array( 
	    array( 'id' => NULL, '__label__' => 'automatico' ),
	    array( 'id' => 'L', '__label__' => 'landscape' ),
	    array( 'id' => 'P', '__label__' => 'portrait' ),
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
