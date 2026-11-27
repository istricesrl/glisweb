<?php

    /**
     * file di esempio per la funzione site2regexp()
     *
     * Un sito con DEV e PROD, www fra gli host di PROD ( quindi facoltativo ), un alias di host e uno di dominio:
     * - gli host di PROD, con e senza www, in maiuscolo, con l'alias di dominio e con l'alias di host;
     * - l'host DEV, e il dominio DEV senza l'host, che non basta;
     * - uno stato senza dominio, che non ha espressione regolare.
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // sito di prova
    $site = array(
        'domains' => array( 'DEV' => 'istricesrl.it', 'PROD' => 'esempio.it' ),
        'hosts' => array( 'DEV' => 'esempio', 'PROD' => 'www' ),
        'alias' => array( 'hosts' => array( 'PROD' => array( 'shop' ) ), 'domains' => array( 'PROD' => array( 'esempio.com' ) ) )
    );

    // applicazione della funzione
    foreach( array( 'www.esempio.it' => 'PROD', 'esempio.it' => 'PROD', 'WWW.ESEMPIO.IT' => 'PROD', 'www.esempio.com' => 'PROD',
        'shop.esempio.it' => 'PROD', 'esempio.istricesrl.it' => 'DEV', 'istricesrl.it' => 'DEV' ) as $h => $s ) {
        echo $h . ' ' . $s . ': ' . var_export( preg_match( site2regexp( $site, $s ), $h ) === 1, true ) . PHP_EOL;
    }
    echo 'TEST: ' . var_export( site2regexp( $site, 'TEST' ), true ) . PHP_EOL;
