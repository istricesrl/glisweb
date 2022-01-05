<?php

/**
 * task che popola il cartellino di un'anagrafica per mese e anno inserendo le ore previste da contratto
 * riceve in ingresso i parametri seguenti:
 * - id_anagrafica
 * - mese
 * - anno
 * - hard: se passato, significa che si vuole ricreare il cartellino di una specifica anagrafica. In tal caso, alla fine, viene chiamato il task cartellini.populate
*/

// inclusione del framework
if( ! defined( 'CRON_RUNNING' ) ) {
    require '../../../../../_src/_config.php';
}


// inizializzo l'array del risultato
$status = array();

if( !empty( $_REQUEST['id_anagrafica'] ) && !empty( $_REQUEST['mese'] ) && !empty( $_REQUEST['anno'] ) ){

    #gdl
    $idT_inps_ordinario = 1;
    $idT_inps_straordinario = 2;

    $id_anagrafica = $_REQUEST['id_anagrafica'];
    $mese = $_REQUEST['mese'];
    $anno = $_REQUEST['anno'];
    
    // se ricevo il parametro hard elimino e ricreo il cartellino
    if( !empty( $_REQUEST['hard'] ) ){

        $status[] = 'ricevuto hard, elimino il cartellino';

        logWrite( 'hard, elimino il cartellino per l\'anagrafica ' . $id_anagrafica . ' per mese ' . $mese . ' e anno ' . $anno, 'cartellini', LOG_ERR );
        $del = mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM cartellini WHERE id_anagrafica = ? AND mese = ? AND anno = ?',
            array(
                array( 's' => $id_anagrafica ),
                array( 's' => $mese ),
                array( 's' => $anno )
            )
        );
    }

// costruisco l'elenco giorni partendo da mese e anno
    $giorni = array();

    for( $d = 1; $d <= 31; $d++ )
    {
        $time = mktime(12, 0, 0, $mese, $d, $anno);          
        if ( date( 'm', $time ) == $mese ) {   
            $giorni[] = intval( date( 'd' , $time ) );
        }
    }

    logWrite( 'lavoro l\'anagrafica ' . $id_anagrafica , 'cartellini', LOG_ERR );

    // inserisco il cartellino
    $cartellino = mysqlQuery( $cf['mysql']['connection'], 
    'INSERT INTO cartellini ( id_anagrafica, mese, anno, timestamp_inserimento ) VALUES ( ?, ?, ?, ? )  ',
    array( 
        array( 's' => $id_anagrafica ), 
        array( 's' => $mese ),
        array( 's' => $anno ),
        array( 's' => time() ) ) 
    );

    $status[] = 'inserito il cartellino ' . $cartellino;

    if( !empty( $cartellino ) ){
        foreach( $giorni as $giorno ){

            $data = date( 'Y-m-d', strtotime("$anno-$mese-$giorno") );
            
            // numero da 1 a 7, se la funzione date restituisce 0 (domenica) setto 7 per uniformità con i giorni degli orari_contratti
            $numgiorno = ( date( 'w', strtotime("$anno-$mese-$giorno") ) == 0 ) ? '7' : date( 'w', strtotime("$anno-$mese-$giorno") );

            logWrite( 'verifico l\'anagrafica ' . $id_anagrafica.' per il  giorno  '.$data , 'cartellini', LOG_ERR );
            
            // check if contratto valido nel giorno in analisi
        /*    $contratto = mysqlSelectRow(
                $cf['mysql']['connection'], 
                'SELECT * FROM contratti WHERE id = ? AND data_inizio_rapporto <= ? AND '.
                '( data_fine_rapporto IS NULL AND ( data_fine IS NULL OR ( data_fine IS NOT NULL and data_fine >= ? ) ) )',
                array( array( 's' => $cid ), array( 's' =>  $data ), array( 's' =>  $data ) )
            );
    */
            $idCa = contrattoAttivo( $id_anagrafica, $data );
            $contratto = mysqlSelectRow(
                $cf['mysql']['connection'], 
                'SELECT * FROM contratti WHERE id = ?',
                array( array( 's' => $idCa ) )
            );  

            if( !empty( $contratto ) && isset( $contratto['id'] ) ){

                logWrite( 'il contratto ' . $idCa . ' è valido nel giorno  '.$data , 'cartellini', LOG_ERR );
                // verifico se la data corrente è nella tabella turni e ricavo il turno corrispondente
                $turno = mysqlSelectValue(
                    $cf['mysql']['connection'], 
                    'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
                    array( 
                        array( 's' => $contratto['id'] ),
                        array( 's' => $data ),
                        array( 's' => $data )
                    )
                );

                // se ci sono turni devo considerare la tabella turni e vedere se la data corrente è in essi
                if( empty( $turno ) ){
                    $turno = 1;
                }

                $orecontratto = oreGiornaliereContratto( $contratto['id_anagrafica'], $data );

                logWrite( 'il contratto ' . $contratto['id'].' per il giorno  '.$data.' prevede  '.$orecontratto .' orari attivi ' , 'cartellini', LOG_ERR );

                // genero i cartellini
                if( !empty ( $orecontratto ) ){
                        
                    $rigaCartellino = mysqlQuery( $cf['mysql']['connection'], 
                        'INSERT INTO righe_cartellini ( id_cartellino, id_contratto, id_anagrafica, data_attivita, id_tipologia_inps, ore_previste, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                        array( 
                            array( 's' => $cartellino  ),
                            array( 's' => $contratto['id'] ),
                            array( 's' => $contratto['id_anagrafica'] ), 
                            array( 's' => $data ),
                            array( 's' => $idT_inps_ordinario ), // tipologia inps ordinaria
                            array( 's' => str_replace(",",".",$orecontratto) ),  
                            array( 's' => time() ) ) 
                        );
                } else {

                    $rigaCartellino = mysqlQuery( $cf['mysql']['connection'], 
                    'INSERT INTO righe_cartellini ( id_cartellino, id_contratto, id_anagrafica, data_attivita, id_tipologia_inps, ore_previste, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                    array( 
                        array( 's' => $cartellino  ),
                        array( 's' => $contratto['id'] ),
                        array( 's' => $contratto['id_anagrafica'] ), 
                        array( 's' => $data ),
                        array( 's' => $idT_inps_straordinario ), // tipologia inps straordinaria
                        array( 's' => 0 ),  
                        array( 's' => time() ) ) 
                    );

                }


            }

        }

        if( !empty( $_REQUEST['hard'] ) ){
            // se è arrivato il parametro hard, richiamo il task cartellini.populate
            $url = $cf['site']['url'] . '_mod/_1120.cartellini/_src/_api/_task/_cartellini.populate.php?id_cartellino=' . $cartellino;

            $status['populate'] = restcall( $url );
        }
        
    }
}
else{
    $status[] = 'parametri in input mancanti';
}

// output
if( ! defined( 'CRON_RUNNING' ) ) {
    buildJson( $status );
}