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

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
