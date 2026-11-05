<?php

    /**
     * file di esempio per la funzione diskRead()
     *
     * una chiave scaduta non si legge e il suo file viene cancellato
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiave di test
    $k = 'TEST_SCADENZA';

    // scrivo la chiave con un TTL di un secondo
    var_dump( diskWrite( $k, 'TEST CONTENT', 1 ) );

    // aspetto che scada
    sleep( 2 );

    // la lettura deve fallire e il file deve sparire
    var_dump( diskRead( $k ) );
    var_dump( is_file( diskKeyPath( diskUniqueKey( $k ) ) ) );
