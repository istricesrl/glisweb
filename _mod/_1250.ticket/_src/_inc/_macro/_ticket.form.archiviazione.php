<?php

    /**
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'todo';

    $ct['page']['contents']['metro']['general'][] = array(
		'modal' => array( 'id' => 'send', 'include' => 'inc/mail.modal.html' )
	    );

    if( isset($_SESSION['account']['id_anagrafica'])){
            $ct['etc']['mail_account'] = mysqlSelectValue( $cf['mysql']['connection'],'SELECT indirizzo FROM mail WHERE id_anagrafica = ?', array(array('s'=>$_SESSION['account']['id_anagrafica'])));
    }

    $ct['etc']['mail_cliente'] = mysqlSelectValue( $cf['mysql']['connection'],'SELECT indirizzo FROM mail WHERE id_anagrafica = ?', array(array('s'=>$_REQUEST['todo']['id_cliente'])));
  

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default.tools.php';
