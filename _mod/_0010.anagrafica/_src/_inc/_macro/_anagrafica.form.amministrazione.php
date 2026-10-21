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

	// tendine per l'iscrizione al REA ( IscrizioneREA della fattura elettronica )
	$ct['etc']['select']['socio_unico'] = array(
	    array( 'id' => 'SU', '__label__' => 'socio unico' ),
	    array( 'id' => 'SM', '__label__' => 'più soci' )
	);
	$ct['etc']['select']['stato_liquidazione'] = array(
	    array( 'id' => 'LN', '__label__' => 'non in liquidazione' ),
	    array( 'id' => 'LS', '__label__' => 'in liquidazione' )
	);

	// tendina rappresentanti fiscali: anagrafiche con partita IVA
	$ct['etc']['select']['rappresentanti_fiscali'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE partita_iva IS NOT NULL AND partita_iva != "" ORDER BY __label__'
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
	require DIR_MOD . '_0010.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
