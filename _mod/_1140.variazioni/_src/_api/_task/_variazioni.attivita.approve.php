<?php

    /**
     * riceve in ingresso l'id della variazione da approvare
     * prende tutte le attività legate a quella richiesta di variazione e setta id_anagrafica a NULL
     * per ogni giorno del periodo di variazione crea le attività previste da contratto settandole alla tipologia_inps indicata nella variazione
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

        foreach( $periodi as $p ){

            // chiamo il task _variazioni.attivita.update che setta id_anagrafica NULL per le attività coinvolte
            $url = $cf['site']['url'] . '_mod/_1140.variazioni/_src/_api/_task/_variazioni.attivita.update.php?id=' . $p['id'];

            $status['update_attivita'][$p['id'] ] = restcall(
                $url
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


         // passo successivo: per ogni giorno di ogni riga periodi
            // 1- prendo la data
            // 2- vado a vedere se c'è un turno attivo per quella data e quell'anagrafica
            // 3- vado nel contratto attivo per l'anagrafica corrente e vedo per quel turno che orari sono previsti
            // 4- creo una riga di attività con la tipologia inps indicata per ogni fascia di orari_contratti trovata
            // 5- vedo se ci sono attività già pianificate per quella fascia di data e ora e setto id_anagrafica NULL
        
        // funzione utile:
        /*
            - funzione che partendo da data_inizio e data_fine restituisce l'elenco delle date comprese       
        */


    } else {

        // status
        $status['err'][] = 'ID variazione non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
