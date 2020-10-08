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
	$ct['form']['table'] = 'anagrafica';
	
	// tendina regimi fiscali
	$ct['etc']['select']['regimi_fiscali'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM regimi_fiscali_view'
	);

	// tendina PEC
	$ct['etc']['select']['pec'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ? AND se_pec = 1',
        array( array( 's' => $_REQUEST['anagrafica']['id'] ) )
	);

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

?>
