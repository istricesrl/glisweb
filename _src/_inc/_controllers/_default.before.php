<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     * TODO come agire nei controller before
     * TODO documentare
     *
     * 
     *
     */

    // log
	logWrite( "controller default/before per $t/$a", 'controller' );

    // debug
    // print_r( $vs );

    // elaborazioni di default dei dati
	switch( strtoupper( $a ) ) {

	    case METHOD_POST:
	    case METHOD_PUT:
	    case METHOD_REPLACE:
	    case METHOD_UPDATE:

		// elaboro l'array dei valori
            foreach( $vs as $vKey => $vVal ) {

                // log
                logWrite( "valuto $vKey", 'controller' );

                // converto le timestamp in int
                    if( substr( $vKey, 0, 10 ) == 'timestamp_' && ( ! empty( $vVal['s'] ) && ! is_numeric( $vVal['s'] ) ) ) {
                        // parsing format-aware: strtotime() su data italiana d/m/Y la legge
                        // all'americana (m/d) e scambia giorno e mese. Gestisco esplicitamente
                        // i formati ISO (datetime-local) e italiano (datetime-local degradato a input testo).
                        $v = trim( (string) $vVal['s'] );
                        if( preg_match( '#^\d{4}-\d{2}-\d{2}#', $v ) ) {
                            // ISO / datetime-local (Y-m-d, Y-m-d\TH:i): strtotime è sicuro
                            $ts = strtotime( $v );
                        } elseif( preg_match( '#^\d{1,2}/\d{1,2}/\d{4}#', $v ) ) {
                            // formato italiano d/m/Y (es. datetime-local degradato a input testo)
                            $dt = DateTime::createFromFormat( 'd/m/Y H:i', $v )
                                ?: DateTime::createFromFormat( 'd/m/Y H:i:s', $v )
                                ?: DateTime::createFromFormat( 'd/m/Y', $v );
                            $ts = $dt ? $dt->getTimestamp() : strtotime( $v );
                        } else {
                            $ts = strtotime( $v );
                        }
                        $vs[ $vKey ]['s'] = $ts;
                    }

                // nei numeri sostituisco la , con il .
                    if(( ! empty( $vVal['s'] ) && is_numeric( str_replace( ',', '', $vVal['s'] ) ) ) ) {
                        $vs[ $vKey ]['s'] = str_replace(',','.',$vs[ $vKey ]['s']);
                    }
		    }

	    break;

	}

    // debug
    // print_r( $vs );
