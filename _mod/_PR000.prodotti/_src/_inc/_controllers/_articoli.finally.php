<?php

    /**
     *
     *
     *
     *
     *
     * TODO documentare
     * TODO qui spiegare il meccanismo delle controller e rimandare alla funzione controller()
     *
     *
     */

    // log
    logWrite( "controller finally per $t/$a", 'controller' );

    // elaborazioni di default dei dati
    switch( strtoupper( $a ) ) {

        case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:
        case METHOD_DELETE:

            // aggiorno la view statica
            updateArticoliViewStatic( $d['id'] );

        break;

    }
