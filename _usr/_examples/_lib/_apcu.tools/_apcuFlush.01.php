<?php

    /**
     * file di esempio per la funzione apcuFlush()
     *
     * svuota le chiavi del sito corrente e lascia quelle degli altri siti, che sul server possono essere di altri deploy
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // una chiave del sito corrente e una di un altro sito
    var_dump( apcuWrite( 'TEST', 'TEST CONTENT' ) );
    var_dump( apcuWrite( 'TEST', 'TEST CONTENT', 0, 'altro.sito.test' ) );

    // svuoto la cache del sito corrente
    var_dump( apcuFlush() );

    // la chiave del sito corrente non c'e' piu', quella dell'altro sito si'
    var_dump( apcuRead( 'TEST' ) );
    var_dump( apcuRead( 'TEST', 'altro.sito.test' ) );

    // pulizia
    apcuFlush( 'altro.sito.test' );
