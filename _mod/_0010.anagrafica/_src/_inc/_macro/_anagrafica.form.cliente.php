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

	/**
	 * tendina agenti — disattivata il 2026-10-12, il campo ha gia' la ricerca REST
	 *
	 * Era `SELECT id, __label__ FROM anagrafica_view_static` senza WHERE: sui deploy con l'anagrafica grande ( Polmasi:
	 * oltre 55.000 righe ) supera il tetto di 1 MB di memcached, la scrittura in cache fallisce
	 * con l'errore 37 e la query si rifa' a ogni apertura della pagina.
	 *
	 * Non serviva: nei template di questa pagina il campo e' reso da `frm.selectBox()` con l'api
	 * `anagrafica`, che non stampa le `<option>` e cerca via REST ( _src/_js/_lib/_selectbox.js ).
	 */
	$ct['etc']['select']['agenti'] = array();

    // tendina responsabile operativo
	$ct['etc']['select']['responsabili_operativi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore IS NOT NULL'
    );
    
     // tendina crm
	$ct['etc']['select']['ranking'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ranking_view WHERE se_cliente = 1'
	);

    // tendina settori e attività
	$ct['etc']['select']['settori'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM settori_view'
	);

	// tendina regimi fiscali
	$ct['etc']['select']['regimi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM regimi_view'
	);

	// tendina PEC
	$ct['etc']['select']['pec'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM mail_view WHERE id_anagrafica = ? AND se_pec = 1',
        array( array( 's' => $_REQUEST['anagrafica']['id'] ) )
    );
    
    // macro di default per l'entità anagrafica
	require DIR_MOD . '_0010.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
