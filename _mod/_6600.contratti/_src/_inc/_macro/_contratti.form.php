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
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
    );
    
    // tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view'
    );
    
    // tendina per le tipologie costi contratto
    $ct['etc']['select']['tipologie_costi_contratti'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_costi_contratti_view'
    );

    // tendina per le tipologie di qualifiche inps
    $ct['etc']['select']['tipologie_qualifiche_inps'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_qualifiche_inps_view'
    );

    // tendina per le tipologie di durate inps
    $ct['etc']['select']['tipologie_durate_inps'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_durate_inps_view'
    );

    // tendina per le tipologie di orari inps
    $ct['etc']['select']['tipologie_orari_inps'] = mysqlCachedIndexedQuery(
	    $cf['cache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_orari_inps_view'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
