<?php

    /**
     * file di esempio per la funzione logWrite(): i log delle richieste dei test vanno in var/log/test/
     *
     * Scrive una riga di errore e dice in quale cartella è finita: in var/log/test/ se la richiesta porta nello
     * User-Agent il marcatore dei test ( LOG_TEST_USER_AGENT, vedi _src/_config/_020.debug.php ), in var/log/
     * altrimenti. Poi cancella il file che ha scritto.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // riga di prova
    $riga = 'TEST-E2E-' . uniqid();
    logWrite( $riga, 'esempio.marcatore', LOG_ERR );

    // dove è finita
    foreach( array( 'var/log/test/' => DIR_VAR_LOG . 'test/', 'var/log/' => DIR_VAR_LOG ) as $nome => $cartella ) {
        $file = $cartella . 'esempio.marcatore.err.' . date( 'Ym' ) . '.log';
        if( file_exists( $file ) && strpos( file_get_contents( $file ), $riga ) !== false ) {
            echo 'riga scritta in ' . $nome . PHP_EOL;
            unlink( $file );
        }
    }
