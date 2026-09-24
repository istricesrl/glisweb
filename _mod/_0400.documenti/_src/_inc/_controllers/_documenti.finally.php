<?php

    /**
     * controller finally dei documenti
     *
     * Tiene allineata la vista statica delle offerte. Gemello di
     * _documenti.articoli.finally.php, con una differenza: la statica non si chiama
     * documenti_view_static ma offerte_attive_view_static, perche' a essere materializzata e'
     * offerte_attive_view - la vista che alimenta l'elenco delle offerte, e che di documenti ne
     * mostra solo una parte.
     *
     * Per questo l'aggiornamento automatico di mysqlInsertRow() non basta: quello cerca la statica
     * con il nome della TABELLA scritta ( getStaticView() -> documenti_view_static ), e
     * offerte_attive tabella non e'. Senza questo controller l'elenco delle offerte resterebbe
     * fermo all'ultima popolazione, che e' il guasto muto descritto in refreshStaticView().
     *
     * PERCHE' PRIMA SI CANCELLA E POI SI RISCRIVE: refreshStaticView() fa una REPLACE, quindi
     * aggiorna la riga se la vista gliela restituisce. Ma un documento puo' USCIRE dalla vista
     * restando in archivio - basta cambiargli la tipologia, o l'emittente - e in quel caso la
     * REPLACE non tocca niente e la riga vecchia resterebbe in elenco per sempre. Cancellare prima
     * costa una query e toglie il caso.
     *
     * Il controllo con getStaticView() e' lo stesso che fa mysqlInsertRow(): dove la tabella
     * statica non e' stata creata, questo controller non fa niente.
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

            // vista statica delle offerte
            if( ! empty( getStaticView( NULL, $c, 'offerte_attive' ) ) ) {

                mysqlQuery( $c, 'DELETE FROM offerte_attive_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
                refreshStaticView( $c, 'offerte_attive', $d['id'] );
                logWrite( 'aggiornata view statica offerte_attive per id #' . $d['id'], 'speed' );

            }

        break;
        case METHOD_DELETE:

            if( ! empty( getStaticView( NULL, $c, 'offerte_attive' ) ) ) {

                mysqlQuery( $c, 'DELETE FROM offerte_attive_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
                logWrite( 'aggiornata view statica offerte_attive per id #' . $d['id'], 'speed' );

            }

        break;

    }
