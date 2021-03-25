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

//    print_r( $_REQUEST[ $ct['form']['table'] ] );

    // se ho un operatore e dei range devo andare a vedere tutte le attività che entrano nei range
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] ) ) {
        
        // per ogni riga di periodo devo vedere se ci sono attività che hanno data e ora programmazione in quel range, completamente o parzialmente
        // se sì aggiungo il cantiere e la data all'array dei risultati da mostrare in dashboard
        // nota: come gestiamo le date? la dashboard deve mostrarmi solo le date interessate? se sono troppe (es. uno va in aspettativa o in maternità 3 mesi) e non ci stanno?
        
        foreach( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] as $p ){
            // 1- prendo la data
            // 2- vado a vedere se c'è un turno attivo per quella data
            // 3- vado nel contratto attivo e vedo per quel turno che orari sono previsti
            // 4- creo una riga di attività con la tipologia inps indicata per ogni fascia di orari_contratti trovata
            // 5- vedo se ci sono attività già pianificate per quella fascia di data e ora e setto id_anagrafica NULL
        }



    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
