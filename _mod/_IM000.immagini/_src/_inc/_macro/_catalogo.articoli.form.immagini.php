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
    $ct['form']['table'] = 'articoli';

    // tendina ruolo immagini
    $ct['etc']['select']['ruoli_immagini'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_immagini_view WHERE se_articoli = 1'
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

    // debug
    // die( print_r( $_REQUEST, true ) );
