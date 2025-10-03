<?php

    /**
     *
     *
     *
     *
     * TODO documentare
     *
     */
    
    // tabella gestita
    $ct['form']['table'] = 'account';

    // gruppi di controlli
	$ct['page']['contents']['metros'] = array(
	    '01.esportazioni' => array(
			'label' => 'esportazioni'
		),
	    '02.importazioni' => array(
			'label' => 'importazioni'
		),
	    '04.azioni' => array(
			'label' => 'azioni'
		),
	);

/* TODO reimplementare

    // ...
    if( ! empty( $_REQUEST['account']['id_mail'] ) ) {
        $ct['page']['contents']['metro']['account'][] = array(
            'modal' => array( 'id' => 'resetta_password', 'include' => 'inc/account.form.tools.resetta.password.html' ),
            'icon' => NULL,
            'fa' => 'fa-unlock-alt',
            'title' => 'resetta password',
            'text' => 'reimposta la password dell\'account e invia una mail all\'utente'
        );
    }

*/

    // debug
    // print_r($_REQUEST);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
    
	// macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.form.php';
