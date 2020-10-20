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

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagine.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'pagina',
	    'template' => 'template',
	    'schema_html' => 'schema',
	    'tipologia_pubblicazione' => 'pubblicazione'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap',
	    'template' => 'text-left',
	    'schema_html' => 'text-left',
	    'tipologia_pubblicazione' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
