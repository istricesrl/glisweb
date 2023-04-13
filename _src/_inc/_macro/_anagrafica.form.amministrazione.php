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
	$ct['etc']['select']['regimi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM regimi_view'
	);

	// tendina settori e attività
	$ct['etc']['select']['settori'] = mysqlCachedIndexedQuery(
		$cf['memcache']['index'],
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id, __label__ FROM settori_view'
	);
	
	// tendina PEC
	$ct['etc']['select']['pec'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ? AND se_pec = 1',
        array( array( 's' => $_REQUEST['anagrafica']['id'] ) )
    );
    
    // tendina condizioni pagamento
	$ct['etc']['select']['condizioni_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM condizioni_pagamento_view'
    );
    
    // tendina modalità pagamento
	$ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM modalita_pagamento_view'
	);

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
