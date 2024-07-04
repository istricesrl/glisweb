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
	$ct['view']['table'] = 'prezzi';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'prezzi.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'listino' => 'listino',
        'id_prodotto' => 'prodotto',
        'id_articolo' => 'articolo',
        'articolo' => 'descrizione',
        'prezzo' => 'prezzo',
        'valuta_utf8' => 'valuta',
        'qta_min' => 'q.tà min',
        'qta_max' => 'q.tà max',
	    'data_inizio' => 'valido_dal'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left',
        'id' => 'd-none',
        'valuta_utf8' => 'd-none', 
        'prezzo' => 'text-right',
        'articolo' => 'text-left',
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // elaborazione risultato
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $row['prezzo'] = number_format( $row['prezzo'], 2, ',', '.' ) . ' ' . $row['valuta_utf8'];
        }
    }
