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
    $ct['form']['table'] = 'mastri';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
        'azioni' => array(
			'label' => 'azioni'
		),
		'ecommerce' => array(
			'label' => 'e-commerce'
		)
	);

    // duplica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'duplica', 'include' => 'inc/articoli.form.tools.modal.duplica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'duplica articolo',
	    'text' => 'duplica l\'articolo corrente'
	);

    // aggiunta al carrello
	if( in_array( "4170.ecommerce", $cf['mods']['active']['array'] ) ) {

		$ct['page']['contents']['metro']['ecommerce'][] = array(
			'ws' => $ct['site']['url'] . 'task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$_REQUEST[ $ct['form']['table'] ]['id'],
			'callback' => 'aggiornaCarrello',
			'icon' => NULL,
			'fa' => 'fa-cart-plus',
			'title' => 'aggiungi al carrello',
			'text' => 'aggiunge questo articolo al carrello corrente'
	    );

	}

    // tendina prodotti
	$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM prodotti_view' );

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
