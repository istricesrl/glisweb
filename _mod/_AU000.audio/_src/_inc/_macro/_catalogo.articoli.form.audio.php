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

    // tendina ruolo audio
    $ct['etc']['select']['ruoli_audio'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM ruoli_audio_view WHERE se_articoli = 1 ORDER BY __label__ ASC '
    );

    // solo html5 dell'enum embed, la sola voce che la tabella embed aveva con se_audio, come nei form audio dei moduli ( 2026-09-25 )
    $ct['etc']['select']['embed'] = array( 
        array( 'id' => 'html5', '__label__' => 'HTML5' ),
    );

    // tendina lingue
    $ct['etc']['select']['lingue'] = $cf['localization']['languages'];

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // debug
    // die( print_r( $_REQUEST, true ) );
