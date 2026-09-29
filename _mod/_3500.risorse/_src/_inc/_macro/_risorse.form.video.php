<?php

    /**
     * macro form prodotti video
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
	$ct['form']['table'] = 'risorse';

    // sotto tabella gestita
	$ct['form']['subtable'] = 'video';

    // tendina ruolo video
	$ct['etc']['select']['ruoli_video'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_video_view WHERE se_risorse = 1'
    );
    
    // tendina tipologia embed
    // i valori dell'enum embed di audio e video, che ha preso il posto della tabella embed ( 2026-09-25 )
	$ct['etc']['select']['embed'] = array(
	    array( 'id' => 'html5', '__label__' => 'HTML5' ),
	    array( 'id' => 'vimeo', '__label__' => 'Vimeo' ),
	    array( 'id' => 'youtube', '__label__' => 'YouTube' ),
	);

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
