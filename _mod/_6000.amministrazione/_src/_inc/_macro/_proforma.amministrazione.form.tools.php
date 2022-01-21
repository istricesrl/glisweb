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
    $ct['form']['table'] = 'documenti';

    // percorsi
	$base = '_mod/_6200.documenti/_src/_api/_task/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'general' => array(
		'label' => ''
	    )
	);


    // aggrega righe
	$ct['page']['contents']['metro']['general'][] = array(
        'host' => $ct['site']['url'],
	    'ws' => $base . '_documenti.aggrega.righe.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'aggrega righe',
	    'text' => 'aggrega a questo documento tutte le righe del cliente'
	);
    
    // trasforma in fattura 
	$ct['page']['contents']['metro']['general'][] = array(
        'host' => $ct['site']['url'],
	   // 'ws' => $base . '_documenti.aggrega.righe.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'trasforma in fattura',
	    'text' => 'crea una fattura a partire da questa proforma'
	);
