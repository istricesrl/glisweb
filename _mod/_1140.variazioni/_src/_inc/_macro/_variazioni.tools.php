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
	    'azioni' => array(
		'label' => 'azioni'
	    )
	);

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view'
	);

    // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1'
	);

    // libera operatore
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'libera-operatore', 'include' => 'inc/variazioni.tools.modal.libera.operatore.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'libera operatore',
	    'text' => 'rimuove un operatore dalle attività di un progetto'
	);


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
