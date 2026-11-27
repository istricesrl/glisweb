<?php

    /**
     * file di esempio per la funzione diskFlush()
     *
     * svuota le chiavi del sito corrente tranne quelle da tenere, come il lock della ricostruzione delle pagine
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // una chiave da togliere e una da tenere
    var_dump( diskWrite( 'TEST', 'TEST CONTENT' ) );
    var_dump( diskWrite( 'TEST_TIENI', 'TEST CONTENT' ) );

    // svuoto la cache del sito corrente tenendo la seconda
    var_dump( diskFlush( null, array( 'TEST_TIENI' ) ) );

    // la prima non c'e' piu', la seconda si'
    var_dump( diskRead( 'TEST' ) );
    var_dump( diskRead( 'TEST_TIENI' ) );

    // pulizia
    diskDelete( 'TEST_TIENI' );
