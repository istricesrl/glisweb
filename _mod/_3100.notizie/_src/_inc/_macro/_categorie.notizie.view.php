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
	$ct['view']['table'] = 'categorie_notizie';


    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'categoria'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell text-left',
	    '__label__' => 'text-left'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'categorie.notizie.form';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';