<?php

/**
 * task che popola il cartellino di un'anagrafica per mese e anno inserendo le ore fatte
 * riceve in ingresso i parametri seguenti:
 * - id_cartellino: id del cartellino da analizzare
*/

// inclusione del framework
if ( !defined('CRON_RUNNING') ) {
    require '../../../../../_src/_config.php';
}

$status = array();

if( !empty( $_REQUEST['id_cartellino'] ) ){

    $cid = $_REQUEST['id_cartellino'];

    $status['id_cartellino'] = $cid;

    #gdl
    $idT_inps_ordinario = 1;
    $idT_inps_straordinario = 2;

    /*$idT_inps_ferie = 6;
    $idT_inps_malattie = 4;
    $idT_inps_permessi = 5;
    */

    // recupero i dati del cartellino
    $righeCartellini = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT * FROM righe_cartellini WHERE id_cartellino = ? ',
                array( array( 's' => $cid ) ) );

    logWrite( 'trovate ' . count( $righeCartellini ) .' righe per il cartellino '.$cid , 'cartellini', LOG_ERR );

    $status[] = 'trovate ' . count( $righeCartellini ) .' righe per il cartellino '.$cid;

    foreach( $righeCartellini as $car ){

        logWrite( 'lavoro l\'anagrafica  ' . $car['id_anagrafica'] .' per la data '.$car['data_attivita'],' tipologia inps '.$car['id_tipologia_inps'] , 'cartellini', LOG_ERR );

        // ricavo l'id del contratto attivo alla data indicata
        $contratto = $car['id_contratto'];

        if( !empty(  $contratto ) ){
            // verifico se c'è un turno specificato nella tabella turni
            $turno = mysqlSelectValue(
                $cf['mysql']['connection'], 
                'SELECT turno FROM turni WHERE id_contratto = ? AND (data_inizio <= ? AND data_fine >= ?) ORDER BY id DESC LIMIT 1',
                array( 
                    array( 's' => $contratto ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['data_attivita'] )
                )
            );

            // se non ci sono turni, di base è attivo il turno 1
            if( empty( $turno ) ){
                $turno = 1;
            }

            $fasce = mysqlSelectRow(
                $cf['mysql']['connection'],  
                'SELECT * FROM fasce_orarie_contratti WHERE id_contratto = ? AND turno = ? AND id_giorno = ? LIMIT 1',
                array(
                    array( 's' => $contratto ),
                    array( 's' => $turno ),
                    array( 's' => ( date( 'w', strtotime($car['data_attivita']) ) == 0 ) ? '7' : date( 'w', strtotime($car['data_attivita']) ) )
                )
            );

            if( empty( $fasce ) ){
                $fasce['ora_inizio'] = '06:00:00';
                $fasce['ora_fine'] = '22:00:00';
            }

        } else {
            $fasce['ora_inizio'] = '00:00:01';
            $fasce['ora_fine'] = '23:59:59';
        }
       
        // LAVORO ORDINARIO
        // tutte le attività svolte nella fascia oraria del giorno 
        $oreOrdinarie = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT sum( TIMEDIFF( LEAST( ?, ora_fine ),GREATEST( ora_inizio, ? )  ) ) AS tot_ore FROM attivita ' .
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'WHERE tipologie_attivita.se_produzione = 1 AND data_attivita = ? AND id_anagrafica = ? GROUP by data_attivita',
            array(
                array( 's' => $fasce['ora_fine'] ),
                array( 's' => $fasce['ora_inizio'] ),
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] )
            )			
        ) / 10000 ;

        if( !empty ( $oreOrdinarie ) && $oreOrdinarie > 0 ){

            logWrite( 'il cartellino ' . $cid.' ha  '.$oreOrdinarie.' ore ordinarie lavorate tra le '.$fasce['ora_inizio'].' e le '.$fasce['ora_fine'].' per il giorno '.$car['data_attivita']  , 'cartellini', LOG_ERR );

                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'UPDATE righe_cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                array( 
                    array( 's' => str_replace(",",".",$oreOrdinarie) ), 
                    array( 's' => time() ),
                    array( 's' => $car['id'] ) )
                );

        } 

       

        // LAVORO STRAORDINARIO
        // tutte le attività svolte nella fascia oraria del giorno
        $oreStraordinarie = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT ( sum( TIMEDIFF( ?, LEAST( ora_inizio, ? )  ) ) + sum( TIMEDIFF(  GREATEST( ora_fine, ? ), ?  )  )  ) as tot_ore FROM attivita ' .
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'WHERE tipologie_attivita.se_produzione = 1 AND data_attivita = ? and id_anagrafica = ? AND (ora_inizio < ? OR ora_fine > ?) GROUP by data_attivita',
            array(
                array( 's' => $fasce['ora_inizio'] ),
                array( 's' => $fasce['ora_inizio'] ),
                array( 's' => $fasce['ora_fine'] ),
                array( 's' => $fasce['ora_fine'] ),
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] ),
                array( 's' => $fasce['ora_inizio'] ),
                array( 's' => $fasce['ora_fine'] )
            )			
        ) / 10000 ;

        if( !empty ( $oreStraordinarie ) && $oreStraordinarie > 0 ){

            if( $car['id_tipologia_inps'] == $idT_inps_ordinario ){

            $status[$car['data_attivita']]['ore_straordinarie'] = $oreStraordinarie;

            logWrite( 'il cartellino ' . $cid.' ha  '.$oreStraordinarie.' ore straordinarie lavorate ' , 'cartellini', LOG_ERR );

                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                array( 
                    array( 's' => $car['id_anagrafica'] ), 
                    array( 's' => $cid ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $idT_inps_straordinario ), // tipologia inps straordinaria
                    array( 's' => str_replace(",",".",$oreStraordinarie) ),  
                    array( 's' => time() ) ) 
                );
            }
            else{
                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'UPDATE righe_cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                array( 
                    array( 's' => str_replace(",",".",$oreOrdinarie+$oreStraordinarie) ), 
                    array( 's' => time() ),
                    array( 's' => $car['id'] ) )
                );
            }
        }
        

        // LAVORO VARIAZIONI
        // tutte le attività legate alle variazioni (permessi, malattie, ecc.)
        $oreVariazioni = mysqlQuery( 
            $cf['mysql']['connection'], 
            'SELECT id_tipologia_inps, sum( ore ) AS tot_ore FROM attivita ' .
            'WHERE id_tipologia_inps <> 1 AND data_attivita = ? and id_anagrafica = ? GROUP by id_tipologia_inps',
            array(
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] )
            )			
        );

 //       $status[$car['data_attivita']]['ore_variazioni'] = $oreVariazioni;

        if( !empty ( $oreVariazioni ) && $oreVariazioni > 0 ){

            logWrite( 'il cartellino ' . $cid. ' ha ore di variazioni ' , 'cartellini', LOG_ERR );

            foreach( $oreVariazioni as $ov ){
                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                array( 
                    array( 's' => $car['id_anagrafica'] ), 
                    array( 's' => $cid ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $ov['id_tipologia_inps'] ), // tipologia inps
                    array( 's' => str_replace(",",".",$ov['tot_ore']) ),  
                    array( 's' => time() ) ) 
                );
            }

        }

        /*
        $oreMalattia = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT sum( ore ) AS tot_ore FROM attivita ' .
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'WHERE tipologie_attivita.se_malattia = 1 AND data_attivita = ? and id_anagrafica = ? GROUP by data_attivita',
            array(
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] )
            )			
        );

        if( !empty ( $oreMalattia ) && $oreMalattia > 0 ){

            logWrite( 'il cartellino ' . $cid.' ha  '.$oreMalattia.' ore malattia ' , 'cartellini', LOG_ERR );

                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                array( 
                    array( 's' => $car['id_anagrafica'] ), 
                    array( 's' => $cid ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $idT_inps_malattie ), // tipologia inps malattia
                    array( 's' => str_replace(",",".",$oreMalattia) ),  
                    array( 's' => time() ) ) 
                );

        }

        $orePermesso = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT sum( ore ) AS tot_ore FROM attivita ' .
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'WHERE tipologie_attivita.se_permesso = 1 AND data_attivita = ? and id_anagrafica = ? GROUP by data_attivita',
            array(
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] )
            )			
        );

        if( !empty ( $orePermesso ) && $orePermesso > 0 ){

            logWrite( 'il cartellino ' . $cid.' ha  '.$orePermesso.' ore di permesso ' , 'cartellini', LOG_ERR );

                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                array( 
                    array( 's' => $car['id_anagrafica'] ), 
                    array( 's' => $cid ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $idT_inps_permessi  ), // tipologia inps permesso
                    array( 's' => str_replace(",",".",$orePermesso) ),  
                    array( 's' => time() ) ) 
                );

        }

        $oreFerie = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT sum( ore ) AS tot_ore FROM attivita ' .
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'WHERE tipologie_attivita.se_ferie = 1 AND data_attivita = ? and id_anagrafica = ? GROUP by data_attivita',
            array(
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] )
            )			
        );

        if( !empty ( $oreFerie ) && $oreFerie > 0 ){

            logWrite( 'il cartellino ' . $cid.' ha  '.$oreFerie.' ore di ferie ' , 'cartellini', LOG_ERR );

                $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                array( 
                    array( 's' => $car['id_anagrafica'] ), 
                    array( 's' => $cid ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $idT_inps_ferie ), // tipologia inps ferie
                    array( 's' => str_replace(",",".",$oreFerie) ),  
                    array( 's' => time() ) ) 
                );

        }

        */

    }
}
else{

}

// output
if( ! defined( 'CRON_RUNNING' ) ) {
    buildJson( $status );
}