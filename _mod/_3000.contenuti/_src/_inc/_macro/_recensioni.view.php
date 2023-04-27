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
    $ct['view']['table'] = 'recensioni';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'recensioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'data' => 'data',
        'autore' => 'autore',
        'titolo' => 'titolo',
        'valutazione' => 'valutazione',
        'se_approvata' => 'approvata'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'titolo' => 'text-left no-wrap'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
		if( is_array( $row ) ) {
			if( $row['se_approvata'] == 1 ) { $row['se_approvata'] = '<i class="fa fa-check"></i>'; } else { $row['se_approvata'] = NULL; }
		}
	}