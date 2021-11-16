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
		),
		'sostituzioni' => array(
			'label' => 'sostituzioni'
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
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1'
	);

    // libera operatore
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'libera-operatore', 'include' => 'inc/variazioni.tools.modal.libera.operatore.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'libera operatore',
	    'text' => 'rimuove un operatore dalle attività di un progetto'
	);

	// richiesta sostituzione per operatore
	$ct['page']['contents']['metro']['sostituzioni'][] = array(
        'modal' => array('id' => 'richiesta', 'include' => 'inc/variazioni.tools.modal.operatore.richiesta.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'richiedi sostituzione operatore',
	    'text' => 'invia la richiesta di sostituzione di un operatore con un altro'
	);
	
	// sostituzione per operatore
	$ct['page']['contents']['metro']['sostituzioni'][] = array(
        'modal' => array('id' => 'sostituisci', 'include' => 'inc/variazioni.tools.modal.operatore.sostituisci.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'sostituisci operatore',
	    'text' => 'effettua la sostituzione di un operatore con un altro'
	);

	// se ho una richiesta di sostituzione creo il job relativo
	if( !empty( $_REQUEST['__sostituzione__']['id_assente'] ) && !empty( $_REQUEST['__sostituzione__']['id_sostituto'] ) ){

		$assente = mysqlSelectValue(
			$cf['mysql']['connection'],
			'SELECT __label__ FROM anagrafica_view_static WHERE id = ?',
			array( array( 's' => $_REQUEST['__sostituzione__']['id_assente'] ) )
		);

		$sostituto = mysqlSelectValue(
			$cf['mysql']['connection'],
			'SELECT __label__ FROM anagrafica_view_static WHERE id = ?',
			array( array( 's' => $_REQUEST['__sostituzione__']['id_sostituto'] ) )
		);

		$nome =  ( !isset( $_REQUEST['__sostituzione__']['hard'] ) ) ? 'richiesta ' : '';
		$nome .= 'sostituzione operatore ' . $assente . ' con ' . $sostituto;
		$nome .=  ( isset( $_REQUEST['__sostituzione__']['data_inizio'] ) && isset( $_REQUEST['__sostituzione__']['data_fine'] ) ) ? ' dal ' . $_REQUEST['__sostituzione__']['data_inizio'] . ' al ' . $_REQUEST['__sostituzione__']['data_fine'] : '';

		$job = mysqlQuery(
			$cf['mysql']['connection'],
			'INSERT INTO job ( nome, job, iterazioni, workspace, se_foreground, delay ) VALUES ( ?, ?, ?, ?, ?, ? )',
			array(
				array( 's' => $nome ),
				array( 's' => '_mod/_1140.variazioni/_src/_api/_job/_sostituzioni.operatore.request.php' ),
				array( 's' => 10 ),
				array( 's' => json_encode(
					array(
						'id_assente' => $_REQUEST['__sostituzione__']['id_assente'],
						'id_sostituto' => $_REQUEST['__sostituzione__']['id_sostituto'],
						'data_inizio' => isset( $_REQUEST['__sostituzione__']['data_inizio'] ) ? $_REQUEST['__sostituzione__']['data_inizio'] : NULL,
						'data_fine' => isset( $_REQUEST['__sostituzione__']['data_fine'] ) ? $_REQUEST['__sostituzione__']['data_fine'] : NULL,
						'hard' => ( isset( $_REQUEST['__sostituzione__']['hard'] ) ) ? $_REQUEST['__sostituzione__']['hard'] : NULL
					)
				) ),
				array( 's' => 1 ),
				array( 's' => 3 )
			)
		);	
	}


	// macro di default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
