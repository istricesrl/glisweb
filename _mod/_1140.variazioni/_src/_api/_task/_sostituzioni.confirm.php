<?php

    /**
     * riceve in ingresso l'id della sostituzione da confermare
     * - estrae l'id dell'attività e dell'anagrafica collegate
     * - aggiorna l'attività settando l'id_anagrafica
     * - inserisce la riga di acl per l'attività legata alla nuova anagrafica
     * - setta la data di accettazione della sostituzione
     * - rimuove dalla tabella "__report_sostituzioni_attivita__" le righe corrispondenti a questa anagrafica, così il task _sostituzioni.calculate.php la rianalizza
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

    // verifico se è arrivata una sostituzione
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della variazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // leggo i dati completi della sostituzione corrente
        $s = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            "SELECT * FROM sostituzioni_attivita WHERE id = ?",
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        if( !empty( $s['id_anagrafica'] ) ){
            
            // aggiorno l'attività collegata settandone l'id_anagrafica
            $attivita = mysqlQuery(
                $cf['mysql']['connection'],
                "UPDATE attivita SET id_anagrafica = ? WHERE id = ?",
                array(
                    array( 's' => $s['id_anagrafica'] ),
                    array( 's' => $s['id_attivita'] )
                )
            );

            // leggo l'id dell'account associato all'anagrafica
            $id_account = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT id FROM account WHERE id_anagrafica = ?',
                array( array( 's' => $s['id_anagrafica'] ) )
            );

            
            // aggiorno la riga di acl
            $acl = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_entita'		=> $s['id_attivita'],
                    'id_account'	=> ( isset( $id_account ) ) ? $id_account : NULL,
                    'permesso'		=> 'FULL'
                ),
                '__acl_attivita__'
            );

            // se l'aggiornamento attività è andato a buon fine confermo la sostituzione
            if( !empty( $attivita ) ){

                $status['info'][] = 'attribuzione attivita ' . $s['id_attivita'] . ' all\'operatore ' . $s['id_anagrafica'];

                // setto la data di accettazione della sostituzione alla data corrente
                $conferma = mysqlQuery(
                    $cf['mysql']['connection'],
                    "UPDATE sostituzioni_attivita SET data_accettazione = ? WHERE id = ?",
                    array(
                        array( 's' => date('Y-m-d') ),
                        array( 's' => $_REQUEST['id'])
                    )
                );

                $status['info'][] = 'sostituzione ' . $_REQUEST['id'] . ' confermata con data ' . date('Y-m-d');

                // rimuovo le righe sulla __report_sostituzioni_attivita__ legate a questa anagrafica
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'DELETE FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
                    array(
                        array( 's' => $s['id_anagrafica'] )
                    )
                );
            }
        }
       

    } else {

        // status
        $status['err'][] = 'ID sostituzione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
