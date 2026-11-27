<?php

    /**
     * controller finally della tabella relazioni_documenti
     *
     * documenti_view elenca i documenti antecedenti e successivi di ogni documento, quindi una relazione cambia le
     * righe di tutti e due i documenti in documenti_view_static: dopo ogni scrittura le si riscrive con
     * refreshStaticView(). Vedi _documenti.finally.php per il perche' sta nel nucleo; quello che il blocco dati non
     * porta ( un DELETE senza i due id ) lo riallinea a lotti il task _documenti.view.static.popolazione.php.
     *
     * @file
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

            // aggiorno la view statica dei due documenti
            $ids = array_filter( array(
                ( isset( $d['id_documento'] ) ) ? $d['id_documento'] : NULL,
                ( isset( $d['id_documento_collegato'] ) ) ? $d['id_documento_collegato'] : NULL
            ) );

            if( ! empty( $ids ) ) {
                refreshStaticView( $c, 'documenti', array_values( $ids ) );
            }

        break;

    }
