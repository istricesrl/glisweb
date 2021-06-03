<?php

    /**
     * task che legge le pianificazioni che hanno il flag se_pulire a 1, pulisce gli eventi ed eventualmente li ripopola
     * 
     *
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

    if( ! empty( $_REQUEST['id'] ) ) {
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM pianificazioni WHERE id = ?',
            array( array( 's' => $_REQUEST['id'] ) )
        );
    }
    else{
        $p = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM pianificazioni WHERE data_inizio_pulizia IS NOT NULL ORDER BY data_inizio_pulizia LIMIT 1'
        );
    }

    // se ho una riga da elaborare
    if( !empty( $p ) ){
		
	#	appendToFile( date('d-m-Y H:i') . ' check pianificazione ' . $p['id'] . PHP_EOL, 'var/log/pianificazioni.check.log');

        $status['id'] = $p['id'];

        // verifico se la pianificazione è da fermare
        if( $p['se_fermare'] == 1 ){
			
	#		appendToFile( date('d-m-Y H:i') . ' la pianificazione è da fermare, chiamo stop' . PHP_EOL, 'var/log/pianificazioni.check.log');
            // chiamo il task _pianificazioni.stop.php per pulire gli oggetti
            $url = $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.stop.php?id=' . $p['id'] . '&data_inizio_pulizia=' . $p['data_inizio_pulizia'];

            $status['stop'] = restcall( $url );

	#		appendToFile( date('d-m-Y H:i') . ' aggiorno la pianificazione dopo stop' . PHP_EOL, 'var/log/pianificazioni.check.log');

            if( $status['stop']['delete'] == 1 ){
                $cl = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_inizio_pulizia = NULL, se_fermare = NULL WHERE id = ?',
                    array(
                        array( 's' => $p['id'] )
                    )
                );

                $status['info'][] = 'aggiornamento riga dopo stop: ' . $cl;
            }

        }
        // se la pianificazione è solo da pulire ma non da fermare
        else{
		#	appendToFile( date('d-m-Y H:i') . ' la pianificazione è solo da pulire, chiamo clean'. PHP_EOL, 'var/log/pianificazioni.check.log');	
			
            // chiamo il task _pianificazioni.clean.php per pulire gli oggetti
            $url = $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.clean.php?id=' . $p['id'] . '&data_inizio_pulizia=' . $p['data_inizio_pulizia'];

            $status['clean'] = restcall( $url );

            // se la pulizia è andata a buon fine aggiorno i flag e controllo se bisogna ripopolare
            if( $status['clean']['delete'] == 1 ){
				
				appendToFile( date('d-m-Y H:i') . ' pulite le righe' . PHP_EOL, 'var/log/pianificazioni.check.log');

                if( $p['se_ripopolare'] == 1 ){
					
					appendToFile( date('d-m-Y H:i') . ' la pianificazione è da ripopolare, chiamo populate' . PHP_EOL, 'var/log/pianificazioni.check.log');
                    $status['ripopola'] = 1;
                    
					// setto il timestamp di popolazione a NULL, così poi la populate fa il resto
					$rp = mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE pianificazioni SET se_ripopolare = NULL, timestamp_popolazione = NULL WHERE id = ?',
                        array(
                            array( 's' => $p['id'] )
                        )
                    );
					
                /*    restcall(
                        $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.populate.php?id=' . $p['id']
                    );
					
					appendToFile( date('d-m-Y H:i') . ' riaggiorno la pianificazione setto se_ripopolare NULL', 'var/log/pianificazioni.check.log');

                    $rp = mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE pianificazioni SET se_ripopolare = NULL WHERE id = ?',
                        array(
                            array( 's' => $p['id'] )
                        )
                    );

                    $status['info'][] = 'aggiornamento riga dopo repopulate: ' . $rp;*/
                }
				
				$cl = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET data_inizio_pulizia = NULL WHERE id = ?',
                    array(
                        array( 's' => $p['id'] )
                    )
                );

                $status['info'][] = 'setto data_inizio_pulizia NULL';
            }
        }
    }
    else{
        $status['info'][] = 'nessuna pianificazione da elaborare';
    }
	
#	appendToFile( date('d-m-Y H:i') . print_r( $status, true ) . PHP_EOL, 'var/log/pianificazioni.check.log');
#	appendToFile( print_r($status, true), 'var/log/pianificazioni.check.log');
        

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
