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
    $ct['form']['table'] = 'certificazioni';

     // tendina anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static WHERE se_collaboratore = 1'
    );

    // tendina emittenti
	$ct['etc']['select']['emittenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view_static'
    );
    
    // tendina per le tipologie di certificazioni
    $ct['etc']['select']['tipologie_certificazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_certificazioni_view'
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

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
