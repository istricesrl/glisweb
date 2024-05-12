<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // debug
    // die( print_r( $_REQUEST, true ) );

    // status
    $status = array();

    // ...
    if( ! isset( $_REQUEST['data'] ) ) {
        $_REQUEST['data'] = date( 'Y-m-d' );
    }

    // ...
    if( isset( $_REQUEST['anagrafica'] ) ) {

        // dati
        $status['dati'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT anagrafica.nome, anagrafica.cognome, mail.indirizzo AS mail 
            FROM anagrafica 
            INNER JOIN mail ON mail.id_anagrafica = anagrafica.id 
            WHERE anagrafica.id = ? LIMIT 1',
            array(
                array( 's' => $_REQUEST['anagrafica'] )
            )
        );

        // dati
        $status['dati']['attivita'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT attivita.nome, attivita.ora_inizio_programmazione 
            FROM attivita 
            WHERE id_anagrafica_programmazione = ? 
            AND data_programmazione = ?',
            array(
                array( 's' => $_REQUEST['anagrafica'] ),
                array( 's' => $_REQUEST['data'] )
            )
        );

        // ...
        if( ! empty( $status['dati']['attivita'] ) ) {

            // accodo la mail
            $status['idMail'] = queueMailFromTemplate(
                $cf['mysql']['connection'],
                $cf['mail']['tpl']['RIEPILOGO_ATTIVITA_GIORNATA'],
                array( 'dt' => $status['dati'], 'ct' => $ct ),
                strtotime( '+5 minutes' ),
                array( $status['dati']['nome'] . ' ' . $status['dati']['cognome'] => $status['dati']['mail'] ),
                $cf['localization']['language']['ietf']
            );

        }

    } else {

        // status
        $status['err'][] = 'ID anagrafica non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
