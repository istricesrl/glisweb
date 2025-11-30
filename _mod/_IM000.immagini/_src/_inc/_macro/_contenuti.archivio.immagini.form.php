<?php

    /**
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
    $ct['form']['table'] = 'video';

    // tendina ruolo video
    $ct['etc']['select']['ruoli_video'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_video_view ORDER BY __label__'
    );

    $ct['etc']['select']['orientamenti'] = array( 
        array( 'id' => NULL, '__label__' => 'automatico' ),
        array( 'id' => 'L', '__label__' => 'landscape' ),
        array( 'id' => 'P', '__label__' => 'portrait' ),
        array( 'id' => 'S', '__label__' => 'square' ),
    );

    // tendina dei tagli
    $ct['etc']['select']['tagli'] = array(
        array( 'id' => 'START', '__label__' => 'peso iniziale' ),
        array( 'id' => 'MIDDLE', '__label__' => 'peso centrale' ),
        array( 'id' => 'END', '__label__' => 'peso finale' )
    );

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

