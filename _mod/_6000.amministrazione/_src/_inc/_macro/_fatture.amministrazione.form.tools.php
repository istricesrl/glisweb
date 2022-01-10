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

    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ){
    // aggiorna data e ora
	$ct['page']['contents']['metro']['general'][] = array(
        'host' => $ct['site']['url'],
	    'ws' => $base . '_chiusura.documento.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-print',
	    'title' => 'chiudi documento',
	    'text' => 'chiudi con data e ora attuale il documento'
	);
    }
