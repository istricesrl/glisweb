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
	    'data_ora_recensione' => 'inserita il',
	    '__label__' => 'autore',
	    'se_approvata' => 'approvata'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left',
		'data_ora_recensione' => 'text-left'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // icona approvato
	foreach($ct['view']['data'] as &$row) {
	    if( $row['se_approvata'] == 1 ){ $row['se_approvata']='<i class="fa fa-check"></i>';  }
	}
