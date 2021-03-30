<?php

    /**
     *
     * form che calcola e mostra l'elenco dei candidati sostituti per l'attività corrente
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella gestita
	$ct['form']['table'] =  'attivita';
   
    // escludere le anagrafiche per cui esiste una riga nella tabella sostituzioni_attivita per l'attivita corrente
    
    // estraggo tutte le info che mi servono per l'attività corrente
    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        // richiamo la funzione che ritorna l'array degli operatori coi punteggi
        $ct['etc']['operatori'] = elencoSostituti( $_REQUEST[ $ct['form']['table'] ]['id'] );

    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


   