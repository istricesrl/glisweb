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
	$base = 'task/6200.documenti/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'amministrazione' => array(
		'label' => 'operazioni amministrative'
	    )
	);

    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ){
	$ct['page']['contents']['metro']['amministrazione'][] = array(
        'host' => $ct['site']['url'],
	    'ws' => $base . 'chiusura.documento?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-check-square-o',
	    'title' => 'chiudi documento',
	    'text' => 'chiudi con data e ora attuale il documento'
	);
    } else {
        // TODO se la proforma è già stata convertita, inserire un link anziché un tasto
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . 'fattura.da.proforma?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-eur',
            'title' => 'crea fattura',
            'text' => 'crea la fattura corrispondente a questa proforma'
        );
    }

    // aggrega righe
	$ct['page']['contents']['metro']['general'][] = array(
        'host' => $ct['site']['url'],
	    'ws' => $base . '_documenti.aggrega.righe.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-compress',
	    'title' => 'aggrega righe',
	    'text' => 'aggrega a questo documento tutte le righe non associate'
	);
