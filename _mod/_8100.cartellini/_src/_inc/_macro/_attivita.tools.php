<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
		'label' => 'esportazioni'
	    )
	);

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['esportazioni'][] = array(
	    'modal' => array( 'id' => 'esporta_zucchetti', 'include' => 'inc/attivita.tools.modal.zucchetti.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione XML per Zucchetti',
	    'text' => 'esporta le ore in formato XML per il software Zucchetti'
	);

    // tendina mesi
	foreach( range( 1, 12 ) as $mese ) {
	    $ct['etc']['select']['mesi'][ $mese ] = array( 'id' => $mese, '__label__' =>  int2month( $mese ) );
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
