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

    // regole
    $regole = array(
        array(
            'label' => 'prova',
            'regexp' => '(provaSicurezza[0-9]+)'
        ),
        array(
            'label' => 'SQL injection',
            'regexp' => "('(''|[^'])*')|(;)|(\b(ALTER|CREATE|DELETE|DROP|EXEC(UTE){0,1}|INSERT( +INTO){0,1}|MERGE|SELECT|UPDATE|UNION( +ALL){0,1})\b)"
        ),
        array(
            'label' => 'file_put_contents',
            'regexp' => '(file_put_contents)'
        ),
        array(
            'label' => 'getallheaders',
            'regexp' => '(getallheaders)'
        ),
        array(
            'label' => '$_COOKIE',
            'regexp' => '(\$\_COOKIE)'
        )
    );

    // funzione checkInput()
    function checkInput( $input, $regole ) {

        // sorgente
        $ip = $_SERVER['REMOTE_ADDR'];

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

                    // debug
                    // die( 'test regola ' . $regola['label'] );
                    
                    // test se $valore matcha $regola['regexp']
                    // se matcha fare un die( $regola['label'] )
                    if( isset( $regola['regexp'] ) ) {
                        $check = preg_match( $regola['regexp'], $valore );
                        $detail = 'regexp: ' . $regola['regexp'];
                    }

                    // verifica
                    if( $check == 1 ) {

                        // debug
                        // die( 'match di ' . $valore . ' per la regola ' . $regola['label'] );

                        // log
                        if( ! is_dir( DIR_VAR_SPOOL_SECURITY ) ) {
                            mkdir( DIR_VAR_SPOOL_SECURITY, 0755, true );
                        }

                        // log
                        $h = fopen( DIR_VAR_SPOOL_SECURITY . 'attacco.' . $ip . '.log', 'a+' );
                        fwrite( $h, date( 'Y-m-d H:i:s' ) . ' match per la regola ' . $regola['label'] . PHP_EOL );
                        fwrite( $h, 'sorgente: ' . $ip . PHP_EOL );
                        fwrite( $h, $detail . PHP_EOL );
                        fwrite( $h, 'contenuto:' . PHP_EOL . $valore . PHP_EOL );
                        fwrite( $h, PHP_EOL );
                        fclose( $h );

                        // output
                        die();

                    }

                }

            }

        }
        
        // controllo delle SQL injection
        $stringa_input= "";
       
    }

    // controlli formali sulla $_REQUEST
    checkInput( $_REQUEST, $regole );


