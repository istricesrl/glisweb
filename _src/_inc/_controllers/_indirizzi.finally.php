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
                sincronizzaIndirizzoInline( $d['id'] );
            }

        break;

	}
