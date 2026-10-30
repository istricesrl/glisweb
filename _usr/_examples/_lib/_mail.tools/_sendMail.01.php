<?php

    /**
     * file di esempio per la funzione sendMail(): senza un destinatario valido in A la mail non parte
     *
     * Prova a spedire una mail il cui unico destinatario in A ha un indirizzo non valido e che ha invece un destinatario
     * valido in CC: sendMail() deve restituire false senza tentare l'invio, e scrivere l'errore nel canale mail a
     * LOG_CRIT. Il server SMTP è 127.0.0.1 sulla porta 1, dove non risponde nessuno, così la mail non parte comunque;
     * per questo l'esempio non si ferma al valore restituito ma cerca la riga di LOG_CRIT, che c'è solo se la funzione
     * si è fermata prima di Send(). Poi toglie dal log la riga che ha scritto.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // oggetto riconoscibile
    $oggetto = 'TEST-E2E-' . uniqid();

    // invio
    $status = sendMail(
        '127.0.0.1',
        array( 'mittente di prova' => 'mittente@example.com' ),
        array( 'destinatario non valido' => 'non-un-indirizzo' ),
        $oggetto,
        '<p>prova</p>',
        array( 'copia di prova' => 'copia@example.com' ),
        array(), array(), array(), NULL, NULL, 1
    );

    // esito
    echo 'status: ' . var_export( $status, true ) . PHP_EOL;

    // dove è finito l'errore
    foreach( array( DIR_VAR_LOG . 'test/', DIR_VAR_LOG ) as $cartella ) {
        $file = $cartella . 'mail.crit.' . date( 'Ym' ) . '.log';
        if( file_exists( $file ) && strpos( file_get_contents( $file ), $oggetto ) !== false ) {
            $righe = file( $file );
            foreach( $righe as $riga ) {
                if( strpos( $riga, $oggetto ) !== false && strpos( $riga, 'nessun destinatario valido in A' ) !== false ) {
                    echo 'errore scritto a LOG_CRIT' . PHP_EOL;
                }
            }
            file_put_contents( $file, implode( '', array_filter( $righe, function( $riga ) use ( $oggetto ) {
                return strpos( $riga, $oggetto ) === false;
            } ) ) );
        }
    }
