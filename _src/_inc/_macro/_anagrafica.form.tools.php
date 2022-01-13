<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */
    
    // tabella gestita
    $ct['form']['table'] = 'anagrafica';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'archivium' => array(
		'label' => 'Archivium'
	    )
	);

    // esportazione azienda in Archivium
    if( in_array( 'INVIO_ANAGRAFICA_ARCHIVIUM', array_keys( $_SESSION['privilegi'] ) ) ) {
        $ct['page']['contents']['metro']['archivium'][] = array(
            'host' => $ct['site']['url'],
            'ws' => 'task/anagrafica.attivazione.archivium?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
            'icon' => NULL,
            'fa' => 'fa-cloud-upload',
            'title' => 'invia anagrafica ad Archivium',
            'text' => 'attiva la fatturazione elettronica per questa anagrafica'
        );
    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
    
	// macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
