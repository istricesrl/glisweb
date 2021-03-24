<?php

    /**
     * macro form approvazione variazioni
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] =  'variazioni_attivita';

    print_r( $_REQUEST[ $ct['form']['table'] ] );

    // se ho un operatore e dei range devo andare a vedere tutte le attività che entrano nei range
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] ) ) {
        
        // per ogni riga di periodo devo vedere se ci sono attività che hanno data e ora programmazione in quel range, completamente o parzialmente
        // se sì aggiungo il cantiere e la data all'array dei risultati da mostrare in dashboard
        // nota: come gestiamo le date?
        foreach( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] as $p ){

        }



    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
