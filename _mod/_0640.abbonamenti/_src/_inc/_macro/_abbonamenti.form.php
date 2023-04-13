<?php

    /**
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
	$ct['form']['table'] = 'contratti';

    $ct['form']['subtable'] = 'contratti_anagrafica';

    // tendina tesserato
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

	// tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_abbonamento = 1'
    );

    // tendina badge
	$ct['etc']['select']['badge'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM badge_view'
    );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view '
    );

    // tendina categorie progetti
	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

    // ID della scuola
	$ct['etc']['gestita'] = mysqlSelectCachedValue(
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id FROM anagrafica_view WHERE se_gestita = 1'
	);

	// debug
	// print_r( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
	// print_r( $_REQUEST );

    // ...
    if( isset( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] ) ) {
		arraySortBy( 'data_inizio', $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
		$ct['etc']['sub']['primo_rinnovo'] = array_shift( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
	}

	// ...
	$ct['etc']['sub']['primo_rinnovo']['idx'] = 0;

	// debug
	// print_r( $ct['etc']['sub']['primo_rinnovo'] );
	// print_r( $_REQUEST );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
