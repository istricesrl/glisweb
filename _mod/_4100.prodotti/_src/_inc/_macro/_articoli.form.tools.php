<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // percorsi
	// $base = $ct['site']['url'].'_mod/_4100.documenti/_src/_api/_print/';

    // tabella gestita
    $ct['form']['table'] = 'articoli';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
		'ecommerce' => array(
			'label' => 'e-commerce'
		)
	);

    // aggiunta al carrello
	if( in_array( "4170.ecommerce", $cf['mods']['active']['array'] ) ) {

		$ct['page']['contents']['metro']['ecommerce'][] = array(
			'ws' => $ct['site']['url'] . 'task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][quantita]=1&__carrello__[__articolo__][id_articolo]='.$_REQUEST[ $ct['form']['table'] ]['id'],
			'callback' => 'aggiornaCarrello',
			'icon' => NULL,
			'fa' => 'fa-cart-plus',
			'title' => 'aggiungi al carrello',
			'text' => 'aggiunge questo articolo al carrello corrente'
	    );

	}

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
