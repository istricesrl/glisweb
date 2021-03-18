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
    $ct['view']['table'] = 'documenti_articoli';
    
    // id della vista
    $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'documenti.articoli.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'nome'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   