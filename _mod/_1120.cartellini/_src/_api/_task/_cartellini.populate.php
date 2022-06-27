<?php

/**
 * task che popola il cartellino di un'anagrafica per mese e anno inserendo le ore fatte
 * riceve in ingresso i parametri seguenti:
 * - id_cartellino: id del cartellino da analizzare
 * 
 * logiche di calcolo:
 * - se il monte ore eseguito supera quello previsto da contratto, le ore da contratto saranno inserite come ordinarie e le ore in eccesso come straordinarie
 * - per i giorni festivi e le domeniche per le quali non è previsto il lavoro da contratto, le ore eseguite saranno inserite interamente come festive
 * - nel caso di lavoro domenicale previsto, le ore da contratto saranno inserite come ordinarie e le ore in eccesso come festive
*/

// inclusione del framework
if ( !defined('CRON_RUNNING') ) {
    require '../../../../../_src/_config.php';
}

$status = array();

if( !empty( $_REQUEST['id_cartellino'] ) ){

    $info[] = 'richiesta popolazione cartellino ' . date('d-m-Y H:i');

    $cid = $_REQUEST['id_cartellino'];

    $status['id_cartellino'] = $info['id_cartellino'] = $cid;

    $cartellino = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM cartellini WHERE id = ?',
        array( array( 's' => $cid ) )
    );
    
    // elenco delle festività per l'anno del cartellino corrente
    $festivi = getHolidays( $cartellino['anno'] );
    
    // tipologia inps da utilizzare per le ore ordinarie
    $idT_inps_ordinario = mysqlSelectValue( 
        $cf['mysql']['connection'], 
        'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
        array( array( 's' => '01') )
    );

    // tipologia inps da utilizzare per le ore straordinarie
    $idT_inps_straordinario = mysqlSelectValue( 
        $cf['mysql']['connection'], 
        'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
        array( array( 's' => 'LS') )
    );

    // tipologia inps da utilizzare per le ore lavorate nei giorni festivi
    $idT_inps_festivo = mysqlSelectValue( 
        $cf['mysql']['connection'], 
        'SELECT id FROM tipologie_attivita_inps WHERE codice = ?',
        array( array( 's' => 'LF1') )
    );  

    // recupero le righe del cartellino
    $righeCartellini = mysqlQuery(
                $cf['mysql']['connection'], 
                'SELECT * FROM righe_cartellini WHERE id_cartellino = ? ',
                array( array( 's' => $cid ) ) );

    $info[] = 'trovate ' . count( $righeCartellini ) .' righe per il cartellino '. $cid;

    foreach( $righeCartellini as $car ){

        $info['righe'][$car['id']][] =  'lavoro l\'anagrafica ' . $car['id_anagrafica'] .' per la data '.$car['data_attivita'];
   
        // ORE LAVORATE
        // tutte le attività svolte nel giorno 
        $oreLavorate = mysqlSelectValue( 
            $cf['mysql']['connection'], 
            'SELECT sum( ore ) AS tot_ore FROM attivita ' .
            'LEFT JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia '.
            'WHERE tipologie_attivita.se_produzione = 1 AND data_attivita = ? AND id_anagrafica = ?',
            array(
                array( 's' => $car['data_attivita'] ),
                array( 's' => $car['id_anagrafica'] )
            )			
        );

        $info['righe'][$car['id']][] = 'ore lavorate: ' . $oreLavorate;

        if( $oreLavorate > 0 ){
            
            // stabilisco se il giorno è una domenica
            $numgiorno = ( date( 'w', strtotime( $car['data_attivita'] ) ) == 0 ) ? '7' : date( 'w', strtotime( $car['data_attivita'] ) );

            // determino, in base al turno, se è previsto che l'operatore lavori di domenica
            $turno = mysqlSelectValue(
                $cf['mysql']['connection'], 
                'SELECT turno FROM turni WHERE id_contratto = ? AND data_inizio <= ? AND data_fine >= ? ORDER BY id DESC LIMIT 1',
                array( 
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['data_attivita'] )
                )
            );

            if( empty( $turno ) ){
                $turno = 1;
            }

            $domenica = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT count(id) FROM orari_contratti WHERE id_contratto = ? AND turno = ? AND id_giorno = 7 AND se_lavoro = 1',
                array(
                    array( 's' => $car['id_contratto'] ),
                    array( 's' => $turno )
                )
            );
            
            
            // Caso 1: giorno festivo oppure domenica con lavoro domenicale non previsto
            if( in_array( strtotime( $car['data_attivita'] ), $festivi ) || ( $numgiorno == 7 && $domenica == 0 ) ){

                $info['righe'][$car['id']][] = 'giorno festivo oppure domenica con lavoro domenicale non previsto, inserisco le ore come festive';

                $insert_festive = mysqlQuery( $cf['mysql']['connection'], 
                    'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ? )  ',
                    array( 
                        array( 's' => $car['id_anagrafica'] ), 
                        array( 's' => $cid ),
                        array( 's' => $car['data_attivita'] ),
                        array( 's' => $car['id_contratto'] ),
                        array( 's' => $idT_inps_festivo),
                        array( 's' => str_replace(",", ".", $oreLavorate )  ),  
                        array( 's' => time() ) 
                    ) 
                );
            }

            // Caso 2: domenica, con lavoro domenicale previsto
            elseif( $numgiorno == 7 ){

                $info['righe'][$car['id']][] = 'domenica, con lavoro domenicale previsto';

                if( $oreLavorate <= $car['ore_previste'] ){   
                    $info['righe'][$car['id']][] = 'non presenti ore in eccesso';
                    $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                        'UPDATE righe_cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                        array( 
                            array( 's' => str_replace(",", ".", $oreLavorate ) ), 
                            array( 's' => time() ),
                            array( 's' => $car['id'] ) 
                        )
                    );
                }
                else{
                    $info['righe'][$car['id']][] = 'presenti ore in eccesso';
                    $update_ordinarie = mysqlQuery( $cf['mysql']['connection'], 
                        'UPDATE righe_cartellini SET ore_fatte = ore_previste, timestamp_aggiornamento = ? WHERE id = ? ',
                        array( 
                            array( 's' => time() ),
                            array( 's' => $car['id'] ) 
                        )
                    );
    
                    $insert_festive = mysqlQuery( $cf['mysql']['connection'], 
                        'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ?)  ',
                        array( 
                            array( 's' => $car['id_anagrafica'] ), 
                            array( 's' => $cid ),
                            array( 's' => $car['data_attivita'] ),
                            array( 's' => $car['id_contratto'] ),
                            array( 's' => $idT_inps_festivo ), // tipologia inps festiva
                            array( 's' => str_replace(",", ".", $oreLavorate - $car['ore_previste'] ) ), 
                            array( 's' => time() ) 
                        ) 
                    );
                }

            }

            // Caso 3: giorno feriale
            else{

                $info['righe'][$car['id']][] = 'giorno feriale';
               
                if( $oreLavorate <= $car['ore_previste'] ){
                    $info['righe'][$car['id']][] = 'non presenti ore in eccesso';
                    $update_cartellino = mysqlQuery( $cf['mysql']['connection'], 
                        'UPDATE righe_cartellini SET ore_fatte = ?, timestamp_aggiornamento = ? WHERE id = ? ',
                        array( 
                            array( 's' => str_replace(",", ".", $oreLavorate ) ), 
                            array( 's' => time() ),
                            array( 's' => $car['id'] ) 
                        )
                    );
                }
                else{
                    $info['righe'][$car['id']][] = 'presenti ore in eccesso';
                    if( $car['ore_previste'] > 0 ){
                        $update_ordinarie = mysqlQuery( $cf['mysql']['connection'], 
                            'UPDATE righe_cartellini SET ore_fatte = ore_previste, timestamp_aggiornamento = ? WHERE id = ? ',
                            array( 
                                array( 's' => time() ),
                                array( 's' => $car['id'] ) 
                            )
                        );
                    }
                    
                    $insert_straordinarie = mysqlQuery( $cf['mysql']['connection'], 
                        'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ?)  ',
                        array( 
                            array( 's' => $car['id_anagrafica'] ), 
                            array( 's' => $cid ),
                            array( 's' => $car['data_attivita'] ),
                            array( 's' => $car['id_contratto'] ),
                            array( 's' => $idT_inps_straordinario ), // tipologia inps straordinaria
                            array( 's' => str_replace(",", ".", $oreLavorate - $car['ore_previste'] ) ),  
                            array( 's' => time() ) 
                        ) 
                    );
                }
            }
        }
        else{

            // se non ci sono ore lavorate verifico se ci sono variazioni (permessi, malattie, ecc.)
            $info['righe'][$car['id']][] = 'ore lavoro non presenti, verifico le variazioni';

            $variazioni = mysqlQuery( 
                $cf['mysql']['connection'], 
                'SELECT id_tipologia_inps, sum( ore ) AS tot_ore FROM attivita ' .
                'WHERE id_tipologia_inps IS NOT NULL AND id_tipologia_inps <> 1 AND data_attivita = ? and id_anagrafica = ? GROUP by id_tipologia_inps',
                array(
                    array( 's' => $car['data_attivita'] ),
                    array( 's' => $car['id_anagrafica'] )
                )			
            );

            $info['righe'][$car['id']]['variazioni'] = $variazioni;

            if( !empty ( $variazioni ) ){

                foreach( $variazioni as $ov ){
                    $insert_variazioni = mysqlQuery( $cf['mysql']['connection'], 
                    'INSERT INTO righe_cartellini ( id_anagrafica, id_cartellino, data_attivita, id_contratto, id_tipologia_inps, ore_fatte, timestamp_inserimento ) VALUES ( ?, ?, ?, ?, ?, ?, ?)  ',
                    array( 
                        array( 's' => $car['id_anagrafica'] ), 
                        array( 's' => $cid ),
                        array( 's' => $car['data_attivita'] ),
                        array( 's' => $car['id_contratto'] ),
                        array( 's' => $ov['id_tipologia_inps'] ),
                        array( 's' => str_replace(",", ".", $ov['tot_ore'] ) ),  
                        array( 's' => time() ) ) 
                    );
                }

            }
            else{
                // se non ci sono neanche variazioni setto le ore ordinarie a 0
                $update_ordinarie = mysqlQuery( $cf['mysql']['connection'], 
                    'UPDATE righe_cartellini SET ore_fatte = 0, timestamp_aggiornamento = ? WHERE id = ? ',
                    array( 
                        array( 's' => time() ),
                        array( 's' => $car['id'] ) 
                    )
                );
            }
        }

    }
    appendToFile( print_r( $info, true ), 'var/log/cartellini/' . $cartellino['anno'] . '/' . $cartellino['mese'] . '/anagrafica.' .  $cartellino['id_anagrafica'] . '.log' );
}
else{

}

// output
if( ! defined( 'CRON_RUNNING' ) ) {
    buildJson( $status );
}