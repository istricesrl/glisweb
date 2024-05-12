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
		),
	    'importazioni' => array(
			'label' => 'importazioni'
		),
	    'notifiche' => array(
			'label' => 'notifiche'
		)
	);

/*
    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['esportazioni'][] = array(
	    'modal' => array( 'id' => 'esporta_per_mail', 'include' => 'inc/anagrafica.tools.modal.mailchimp.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione per MailChimp',
	    'text' => 'esporta le e-mail dei contatti anagrafici in formato CSV'
	);

    // esportazione indirizzi anagrafica
	$ct['page']['contents']['metro']['esportazioni'][] = array(
	    'modal' => array( 'id' => 'esporta_indirizzi', 'include' => 'inc/anagrafica.tools.modal.indirizzi.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione indirizzario',
	    'text' => 'esporta gli indirizzi dei contatti anagrafici in formato CSV'
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['importazioni'][] = array(
	    'modal' => array( 'id' => 'importa_contatti', 'include' => 'inc/anagrafica.tools.modal.import.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-upload',
	    'title' => 'importazione anagrafiche',
	    'text' => 'importa contatti anagrafici in formato CSV'
	);

    // categorie anagrafica
	$ct['etc']['select']['categorie_anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);
*/

    // anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore IS NOT NULL'
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['importazioni'][] = array(
	    'modal' => array( 'id' => 'importa_attivita', 'include' => 'inc/agenda.tools.modal.import.attivita.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-upload',
	    'title' => 'importazione attività',
	    'text' => 'importa nominativi e attività in formato CSV'
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['notifiche'][] = array(
	    'modal' => array( 'id' => 'invia_promemoria_per_mail', 'include' => 'inc/agenda.tools.modal.promemoria.giornata.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-envelope-o',
	    'title' => 'mail di promemoria della giornata',
	    'text' => 'invia una mail con il riepilogo delle attività in programma per una certa data'
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
