<?php

    /**
     * file di esempio per la funzione apcuFlush()
     *
     * svuota le chiavi del sito corrente tranne quelle da tenere, come il lock della ricostruzione delle pagine
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // una chiave da togliere e una da tenere
    var_dump( apcuWrite( 'TEST', 'TEST CONTENT' ) );
    var_dump( apcuWrite( 'TEST_TIENI', 'TEST CONTENT' ) );

    // svuoto la cache del sito corrente tenendo la seconda
    var_dump( apcuFlush( null, array( 'TEST_TIENI' ) ) );

    // la prima non c'e' piu', la seconda si'
    var_dump( apcuRead( 'TEST' ) );
    var_dump( apcuRead( 'TEST_TIENI' ) );

    // pulizia
    apcuDelete( 'TEST_TIENI' );
