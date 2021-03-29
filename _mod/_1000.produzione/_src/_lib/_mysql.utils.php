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
        // 100 punti se conosce già il progetto, 0 altrimenti

        global $cf;
        
        $punti = 0;

        // verifico se ci sono attività passate legate a questo operatore
        $a = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT count(*) AS attivita_precedenti FROM attivita WHERE id_anagrafica = ? AND id_progetto = ? AND data_attivita < ?',
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $id_progetto ),
                array( 's' => $data )
            )
        );

        if( $a > 0 ){
            $punti = 100;
        }

        return $punti;
    }

