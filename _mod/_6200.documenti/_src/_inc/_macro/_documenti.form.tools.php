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
	    'amministrazione' => array(
		'label' => 'operazioni amministrative'
	    )
	);

    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ){
    // aggiorna data e ora
	$ct['page']['contents']['metro']['amministrazione'][] = array(
        'host' => $ct['site']['url'],
	    'ws' => $base . '_chiusura.documento.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-check-square-o',
	    'title' => 'chiudi documento',
	    'text' => 'chiudi con data e ora attuale il documento'
	);
    }

    if(  $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] == 1 ){
    // invio fattura elettronica
	$ct['page']['contents']['metro']['amministrazione'][] = array(
        'host' => $ct['site']['url'],
	  //  'ws' => $base . '.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
	    'icon' => NULL,
	    'fa' => 'fa-check-square-o',
	    'title' => 'invia fattura elettronica',
	    'text' => 'invia tramite archivum la fattura'
	);
    }

    if( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] == 5 ) {
        // TODO basarsi sui flag e non sull'id_tipologia
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . 'fattura.da.proforma?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-eur',
            'title' => 'crea fattura',
            'text' => 'crea la fattura corrispondente a questa proforma'
        );
    }
