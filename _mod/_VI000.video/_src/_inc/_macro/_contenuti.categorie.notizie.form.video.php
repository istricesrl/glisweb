<?php

    /**
     *
     *
     *
     *
     *
     *
     * TODO documentare
     *
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'categorie_notizie';

    // tendina ruolo video
    $ct['etc']['select']['ruoli_video'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_video_view WHERE se_pagine = 1 ORDER BY __label__ ASC '
    );

    $ct['etc']['select']['embed'] = array( 
        array( 'id' => '1', '__label__' => 'HTML5' ),
        array( 'id' => '2', '__label__' => 'Vimeo' ),
        array( 'id' => '3', '__label__' => 'YouTube' ),
    );

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // debug
    // die( print_r( $_REQUEST, true ) );
