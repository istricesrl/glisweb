<?php

    /**
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella della vista
	$ct['view']['table'] = 'immagini';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'nome' => 'titolo',
	    '__label__' => 'path',
	    'ruolo' => 'ruolo'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    '__label__' => 'text-left',
	    'ruolo' => 'text-left',
	    'associato' => 'text-left'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'immagini.form';

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

