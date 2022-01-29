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
    $ct['view']['table'] = 'campagne';
    
    // id della vista
  #  $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'campagne.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'nome',
        'n_contatti' => 'contatti'
	);

    // stili della vista
	$ct['view']['class'] = array(
        '__label__' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   