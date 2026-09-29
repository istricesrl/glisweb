<?php

    /**
     * propagazione della copia inline dell'indirizzo su `anagrafica_indirizzi`
     *
     * Dalla migrazione del 2026-07-10 `anagrafica_indirizzi` porta l'indirizzo per esteso
     * ( indirizzo, civico, id_comune, localita, cap, id_tipologia ) ed è la fonte da cui leggono
     * le query del modulo documenti e le stampe. Il form dell'anagrafica però continua a scrivere
     * il sotto-modulo degli indirizzi su `indirizzi`, con `anagrafica_indirizzi.id_indirizzo` come
     * collegamento: `indirizzi` resta la tabella degli indirizzi deduplicati, referenziata da una
     * quindicina di altre tabelle ( luoghi, progetti, edifici, todo, zone_indirizzi, ... ), e non
     * si può sostituire con la copia inline senza perdere quella deduplicazione.
     *
     * Senza questo hook la copia inline resterebbe ferma all'ultimo allineamento di massa, e un
     * documento emesso dopo una correzione dell'indirizzo stamperebbe il dato vecchio.
     *
     * Un indirizzo può essere collegato da più righe — conviventi, sedi condivise — quindi
     * `sincronizzaIndirizzoInline()` aggiorna tutte le `anagrafica_indirizzi` che lo citano, non
     * solo quella da cui si è arrivati.
     *
     * Per lo stesso motivo, dopo la sincronizzazione si rigenera nella vista statica anagrafica_view_static la riga
     * di ogni anagrafica che cita l'indirizzo, con updateAnagraficaViewStatic() del modulo anagrafica attivo: la vista
     * ricava stato e provincia dal comune dell'indirizzo, e cambiando il comune resterebbero quelli vecchi. Su un
     * DELETE non si fa niente: le righe di anagrafica_indirizzi se ne vanno in cascata con l'indirizzo, e quando si
     * arriva qui non dicono più quali anagrafiche lo citavano.
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

            if( ! empty( $d['id'] ) ) {

                // copia inline
                sincronizzaIndirizzoInline( $d['id'] );

                // vista statica delle anagrafiche che citano l'indirizzo
                if( function_exists( 'updateAnagraficaViewStatic' ) ) {
                    foreach( mysqlSelectColumn(
                        'id_anagrafica',
                        $c,
                        'SELECT DISTINCT id_anagrafica FROM anagrafica_indirizzi WHERE id_indirizzo = ? AND id_anagrafica IS NOT NULL',
                        array( array( 's' => $d['id'] ) )
                    ) as $idAnagrafica ) {
                        updateAnagraficaViewStatic( $idAnagrafica );
                    }
                }

            }

        break;

	}
