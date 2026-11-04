<?php

    /**
     * controller before per la tabella articoli
     *
     * Per ora non fa niente: e' il posto dove vanno le elaborazioni dei dati degli articoli prima della query. Fino al
     * 2026-11-04 stava in _src/_api/_inc/_controllers/, dove controller() non guarda ( vedi _articoli.finally.php ).
     *
     * @file
     *
     */

    // log
	logWrite( "controller before per $t/$a", 'controller' );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
        case METHOD_PUT:
        case METHOD_REPLACE:
        case METHOD_UPDATE:

        break;

	}
