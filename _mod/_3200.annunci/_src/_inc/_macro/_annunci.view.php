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
	$ct['view']['table'] = 'annunci';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'titolo',
	    'categorie' => 'categorie'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left',
	    'categorie' => 'text-left'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'annunci.form';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';