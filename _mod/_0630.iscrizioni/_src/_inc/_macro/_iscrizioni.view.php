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
	$ct['view']['table'] = 'iscrizioni';

    // tabella per la gestione degli oggetti esistenti
    $ct['view']['open']['table'] = 'contratti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'iscrizioni.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
   //     'tipologia' => 'tipologia',
        'iscritti' => 'anagrafica',
        'data_inizio' => 'data',
        'progetto' => 'corso'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        'iscritti' => 'text-left',
        'data_inizio' => 'text-left',
        'progetto' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // timer
    timerCheck( $cf['speed'], 'inizio rielaborazione dati tabella' );

    // rielaborazione dati tabella
    if( !empty( $ct['view']['data'] ) ){
		foreach ( $ct['view']['data'] as &$row ){
                if( ! empty( $row['data_inizio'] ) ) {
                    $row['data_inizio'] = date('d/m/Y', strtotime( $row['data_inizio'] ) );
                }
          	}
	}

    // timer
    timerCheck( $cf['speed'], 'fine rielaborazione dati tabella (' . count( $ct['view']['data'] ) . ' righe)' );
