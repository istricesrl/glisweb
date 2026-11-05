<?php

    /**
     * file di esempio per la funzione diskDelete()
     *
     * cancellare una chiave che non esiste restituisce false
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST_INESISTENTE';

    // stampa il risultato
    var_dump( diskDelete( $k ) );
