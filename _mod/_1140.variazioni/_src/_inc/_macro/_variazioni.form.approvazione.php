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

   

    // se ho un operatore e dei range devo andare a vedere tutte le attività che entrano nei range
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] ) ) {
        
        // per ogni riga di periodo devo vedere se ci sono attività che hanno data e ora programmazione in quel range, completamente o parzialmente
        // se sì aggiungo il cantiere e la data all'array dei risultati da mostrare in dashboard
        // nota: come gestiamo le date? la dashboard deve mostrarmi solo le date interessate? se sono troppe (es. uno va in aspettativa o in maternità 3 mesi) e non ci stanno?
        
        foreach( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] as $p ){
            // se l'ora inizio non è settata parto dalla mezzanotte, idem per l'ora fine
            
            if( empty( $p['ora_inizio'] ) ){
                $p['ora_inizio'] = '00:00:01';
            }
            if( empty( $p['ora_fine'] ) ){
                $p['ora_fine'] = '23:59:59';
            }
            
            $data_ora_inizio = $p['data_inizio'] . " " . $p['ora_inizio'];
            $data_ora_fine = $p['data_fine'] . " " . $p['ora_fine'];


            $attivita = mysqlQuery( 
                $cf['mysql']['connection'],
                "SELECT id, id_anagrafica, data_programmazione, TIME_FORMAT(ora_inizio_programmazione, '%H:%i') as ora_inizio_programmazione, "
                ."TIME_FORMAT(ora_fine_programmazione, '%H:%i') as ora_fine_programmazione, id_progetto, progetto, TIMESTAMP( data_programmazione, ora_inizio) as timestamp_inizio, "
                ."TIMESTAMP( data_programmazione, ora_fine) as timestamp_fine FROM attivita_view "
                ."WHERE id_anagrafica = ? "
                ."AND ( ( TIMESTAMP( data_programmazione, ora_inizio) between ? and ? ) OR ( TIMESTAMP( data_programmazione, ora_fine) between ? and ? ) ) "
                ."ORDER by data_programmazione, id_progetto, ora_inizio_programmazione"
              ,
                array(
                    array( 's' =>  $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ),
                    array( 's' =>  $data_ora_inizio ),
                    array( 's' =>  $data_ora_fine ),
                    array( 's' =>  $data_ora_inizio ),
                    array( 's' =>  $data_ora_fine )
                )
            );

           foreach( $attivita as $a ){
               $ct['etc']['attivita'][ $a['data_programmazione'] ][ $a['id_progetto'] ]['attivita'][ $a['id'] ] = $a;
               $ct['etc']['attivita'][ $a['data_programmazione'] ][ $a['id_progetto'] ]['progetto'] = $a['progetto'];
           }

        // successivo per la creazione delle attività 
            // 1- prendo la data
            // 2- vado a vedere se c'è un turno attivo per quella data e quell'anagrafica
            // 3- vado nel contratto attivo per l'anagrafica corrente e vedo per quel turno che orari sono previsti
            // 4- creo una riga di attività con la tipologia inps indicata per ogni fascia di orari_contratti trovata
            // 5- vedo se ci sono attività già pianificate per quella fascia di data e ora e setto id_anagrafica NULL
        }

    }

 //  print_r( $ct['etc']['attivita'] );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
