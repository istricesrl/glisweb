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

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['01.esportazioni'][] = array(
	    'modal' => array( 'id' => 'esporta_per_mail', 'include' => 'inc/anagrafica.tools.modal.mailchimp.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione per MailChimp',
	    'text' => 'esporta le e-mail dei contatti anagrafici in formato CSV'
	);

    // esportazione indirizzi anagrafica
	$ct['page']['contents']['metro']['01.esportazioni'][] = array(
	    'modal' => array( 'id' => 'esporta_indirizzi', 'include' => 'inc/anagrafica.tools.modal.indirizzi.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione indirizzario',
	    'text' => 'esporta gli indirizzi dei contatti anagrafici in formato CSV'
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['02.importazioni'][] = array(
	    'modal' => array( 'id' => 'importa_anagrafiche', 'include' => 'inc/anagrafica.tools.modal.import.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-upload',
	    'title' => 'importazione anagrafiche',
	    'text' => 'importa contatti anagrafici in formato CSV'
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['03.elaborazioni'][] = array(
	    'modal' => array( 'id' => 'deduplica_anagrafiche', 'include' => 'inc/anagrafica.tools.modal.deduplica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-compress',
	    'title' => 'unione anagrafiche',
	    'text' => 'unisce due anagrafiche e tutti gli oggetti collegati'
	);

    // categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // categorie anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
