<?php

    /**
     * macro form pagine
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
	$ct['form']['table'] = 'pagine';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'video';

    // tendina ruolo video
	$ct['etc']['select']['ruoli_video'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_video_view WHERE se_contenuti = 1'
    );
    
    // tendina tipologia embed
	$ct['etc']['select']['tipologie_embed'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_embed_view  WHERE se_video = 1'
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
