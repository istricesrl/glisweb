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
	    'general' => array(
		'label' => NULL
	    )
	);

    // importazione contatti anagrafica
	$ct['page']['contents']['metro']['general'][] = array(
	    'modal' => array( 'id' => 'esporta_per_mail', 'include' => 'inc/anagrafica.tools.modal.mailchimp.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-file-excel-o',
	    'title' => 'esportazione per MailChimp',
	    'text' => 'esporta i contatti anagrafici in formato CSV'
	);

    // categorie anagrafica
	$ct['etc']['select']['id_categoria'] = mysqlCachedQuery(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_anagrafica_view'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';

?>
