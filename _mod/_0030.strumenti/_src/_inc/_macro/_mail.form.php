<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] = 'mail';

    // tendine variabili
	if( isset( $_REQUEST['mail']['id_anagrafica'] ) && ! empty( $_REQUEST['mail']['id_anagrafica'] ) ) {

		// tendina anagrafica
		$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM anagrafica_view_static WHERE id = ?',
		    array( array( 's' => $_REQUEST['mail']['id_anagrafica'] ) )
		);

	    // tendina mail
		$ct['etc']['select']['mail'] = mysqlCachedIndexedQuery(
		    $cf['memcache']['index'],
		    $cf['memcache']['connection'],
		    $cf['mysql']['connection'],
		    'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ?',
		    array( array( 's' => $_REQUEST['mail']['id_anagrafica'] ) )
		);

	}

	// tendina notifiche
	$ct['etc']['select']['se_notifiche'] = array(
	    array( 'id' => NULL, '__label__' => 'no' ),
	    array( 'id' => 1, '__label__' => 'si' )
	);

    // tendina PEC
	$ct['etc']['select']['se_pec'] = array(
	    array( 'id' => NULL, '__label__' => 'mail' ),
	    array( 'id' => 1, '__label__' => 'pec' )
	);

    // tendina SMTP
	$ct['etc']['select']['smtp'] = array();
	foreach( $cf['smtp']['profile']['servers'] as $server ) {
		$ct['etc']['select']['smtp'][] = array(
			'id' => $server, '__label__' => $server
		);
	}

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
	require DIR_SRC_INC_MACRO . '_default.tools.php';

	// debug
	// print_r( $_REQUEST );
