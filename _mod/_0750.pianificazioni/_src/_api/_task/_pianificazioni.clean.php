<?php

    /**
     * cancella tutte le entità collegate successive alla data indicata
     * setta la data_ultimo_oggetto alla data indicata
     *
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

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata una data
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della pianificazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // entità su cui fare il match
        $status['entita'] = pianificazioniGetMatchEntityName( $status['id'] );

        // verifico se la pianificazione esiste
        if( ! empty( $status['entita'] ) ) {

            // campo su cui fare il match
            $status['campo'] = pianificazioniGetMatchFieldName( $status['id'], $status['entita'] );

            // verifico se è stato trovato il campo di match
            if( ! empty( $status['campo'] ) ) {

                // verifico se è arrivata una data
                if( ! empty( $_REQUEST['data_inizio_pulizia'] ) ) {

                    // data inizio pulizia della pianificazione in oggetto
                    $status['inizio'] = $_REQUEST['data_inizio_pulizia'];

                    // status
                    $status['info'][] = 'pulizia oggetti collegati alla pianificazione';

                    // query
                    $q = 'DELETE FROM ' . $status['entita'] . ' WHERE id_pianificazione = ? AND ' . $status['campo'] . ' > ?';
					
					// cerco se ci sono righe da eliminare
					$status['to_delete'] = mysqlSelectValue(
						$cf['mysql']['connection'],
						'SELECT count(id) FROM ' . $status['entita'] . ' WHERE id_pianificazione = ? AND ' . $status['campo'] . ' > ?',
						array( array( 's' => $status['id'] ), array( 's' => $status['inizio'] ) )
					);
                    
                    $status['statiche'] = pianificazioniGetStatic( $status['id'] );
                    // se ci sono righe da eliminare estraggo le statiche e disattivo i trigger
                    
                    if( !empty( $status['to_delete'] ) && !empty( $status['statiche'] ) ){                   
                        foreach( $status['statiche'] as $s ){
                            triggerOff( $s );
                            $cf['cron']['cache']['view']['static']['refresh'][] = $s;
                        }
                    }

                #    var_dump( $q );
                #    var_dump( $status['id'] );
                #    var_dump( $status['inizio'] );
                
                    // esecuzione della query
                    $del = mysqlQuery( $cf['mysql']['connection'], $q, array( array( 's' => $status['id'] ), array( 's' => $status['inizio'] ) ) );

                    // status
                    $status['info'][] = 'eliminate ' . $del . ' righe dalla tabella ' . $status['entita'];

					if( ( $status['to_delete'] > 0 && $del == $status['to_delete'] ) ||  $status['to_delete'] == 0 ){
						$status['delete'] = 1;
					}
					else{
						$status['delete'] = 0;
					}
                    

                    // modalità hard/stop
                    if( ! empty( $_REQUEST['hard'] ) ) {

                        // status
                        $status['info'][] = 'esecuzione HARD';

                        // query
                        $q = 'UPDATE pianificazioni SET giorni_rinnovo = NULL, data_fine = ? WHERE id = ?';

                        // esecuzione della query
                        $status['hard'] = mysqlQuery( $cf['mysql']['connection'], $q, array( array( 's' => $status['inizio'] ), array( 's' => $status['id'] ) ) );

                    } else {

                        // query
                         $q = 'UPDATE pianificazioni SET data_ultimo_oggetto = ?, timestamp_popolazione = NULL WHERE id = ?';

                         // esecuzione della query
                         $status['hard'] = mysqlQuery( $cf['mysql']['connection'], $q, array( array( 's' => $status['inizio'] ), array( 's' => $status['id'] ) ) );

                    }

                    // se erano presenti statiche, riattivo i trigger e le ripopolo
                /*    if( !empty( $status['statiche'] ) ){
                        $status['info'][] = 'riattivo i trigger';
                        $tron = mysqlQuery(
                            $cf['mysql']['connection'],
                            'SET @TRIGGER_LAZY = NULL'
                        );

                        foreach( $status['statiche'] as $s ){
                            $status['info'][] = 'chiamo la procedure ' . $s ;
                            $exec = mysqlQuery(
                                $cf['mysql']['connection'],
                                'CALL ' . $s . '(NULL)'
                            );
                        }
                    }
					*/

                } else {

                    // status
                    $status['err'][] = 'data inizio pulizia non passata';

                }

            } else {

                // status
                $status['err'][] = 'campo di match per la pianificazione ' . $status['id'] . ' su ' . $status['entita'] . ' non trovata';
                    
            }

        } else {

            // status
            $status['err'][] = 'pianificazione ' . $status['id'] . ' non trovata';

        }

    } else {

        // status
        $status['err'][] = 'ID pianificazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
