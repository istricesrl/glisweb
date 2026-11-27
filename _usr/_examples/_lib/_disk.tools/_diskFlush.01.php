<?php

    /**
     * file di esempio per la funzione diskFlush()
     *
     * svuota le chiavi del sito corrente e lascia quelle degli altri siti del deploy
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // una chiave del sito corrente e una di un altro sito
    var_dump( diskWrite( 'TEST', 'TEST CONTENT' ) );
    var_dump( diskWrite( 'TEST', 'TEST CONTENT', 0, 'altro.sito.test' ) );

    // svuoto la cache del sito corrente
    var_dump( diskFlush() );

    // la chiave del sito corrente non c'e' piu', quella dell'altro sito si'
    var_dump( diskRead( 'TEST' ) );
    var_dump( diskRead( 'TEST', 'altro.sito.test' ) );

    // pulizia
    diskFlush( 'altro.sito.test' );
