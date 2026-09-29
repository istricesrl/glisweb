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
    $ct['form']['table'] = 'categorie_prodotti';

    // tendina ruolo video
    $ct['etc']['select']['ruoli_video'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_video_view WHERE se_categorie_prodotti = 1 ORDER BY __label__ ASC '
    );

    $ct['etc']['select']['embed'] = array( 
        array( 'id' => 'html5', '__label__' => 'HTML5' ),
        array( 'id' => 'vimeo', '__label__' => 'Vimeo' ),
        array( 'id' => 'youtube', '__label__' => 'YouTube' ),
    );

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // debug
    // die( print_r( $_REQUEST, true ) );
