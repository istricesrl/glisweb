<?php

    // funzione che riceve in ingresso un id_anagrafica e una data e restituisce l'id del contratto attivo corrispondente
    function contrattoAttivo( $id_anagrafica, $data ){
        
        global $cf;

        // ricavo l'id del contratto attivo alla data indicata
        $c = mysqlSelectValue(
            $cf['mysql']['connection'], 
            'SELECT id FROM contratti WHERE id_anagrafica = ? AND data_inizio <= ? AND  ( '.
            'data_fine_rapporto >= ? OR ( data_fine_rapporto IS NULL AND ( data_fine IS NULL or data_fine >= ? )  ) ' .
            ') ORDER BY id DESC LIMIT 1',
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $data ),
                array( 's' => $data ),
                array( 's' => $data )
            )
        );

        return $c;

    }

    // funzione che restituisce il monte ore previsto da contratto per l'anagrafica corrente in una certa data e fascia oraria
    // NOTA: le ore considerate sono quelle di quadratura
    function oreGiornaliereContratto( $id_anagrafica, $data, $ora_inizio = '00:00:01', $ora_fine = '23:59:59' ){

        global $cf;

        $result = array();

        // ricavo l'id del contratto attivo alla data indicata
        $cId = contrattoAttivo( $id_anagrafica, $data );

        // se ho un contratto attivo
        if( !empty( $cId ) ){
            
            $result['contratto'] = $cId;

            // verifico se c'è un turno specificato nella tabella turni
            $turno = mysqlSelectValue(
                $cf['mysql']['connection'], 
                'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
                array( 
                    array( 's' => $cId ),
                    array( 's' => $data ),
                    array( 's' => $data )
                )
            );
        
            // se non ci sono turni, di base è attivo il turno 1
            if( empty( $turno ) ){
                $turno = 1;
            }

            $result['turno'] = $turno;
            $result['ora_inizio'] = $ora_inizio;
            $result['ora_fine'] = $ora_fine;

            // numero del giorno da confrontare con gli orari contratti (1: lunedi -> 7: domenica)
            $giorno = ( date( 'w', strtotime( $data ) ) == 0 ) ? '7' : date( 'w', strtotime( $data ) );

            $result['giorno'] = $giorno;

            $ore = mysqlSelectValue(
                $cf['mysql']['connection'], 
                'SELECT sum( time_to_sec( timediff( LEAST( ora_fine, ? ), GREATEST( ora_inizio, ? ) ) ) / 3600 ) as tot_ore FROM orari_contratti '
                .'INNER JOIN costi_contratti ON orari_contratti.id_costo = costi_contratti.id '
                .'INNER JOIN tipologie_attivita_inps ON costi_contratti.id_tipologia = tipologie_attivita_inps.id '
                .'WHERE tipologie_attivita_inps.se_quadratura = 1 AND orari_contratti.se_lavoro = 1 '
                .'AND orari_contratti.id_giorno = ? '
                .'AND orari_contratti.id_contratto = ? AND orari_contratti.turno = ? '
                .'AND (orari_contratti.ora_inizio between ? and ? '
                .'OR orari_contratti.ora_fine between ? and ? ) ',
                array(
                    array( 's' => $ora_fine ),
                    array( 's' => $ora_inizio ),
                    array( 's' => $giorno ),
                    array( 's' => $cId ),
                    array( 's' => $turno ),
                    array( 's' => $ora_inizio ),
                    array( 's' => $ora_fine ),
                    array( 's' => $ora_inizio ),
                    array( 's' => $ora_fine )
                )
            );

        }

        if( empty( $ore ) ){
            $ore = 0;
        }

        $result['ore'] = round( $ore, 2);
       
    //    return $result;       
        return round( $ore, 2);
       
    }


    // funzione che verifica se un operatore ha già lavorato ad un dato progetto prima di una certa data e restituisce un punteggio

    function puntiConoscenzaProgetto( $id_anagrafica, $id_progetto, $data ){

        global $cf;
        
        $punti = 0;

        // verifico se ci sono attività passate legate a questo operatore per questo progetto, estraendo la data di ultima attività eventualmente svolta
        $a = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max(data_programmazione) FROM attivita_view WHERE id_anagrafica = ? AND id_progetto = ? AND data_programmazione < ?',
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $id_progetto ),
                array( 's' => $data )
            )
        );

        $result['ultima_attivita'] = $a;

        if( !empty( $a ) ){
            // inizializzo il punteggio a 100
            $punti = 100;

            // calcolo il numero di settimane passate tra la data di ultima attività e la data dell'attività da svolgere
            $lw = date('W', strtotime( $a ) );
            $cw = date('W', strtotime( $data ) );

            $result['settimana_ultima_attivita'] = $lw;
            $result['settimana_attivita_corrente'] = $cw;

            // sottraggo 1 punto per ogni settimana passata tra l'ultima attività e quella da effettuare
            $punti -= ($cw - $lw);
  
       }
        
    //   $result['punti'] = $punti;
    //  return $result;
    
        return $punti;
    }


    /* funzione che verifica se un operatore da contratto è disponibile in una certa data/fascia oraria e restituisce:
        - 50 punti se sì
        - 0 punti se no
    */
    function puntiDisponibilitaOperatore( $id_anagrafica, $data, $ora_inizio = '00:00:01', $ora_fine = '23:59:59' ){

        $punti = 0;
        
        global $cf;

        // calcolo l'id del contratto attivo in quella data
        $cId = contrattoAttivo(  $id_anagrafica, $data );

        $result['contratto'] = $cId;

        // numero del giorno da confrontare con gli orari contratti (1: lunedi -> 7: domenica)
        $giorno = ( date( 'w', strtotime( $data ) ) == 0 ) ? '7' : date( 'w', strtotime( $data ) );

        $result['giorno'] = $giorno;

        $disponibile = mysqlSelectValue(
            $cf['mysql']['connection'], 
            'SELECT count(*) FROM orari_contratti '
            .'WHERE orari_contratti.se_disponibile = 1 '
            .'AND orari_contratti.id_contratto = ? '
            .'AND orari_contratti.id_giorno = ? '
            .'AND orari_contratti.ora_inizio <= ? AND orari_contratti.ora_fine >= ? ',
            array(
                array( 's' => $cId ),
                array( 's' => $giorno ),
                array( 's' => $ora_inizio ),
                array( 's' => $ora_fine )
            )
        );

        $result['disponibile'] = $disponibile;

        if( $disponibile > 0 ){
            $punti = 50;
        }

        //return $result;
        return $punti;

    }

    function puntiDistanzaAttivita( $id_anagrafica, $id_attivita ){

    }

    function puntiDistanzaProgetto( $id_anagrafica, $id_progetto ){

    }

    // funzione che data un'attività, ritorna l'elenco degli operatori che possono coprirla per una sostituzione con relativo punteggio
    function elencoSostituti( $id_attivita ){

        global $cf;

        // estraggo i dati che mi occorrono per l'attività
        $a = mysqlSelectRow(
            $cf['mysql']['connection'],
            "SELECT id, id_progetto, data_programmazione, ora_inizio_programmazione, ora_fine_programmazione, TIMESTAMP( data_programmazione, ora_inizio_programmazione) as data_ora_inizio, "
            ."TIMESTAMP( data_programmazione, ora_fine_programmazione) as data_ora_fine FROM attivita_view "
            ."WHERE id = ?",
            array(
                array( 's' => $id_attivita )
            )
        );

        // TODO silvia: questa parte che calcola operatori e punteggio metterla in una funzione e richiamarla per ogni attività del progetto nella macro _progetti.scoperti.form.php
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
                array( 's' => $id_attivita ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] )
            )
        );

        $candidati = array();

        foreach( $operatori as $o ){
                   
        // calcolo punteggi vari con le funzioni
            $o['punti_progetto'] = puntiConoscenzaProgetto( $o['id'], $a['id_progetto'], $a['data_programmazione']);
            $o['punti_disponibilita'] = puntiDisponibilitaOperatore( $o['id'], $a['data_programmazione'], $a['ora_inizio_programmazione'], $a['ora_fine_programmazione'] );
            $o['punti_distanza'] = puntiDistanzaAttivita( $o['id'], $a['id'] );
            
            $o['punteggio'] = $o['punti_progetto'];
            $o['punteggio'] += $o['punti_disponibilita'];
            $o['punteggio'] -= $o['punti_distanza'];
            
            // TODO: prevedere parte per audit qualità e blocchi (es. il cliente non vuole quell'operatore, ecc.)

            while( array_key_exists( $o['punteggio'], $candidati ) ){
                $o['punteggio']++;
            }
    
            $candidati[ $o['punteggio'] ] = $o;


            // per cantiere la funzione che calcola la disponibilità deve restituire la percentuale 
            // rapporto tra numero di attività che può coprire e numero attività totali
    /*        $o['punteggio'] = puntiConoscenzaProgetto();   stessa delle attività ma passando la data della prima attivita scoperta
            $o['punteggio'] += puntiCoperturaProgetto();  // funzione da creare per me > solo per il cantiere: numero attività che può coprire
            $o['punteggio'] -= puntiDistanzaProgetto( anagrafica, progetto );  // passare 
    */

        }

    //    ksort( $ct['etc']['operatori'], SORT_ASC|SORT_NUMERIC );
          krsort( $candidati );

          return $candidati;

    }