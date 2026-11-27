<?php

    /**
     * controller before per la tabella immagini
     *
     * In scrittura, se arriva il percorso, decide se la riga entra nella coda di scalamento: un file che il task di
     * scalamento non sa lavorare ( un SVG, un PDF, qualsiasi cosa non sia JPEG, PNG o WebP, vedi imageScalabile() )
     * riceve il token di stato `NON_SCALABILE`, che lo toglie dalla coda; una riga che lo aveva e torna a un percorso
     * scalabile lo perde, e il task la riprende. Fino al 2026-10-30 il task girava a vuoto su queste righe a ogni giro.
     * Le righe scritte senza passare dal controller le marca il task stesso
     * ( _mod/_IM000.immagini/_src/_api/_task/_images.resize.php ).
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per $t/$a", 'controller' );

    // controllo azione corrente
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

            // il token si decide solo se arriva il percorso
            if( array_key_exists( 'path', $vs ) ) {

                // token attuale della riga
                $tokenImmagine = ( ! empty( $d['id'] ) ) ? mysqlSelectValue( $c, 'SELECT token FROM immagini WHERE id = ?', array( array( 's' => $d['id'] ) ) ) : NULL;

                // un file non scalabile esce dalla coda, uno tornato scalabile ci rientra
                if( ! imageScalabile( (string) $vs['path']['s'] ) ) {
                    $vs['token'] = array( 's' => 'NON_SCALABILE' );
                } elseif( $tokenImmagine == 'NON_SCALABILE' ) {
                    $vs['token'] = array( 's' => NULL );
                }

                // chiave del token
                if( isset( $vs['token'] ) && ! in_array( 'token', $ks ) ) {
                    $ks[] = 'token';
                }

            }

	    break;

	}
