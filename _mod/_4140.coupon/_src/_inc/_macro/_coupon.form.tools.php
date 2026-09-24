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
    $ct['form']['table'] = 'coupon';

    // percorsi
	$base = $ct['site']['url'].'task/4140.coupon/';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '03.elaborazioni' => array(
			'label' => 'elaborazioni'
		),
	    '04.connessioni' => array(
			'label' => 'connessioni'
		)
	);

	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
		'ws' => $base . 'nota.da.coupon?coupon=' . $_REQUEST[ $ct['form']['table'] ]['id'],
		// 'callback' => 'function( data ) { alert( "Nota di credito creata con successo: " + data.nota_di_credito.id ); }',
		'callback' => 'function( data ) { window.open( "/amministrazione/ciclo-attivo/note-di-credito/stampe.it-IT.html?documenti[id]=" + data.nota_di_credito.id, "_self" ); }',
        'confirm' => true,
		'icon' => NULL,
		'fa' => 'fa-euro',
		'title' => 'rimborso coupon',
		'text' => 'crea una nota di credito per il rimborso del coupon'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

   