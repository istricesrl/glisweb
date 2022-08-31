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

    // esportazione azienda in Archivium
    if( in_array( 'INVIO_ANAGRAFICA_ARCHIVIUM', $_SESSION['account']['privilegi'] ) ) {
        if( ! empty( $_REQUEST['anagrafica']['se_gestita'] ) ) {
            if( ! empty( $cf['archivium']['profile'] ) ) {
                if( ! empty( $_REQUEST['anagrafica']['codice_archivium'] ) ) {
                    // TODO se è settato il codice archivium, proporre la modifica e non il caricamento
                } else {
                    $ct['page']['contents']['metro']['archivium'][] = array(
                        'host' => $ct['site']['url'],
                        'ws' => 'task/anagrafica.attivazione.archivium?id='.$_REQUEST[ $ct['form']['table'] ]['id'],
                        'icon' => NULL,
                        'fa' => 'fa-cloud-upload',
                        'title' => 'invia anagrafica ad Archivium',
                        'text' => 'attiva la fatturazione elettronica per questa anagrafica'
                    );
                }
            }
        }
    }

    // TODO appare solo se account esiste e se ha una mail associata
    // esportazione contatti anagrafica
    $ct['page']['contents']['metro']['account'][] = array(
        'modal' => array( 'id' => 'crea_account', 'include' => 'inc/anagrafica.form.tools.crea.account.html' ),
        'icon' => NULL,
        'fa' => 'fa-plus-square',
        'title' => 'crea account',
        'text' => 'crea un account per l\'anagrafica e invia mail di attivazione all\'utente'
    );

    foreach( $cf['registrazione']['profili'] as $k => $v ) {
        $ct['etc']['select']['profili'][] = array(
            'id' => $k,
            '__label__' => $v['nome'] 
        );
    }

    foreach( $_REQUEST['anagrafica']['mail'] as $k => $v ) {
        $ct['etc']['select']['mail'][] = array(
            'id' => $v['id'],
            '__label__' => $v['indirizzo'] 
        );
    }

    // debug
    // print_r($_REQUEST);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.tools.php';
    
	// macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';
	
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
