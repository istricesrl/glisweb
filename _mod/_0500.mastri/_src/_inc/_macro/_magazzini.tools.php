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
	    'connessioni' => array(
			'label' => 'connessioni'
		)
	);

    // esportazione contatti anagrafica
	$ct['page']['contents']['metro']['connessioni'][] = array(
	    'modal' => array( 'id' => 'test_modula', 'include' => 'inc/magazzini.tools.modal.modula.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-terminal',
	    'title' => 'test comunicazione Modula',
	    'text' => 'invia dei comandi di test ai magazzini Modula'
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

    // tendina prefissi
	$ct['etc']['select']['prefissi'] = array( 
	    array( 'id' => '11', '__label__' => 'Modula 1' ),
	    array( 'id' => '21', '__label__' => 'Modula 2' ),
	);

	// gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
