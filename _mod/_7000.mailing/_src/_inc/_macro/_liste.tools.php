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

    // percorsi
	$base = '/task/0400.documenti/';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
		'label' => 'esportazioni'
		),
	    'importazioni' => array(
			'label' => 'importazioni'
			)
		);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['importazioni'][] = array(
	    'modal' => array( 'id' => 'importa_iscritti', 'include' => 'inc/iscritti.tools.modal.import.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-upload',
	    'title' => 'importazione iscritti',
	    'text' => 'importa iscritti in formato CSV'
	);

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['esportazioni'][] = array(
	    'modal' => array( 'id' => 'esporta_per_lista', 'include' => 'inc/iscritti.tools.modal.export.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione iscritti alla lista',
	    'text' => 'esporta gli iscritti alla lista in formato CSV'
	);

    // categorie anagrafica
	$ct['etc']['select']['liste'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM liste_view'
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
