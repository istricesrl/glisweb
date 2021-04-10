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


    function puntiDistanzaAttivita( $id_anagrafica, $id_attivita ) {

        // globalizzazione di $cf
        global $cf;

        // seleziono le coordinate di eventuali attività nell'ora precedente
        $cBase = mysqlSelectRow(
            $cf['mysql']['connection'], 
            'SELECT t1.latitudine, t1.longitudine, a1.data_programmazione, a1.ora_inizio_programmazione, a1.ora_fine_programmazione '.
            'FROM indirizzi AS t1 '.
            'INNER JOIN attivita_view AS a1 ON a1.id_indirizzo = t1.id '.
            'WHERE a1.id = ?',
            array(
                array( 's' => $id_attivita )
            )
        );

        // se non è possibile trovare le coordinate dell'attività base
        if( empty( $cBase ) ) {

            return 0;

        } else {

            $cCasa = mysqlSelectRow(
                $cf['mysql']['connection'], 
                'SELECT t1.latitudine, t1.longitudine '.
                'FROM indirizzi AS t1 '.
                'INNER JOIN anagrafica_indirizzi AS a1 ON a1.id_indirizzo = t1.id '.
                'INNER JOIN tipologie_indirizzi AS ti ON ti.id = a1.id_tipologia '.
                'WHERE a1.id_anagrafica = ? AND ti.se_abitazione = 1 '.
                'LIMIT 1',
                array(
                    array( 's' => $id_anagrafica )
                )
            );

            $cPrima = mysqlSelectRow(
                $cf['mysql']['connection'], 
                'SELECT t1.latitudine, t1.longitudine '.
                'FROM indirizzi AS t1 '.
                'INNER JOIN attivita_view AS a1 ON a1.id_indirizzo = t1.id '.
                'WHERE a1.id_anagrafica = ? '.
                'AND a1.data_programmazione = ? '.
                'AND a1.ora_fine_programmazione < ? '.
                'ORDER BY a1.ora_fine_programmazione DESC '.
                'LIMIT 1',
                array(
                    array( 's' => $id_anagrafica ),
                    array( 's' => $cBase['data_programmazione'] ),
                    array( 's' => $cBase['ora_inizio_programmazione'] )
                )
            );

            if( empty( $cPrima ) ) { $cPrima = $cCasa; }

            $cDopo = mysqlSelectRow(
                $cf['mysql']['connection'], 
                'SELECT t1.latitudine, t1.longitudine '.
                'FROM indirizzi AS t1 '.
                'INNER JOIN attivita_view AS a1 ON a1.id_indirizzo = t1.id '.
                'WHERE a1.id_anagrafica = ? '.
                'AND a1.data_programmazione = ? '.
                'AND a1.ora_inizio_programmazione > ? '.
                'ORDER BY a1.ora_inizio_programmazione ASC '.
                'LIMIT 1',
                array(
                    array( 's' => $id_anagrafica ),
                    array( 's' => $cBase['data_programmazione'] ),
                    array( 's' => $cBase['ora_fine_programmazione'] )
                )
            );

            if( empty( $cDopo ) ) { $cDopo = $cCasa; }

            if( empty( $cPrima ) || empty( $cDopo ) ) {

                return 0;

            } else {

                // calcolo le distanze
                $dPrima = getCoordsDistance(
                    $cBase['latitudine'], $cBase['longitudine'],
                    $cPrima['latitudine'], $cPrima['longitudine']
                );

                $dDopo = getCoordsDistance(
                    $cBase['latitudine'], $cBase['longitudine'],
                    $cDopo['latitudine'], $cDopo['longitudine']
                );

                // calcolo il punteggio
                $punti = 100 - ( $dPrima + $dDopo );
            
                // return
                return ( $punti > 0 ) ? $punti : 0;

            }

        }

    }


     // funzione che verifica se un operatore può essere chiamato a coprire un'attività
     function coperturaAttivita( $id_anagrafica, $id_attivita ){

        global $cf;

        $copertura = 0;

        // estraggo i dati che mi occorrono per l'attività
        $a = mysqlSelectRow(
            $cf['mysql']['connection'],
            "SELECT TIMESTAMP( data_programmazione, ora_inizio_programmazione) as data_ora_inizio, "
            ."TIMESTAMP( data_programmazione, ora_fine_programmazione) as data_ora_fine FROM attivita_view "
            ."WHERE id = ?",
            array(
                array( 's' => $id_attivita )
            )
        );

        // conteggio delle eventuali attività in collisione
        $collisioni = mysqlSelectValue(
            $cf['mysql']['connection'],
                "SELECT count(*) FROM attivita_view WHERE id_anagrafica = ? "
                ."AND ( "
                    ."(TIMESTAMP( data_programmazione, ora_inizio_programmazione) between ? and ?) "
                    ."OR "
                    ."(TIMESTAMP( data_programmazione, ora_fine_programmazione) between ? and ?) "
                .") ",
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] )
            )
        );

        if( empty( $collisioni ) || $collisioni = 0 ){
            $copertura = 1;
        }

        return $copertura;
        
    }

    // funzione che data un'attività, ritorna l'elenco degli operatori che possono coprirla per una sostituzione con relativo punteggio
    function elencoSostitutiAttivita( $id_attivita ){

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

        // escludere le anagrafiche per cui esiste una riga nella tabella sostituzioni_attivita per l'attivita corrente

        // select che estrae i dati dall'anagrafica_view, sostituita con quella che estrae da contratti_view
    /*    "SELECT id, __label__ FROM anagrafica_view WHERE se_collaboratore = 1 "
        ."AND id NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? ) "
        ."AND ( "
            ."SELECT count(*) FROM attivita_view WHERE id_anagrafica = anagrafica_view.id "
            ."AND ( "
                ."(TIMESTAMP( data_programmazione, ora_inizio_programmazione) between ? and ?) "
                ."OR "
                ."(TIMESTAMP( data_programmazione, ora_fine_programmazione) between ? and ?) "
            .") "
        .") = 0 ",
    */

        
        $operatori = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT id_anagrafica AS id, anagrafica AS __label__ FROM contratti_view WHERE "
            ."id_anagrafica NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? ) "
            ."AND ( "
                ."SELECT count(*) FROM attivita_view WHERE id_anagrafica = contratti_view.id_anagrafica "
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
        $op = array();      // array provvisorio

        foreach( $operatori as $o ){
                   
        // calcolo punteggi vari con le funzioni
            $o['punti_progetto'] = puntiConoscenzaProgetto( $o['id'], $a['id_progetto'], $a['data_programmazione']);
            $o['punti_disponibilita'] = puntiDisponibilitaOperatore( $o['id'], $a['data_programmazione'], $a['ora_inizio_programmazione'], $a['ora_fine_programmazione'] );
            $o['punti_distanza'] = intval( puntiDistanzaAttivita( $o['id'], $a['id'] ) );
            
            $o['punteggio'] = $o['punti_progetto'];
            $o['punteggio'] += $o['punti_disponibilita'];
            $o['punteggio'] += $o['punti_distanza'];
            
            // TODO: prevedere parte per audit qualità e blocchi (es. il cliente non vuole quell'operatore, ecc.)

            $op[ $o['id'] ] = $o;

        }


        // riordino l'array degli operatori in base al punteggio
        $sort_data = array();
        foreach( $op as $key => $value ) {
            $sort_data[ $key ] = $value['punteggio'];
        }

        if( isset( $sort_data ) ){
            array_multisort( $sort_data, $op );
        }

        foreach( $op as $o ){
            while( array_key_exists( $o['punteggio'], $candidati ) ){
                $o['punteggio']++;
            }

            $candidati[ $o['punteggio'] ] = $o;
        }

        krsort( $candidati );

        return $candidati;

    }


    // funzione che dato un progetto, ritorna l'elenco degli operatori che possono coprirne le attività scoperte con relativo punteggio
    function elencoSostitutiProgetto( $id_progetto ){

        global $cf;

        $candidati = array();   // inizializzo l'array del risultato
        $op = array();      // array provvisorio per l'ordinamento

        // data di pianificazione della prima attività scoperta per il progetto corrente
        $dataPrima = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT min(data_programmazione) FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $id_progetto )
            )
        );

        // operatori che di base sono assegnati alle sostituzioni
        $sostituti = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT id AS id_anagrafica, __label__ as anagrafica, se_sostituto FROM anagrafica_view WHERE se_sostituto = 1'
        );

        if( !empty( $sostituti ) ){
            foreach( $sostituti as $s ){
                $operatori[ $s['id_anagrafica'] ] = $s;
            } 
        }
       

        // elenco degli operatori che hanno attivita assegnate pianificate per questo progetto prima di questa data (quindi che lo conoscono)
        $assegnati = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT a.id_anagrafica, a.anagrafica, ca.se_sostituto FROM attivita_view AS a '
            .'LEFT JOIN anagrafica_categorie AS ac ON a.id_anagrafica = ac.id_anagrafica '
            .'LEFT JOIN categorie_anagrafica AS ca ON ac.id_categoria = ca.id '
            .'WHERE id_progetto = ? AND data_programmazione < ? AND a.id_anagrafica IS NOT NULL GROUP BY a.id_anagrafica ',
            array(
                array( 's' => $id_progetto ),
                array( 's' => $dataPrima )
            )
        );

        if( !empty( $assegnati ) ){
            foreach( $assegnati as $a ){
                $operatori[ $a['id_anagrafica'] ] = $a;
            }
        }


        // elenco delle attività scoperte per il progetto corrente
        $attivita = mysqlQuery( 
            $cf['mysql']['connection'],
            'SELECT * FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $id_progetto )
            )
        );

        // se ci sono operatori candidati calcolo i punteggi
        if( !empty( $operatori ) ){

            // per ciascun operatore
            foreach( $operatori as $o ){
                // scorro le attività e vedo se può coprirle

                $o['punteggio'] = 0;
                $o['punti_distanza'] = 0;
                $o['punti_attivita'] = 0;
                $o['punti_distanza_attivita'] = 0;

                if( $o['se_sostituto'] == 1 ){
                    $o['punti_sostituto'] = 100;
                }
                else{
                    $o['punti_sostituto'] = 0;
                }

                $o['punteggio'] += $o['punti_sostituto'];

                $attivita_coperte = 0;
                $richieste_inviate = 0;

                $svr = array();     //

                foreach( $attivita as $a ){
                    //14:00-15:45 2021-04-07 > ragionare a intervalli di 15 minuti, no ora inizio
                //    $a['range'] = array( '202104071430', '202104071500', '202104071530', '202104071600');

                    $inizio = strtotime( $a['ora_inizio_programmazione'] );
                    $fine = strtotime( $a['ora_fine_programmazione'] );
                    $a['range'] = array();
                    $step = $inizio;
                
                    while( $step >= $inizio && $step <= $fine ){
                    $step = strtotime("+15 minutes", $step);
                    $a['range'][] = str_replace('-', '', $a['data_programmazione'] ) . str_replace(':', '', date('H:i', $step) );
                    }

                    $copertura = coperturaAttivita( $o['id_anagrafica'], $a['id'] );

                    // se può coprire l'attività e non ci sono sovrapposizioni con altre fasce orarie
                    // verifico se c'è già una richiesta di sostituzione per essa
                    // in tal caso escludo l'attività, altrimenti procedo con il calcolo dei punti distanza
                    if(  $copertura == 1 && count( array_intersect( $svr, $a['range'] ) ) == 0 ){

                        $svr = array_merge( $a['range'], $svr );

                        $o['punti_attivita']++;
                        $o['punti_distanza_attivita'] += puntiDistanzaAttivita( $o['id_anagrafica'], $a['id'] );

                        $richieste = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT count(*) FROM sostituzioni_attivita WHERE id_attivita = ? '
                            .'AND id_anagrafica = ?',
                            array(
                                array( 's' => $a['id'] ),
                                array( 's' => $o['id_anagrafica'] )
                            )
                        );

                        if( !empty( $richieste ) ){
                        $richieste_inviate++;
                        }
                        
                    }
                }

                // solo se il numero di attività che può coprire è maggiore delle richieste già inviate procedo
                if( $o['punti_attivita'] > $richieste_inviate ){

                    // punti copertura: numero attività copribili /numero attività da coprire
                    $o['punti_copertura'] = intval( $o['punti_attivita'] / count( $attivita ) * 100 );
                    $o['punteggio'] +=  $o['punti_copertura'];
                    
                    // punti distanza
                    if( $o['punti_attivita'] > 0 && $o['punti_distanza_attivita'] > 0 ){
                        $o['punti_distanza'] = intval( $o['punti_distanza_attivita'] / $o['punti_attivita'] );
                        $o['punteggio'] += $o['punti_distanza'];
                    }         

                    // punti conoscenza del progetto
                    $o['punti_progetto'] = puntiConoscenzaProgetto( $o['id_anagrafica'], $id_progetto, $dataPrima );
                    $o['punteggio'] += $o['punti_progetto'];

                
                    $op[ $o['id_anagrafica'] ] = $o;
                }     
            
            }

            // riordino l'array degli operatori in base al punteggio
            $sort_data = array();
            foreach( $op as $key => $value ) {
                $sort_data[ $key ] = $value['punteggio'];
            }

            if( isset( $sort_data ) ){
                array_multisort( $sort_data, $op );
            }

            foreach( $op as $o ){
                while( array_key_exists( $o['punteggio'], $candidati ) ){
                    $o['punteggio']++;
                }

                $candidati[ $o['punteggio'] ] = $o;
            }
            
            krsort( $candidati );
        }

        return $candidati;

    }

