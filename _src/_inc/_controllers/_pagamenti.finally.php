<?php

    /**
     * controller finally della tabella pagamenti
     *
     * documenti_view lega i pagamenti al documento ( i totali ), quindi scrivere un pagamento cambia la riga del suo
     * documento in documenti_view_static: dopo ogni scrittura la si riscrive con refreshStaticView(). Vedi
     * _documenti.finally.php per il perche' sta nel nucleo.
     *
     * Dopo un DELETE il documento si conosce solo se il blocco dati porta id_documento, come quando il pagamento si
     * toglie dal form del documento ( e li' ci pensa comunque il controller finally di documenti ); altrimenti la riga
     * la riallinea a lotti il task _documenti.view.static.popolazione.php.
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

            // aggiorno la view statica del documento
            if( ! empty( $d['id_documento'] ) ) {
                refreshStaticView( $c, 'documenti', $d['id_documento'] );
            }

        break;

    }
