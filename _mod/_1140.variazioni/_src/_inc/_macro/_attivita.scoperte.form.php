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
    
    if( !empty( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $a = mysqlSelectRow(
            $cf['mysql']['connection'],
            "SELECT id_progetto, data_programmazione, TIMESTAMP( data_programmazione, ora_inizio_programmazione) as data_ora_inizio, "
            ."TIMESTAMP( data_programmazione, ora_fine_programmazione) as data_ora_fine FROM attivita_view "
            ."WHERE id = ?",
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );

 
        $operatori = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 "
            ."AND id NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? ) "
            ."AND ( "
                ."SELECT count(*) FROM attivita_view WHERE id_anagrafica = anagrafica_view.id "
                ."AND ( "
                    ."(TIMESTAMP( data_programmazione, ora_inizio_programmazione) between ? and ?) "
                    ."OR "
                    ."(TIMESTAMP( data_programmazione, ora_fine_programmazione) between ? and ?) "
                .") "
            .") = 0 ",
            array(
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] )
            )
        );

        $ct['etc']['operatori'] = array();

        foreach( $operatori as $o ){
        #    $ct['etc']['operatori'][ $o['id'] ] = $o;
  
            // calcolo punteggi vari con le funzioni
            $o['punteggio'] = puntiConoscenzaProgetto( $o['id'], $a['id_progetto'], $a['data_programmazione']);   // funzione da creare per Fabio
    #        $o['punteggio'] += puntiDisponibilitaOperatore();  // funzione da creare per me > solo per l'attività
    #        $o['punteggio'] -= puntiDistanzaProgetto();  // funzione da creare per Fabio
            
            // TODO: prevedere parte per audit qualità

            echo "operatore: " . $o['id'] . "-" . $o['__label__'] . " punteggio: " . $o['punteggio'] . "<br>";

/*          while( !array_key_exists( $o['punteggio'], $ct['etc']['operatori'] ) ){
                $o['punteggio']++;
            }
    
            $ct['etc']['operatori'][ $o['punteggio'] ] = $o;
*/

            // per cantiere la funzione che calcola la disponibilità deve restituire la percentuale 
            // rapporto tra numero di attività che può coprire e numero attività totali
    /*        $o['punteggio'] = puntiConoscenzaProgetto();   // funzione da creare per Fabio
            $o['punteggio'] += puntiCoperturaProgetto();  // funzione da creare per me > solo per il cantiere: numero attività che può coprire
            $o['punteggio'] -= puntiDistanzaProgetto();  // funzione da creare per Fabio
    */


        }

        ksort( $ct['etc']['operatori'], SORT_DESC|SORT_NUMERIC );

    //   print_r( $ct['etc']['operatori'] );
    // print_r(  $operatori );
    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';


   