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
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '03.elaborazioni' => array(
			'label' => 'elaborazioni'
		)
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
	    'modal' => array( 'id' => 'deduplica_indirizzi', 'include' => 'inc/indirizzi.tools.modal.deduplica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-compress',
	    'title' => 'unione indirizzi',
	    'text' => 'unisce due indirizzi e tutti gli oggetti collegati'
	);

    // categorie anagrafica
	$ct['etc']['select']['indirizzi'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM indirizzi_view'
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
