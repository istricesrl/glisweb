<?php

    /**
     * riceve in ingresso l'id della variazione da approvare
     * - prende tutte le attività legate a quella richiesta di variazione e setta id_anagrafica a NULL
     * - per ogni giorno del periodo di variazione crea le attività previste da contratto settandole alla tipologia_inps indicata nella variazione
     * - rimuove dalla tabella "__report_sostituzioni_attivita__" le righe corrispondenti a questa anagrafica, così il task _sostituzioni.calculate.php la rianalizza
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

    // verifico se è arrivata una variazione
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della variazione in oggetto
        $status['id'] = $_REQUEST['id'];

        // leggo i dati completi della variazione corrente
        $v = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            "SELECT * FROM variazioni_attivita WHERE id = ?",
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        // leggo i periodi associati alla variazione corrente
        $periodi = mysqlQuery(
            $cf['mysql']['connection'],
            "SELECT * FROM periodi_variazioni_attivita WHERE id_variazione = ?",
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        if( !empty( $periodi ) ){
            $status['info'][] = 'disttivo i trigger';

             // bypasso i trigger
             $troff = mysqlQuery(
                $cf['mysql']['connection'],
                'SET @TRIGGER_LAZY = 1'
            );

            foreach( $periodi as $p ){

                // chiamo il task _variazioni.attivita.update che setta id_anagrafica NULL per le attività coinvolte
                $url = $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_variazioni.attivita.update.php?id=' . $p['id'];

                $status['update_attivita'][$p['id'] ] = restcall(
                    $url
                );
                
            }

            // riattivo i trigger e ripopolo attivita_view_static
            $status['info'][] = 'riattivo i trigger e popolo attivita_view_static';
            $tron = mysqlQuery(
                $cf['mysql']['connection'],
                'SET @TRIGGER_LAZY = NULL'
            );

            $a = mysqlQuery(
                $cf['mysql']['connection'],
                'CALL attivita_view_static(NULL)'
            );
        }
            

        // setto la data di approvazione della variazione alla data corrente
        $approva = mysqlQuery(
            $cf['mysql']['connection'],
            "UPDATE variazioni_attivita SET data_approvazione = ? WHERE id = ?",
            array(
                array( 's' => date('Y-m-d') ),
                array( 's' => $_REQUEST['id'])
            )
        );

        $status['info'][] = 'variazione ' . $_REQUEST['id'] . ' approvata con data ' . date('Y-m-d');


        // rimuovo le righe sulla __report_sostituzioni_attivita__ legate a questa anagrafica
        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE FROM __report_sostituzioni_attivita__ WHERE id_anagrafica = ?',
            array(
                array( 's' => $v['id_anagrafica'] )
            )
        );


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
