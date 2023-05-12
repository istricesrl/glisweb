<?php

    /**
     * LAYER DI SICUREZZA DEL FILE _src/_config/_config.php
     * 
     * avvertenze importanti:
     * 
     * - questo file è standalone
     * - questo file è richiamato da _src/_config/_config.php quindi se un file del framework non usa _src/_config/_config.php deve includerlo manualmente
     * 
     * 
     * controllare che $valore:
     *
     *  - non contenga tentativi di SQL injection
     *  - non contenga codice di alcun tipo
     * 
     * 
     * NOTA
     * testare chiamando il framework con la seguente query string:
     * 
     * ?z=provaSicurezza1
     * 
     * 
     */

    // cartella
    if( ! is_dir( DIR_VAR_SPOOL_SECURITY ) ) {
        mkdir( DIR_VAR_SPOOL_SECURITY, 0755, true );
    }

    // regole
    $regole = array(
        array(
            'label' => 'prova',
            'regexp' => '(provaSicurezza[0-9]+)',
            'type' => 'hard'
        ),
        array(
            'label' => 'SQL injection',
            'regexp' => "('(''|[^'])*')|(;)|(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE){0,1}|INSERT( +INTO){0,1}|MERGE|SELECT|UPDATE|UNION( +ALL){0,1})\b)",
            'type' => 'hard'
        ),
        array(
            'label' => 'file_put_contents',
            'regexp' => '(file_put_contents)',
            'type' => 'hard'
        ),
        array(
            'label' => 'getallheaders',
            'regexp' => '(getallheaders)',
            'type' => 'hard'
        ),
        array(
            'label' => '$_COOKIE',
            'regexp' => '(\$\_COOKIE)',
            'type' => 'hard'
        ),
        array(
            'label' => 'codice PHP generico',
            'chars' => array( '$', ';', '=' ),
            'type' => 'hard'
        ),
        array(
            'label' => 'codice Js generico',
            'chars' => array( '=', ';', '{' ),
            'type' => 'hard'
        )
    );

    // URL sospetti
    $urls = array(
        'phpunit',
        'cgi-bin',
        'htaccess',
        'cmsadmin',
        'config.inc',
        'cpanel',
        'dbadmin',
        'servlet'
    );

    // debug
    // die( 'inizio layer di sicurezza' );

    // funzione checkInput()
    function checkInput( $input, $regole ) {

        // sorgente
        $_SERVER['REMOTE_ADDR'] = $_SERVER['REMOTE_ADDR'];

        // controllo i valori
        foreach( $input as $chiave => $valore ) {

            // debug
            // die( 'test di ' . $chiave );

            if( is_array( $valore ) ) {

                checkInput( $valore, $regole );

            } else {

                // debug
                // die( 'test di ' . $chiave . '/' . $valore );

                // controllo ogni regola
                foreach( $regole as $regola ) {

                    // default
                    $check = 0;

                    // debug
                    // die( 'test regola ' . $regola['label'] );
                    
                    // test se $valore matcha $regola['regexp']
                    // se matcha fare un die( $regola['label'] )
                    if( isset( $regola['regexp'] ) ) {
                        $check = preg_match( $regola['regexp'], $valore );
                        $detail = 'regexp: ' . $regola['regexp'];
                    } elseif( isset( $regola['chars'] ) ) {
                        $check = findChars( $valore, $regola['chars'] );
                        $detail = 'caratteri: ' . implode( ', ', $regola['chars'] );
                    }

                    // debug
                    // var_dump( $check );
                    // die( 'esito test regola ' . $regola['label'] . ' -> ' . $check );

                    // verifica
                    if( $check == 1 ) {

                        // debug
                        // die( 'match di ' . $valore . ' per la regola ' . $regola['label'] );
/*
                        // contatore
                        $mem_var = new Memcached();
                        $mem_var->addServer('127.0.0.1', 11211);
                        $response = $mem_var->get( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'] );
                        if ($response) {
                            $response++;
                        } else {
                            $response=1;
                        }
                        $mem_var->set( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'], $response );
*/
                        // log
                        $h = fopen( DIR_VAR_SPOOL_SECURITY . 'attacco.' . $_SERVER['REMOTE_ADDR'] . '.log', 'a+' );
                        fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola ' . $regola['label'] . PHP_EOL );
                        fwrite( $h, 'sorgente: ' . $_SERVER['REMOTE_ADDR'] . PHP_EOL );
                        fwrite( $h, $detail . PHP_EOL );
                        fwrite( $h, 'contenuto:' . PHP_EOL . $valore . PHP_EOL );
                        fwrite( $h, PHP_EOL );
                        fclose( $h );

                        // HTTP status
                        http_response_code( 400 );

                        // output
                        die('nice try');

                    }

                }

            }

        }      

    }

    // controllo totale attacchi
    $mem_var = new Memcached();
    $mem_var->addServer( '127.0.0.1', 11211 );
    $response = $mem_var->get( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'] );
    if ($response) {
        if( $response > 4 ) {
            die('enough, guy');
        }
    }

    // controlli formali sulla $_REQUEST
    checkInput( $_REQUEST, $regole );

    // controllo URL
    foreach( $urls as $url ) {

        // controllo
        if( stripos( $_SERVER['QUERY_STRING'], $url ) !== false ) {

            // contatore
            $mem_var = new Memcached();
            $mem_var->addServer('127.0.0.1', 11211);
            $response = $mem_var->get( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'] );
            if ($response) {
                $response++;
            } else {
                $response=1;
            }
            $mem_var->set( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'], $response );

            // log
            $h = fopen( DIR_VAR_SPOOL_SECURITY . 'attacco.' . $_SERVER['REMOTE_ADDR'] . '.log', 'a+' );
            fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola URL ' . $url . PHP_EOL );
            fwrite( $h, 'sorgente: ' . $_SERVER['REMOTE_ADDR'] . PHP_EOL );
            fwrite( $h, 'url:' . $_SERVER[HTTP_HOST] . $_SERVER[REQUEST_URI] . PHP_EOL );
            fwrite( $h, 'contenuto:' . PHP_EOL . $_SERVER['QUERY_STRING'] . PHP_EOL );
            fwrite( $h, PHP_EOL );
            fclose( $h );

            // HTTP status
            http_response_code( 400 );

            // output
            die('nice try');

        }
    
    }
