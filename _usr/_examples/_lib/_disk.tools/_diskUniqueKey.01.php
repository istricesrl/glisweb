<?php

    /**
     * file di esempio per la funzione diskUniqueKey()
     *
     * aggiunge alla chiave il seme del sito corrente, una volta sola
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $v = 'TEST';

    // aggiungo il seme due volte: la seconda non deve cambiare niente
    diskUniqueKey( $v );
    var_dump( diskUniqueKey( $v ) );
