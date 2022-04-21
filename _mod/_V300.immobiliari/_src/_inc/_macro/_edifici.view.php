<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $_SESSION );

    // tabella della vista
	$ct['view']['table'] = 'edifici';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'edifici.form';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'edificio',
        'piani' => 'piani'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
	);

    // inclusione filtri speciali
	// $ct['etc']['include']['filters'] = 'inc/edifici.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	#foreach( $ct['view']['data'] as &$row ) {
	#    $row['id_sito'] = $cf['sites'][ $row['id_sito'] ]['__label__'];
	#}
