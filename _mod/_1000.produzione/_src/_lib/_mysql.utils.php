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

    function puntiConoscenzaProgetto( $id_anagrafica, $id_progetto, $data ) {

        global $cf;
        
        $punti = 0;

        $frequenza = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count(*) FROM attivita WHERE id_progetto = ? AND id_anagrafica = ? '
            .'AND (data_programmazione between ? AND ?)',
            array(
                array( 's' => $id_progetto ),
                array( 's' => $id_anagrafica ),
                array( 's' => date('Y-m-d', strtotime( $data . '-3 months' ) ) ),
                array( 's' => $data )
            )
        );

        if( ! empty( $frequenza ) ) {
            if( $frequenza >= 100 ) {
                $punti = 100;
            } else {
                $punti = $frequenza;
            }
        }

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
            .'AND ( orari_contratti.id_giorno = ? OR orari_contratti.id_giorno IS NULL ) '
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
            $punti = 100;
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
            'INNER JOIN attivita AS a1 ON a1.id_indirizzo = t1.id '.
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
                'INNER JOIN attivita AS a1 ON a1.id_indirizzo = t1.id '.
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
                'INNER JOIN attivita AS a1 ON a1.id_indirizzo = t1.id '.
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
            'SELECT TIMESTAMP( data_programmazione, ora_inizio_programmazione) as data_ora_inizio, '
            .'TIMESTAMP( data_programmazione, SUBTIME( ora_fine_programmazione, "00:00:01") ) as data_ora_fine FROM attivita '
            .'WHERE id = ?',
            array(
                array( 's' => $id_attivita )
            )
        );

        // conteggio delle eventuali attività in collisione
        $collisioni = mysqlSelectValue(
            $cf['mysql']['connection'],
                'SELECT count(*) FROM attivita WHERE id_anagrafica = ? '
                .'AND ( ' 
                    .'( (TIMESTAMP( data_programmazione, ora_inizio_programmazione) between ? and ?) '
                    .'OR '
                    .'(TIMESTAMP( data_programmazione, SUBTIME( ora_fine_programmazione, "00:00:01" ) ) between ? and ?) ) ' 
                    .'OR '
                    .'( TIMESTAMP( data_programmazione, ora_inizio_programmazione) < ? AND TIMESTAMP( data_programmazione, ora_fine_programmazione) > ? ) '
                .')',
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
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
                .'( (TIMESTAMP( pv.data_inizio, coalesce( pv.ora_inizio, "00:00:01" ) ) between ? and ?) '
                .'OR '
                .'( TIMESTAMP( pv.data_fine, SUBTIME( coalesce( pv.ora_fine, "23:59:59" ), "00:00:01" ) ) between ? and ?) ) ' 
                .'OR '
                .'( TIMESTAMP( pv.data_inizio, coalesce( pv.ora_inizio, "00:00:01" ) ) < ? AND TIMESTAMP( pv.data_fine, coalesce( pv.ora_fine, "23:59:59" ) ) > ? ) '
                .')',
                array(
                    array( 's' => $id_anagrafica ),
                    array( 's' => $a['data_ora_inizio'] ),
                    array( 's' => $a['data_ora_fine'] ),
                    array( 's' => $a['data_ora_inizio'] ),
                    array( 's' => $a['data_ora_fine'] ),
                    array( 's' => $a['data_ora_inizio'] ),
                    array( 's' => $a['data_ora_fine'] )
                )
            );

            if( empty( $permessi ) || $permessi == 0 ){
                $copertura = 1;
            }
        }

        return $copertura;
        
    }

    // funzione che calcola l'elenco dei possibili sostituti per un'attività
    function sostitutiAttivita( $id_attivita ){

        global $cf;

        // estraggo i dati che mi occorrono per l'attività
        $a = mysqlSelectRow(
            $cf['mysql']['connection'],
            "SELECT a.id, a.id_progetto, a.data_programmazione, a.ora_inizio_programmazione, a.ora_fine_programmazione, "
            ."TIMESTAMP( a.data_programmazione, a.ora_inizio_programmazione) as data_ora_inizio, "
            ."TIMESTAMP( a.data_programmazione, SUBTIME( a.ora_fine_programmazione, '00:00:01') ) as data_ora_fine, "
            ."count( pc.id ) AS certificazioni_progetto FROM attivita as a "
            ."LEFT JOIN progetti_certificazioni as pc on a.id_progetto = pc.id_progetto "
            ."WHERE a.id = ? GROUP BY a.id",
            array(
                array( 's' => $id_attivita )
            )
        );

        // elenco degli operatori disponibili che non sono già stati analizzati
        $operatori = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT c.id_anagrafica, max(ca.se_sostituto) as se_sostituto, max(ca.se_produzione) as se_produzione, '
            .'( SELECT count(*) FROM attivita WHERE id_anagrafica = c.id_anagrafica '
                .'AND ( '
                .'( ( TIMESTAMP( data_programmazione, ora_inizio_programmazione) between ? and ? ) '
                .'OR '
                .'( TIMESTAMP( data_programmazione, SUBTIME( ora_fine_programmazione, "00:00:01" ) ) between ? and ? ) ) '
                .'OR '
                .'( TIMESTAMP( data_programmazione, ora_inizio_programmazione) < ? AND TIMESTAMP( data_programmazione, ora_fine_programmazione) > ? ) '
                .') '
            .') AS collisioni '
            .'FROM contratti AS c '
            .'LEFT JOIN __report_sostituzioni_attivita__ AS r ON c.id_anagrafica = r.id_anagrafica AND r.id_attivita = ? '
            .'LEFT JOIN anagrafica_categorie AS ac ON c.id_anagrafica = ac.id_anagrafica '
            .'LEFT JOIN categorie_anagrafica AS ca ON ac.id_categoria = ca.id '
            .'WHERE r.id IS NULL '
            .'AND ( c.data_fine_rapporto IS NULL or data_fine_rapporto >= ?) '
            .'GROUP BY c.id_anagrafica '
            .'HAVING collisioni = 0 AND se_produzione = 1'
           ,
            array(
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $a['data_ora_inizio'] ),
                array( 's' => $a['data_ora_fine'] ),
                array( 's' => $id_attivita ),
                array( 's' => $a['data_programmazione'] )
            )
        );

        if( !empty( $operatori ) ){
            foreach( $operatori as $o ){

                // se sono richieste certificazioni per il progetto, verifico che l'operatore le abbia e che siano valide alla data di programmazione dell'attività
                if( $a['certificazioni_progetto'] > 0 ){
                    $match = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT count( pc.id ) FROM progetti_certificazioni as pc INNER JOIN anagrafica_certificazioni as ac '
                        .'ON pc.id_certificazione = ac.id_certificazione '
                        .'WHERE pc.id_progetto = ? AND ac.id_anagrafica = ? AND ( ac.data_scadenza >= ? OR ac.data_scadenza IS NULL )',
                        array(
                            array( 's' => $a['id_progetto'] ),
                            array( 's' => $o['id_anagrafica'] ),
                            array( 's' => $a['data_programmazione'] )
                        )
                    );

                    // se il numero di certificazioni valide non corrisponde a quelle richieste passo ad altro operatore
                    if( $match != $a['certificazioni_progetto'] ){
                        continue;
                    }
                }
                
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


    // funzione che calcola l'elenco dei possibili sostituti per un progetto
    function sostitutiProgetto( $id_progetto ){

        global $cf;

        $candidati = array();

        // numero delle attività scoperte per il progetto corrente
        $attivita = mysqlSelectRow( 
            $cf['mysql']['connection'],
            'SELECT count(id) as num_attivita, min(data_programmazione) as dataPrima FROM attivita WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $id_progetto )
            )
        );

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

	// funzione che ritorna un array dei giorni festivi (timestamp) relativi ad un certo anno
    function getHolidays( $anno ){

        $festivi = array(
			strtotime( $anno . '-01-01' ), 	    // Capodanno
			strtotime( $anno . '-01-06' ),  	// Epifania
			easter_date( $anno ),		        // Pasqua calcolata per l'anno corrente
			strtotime( date("Y-m-d", easter_date( $anno ) ) . '+ 1 days'),	// Pasquetta calcolata per l'anno corrente
			strtotime( $anno . '-04-25' ),  	// Liberazione
			strtotime( $anno . '-05-01' ),  	// Festa Lavoratori
			strtotime( $anno . '-06-02' ),  	// Festa Repubblica
			strtotime( $anno . '-08-15' ),  	// Ferragosto
			strtotime( $anno . '-11-01' ),  	// Tutti i santi
			strtotime( $anno . '-12-08' ),  	// Immacolata
			strtotime( $anno . '-12-25' ),  	// Natale
			strtotime( $anno . '-12-26' ) 	    // Santo Stefano
		);

        return $festivi;
    }
    