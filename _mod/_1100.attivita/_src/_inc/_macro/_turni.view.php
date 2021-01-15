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
        'id_contratto' => 'contratto',
        'turno' => 'turno',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'text-left',
        'anagrafica' => 'text-left',
        'id_contratto' => 'text-left',
        'turno' => 'text-left',
        'data_inizio' => 'text-left',
        'data_fine' => 'text-left'
	);

    // inclusione filtri speciali
#	$ct['etc']['include']['filters'] = 'inc/turni.view.filters.html';

    
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
