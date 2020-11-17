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

	// tabella gestita
	$ct['form']['table'] = 'pubblicazione';

    // tabella della vista
	$ct['view']['table'] = 'pagine';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagine.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'id_sito' => 'sito',
	    '__label__' => 'pagina',
	    'template' => 'template',
	    'schema_html' => 'schema',
	   'tema_css' => 'tema',
	    'tipologia_pubblicazione' => 'pubblicazione'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
	    'id_sito' => 'text-left',
	    'template' => 'text-left',
	    'schema_html' => 'text-left',
	    'tema_css' => 'text-left',
	    'tipologia_pubblicazione' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
	    $row['id_sito'] = $cf['sites'][ $row['id_sito'] ]['__label__'];
	}
