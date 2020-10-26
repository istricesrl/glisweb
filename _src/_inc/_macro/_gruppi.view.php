<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

   // tabella della vista
    $ct['view']['table'] = 'gruppi';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'gruppi.form';


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


    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
