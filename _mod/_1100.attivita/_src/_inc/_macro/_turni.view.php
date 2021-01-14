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
    $ct['view']['table'] = 'turni';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'turni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'anagrafica' => 'anagrafica',
        'turno' => 'turno',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine',
	    '__label__' => 'turno'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
	);

    // inclusione filtri speciali
#	$ct['etc']['include']['filters'] = 'inc/turni.view.filters.html';

    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
