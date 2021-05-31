<?php

    /**
     * task che gira, preleva le righe di periodi_variazioni_attivita per le variazioni approvate che hanno timestamp_creazione_cartellino NULL e
     * - crea le attività sostitutive per il cartellino (ferie, permessi, ...) corrispondenti
     * - setta timestamp_creazione_cartellino (la riga non dovrà più essere controllata)
     *
     *
     * @todo commentare
     * @todo usare le funzioni di ACL per verificare se l'azione è autorizzata
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

     // inizializzo l'array del risultato
	$status = array();
	
	$cf['cron']['cache']['view']['static']['refresh'][] = 'attivita_view_static';

    $p = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT pv.*, v.id_anagrafica, v.id_tipologia_inps FROM periodi_variazioni_attivita as pv '
        .'LEFT JOIN variazioni_attivita AS v ON pv.id_variazione = v.id '
        .'WHERE v.data_approvazione IS NOT NULL AND pv.timestamp_creazione_cartellino IS NULL '
        .'ORDER BY pv.timestamp_creazione_cartellino LIMIT 1'
    );

    // se ho una riga da elaborare
    if( !empty( $p ) ){

        $status['id'] = $p['id'];

        // array delle giornate per cui creare le attività
        $giornate = array();

        // se data inizio e fine coincidono
        if( $p['data_inizio'] == $p['data_fine'] ){
            $giornate[] = array(
                'data' => $p['data_inizio'],
                'ora_inizio' => $p['ora_inizio'],
                'ora_fine' => $p['ora_fine']
            );
        }
        elseif( $p['data_inizio'] < $p['data_fine'] ){
            // aggiungo la data inizio
            $giornate[] = array(
                'data' => $p['data_inizio'],
                'ora_inizio' => $p['ora_inizio'],
                'ora_fine' => NULL
            );

            // estraggo le date comprese
            $gg = date_diff( date_create( $p['data_inizio'] ),date_create( $p['data_fine'] ) )->format("%R%a");

            for( $i = 1; $i < $gg ; $i++ ){
                $giornate[] = array(
                    'data' => date( 'Y-m-d', strtotime( $p['data_inizio'].' + '.$i.' days ' ) ),
                    'ora_inizio' => NULL,
                    'ora_fine' => NULL
                );
            }

            // aggiungo la data fine
            $giornate[] = array(
                'data' => $p['data_fine'],
                'ora_inizio' => NULL,
                'ora_fine' => $p['ora_fine']
            );
        }

        if( !empty( $giornate ) ){
            foreach( $giornate as $g ){
                
                $ore = oreGiornaliereContratto( $p['id_anagrafica'], $g['data'], $g['ora_inizio'], $g['ora_fine'] );

                $status['date'][] = 'data ' . $g['data'] . ', ore ' . $ore;
            
                if( $ore > 0 ){

                    $status['info'][] = 'inserisco riga di attivita id_anagrafica ' . $p['id_anagrafica'] . ' - data ' . $g['data'] . ', ore ' . $ore . ', tipologia_inps ' .  $p['id_tipologia_inps'];
                    
                    $a = mysqlQuery(
                        $cf['mysql']['connection'],
                        'INSERT INTO attivita (id_anagrafica, data_attivita, ore, id_tipologia_inps) VALUES (?, ?, ?, ?)',
                        array(
                            array( 's' => $p['id_anagrafica'] ),
                            array( 's' => $g['data'] ),
                            array( 's' => $ore ),
                            array( 's' => $p['id_tipologia_inps'] )
                        )
                    );
                
                }
            }
        }

        // setto la riga come elaborata
        $u = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE periodi_variazioni_attivita SET timestamp_creazione_cartellino = ? WHERE id = ?',
            array(
                array( 's' => time() ),
                array( 's' => $p['id'] )
            )
        );

        $status['info'][] = 'settaggio riga come elaborata ' . $u;
		
    }
    else{
        $status['info'][] = 'nessun periodo da elaborare';
    }
        

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
