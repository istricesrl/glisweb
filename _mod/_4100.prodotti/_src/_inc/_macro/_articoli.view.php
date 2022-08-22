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
	$ct['view']['table'] = 'articoli';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'articoli.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id_prodotto' => 'prodotto',
        'id' => 'articolo',
	    'nome' => 'nome',
        'ean' => 'EAN',
        NULL => 'azioni'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'nome' => 'text-left',
	    'ean' => 'text-left'
	);

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$row['id'].'\', aggiornaCarrello );"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
    }
