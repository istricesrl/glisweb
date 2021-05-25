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
            'SELECT * FROM pianificazioni WHERE se_pulire = 1 ORDER BY timestamp_popolazione LIMIT 1'
        );
    }

    // se ho una riga da elaborare
    if( !empty( $p ) ){

        $status['id'] = $p['id'];

        // se è specificata una data di inizio pulizia chiamo il task _pianificazioni.clean.php per pulire gli oggetti
        if( !empty( $p['data_inizio_pulizia'] ) ){
            $status['clean'] = restcall(
                $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.clean.php?id=' . $p['id'] . '&data_inizio_pulizia=' . $p['data_inizio_pulizia']
            );
        }

        // se l'eliminazione è andata a buon fine verifico se bisogna ripopolare
        if( isset( $status['clean']['delete'] ) && $status['clean']['delete'] > 0 ){

            $cl = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE pianificazioni SET se_pulire = NULL, data_inizio_pulizia = NULL WHERE id = ?',
                array(
                    array( 's' => $p['id'] )
                )
            );

            $status['info'][] = 'aggiornamento riga dopo clean: ' . $cl;

            if( $p['se_ripopolare'] == 1 ){
                $status['ripopola'] = 1;
                
                restcall(
                    $cf['site']['url'] . '_mod/_0750.pianificazioni/_src/_api/_task/_pianificazioni.populate.php?id=' . $p['id']
                );

                $rp = mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE pianificazioni SET se_ripopolare = NULL WHERE id = ?',
                    array(
                        array( 's' => $p['id'] )
                    )
                );

                $status['info'][] = 'aggiornamento riga dopo repopulate: ' . $rp;
            }

        }
		
    }
    else{
        $status['info'][] = 'nessuna pianificazione da elaborare';
    }
        

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
