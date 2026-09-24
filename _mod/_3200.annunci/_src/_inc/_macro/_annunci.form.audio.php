<?php

    /**
     * macro form annunci
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
	$ct['form']['table'] = 'annunci';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'audio';

    // tendina ruolo video
	$ct['etc']['select']['ruoli_audio'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM ruoli_audio_view WHERE se_annunci = 1'
    );
    
    // tendina tipologia embed
	$ct['etc']['select']['embed'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM embed_view  WHERE se_audio = 1'
	); 

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
