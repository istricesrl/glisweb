<?php

    /**
     * file di esempio per la funzione urlLocale() in un multisito
     *
     * Con un elenco di host ammessi, come quello che urlDelDeploy() ricava dai siti del deploy, passano gli URL degli
     * altri siti e degli alias; non passano i domini che contengono quello del sito senza esserne un sottodominio.
     *
     * @file
     *
     */

    // inclusione del framework
    require '../../../../_src/_config.php';

    // output
    header( 'Content-type: text/plain' );

    // sito di prova
    $site = array(
        'domains' => array( 'PROD' => 'esempio.it' ),
        'hosts' => array( 'PROD' => 'www' ),
        'alias' => array( 'hosts' => array( 'PROD' => array( 'shop' ) ) )
    );

    // host ammessi: quello della richiesta e la regola del sito
    $h = array( 'www.example.com', site2regexp( $site, 'PROD' ) );

    // casi
    $casi = array(
        'host della richiesta' => 'https://www.example.com/pagina.it-IT.html',
        'altro sito del deploy' => 'https://www.esempio.it/pagina.it-IT.html',
        'alias' => 'https://shop.esempio.it/pagina.it-IT.html',
        'senza punto' => 'https://wwwesempio.it/',
        'dominio in coda' => 'https://www.esempio.it.evil.org/',
        'dominio come suffisso' => 'https://evilesempio.it/',
        'altro sito' => 'https://evil.org/'
    );

    // output
    foreach( $casi as $k => $v ) {
        echo $k . ': ' . var_export( urlLocale( $v, $h ), true ) . PHP_EOL;
    }
