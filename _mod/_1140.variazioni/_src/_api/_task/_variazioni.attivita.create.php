<?php

    /**
     * task che può girare automaticamente o essere richiamato manualmente
     * preleva le righe di periodi_variazioni_attivita per le variazioni approvate che hanno timestamp_creazione_cartellino NULL e
     * - crea le attività sostitutive per il cartellino (ferie, permessi, ...) corrispondenti, dopo aver verificato che non esistano già
     * - setta timestamp_creazione_cartellino (la riga non dovrà più essere controllata)
     *
     *
     * può ricevere in ingresso
     * - id: id del periodo di variazione da elaborare
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

     // inizializzo l'array del risultato
	$status = array();
	
	if( !empty( $_REQUEST['id'] ) ){
		$status['id'] = $_REQUEST['id'];
        $status['info'][] = 'id passato in request';
		$p = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT pv.*, v.id_anagrafica, v.id_tipologia_inps FROM periodi_variazioni_attivita as pv '
			.'LEFT JOIN variazioni_attivita AS v ON pv.id_variazione = v.id '
			.'WHERE pv.id = ?',
			array( array( 's' => $_REQUEST['id']) )
		);
	}
	else{
		$p = mysqlSelectRow(
			$cf['mysql']['connection'],
			'SELECT pv.*, v.id_anagrafica, v.id_tipologia_inps FROM periodi_variazioni_attivita as pv '
			.'LEFT JOIN variazioni_attivita AS v ON pv.id_variazione = v.id '
			.'WHERE v.data_approvazione IS NOT NULL AND pv.timestamp_creazione_cartellino IS NULL '
			.'ORDER BY pv.timestamp_creazione_cartellino LIMIT 1'
		);
	}

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

                 #   $status['info'][] = 'mi preparo ad inserire riga di attivita id_anagrafica ' . $p['id_anagrafica'] . ' - data ' . $g['data'] . ', ore ' . $ore . ', tipologia_inps ' .  $p['id_tipologia_inps'];
					
					$tinps = mysqlSelectValue(
						$cf['mysql']['connection'],
						'SELECT nome FROM tipologie_attivita_inps WHERE id = ?',
						array( array( 's' => $p['id_tipologia_inps'] ) )
					);
					
					$nomeattivita = 'riga creata automaticamente per variazione';
					if( !empty( $tinps ) ){
						$nomeattivita .= ' ' . $tinps;
					}
					
					$nomeattivita .= ' - periodo ' . $status['id'];
					
					$status['attivita'][$g['data']]['dati'] = array(
						'id_anagrafica' => $p['id_anagrafica'],
						'data_attivita' => $g['data'],
						'ore' => $ore,
						'id_tipologia_inps' => $p['id_tipologia_inps'],
						'nome' => $nomeattivita
					);
					
					// verifico che non esistà già la riga di attività per la variazione corrente
					$att = mysqlSelectValue(
						$cf['mysql']['connection'],
						'SELECT count(id) FROM attivita WHERE id_anagrafica = ? AND data_attivita = ? AND ore = ? AND id_tipologia_inps = ?',
						array(
							array( 's' => $p['id_anagrafica'] ),
                            array( 's' => $g['data'] ),
                            array( 's' => $ore ),
                            array( 's' => $p['id_tipologia_inps'] )
						)
					);
                    
					if( empty( $att ) || $att == 0 ){
						$a = mysqlQuery(
							$cf['mysql']['connection'],
							'INSERT INTO attivita (id_anagrafica, data_attivita, ore, id_tipologia_inps, nome ) VALUES (?, ?, ?, ?, ?)',
							array(
								array( 's' => $p['id_anagrafica'] ),
								array( 's' => $g['data'] ),
								array( 's' => $ore ),
								array( 's' => $p['id_tipologia_inps'] ),
								array( 's' => $nomeattivita )
							)
						);
						
						$status['attivita'][$g['data']]['esito'] = 'creata attivita ' . $a;
					}
					else{
						$status['attivita'][$g['data']]['esito'] = 'riga di attivita presente, non la ricreo';
					}
                
                }
            }

             // inserisco una richiesta di ripopolamento delle statiche
             mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO refresh_view_statiche (entita, note, timestamp_prenotazione) VALUES( ?, ?, ? )',
                array(
                    array( 's' => 'attivita' ),
                    array( 's' => '_mod/_1140.variazioni/_src/_api/_task/_variazioni.attivita.create.php'),
                    array( 's' => time() )
                )
            );
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
		
		appendToFile( print_r( $status, true ) . PHP_EOL, 'var/log/variazioni.attivita.create/' .  date("Ym") . '.log' );
		
    }
    else{
        $status['info'][] = 'nessun periodo da elaborare';
    }
        

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
	
	#appendToFile( print_r( $status, true ) . PHP_EOL, 'var/log/variazioni.attivita.create/' .  date("Ym") . '.log' );
	
