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
    
    // tabella della vista
	$ct['view']['table'] = 'matricole';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'matricole.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'matricola' => 'matricola',
	    'articolo' => 'articolo'
	);

    // OPZIONE matricole
    if( ! empty( $cf['matricole']['scadenze'] ) ) {
        arrayInsertAssoc( 'articolo', $ct['view']['cols'], array( 'data_scadenza' => 'scadenza' ) );
    }

    // stili della vista
	$ct['view']['class'] = array(
		'articolo' => 'text-left'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
