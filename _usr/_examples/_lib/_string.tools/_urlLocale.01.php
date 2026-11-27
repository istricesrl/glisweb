<?php

    /**
     * file di esempio per la funzione urlLocale()
     *
     * Mostra l'esito su un percorso locale, su un URL dello stesso sito e sugli indirizzi che non devono passare:
     * altro sito, percorso relativo al protocollo, barra rovesciata, javascript:, data:, credenziali, vuoto e array.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // host del sito
    $h = 'www.example.com';

    // casi
    $casi = array(
        'percorso' => '/strumenti/pagina.it-IT.html?mail_out[id]=1',
        'stesso sito' => 'https://www.example.com/pagina.it-IT.html',
        'altro sito' => 'https://evil.example.org/',
        'protocollo relativo' => '//evil.example.org/',
        'barra rovesciata' => '/\\evil.example.org/',
        'javascript' => 'javascript:alert(1)',
        'data' => 'data:text/html,x',
        'credenziali' => 'https://www.example.com@evil.example.org/',
        'a capo' => "/pagina\r\nSet-Cookie: x=1",
        'vuoto' => '',
        'array' => array( '/' )
    );

    // output
    foreach( $casi as $k => $v ) {
        echo $k . ': ' . var_export( urlLocale( $v, $h ), true ) . PHP_EOL;
    }
