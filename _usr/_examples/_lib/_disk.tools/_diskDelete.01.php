<?php

    /**
     * file di esempio per la funzione diskDelete()
     *
     * cancella un dato e la sua chiave _AGE
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST';

    // valore di test
    $v = 'TEST CONTENT';

    // scrivo la chiave
    var_dump( diskWrite( $k, $v ) );

    // stampa il risultato
    var_dump( diskDelete( $k ) );

    // ne' la chiave ne' la sua eta' si leggono piu'
    var_dump( diskRead( $k ) );
    var_dump( diskGetKeyAge( $k ) );
