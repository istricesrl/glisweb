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
            "SELECT v.*, a.__label__ as anagrafica FROM variazioni_attivita AS v LEFT JOIN anagrafica_view_static AS a ON v.id_anagrafica = a.id WHERE v.id = ?",
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

            // creo il job            
            $nome = 'approvazione variazione ' . $v['id'] . ' per anagrafica ' . $v['id_anagrafica'] . ' - ' . $v['anagrafica'];
            $job = mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO job ( nome, job, iterazioni, workspace, se_foreground, delay ) VALUES ( ?, ?, ?, ?, ?, ? )',
                array(
                    array( 's' => $nome ),
                    array( 's' => '_mod/_1140.variazioni/_src/_api/_job/_variazioni.attivita.approve.php' ),
                    array( 's' => 10 ),
                    array( 's' => json_encode(
                        array(
                            'id_variazione' => $v['id']
                        )
                    ) ),
                    array( 's' => 1 ),
                    array( 's' => 3 )
                )
            );

        }


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
