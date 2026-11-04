<?php

    /**
     * controller finally per la tabella articoli
     *
     * Dopo ogni scrittura su articoli rigenera la riga dell'articolo nella vista statica articoli_view_static, e dopo
     * una cancellazione la toglie. Fino al 2026-11-04 questo file stava in _src/_api/_inc/_controllers/, dove
     * controller() non guarda ( cerca in DIR_MOD_ATTIVI_SRC_INC_CONTROLLERS, cioe' _src/_inc/_controllers/ ): non e'
     * mai stato eseguito, e la statica dal back-end non si aggiornava ( LUGHESE, 04/11/2026 ).
     *
     * Le tabelle che alimentano articoli_view hanno il loro controller finally, che rigenera gli articoli toccati:
     * _prodotti.finally.php, _prodotti.categorie.finally.php, _articoli.caratteristiche.finally.php.
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

            // view statica naturale
            // mysqlQuery( $c, 'CALL articoli_view_static( ? )', array( array( 's' => $d['id'] ) ) );
            refreshStaticView( $c, 'articoli', $d['id'] );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;
        case METHOD_DELETE:

            mysqlQuery( $c, 'DELETE FROM articoli_view_static WHERE id = ?', array( array( 's' => $d['id'] ) ) );
            logWrite( 'aggiornata view statica ' . $t . ' per id #' . $d['id'], 'speed' );

        break;

    }
