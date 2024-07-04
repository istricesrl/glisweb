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

    // aggiunta al carrello
	if( in_array( "E300.modula", $cf['mods']['active']['array'] ) ) {

		$ct['page']['contents']['metro']['ecommerce'][] = array(
			'ws' => 'http://localhost:5000/modula',
            'wsmethod' => 'POST',
            'wsdata' => '{"comando":"' . $_REQUEST[ $ct['form']['table'] ]['prefisso_modula'] . '|' . time() . '|CALL|' . $_REQUEST[ $ct['form']['table'] ]['codice_modula'] . '|1"}',
			'callback' => 'aggiornaCarrello',
			'icon' => NULL,
			'fa' => 'fa-level-down',
			'title' => 'richiama cassetto',
			'text' => 'richiama il cassetto del Modula'
	    );

	}

	// macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
