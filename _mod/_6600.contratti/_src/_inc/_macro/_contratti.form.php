<?php

    /**
     *
     *
     *
     * @todo documentare
     * 
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'contratti';

     // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1 OR se_dipendente = 1 OR se_interinale = 1'
    );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM progetti_view'
    );

    // tendina agenzia
	$ct['etc']['select']['agenzia'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_agenzia_interinale = 1'
    );
    
    // tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_anagrafica = 1'
    );
    
    // tendina per le tipologie di attività inps
    $ct['etc']['select']['tipologie_attivita_inps'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_attivita_inps_view'
    );

    // tendina per le tipologie di qualifiche inps
    $ct['etc']['select']['tipologie_qualifiche_inps'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_qualifiche_inps_view'
    );

    // tendina per le tipologie di durate inps
    $ct['etc']['select']['tipologie_durate_inps'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_durate_inps_view'
    );

    // tendina per le tipologie di orari inps
    $ct['etc']['select']['tipologie_orari_inps'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_orari_inps_view'
    );

    // macro di default per l'entità contratti
	require '_contratti.form.default.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
