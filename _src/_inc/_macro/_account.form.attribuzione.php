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
	$ct['form']['table'] = 'account_gruppi_attribuzione';

    // tendina anagrafica
	$ct['etc']['select']['id_gruppo'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM account_gruppi_attribuzione_view'
    );
    
    // tendine variabili
	if( isset( $_REQUEST['account']['id_anagrafica'] ) && ! empty( $_REQUEST['account']['id_anagrafica'] ) ) {

	    // tendina mail
		$ct['etc']['select']['mail'] = mysqlCachedIndexedQuery(
		    $cf['cache']['index'],
		    $cf['memcache']['connection'],
		    $cf['mysql']['connection'],
		    'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ?',
		    array( array( 's' => $_REQUEST['account']['id_anagrafica'] ) )
		);

	}

    // impedisco che la password cifrata venga inviata al modulo
	unset( $_REQUEST['account']['password'] );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
