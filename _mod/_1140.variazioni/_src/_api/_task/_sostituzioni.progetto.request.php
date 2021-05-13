<?php

    /**
     * riceve in ingresso id_progetto e id_anagrafica
     * cerca tutte le attività scoperte del progetto che quell'anagrafica può coprire
     * e fa una restCall alla _sostituzioni.request.php per ciascuna
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

    // verifico se sono arrivati un progetto e un'anagrafica
    if( ! empty( $_REQUEST['id_progetto'] ) && ! empty( $_REQUEST['id_anagrafica'] ) && ! empty( $_REQUEST['data_scopertura'] ) ) {

        // ID del progetto
        $status['id_progetto'] = $_REQUEST['id_progetto'];

        // ID dell'anagrafica
        $status['id_anagrafica'] = $_REQUEST['id_anagrafica'];

        // data di scopertura
        $status['data_scopertura'] = $_REQUEST['data_scopertura'];

        // scrivo una riga nella tabella sostituzioni_progetti così al calcolo successivo dei sostituti questa anagrafica verrà esclusa
        mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT IGNORE INTO sostituzioni_progetti ( id_progetto, data_scopertura, id_anagrafica ) VALUES ( ?, ?, ? )',
            array(
                array( 's' => $_REQUEST['id_progetto'] ),
                array( 's' => $_REQUEST['data_scopertura'] ),
                array( 's' => $_REQUEST['id_anagrafica'] )
            )
        );

        // cerco le attività scoperte per il progetto corrente
        $attivita = mysqlQuery( 
            $cf['mysql']['connection'],
            'SELECT * FROM attivita_view WHERE id_progetto = ? AND id_anagrafica IS NULL',
            array(
                array( 's' => $status['id_progetto'] )
            )
        );

        if( !empty( $attivita ) ){
            
            foreach( $attivita as $a ){               
                $copertura = coperturaAttivita(  $status['id_anagrafica'], $a['id'] );
               
                $status['attivita'][$a['id']]['copertura'] = $copertura;
               
                if( $copertura == 1){
                
                    // verifico se ci sono già delle richieste di sostituzione
                    $richieste = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT count(*) FROM sostituzioni_attivita WHERE id_anagrafica = ? AND id_attivita = ?',
                        array(
                            array( 's' => $status['id_anagrafica'] ),
                            array( 's' => $a['id'] )
                        )
                    );

                    $status['attivita'][$a['id']]['richieste'] = $richieste;
                    
                    // se non c'è già una richiesta la creo
                    if( empty( $richieste ) ){
                        $url = $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_sostituzioni.request.php?id_attivita=' . $a['id'] . '&id_anagrafica=' . $status['id_anagrafica'];
                        
                        // se la richiesta arriva in modalità hard aggiungo il parametro per creare le attività
                        if( !empty( $_REQUEST['hard'] ) ){
                            $status['hard'] = $_REQUEST['hard'];
                            $url .= '&hard=1';
                        }
                        $status['attivita'][$a['id']]['creazione_richiesta'] = restcall(
                            $url
                        );
                    }
                }
            }
        }

    } else {

        // status
        $status['err'][] = 'anagrafica o progetto non ricevuti';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
