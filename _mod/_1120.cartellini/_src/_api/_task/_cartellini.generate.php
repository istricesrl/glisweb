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

    $info[] = 'richiesta generazione cartellino ' . date('d-m-Y H:i');

    $idT_inps_ordinario = mysqlSelectValue( 
        $cf['mysql']['connection'], 
        'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
        array( array( 's' => '01') )
    );

    $id_anagrafica = $_REQUEST['id_anagrafica'];
    $mese = $_REQUEST['mese'];
    $anno = $_REQUEST['anno'];
    
    // se ricevo il parametro hard elimino e ricreo il cartellino
    if( !empty( $_REQUEST['hard'] ) ){

        $info[] = 'hard, elimino il cartellino e relativo log per l\'anagrafica ' . $id_anagrafica . ' per mese ' . $mese . ' e anno ' . $anno;

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

    $info[] =  'lavoro l\'anagrafica ' . $id_anagrafica;

    // inserisco il cartellino
    $cartellino = mysqlQuery( $cf['mysql']['connection'], 
    'INSERT INTO cartellini ( id_anagrafica, mese, anno, timestamp_inserimento ) VALUES ( ?, ?, ?, ? )  ',
    array( 
        array( 's' => $id_anagrafica ), 
        array( 's' => $mese ),
        array( 's' => $anno ),
        array( 's' => time() ) ) 
    );

    $info[] = 'inserito il cartellino ' . $cartellino;

    if( !empty( $cartellino ) ){
        foreach( $giorni as $giorno ){

            $data = date( 'Y-m-d', strtotime("$anno-$mese-$giorno") );
            
            // numero da 1 a 7, se la funzione date restituisce 0 (domenica) setto 7 per uniformità con i giorni degli orari_contratti
            $numgiorno = ( date( 'w', strtotime("$anno-$mese-$giorno") ) == 0 ) ? '7' : date( 'w', strtotime("$anno-$mese-$giorno") );

            $info['giorni'][$giorno][] = 'verifico l\'anagrafica ' . $id_anagrafica.' per il  giorno  '. $data;
            
            // cerco il contratto attivo nel giorno in analisi
            $idCa = contrattoAttivo( $id_anagrafica, $data );

            $contratto = mysqlSelectRow(
                $cf['mysql']['connection'], 
                'SELECT * FROM contratti WHERE id = ?',
                array( array( 's' => $idCa ) )
            );  

            if( !empty( $contratto ) && isset( $contratto['id'] ) ){

                $info['giorni'][$giorno][] =  'il contratto ' . $idCa . ' è valido nel giorno  '.$data ;
                
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

                $info['giorni'][$giorno][] = 'il contratto ' . $contratto['id'].' per il giorno  '.$data.' prevede '. $orecontratto .' ore lavoro';

                // genero la riga di cartellino con le ore da contratto previste
                $rigaCartellino = mysqlQuery( $cf['mysql']['connection'], 
                    'INSERT INTO righe_cartellini ( id_cartellino, id_contratto, id_anagrafica, data_attivita, id_tipologia_inps, ore_previste, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                    array( 
                        array( 's' => $cartellino  ),
                        array( 's' => $contratto['id'] ),
                        array( 's' => $contratto['id_anagrafica'] ), 
                        array( 's' => $data ),
                        array( 's' => $idT_inps_ordinario ), // tipologia inps ordinaria
                        array( 's' => str_replace(",",".",$orecontratto) ),  
                        array( 's' => time() ) 
                    ) 
                );
            }
            else{
                $info['giorni'][$giorno][] =  'nessun contratto attivo nel giorno  '.$data ;
            }

        }

        writeToFile( print_r( $info, true ), 'var/log/cartellini/' . $_REQUEST['anno'] . '/' . $_REQUEST['mese'] . '/anagrafica.' .  $_REQUEST['id_anagrafica'] . '.log' );

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

