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

        $result['parametri_ricevuti'] = array(
            'anagrafica' => $id_anagrafica,
            'data' => $data,
            'ora_inizio' => $ora_inizio,
            'ora_fine' => $ora_fine
        );

        if( empty( $ora_inizio ) ){
            $ora_inizio = '00:00:01';
        }

        if( empty( $ora_fine ) ){
            $ora_fine = '23:59:59';
        }

        // ricavo l'id del contratto attivo alla data indicata
        $cId = contrattoAttivo( $id_anagrafica, $data );

        $result['contratto'] = $cId;

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

        $frequenza = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count(*) FROM attivita_view WHERE id_progetto = ? AND id_anagrafica = ? '
            .'AND (data_programmazione between ? AND ?)',
            array(
                array( 's' => $id_progetto ),
                array( 's' => $id_anagrafica ),
                array( 's' => date('Y-m-d', strtotime( $data . '-3 months' ) ) ),
                array( 's' => $data )
            )
        );

        if( !empty( $frequenza ) ){
            if( $frequenza >= 100 ){
                $punti = 100;
            }
            else{
                $punti = $frequenza;
            }
        }

/*
        // verifico quante attività passate ci sono legate a questo operatore per questo progetto
        $a = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count(*) as frequenza FROM attivita_view WHERE id_anagrafica = ? AND id_progetto = ? AND data_programmazione < ?',
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $id_progetto ),
                array( 's' => $data )
            )
        );


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
*/

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
        $cBase = mysqlSelectCachedRow(
            $cf['memcache']['connection'], 
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

            $cCasa =  mysqlSelectCachedRow(
                $cf['memcache']['connection'], 
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

            $cPrima =  mysqlSelectCachedRow(
                $cf['memcache']['connection'], 
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

            $cDopo =  mysqlSelectCachedRow(
                $cf['memcache']['connection'], 
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
            /*    ."( TIMESTAMP( data_programmazione, ora_inizio_programmazione) > ? and TIMESTAMP( data_programmazione, ora_inizio_programmazione) < ? ) "
                ."OR "
                ."( TIMESTAMP( data_programmazione, ora_fine_programmazione) > ? and TIMESTAMP( data_programmazione, ora_fine_programmazione) < ? ) "
            */    
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

        if( empty( $collisioni ) || $collisioni == 0 ){

            // verifico se l'operatore non ha preso permessi o ferie in questa data/ora
            $permessi = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT count(*) FROM periodi_variazioni_attivita AS pv LEFT JOIN variazioni_attivita AS v '
                .'ON pv.id_variazione = v.id WHERE v.id_anagrafica = ? AND v.data_approvazione IS NOT NULL '
                .'AND ( '
                .'( TIMESTAMP( pv.data_inizio, coalesce( pv.ora_inizio, "00:00:01" ) ) <= ? AND TIMESTAMP( pv.data_fine, coalesce( pv.ora_fine, "23:59:59" ) ) >= ? ) '
                .'OR '
                .'( TIMESTAMP( pv.data_inizio, coalesce( pv.ora_inizio, "00:00:01" ) ) <= ? AND TIMESTAMP( pv.data_fine, coalesce( pv.ora_fine, "23:59:59" ) ) >= ? ) '
                .')',
                array(
                    array( 's' => $id_anagrafica ),
                    array( 's' => $a['data_ora_inizio'] ),
                    array( 's' => $a['data_ora_inizio'] ),
                    array( 's' => $a['data_ora_fine'] ),                   
                    array( 's' => $a['data_ora_fine'] )
                )
            );

            if( empty( $permessi ) || $permessi == 0 ){
                $copertura = 1;
            }
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

        // operatori che di base sono assegnati alle sostituzioni
        // sono esclusi quelli per cui esiste una riga nella tabella sostituzioni_attivita per l'attivita corrente      
        $sostituti = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT id AS id_anagrafica, __label__ as anagrafica, se_sostituto FROM anagrafica_view WHERE se_sostituto = 1 '
            .'AND id NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? ) ',
            array(
                array( 's' => $id_attivita )
            )
        );

        if( !empty( $sostituti ) ){
            foreach( $sostituti as $s ){
                $operatori[ $s['id_anagrafica'] ] = $s;
            } 
        }

        // elenco di 30 operatori che hanno svolto attività in passato con priorità per quelli che hanno già lavorato al progetto
        // esclusi quelli per cui esiste una riga nella tabella sostituzioni_attivita per l'attivita corrente
        $assegnati = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT a.id_anagrafica, a.anagrafica, max(ca.se_sostituto) as se_sostituto, progetti.id as esperienza FROM attivita_view AS a '
            .'LEFT JOIN anagrafica_categorie AS ac ON a.id_anagrafica = ac.id_anagrafica '
            .'LEFT JOIN categorie_anagrafica AS ca ON ac.id_categoria = ca.id '
            .'LEFT JOIN progetti ON a.id_progetto = progetti.id AND progetti.id = ? '
            #.'INNER JOIN contratti as c ON (a.id_anagrafica = c.id_anagrafica AND (c.data_fine IS NULL OR c.data_fine > ?) ) '
			.'INNER JOIN contratti as c ON (a.id_anagrafica = c.id_anagrafica AND (c.data_fine_rapporto IS NULL AND ( c.data_fine IS NULL OR c.data_fine >= ? ) ) ) '
            .'WHERE a.id_anagrafica IS NOT NULL AND a.data_programmazione < ? AND a.id_anagrafica NOT IN ( SELECT id_anagrafica FROM sostituzioni_attivita WHERE id_attivita = ? ) '
            .'GROUP BY a.id_anagrafica ORDER BY esperienza DESC LIMIT 15',
            array(
                array( 's' => $a['id_progetto'] ),
                array( 's' => $a['data_programmazione'] ),
                array( 's' => $a['data_programmazione'] ),
                array( 's' => $id_attivita )
            )
        );

        if( !empty( $assegnati ) ){
            foreach( $assegnati as $as ){
                $operatori[ $as['id_anagrafica'] ] = $as;
            }
        }

        $candidati = array();
        $op = array();      // array provvisorio

        if( !empty( $operatori ) ){
            foreach( $operatori as $k => $o ){
                
                // calcolo se può coprire l'attività
                $copertura = coperturaAttivita( $o['id_anagrafica'], $id_attivita );
                
                // se non può coprirla rimuovo l'operatore dall'array e inserisco una riga di sostituzioni_attivita come scarto
                // in modo che al prossimo giro non considererà più questo operatore
                if( $copertura == 0 ){

                    // chiamo il task che inserisce la riga di scarto
                    restcall(
                        $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_operatori.descard.php?id_anagrafica=' . $o['id_anagrafica'] . '&id_attivita=' . $id_attivita
                    );
                    unset( $operatori[$k] );
                }
                else{

                    $o['punteggio'] = 0;

                    if( $o['se_sostituto'] == 1 ){
                        $o['punti_sostituto'] = 100;
                    }
                    else{
                        $o['punti_sostituto'] = 0;
                    }

                    $o['punteggio'] += $o['punti_sostituto'];
                        
                // calcolo punteggi vari con le funzioni
                    $o['punti_progetto'] = puntiConoscenzaProgetto( $o['id_anagrafica'], $a['id_progetto'], $a['data_programmazione']);
                    $o['punti_disponibilita'] = puntiDisponibilitaOperatore( $o['id_anagrafica'], $a['data_programmazione'], $a['ora_inizio_programmazione'], $a['ora_fine_programmazione'] );
                    $o['punti_distanza'] = intval( puntiDistanzaAttivita( $o['id_anagrafica'], $a['id'] ) );
                    
                    $o['punteggio'] += $o['punti_progetto'];
                    $o['punteggio'] += $o['punti_disponibilita'];
                    $o['punteggio'] += $o['punti_distanza'];
                    
                    // TODO: prevedere parte per audit qualità e blocchi (es. il cliente non vuole quell'operatore, ecc.)

                    $op[ $o['id_anagrafica'] ] = $o;
                }

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

        return $candidati;

    }



    function sostitutiAttivita( $id_attivita ){

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

    //    print_r($a);

        // elenco degli operatori disponibili che non sono già stati analizzati
        $operatori = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT c.id_anagrafica, c.anagrafica, max(ca.se_sostituto) as se_sostituto, '
            .'( SELECT count(*) FROM attivita_view WHERE id_anagrafica = c.id_anagrafica '
                .'AND ( '
                .'( TIMESTAMP( data_programmazione, ora_inizio_programmazione) between ? and ? ) '
                .'OR '
                .'( TIMESTAMP( data_programmazione, ora_fine_programmazione) between ? and ? ) '
                .') '
            .') AS collisioni '
            .'FROM contratti_view AS c '
            .'LEFT JOIN __report_sostituzioni_attivita__ AS r ON c.id_anagrafica = r.id_anagrafica AND r.id_attivita = ? '
            .'LEFT JOIN anagrafica_categorie AS ac ON c.id_anagrafica = ac.id_anagrafica '
            .'LEFT JOIN categorie_anagrafica AS ca ON ac.id_categoria = ca.id '
            .'WHERE r.id IS NULL '
            .'GROUP BY c.id_anagrafica '
            .'HAVING collisioni = 0'
           ,
            array(
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $id_attivita )               
            )
        );

    //    echo $a['data_ora_inizio'] . ' ' . $a['data_ora_fine'];
    //    print_r($operatori);

        if( !empty( $operatori ) ){
            foreach( $operatori as $o ){
                
                // calcolo i punteggi
                $o['punteggio'] = 0;

                if( $o['se_sostituto'] == 1 ){
                    $o['punti_sostituto'] = 100;
                }
                else{
                    $o['punti_sostituto'] = 0;
                }

                $o['punteggio'] += $o['punti_sostituto'];
                    
                $o['punti_progetto'] = puntiConoscenzaProgetto( $o['id_anagrafica'], $a['id_progetto'], $a['data_programmazione']);
                $o['punti_disponibilita'] = puntiDisponibilitaOperatore( $o['id_anagrafica'], $a['data_programmazione'], $a['ora_inizio_programmazione'], $a['ora_fine_programmazione'] );
                $o['punti_distanza'] = intval( puntiDistanzaAttivita( $o['id_anagrafica'], $a['id'] ) );
                
                $o['punteggio'] += $o['punti_progetto'];
                $o['punteggio'] += $o['punti_disponibilita'];
                $o['punteggio'] += $o['punti_distanza'];

                // controllo se la persona ha preso ferie o permessi nella data attività
                $permessi = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT count(*) FROM periodi_variazioni_attivita AS pv LEFT JOIN variazioni_attivita AS v '
                    .'ON pv.id_variazione = v.id WHERE v.id_anagrafica = ? AND v.data_approvazione IS NOT NULL '
                    .'AND ( '
                    .'( TIMESTAMP( pv.data_inizio, coalesce( pv.ora_inizio, "00:00:01" ) ) <= ? AND TIMESTAMP( pv.data_fine, coalesce( pv.ora_fine, "23:59:59" ) ) >= ? ) '
                    .'OR '
                    .'( TIMESTAMP( pv.data_inizio, coalesce( pv.ora_inizio, "00:00:01" ) ) <= ? AND TIMESTAMP( pv.data_fine, coalesce( pv.ora_fine, "23:59:59" ) ) >= ? ) '
                    .')',
                    array(
                        array( 's' => $o['id_anagrafica'] ),
                        array( 's' => $a['data_ora_inizio'] ),
                        array( 's' => $a['data_ora_inizio'] ),
                        array( 's' => $a['data_ora_fine'] ),                   
                        array( 's' => $a['data_ora_fine'] )
                    )
                );
    
                // inserisco la riga nella tabella __report_sostituzioni_attivita__
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'INSERT INTO __report_sostituzioni_attivita__ (id_attivita, id_anagrafica, punteggio, punti_progetto, punti_disponibilita, punti_distanza, punti_sostituto, se_scartato) VALUES ( ?, ?, ?, ?, ?, ?, ?, ? ) '
                    .'ON DUPLICATE KEY UPDATE punteggio = VALUES( punteggio ), punti_progetto = VALUES(punti_progetto), punti_disponibilita = VALUES(punti_disponibilita), punti_distanza = VALUES(punti_distanza), punti_sostituto = VALUES(punti_sostituto)',
                    array(
                        array( 's' => $id_attivita ),
                        array( 's' => $o['id_anagrafica'] ),
                        array( 's' => $o['punteggio'] ),
                        array( 's' => $o['punti_progetto'] ),
                        array( 's' => $o['punti_disponibilita'] ),
                        array( 's' => $o['punti_distanza'] ),
                        array( 's' => $o['punti_sostituto'] ),
                        array( 's' => ( $permessi > 0) ? 1 : NULL )
                    )
                );
               
                

            } 
        }

    }





    // funzione che dato un progetto, calcola l'elenco degli operatori che possono coprirne le attività scoperte con relativo punteggio
    function elencoSostitutiProgetto( $id_progetto ){

        $logdir = 'var/log/sostitutiProgetto.log';

        appendToFile('cerco sostituti progetto ' . $id_progetto . PHP_EOL, $logdir);

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
        
        // data di pianificazione dell'ultima attività scoperta per il progetto corrente
        $dataUltima = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max(data_programmazione) FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
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

        appendToFile('sostituti ' . print_r( $sostituti, true ) . PHP_EOL, $logdir);

        timerCheck( $cf['speed'], 'inizio ricerca assegnati');

        // elenco degli operatori che hanno attivita assegnate prima della prima scopertura e non sono già stati scartati, con priorità per quelli che conoscono già il progetto
        $assegnati = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT a.id_anagrafica, a.anagrafica, max(ca.se_sostituto) as se_sostituto, progetti.id as esperienza FROM attivita_view AS a '
            .'LEFT JOIN anagrafica_categorie AS ac ON a.id_anagrafica = ac.id_anagrafica '
            .'LEFT JOIN categorie_anagrafica AS ca ON ac.id_categoria = ca.id '
            .'LEFT JOIN progetti ON a.id_progetto = progetti.id AND progetti.id = ? '
            #.'INNER JOIN contratti as c ON (a.id_anagrafica = c.id_anagrafica AND (c.data_fine IS NULL OR c.data_fine > ?) ) '
			.'INNER JOIN contratti as c ON (a.id_anagrafica = c.id_anagrafica AND (c.data_fine_rapporto IS NULL AND ( c.data_fine IS NULL OR c.data_fine >= ? ) ) ) '
            .'WHERE a.id_anagrafica IS NOT NULL AND a.data_programmazione < ? '
            .'AND a.id_anagrafica NOT IN ( SELECT id_anagrafica FROM sostituzioni_progetti WHERE id_progetto = ? AND data_scopertura = ? ) '
            .'GROUP BY a.id_anagrafica ORDER BY esperienza DESC, a.data_programmazione DESC LIMIT 15',
            array(
                array( 's' => $id_progetto ),
                array( 's' => $dataPrima ),
                array( 's' => $dataPrima ),
                array( 's' => $id_progetto ),
                array( 's' => $dataUltima )
            )
        );

        appendToFile('assegnati ' . print_r( $assegnati, true ) . PHP_EOL, $logdir);

        timerCheck( $cf['speed'], 'fine ricerca assegnati');
    
        if( !empty( $assegnati ) ){
            foreach( $assegnati as $a ){
                $operatori[ $a['id_anagrafica'] ] = $a;
            }
        }

        timerCheck( $cf['speed'], 'inizio ricerca attivita scoperte');

        // elenco delle attività scoperte per il progetto corrente
        $attivita = mysqlQuery( 
            $cf['mysql']['connection'],
            'SELECT * FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $id_progetto )
            )
        );

        timerCheck( $cf['speed'], 'fine ricerca attivita scoperte');

        timerCheck( $cf['speed'], 'inizio calcolo punteggi');

        // se ci sono operatori candidati calcolo i punteggi
        if( !empty( $operatori ) ){

            // per ciascun operatore
            foreach( $operatori as $o ){

                appendToFile('operatore ' . $o['id_anagrafica'] . ' ' . $o['anagrafica'] . PHP_EOL, $logdir);
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
                    appendToFile('attivita ' . $a['id'] . PHP_EOL, $logdir);
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

                    appendToFile('copertura ' . $copertura . PHP_EOL, $logdir);

                    #appendToFile('count_intersect ' . $copertura . PHP_EOL, $logdir);count( array_intersect( $svr, $a['range'] ) )

                    // se può coprire l'attività e non ci sono sovrapposizioni con altre fasce orarie
                    if(  $copertura == 1 && count( array_intersect( $svr, $a['range'] ) ) == 0 ){

                        $svr = array_merge( $a['range'], $svr );

                        $o['punti_attivita']++;
                        $o['punti_distanza_attivita'] += puntiDistanzaAttivita( $o['id_anagrafica'], $a['id'] );

                        // verifico se c'è già una richiesta di sostituzione per essa
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

                // se i punti attività sono ancora a 0 vuol dire che non può coprire nessuna attività
                // lo inserisco quindi nella tabella di sostituzioni come scarto
                if( $o['punti_attivita'] == 0 ){
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'INSERT IGNORE INTO sostituzioni_progetti (id_progetto, id_anagrafica, data_scopertura, data_scarto) VALUES (?, ?, ?, ?)',
                        array(
                            array( 's' => $id_progetto ),
                            array( 's' => $o['id_anagrafica'] ),
                            array( 's' => $dataUltima ),
                            array( 's' => date( 'Y-m-d') )
                        )
                    );
                }
                // se il numero di attività che può coprire è maggiore delle richieste già inviate procedo con il calcolo
                elseif( $o['punti_attivita'] > $richieste_inviate ){

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
                else{
                    // se può coprire attività ma sono giò state mandate tutte le richieste inserisco una riga nelle sostituzioni_progetti per questo gruppo di attività
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'INSERT IGNORE INTO sostituzioni_progetti (id_progetto, id_anagrafica, data_scopertura) VALUES (?, ?, ?)',
                        array(
                            array( 's' => $id_progetto ),
                            array( 's' => $o['id_anagrafica'] ),
                            array( 's' => $dataUltima )
                        )
                    );
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
            

            appendToFile('operatori dopo il calcolo' . print_r( $op, true ) . PHP_EOL, $logdir);

            foreach( $op as $o ){
                               
                while( array_key_exists( $o['punteggio'], $candidati ) ){
                    $o['punteggio']++;
                }

                $candidati[ $o['punteggio'] ] = $o;
            }
            
            krsort( $candidati );
        }

        timerCheck( $cf['speed'], 'fine calcolo punteggi');

        return $candidati;

    }


    // nuova funzione per calcolo sostituti progetto
    function sostitutiProgetto( $id_progetto ){

        $logdir = 'var/log/sostitutiProgetto.log';

        appendToFile('cerco sostituti progetto ' . $id_progetto . PHP_EOL, $logdir);

        global $cf;

        $candidati = array();

        // numero delle attività scoperte per il progetto corrente
        $attivita = mysqlSelectRow( 
            $cf['mysql']['connection'],
            'SELECT count(id) as num_attivita, min(data_programmazione) as dataPrima FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $id_progetto )
            )
        );

    //    print_r($attivita);

        // elenco degli operatori calcolati per le attività scoperte del progetto corrente
        $operatori = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT r.id_anagrafica,  count(r.id) as pta, sum(punteggio) as ptt, sum(punti_distanza) AS ptd, '
            .'max(punti_sostituto) AS pts, sum(punti_progetto) AS ptp, '
            .'coalesce(
                an.soprannome,
                an.denominazione,
                concat_ws(" ", coalesce(an.nome, ""),
                coalesce(an.cognome, "") ),
                ""
            ) AS anagrafica '
            .'FROM __report_sostituzioni_attivita__ AS r INNER JOIN attivita AS a ON r.id_attivita = a.id AND a.id_anagrafica IS NULL AND a.id_progetto = ? '
            .'AND r.se_scartato IS NULL AND r.se_convocato IS NULL '
            .'LEFT JOIN anagrafica AS an ON r.id_anagrafica = an.id '
            .'GROUP BY r.id_anagrafica '
           ,
            array(
                array( 's' => $id_progetto  )        
            )
        );

    //    print_r($operatori);
        
        // array di appoggio per il calcolo dei punteggi
        $op = array();

        foreach( $operatori as $o ){
            $o['punteggio'] = 0;    // inizializzo il punteggio
            $o['punti_sostituto'] = $o['pts'];
            $o['punti_copertura'] = intval( $o['pta'] / $attivita['num_attivita'] * 100 );
            $o['punti_distanza'] = intval( $o['ptd'] / $o['pta'] );
            $o['punti_progetto'] = puntiConoscenzaProgetto( $o['id_anagrafica'], $id_progetto, $attivita['dataPrima'] );

            $o['punteggio'] =  $o['punti_sostituto'] +  $o['punti_copertura'] +  $o['punti_distanza'] +  $o['punti_progetto'];

            $op[ $o['id_anagrafica'] ] = $o;
        }

    //    print_r($op);

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

    //    print_r($candidati);
       
        return $candidati;

    }

	