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
	$ct['view']['table'] = 'pagine';

    // id della vista
    # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagine.form';

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'id_sito' => 'sito',
	    '__label__' => 'pagina',
	    'template' => 'template',
	    'schema_html' => 'schema',
	   'tema_css' => 'tema'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
	    'id_sito' => 'text-left',
	    'template' => 'text-left',
	    'schema_html' => 'text-left',
	    'tema_css' => 'text-left'
	);

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/pagine.view.filters.html';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $row['id_sito'] = $cf['sites'][ $row['id_sito'] ]['__label__'];
        }
	}
