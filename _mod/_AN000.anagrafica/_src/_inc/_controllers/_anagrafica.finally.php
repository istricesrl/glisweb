<?php

    /**
     * controller finally per l'anagrafica
     *
     * Questa controller viene invocata alla fine di tutte le operazioni sull'anagrafica.
     * Il suo scopo principale è quello di aggiornare la view statica dell'anagrafica dopo
     * ogni operazione di modifica (POST, PUT, REPLACE, UPDATE, DELETE).
     *
     *
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
            updateAnagraficaViewStatic( $d['id'] );

        break;

    }
