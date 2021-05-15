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

    // tendina  agente
	$ct['etc']['select']['agenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view WHERE se_agente IS NOT NULL'
    );

    // tendina responsabile operativo
	$ct['etc']['select']['responsabili_operativi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore IS NOT NULL'
    );
    
     // tendina crm
	$ct['etc']['select']['tipologie_crm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_crm_view'
	);

    // tendina settori e attività
	$ct['etc']['select']['settori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM settori_view'
	);

    // macro di default per l'entità anagrafica
	require DIR_SRC_INC_MACRO . '_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
