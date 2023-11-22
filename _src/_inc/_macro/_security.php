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

    // IP
    // $ipFiles = glob( DIR_VAR_SPOOL_SECURITY . '*.log' );

    // die( print_r( $ipFiles, true ) );

    // regole
    $regole = array(
        array(
            'label' => 'prova',
            'regexp' => '(provaSicurezza[0-9]+)',
            'type' => 'hard'
        ),
        /*
        array(
            'label' => 'SQL injection',
            'regexp' => "('(''|[^'])*')|(;)|(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE){0,1}|INSERT( +INTO){0,1}|MERGE|SELECT|UPDATE|UNION( +ALL){0,1})\b)",
            'type' => 'hard'
        ),
        */
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
            'label' => 'eval',
            'regexp' => '(\beval\b)',
            'type' => 'hard'
        ),
        array(
            'label' => 'rawurldecode',
            'regexp' => '(rawurldecode)',
            'type' => 'hard'
        ),
        array(
            'label' => '$_COOKIE',
            'regexp' => '(\$\_COOKIE)',
            'type' => 'hard'
        ),
        array(
            'label' => 'codice PHP generico',
            'chars' => array( '$', ';', '=', '<?' ),
            'type' => 'hard'
#        ),
#        array(
#            'label' => 'codice Js generico',
#            'chars' => array( '=', ';', '{' ),
#            'type' => 'hard'
        )
    );

    // debug
    // die( 'inizio layer di sicurezza' );

    // funzione checkInput()
    function checkInput( $input, $regole, $memcache, $response, $attackers ) {

        // controllo i valori
        foreach( $input as $chiave => $valore ) {

            // debug
            // die( 'test di ' . $chiave );

            // ricorsione
            if( is_array( $valore ) ) {

                checkInput( $valore, $regole, $memcache, $response, $attackers );

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

                        // incremento
                        $response++;

                        // contatore
                        if( is_object( $memcache ) ) {
                            $memcache->set( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'], $response );
                        }

                        // riepilogo
                        $attackers[ $_SERVER['REMOTE_ADDR'] ] = $response;
                        if( is_object( $memcache ) ) {
                            $memcache->set( 'ATTACKERS', $attackers );
                        }

                        // log
                        $h = fopen( DIR_VAR_SPOOL_SECURITY . 'attacco.' . $_SERVER['REMOTE_ADDR'] . '.log', 'a+' );
                        fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola ' . $regola['label'] . PHP_EOL .
                                    'sorgente: ' . $_SERVER['REMOTE_ADDR'] . PHP_EOL .
                                    $detail . PHP_EOL .
                                    'contenuto: ' . PHP_EOL . $valore . PHP_EOL . PHP_EOL );
                        fclose( $h );

                        // HTTP status
                        http_response_code( 400 );

                        // output
                        die('no way');

                    }

                }

            }

        }      

    }

    // connessione a memcache
    if( class_exists( 'Memcached' ) ) {
        $memcache = new Memcached();
        $memcache->addServer( '127.0.0.1', 11211 );
        $response = $memcache->get( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'] );
        $attackers = $memcache->get( 'ATTACKERS' );
        $urls = $memcache->get( 'BANNED_URLS' );
    } else {
        $memcache = NULL;
        $response = NULL;
        $attackers = NULL;
        $urls = NULL;
    }

    // debug
    // print_r( $attackers );

    // controllo attackers
    if( isset( $attackers ) && is_array( $attackers ) ) {
        if( in_array( $_SERVER['REMOTE_ADDR'], array_keys( $attackers ) ) ) {

            // log
            $h = fopen( DIR_VAR_SPOOL_SECURITY . 'attacco.' . $_SERVER['REMOTE_ADDR'] . '.log', 'a+' );
            fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola IP ' . $_SERVER['REMOTE_ADDR'] . PHP_EOL . 
                        'sorgente: ' . $_SERVER['REMOTE_ADDR'] . PHP_EOL .
                        'url: ' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] . PHP_EOL .
                        'contenuto: ' . PHP_EOL . $_SERVER['QUERY_STRING'] . PHP_EOL . PHP_EOL );
            fclose( $h );
    
            // HTTP status
            http_response_code( 400 );
    
            // output
            die('nice try');
    
        }
    }

    // URL sospetti
    if( empty( $urls ) ) {
        $urls = array_merge(
            array(
                'phpunit',
                'cgi-bin',
                'htaccess',
                'cmsadmin',
                'config.inc',
                'cpanel',
                'dbadmin',
                'servlet',
                'wp-config',
                '__firma__'
            ),
            array_map('trim',
                file(
                    DIR_BASE . '_etc/_security/_banned.words.conf'
                )
            )
        );
        if( isset( $memcache ) && is_object( $memcache ) ) {
            $memcache->set( 'BANNED_URLS', $urls );
        }
    }

    // controllo totale attacchi
    if( isset( $response ) ) {
        if( $response > 4 ) {

            // HTTP status
#            http_response_code( 400 );

            // output
#            die('enough, guy');

        }
    } else {
        $response = 1;
    }

    // controlli formali sulla $_REQUEST
    checkInput( $_REQUEST, $regole, $memcache, $response, $attackers );

    // controllo URL
    foreach( $urls as $url ) {

        // controllo
        if( stripos( urldecode( $_SERVER['REQUEST_URI'] ), urldecode( $url ) ) !== false ) {

            // incremento
            $response++;

            // contatore
            if( is_object( $memcache ) ) {
                $memcache->set( 'ATTACKER_' . $_SERVER['REMOTE_ADDR'], $response );
            }

            // riepilogo
            $attackers[ $_SERVER['REMOTE_ADDR'] ] = $response;
            if( is_object( $memcache ) ) {
                $memcache->set( 'ATTACKERS', $attackers );
            }

            // log
            $h = fopen( DIR_VAR_SPOOL_SECURITY . 'attacco.' . $_SERVER['REMOTE_ADDR'] . '.log', 'a+' );
            fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola URL ' . $url . PHP_EOL . 
                        'sorgente: ' . $_SERVER['REMOTE_ADDR'] . PHP_EOL .
                        'url: ' . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'] . PHP_EOL .
                        'contenuto: ' . PHP_EOL . $_SERVER['QUERY_STRING'] . PHP_EOL . PHP_EOL );
            fclose( $h );

            // HTTP status
            http_response_code( 400 );

            // output
            die('nice try');

        } else {

            // debug
            // echo urldecode( $_SERVER['REQUEST_URI'] ) . ' != ' . urldecode( $url ) . PHP_EOL;

        }
    
    }

    // debug
    // die( print_r( $urls, true ) );
