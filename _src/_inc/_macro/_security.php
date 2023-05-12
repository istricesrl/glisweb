<?php

    /**
     * LAYER DI SICUREZZA DEL FILE _src/_config/_config.php
     * 
     * avvertenze importanti:
     * 
     * - questo file è standalone
     * - questo file è richiamato da _src/_config/_config.php quindi se un file del framework non usa _src/_config/_config.php deve includerlo manualmente
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
        )
    );

    // funzione checkInput()
    function checkInput( $input ) {

        foreach( $input as $chiave => $valore ) {

            if( is_array( $valore ) ) {

                checkInput( $valore );

            } else {

                /**
                 * controllare che $valore:
                 *
                 *  - non contenga tentativi di SQL injection
                 *  - non contenga codice di alcun tipo
                 *  
                 */
                foreach( $regole as $regola ) {

                    // test se $valore matcha $regola['regexp']
                    // se matcha fare un die( $regola['label'] )

                }

            }

        }

    }

    // controlli formali sulla $_REQUEST
    checkInput( $_REQUEST );


