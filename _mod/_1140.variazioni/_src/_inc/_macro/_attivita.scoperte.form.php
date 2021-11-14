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
   
    // se ho un'attività, cerco i sostituti
    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        // richiamo la funzione che ritorna l'array degli operatori coi punteggi
        $ct['etc']['operatori'] = elencoSostitutiAttivita( $_REQUEST[ $ct['form']['table'] ]['id'] );

        // tendina operatori per settaggio manuale
	    $ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            "SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 AND "
            ."id NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? )",
        /*    "SELECT DISTINCT id_anagrafica AS id, anagrafica AS __label__ FROM attivita_view WHERE "
            ."id_anagrafica IS NOT NULL AND "
            ."id_anagrafica NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? ) ORDER BY anagrafica",*/
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );
    }

    // modal per la conferma di invio richiesta sostituzione
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'richiesta', 'include' => 'inc/attivita.scoperte.form.modal.richiesta.html' )
    );

    // modal per la conferma di sostituzione diretta
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'sostituisci', 'include' => 'inc/attivita.scoperte.form.modal.sostituisci.html' )
    );

    // modal per la conferma di scarto operatore
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'scarta', 'include' => 'inc/attivita.scoperte.form.modal.scarta.html' )
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';
    


   