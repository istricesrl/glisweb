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
    $ct['form']['table'] = 'account';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    'esportazioni' => array(
        'label' => 'esportazioni'
        ),
        'importazioni' => array(
            'label' => 'importazioni'
        ),
        'archivium' => array(
		'label' => 'Archivium'
	    ),
        'account' => array(
            'label' => 'account'
        )
	);

    // TODO appare solo se account esiste e se ha una mail associata
    // esportazione contatti anagrafica
    $ct['page']['contents']['metro']['account'][] = array(
        'modal' => array( 'id' => 'resetta_password', 'include' => 'inc/account.form.tools.resetta.password.html' ),
        'icon' => NULL,
        'fa' => 'fa-unlock-alt',
        'title' => 'resetta password',
        'text' => 'reimposta la password dell\'account e invia una mail all\'utente'
    );

    // debug
    // print_r($_REQUEST);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
    
	// macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
