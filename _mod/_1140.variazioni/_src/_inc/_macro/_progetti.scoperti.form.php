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
	$ct['form']['table'] = 'progetti';

    // se ho un progetto, estraggo le attività scoperte ad esso relative e per ciascuna calcolo l'elenco dei sostituti
    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        // estraggo la data di pianificazione della prima attività scoperta per il progetto corrente
        $dataPrima = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT min(data_programmazione) FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );


        // cerco se ci sono già dei sostituti calcolati
        $ct['etc']['operatori'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT r.*, coalesce(
                a.soprannome,
                a.denominazione,
                concat_ws(" ", coalesce(a.nome, ""),
                coalesce(a.cognome, "") ),
                ""
            ) as anagrafica FROM __report_progetti_sostituti__ AS r '
            .'LEFT JOIN anagrafica AS a ON r.id_anagrafica = a.id '
            .'WHERE r.id_progetto = ? AND r.data_prima_scopertura = ? ORDER BY r.punti_totali DESC, r.punti_sostituto DESC LIMIT 30',
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $dataPrima )
            )
        );

        // richiamo la funzione che ritorna l'array degli operatori coi punteggi
    #    $ct['etc']['operatori'] = elencoSostitutiProgetto( $_REQUEST[ $ct['form']['table'] ]['id'] );

        // tendina operatori per settaggio manuale
	    $ct['etc']['select']['operatori'] = mysqlCachedIndexedQuery(
            $cf['cache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1' );
    }

     // modal per la conferma di invio richiesta sostituzione
     $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'richiesta', 'include' => 'inc/progetti.scoperti.form.modal.richiesta.html' )
    );
    
    // modal per la conferma di sostituzione diretta
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'sostituisci', 'include' => 'inc/progetti.scoperti.form.modal.sostituisci.html' )
    );

    // modal per la conferma di avvio calcolo sostituti
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'calcola', 'include' => 'inc/progetti.scoperti.form.modal.calcola.html' )
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';

   