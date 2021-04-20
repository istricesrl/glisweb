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
        // se sì aggiungo il progetto e la data all'array dei risultati da mostrare in dashboard
        
        // elenco dei progetti per cui sono presenti attività coinvolte
        $prog = array();
        $ct['etc']['attivita'] = array();

        foreach( $_REQUEST[ $ct['form']['table'] ]['periodi_variazioni_attivita'] as $p ){
            
            // la data_fine maggiore nell'elenco periodi
            if( !isset( $ct['etc']['datamax'] ) || $ct['etc']['datamax'] < $p['data_fine'] ){
                $ct['etc']['datamax'] = $p['data_fine'];
            }

            // se l'ora inizio non è settata parto dalla mezzanotte, idem per l'ora fine
            if( empty( $p['ora_inizio'] ) ){
                $p['ora_inizio'] = '00:00:01';
            }
            if( empty( $p['ora_fine'] ) ){
                $p['ora_fine'] = '23:59:59';
            }
            
            $data_ora_inizio = $p['data_inizio'] . " " . $p['ora_inizio'];
            $data_ora_fine = $p['data_fine'] . " " . $p['ora_fine'];

            // elenco delle righe di attività già pianificate coinvolte nella sostituzione
            $attivita = mysqlQuery( 
                $cf['mysql']['connection'],
                "SELECT attivita_view.id, id_anagrafica, data_programmazione, TIME_FORMAT(ora_inizio_programmazione, '%H:%i') as ora_inizio_programmazione, "
                ."TIME_FORMAT(ora_fine_programmazione, '%H:%i') as ora_fine_programmazione, id_progetto, progetto, "
                ."coalesce( p1.id, p2.id) AS id_pianificazione, coalesce( p1.data_fine, p2.data_fine) as data_fine, "
                ."coalesce( p1.giorni_rinnovo, p2.giorni_rinnovo) as giorni_rinnovo FROM attivita_view "
                ."LEFT JOIN pianificazioni as p1 ON attivita_view.id_pianificazione = p1.id "
                ."LEFT JOIN pianificazioni as p2 ON attivita_view.id_todo = p2.id_todo "
                ."WHERE id_anagrafica = ? "
                ."AND ( ( TIMESTAMP( data_programmazione, ora_inizio_programmazione ) between ? and ? ) OR ( TIMESTAMP( data_programmazione, ora_fine_programmazione ) between ? and ? ) ) "
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
        /*       $ct['etc']['attivita'][ $a['data_programmazione'] ][ $a['id_progetto'] ]['attivita'][ $a['id'] ] = $a;
               $ct['etc']['attivita'][ $a['data_programmazione'] ][ $a['id_progetto'] ]['progetto'] = $a['progetto']; */ 
           
                $ct['etc']['attivita'][ $a['id'] ] = $a;
            }          
        }

        // se ho un valore di data_fine massima settato
        if( isset( $ct['etc']['datamax']) ){

            $ct['etc']['estendere'] = 0;      // parametro per il pulsante di approvazione

            // per ogni riga di attività individuata
            foreach( $ct['etc']['attivita'] as &$a ){
                if( !empty( $a['data_fine'] ) && $a['data_fine'] < $ct['etc']['datamax'] && $a['giorni_rinnovo'] > 0 ){
                    $a['estendi'] = 1;     // bisogna allungare la pianificazione
                    $ct['etc']['estendere']++;
                }

                // aggiungo il progetto all'elenco di quelli verificati
                $prog[] = $a['id_progetto'];
            }

            
            // cerco l'elenco dei progetti in cui è coinvolto quell'operatore che hanno pianificazioni attive con data fine minore di datamax
            $progetti = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT a.id_progetto, a.progetto, min( p.data_fine ) as data_fine FROM pianificazioni as p '
                .'INNER JOIN attivita_view as a ON ( p.id_todo = a.id_todo AND a.id_anagrafica = ? ) '
                .'WHERE p.data_fine < ? AND p.giorni_rinnovo > 0 '
                .'GROUP BY a.id_progetto',
                array(
                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_anagrafica'] ),
                    array( 's' => $ct['etc']['datamax'] )
                )
            );

            if( !empty($progetti ) ){
                $ct['etc']['estendere']++;

                foreach( $progetti as $p ){
                    $ct['etc']['progetti'][ $p['id_progetto'] ] = $p;

                // se il progetto non è tra quelli già individuati in precedenza, lo aggiungo all'elenco di quelli da verificare
            /*    if( !in_array( $p['id_progetto'], $prog ) ){
                    $ct['etc']['progetti'][ $p['id_progetto'] ] = $p;
                }*/
                }     
            }
            
        }

    }

    // modal per la conferma di approvazione
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'conferma', 'include' => 'inc/variazioni.form.approvazione.modal.conferma.html' )
    );

    // modal per la conferma di allungamento pianificazione singola
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'estendi', 'include' => 'inc/variazioni.form.approvazione.modal.estendi.html' )
    );

    // modal per la conferma di allungamento delle pianificazioni del progetto
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array('id' => 'estendiprogetto', 'include' => 'inc/variazioni.form.approvazione.modal.estendi.progetto.html' )
    );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    require DIR_SRC_INC_MACRO . '_default.tools.php';

