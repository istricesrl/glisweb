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
	$ct['view']['table'] = 'pesi_tipologie_corrispondenza';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pesi.tipologie.corrispondenza.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        '__label__' => 'text-left'
	);
   
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
