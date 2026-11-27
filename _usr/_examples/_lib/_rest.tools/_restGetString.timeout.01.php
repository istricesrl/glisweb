<?php

    /**
     * file di esempio per il tempo massimo di restGetString()
     *
     * Chiama un indirizzo non instradabile, che non risponde mai, con un tempo massimo di un secondo, e mostra che la
     * funzione restituisce false senza aspettare i default di restCall(): e' il caso del controllo della versione in
     * _030.common.php quando glisweb.istricesrl.it non si raggiunge.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // chiamata a un indirizzo che non risponde
    $t = microtime( true );
    $r = restGetString( 'http://10.255.255.1/', 1 );
    $d = microtime( true ) - $t;

    echo 'risposta: ';
    var_dump( $r );
    echo 'entro il tempo: ' . ( ( $d < 2.5 ) ? 'si' : 'no ( ' . round( $d, 1 ) . ' secondi )' ) . PHP_EOL;
