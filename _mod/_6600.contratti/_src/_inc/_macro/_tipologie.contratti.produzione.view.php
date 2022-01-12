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
	$ct['view']['table'] = 'tipologie_contratti';

    $ct['view']['id'] = md5( 'tipologie_contratti_produzione');

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'tipologie.contratti.produzione.form';

     // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        '__label__' => 'tipologia'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        '__label__' => 'text-left'
	);

    // preset filtro custom tipologie anagrafica
	if( ! isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['se_produzione']['EQ'] ) ) {
	    $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['se_produzione']['EQ'] = 1;
    }
   
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';
