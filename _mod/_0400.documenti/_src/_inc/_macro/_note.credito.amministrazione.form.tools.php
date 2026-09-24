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
	$base = '_mod/_0400.documenti/_src/_api/_task/';

    // NOTA la variabile $base causa problemi nel multi sito fatta in questo modo, per cui ho commentato tutto

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'amministrazione' => array(
		'label' => 'operazioni amministrative'
	    )
	);

    // amministrazione documento
    if( empty( $_REQUEST[ $ct['form']['table'] ]['timestamp_chiusura'] ) ) {

        // chiusura documento
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . '_chiusura.documento.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-check-square-o',
            'title' => 'chiudi documento',
            'text' => 'chiudi con data e ora attuale il documento'
        );
/*
        // aggregazione righe
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . '_documenti.aggrega.righe.php?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-compress',
            'title' => 'aggrega righe',
            'text' => 'aggrega a questo documento tutte le righe non associate'
        );
*/
    } elseif( empty( $_REQUEST[ $ct['form']['table'] ]['codice_archivium'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['progressivo_invio'] ) ) {

        // invio a SDI
        $ct['page']['contents']['metro']['amministrazione'][] = array(
            'host' => $ct['site']['url'],
            'ws' => $base . '_fattura.invia.sdi.php?idFattura='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'callback' => 'function(){location.reload();}',
            'icon' => NULL,
            'fa' => 'fa-check-square-o',
            'title' => 'invia nota di credito elettronica',
            'text' => 'invia tramite archivum la nota di credito'
        );
    
    }
