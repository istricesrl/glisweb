<?php

    /**
     * riceve in ingresso l'id di un progetto
     * estrae l'elenco delle sospensioni dalla tabella pause_progetti, prende tutte le todo e attività programmate in quei periodi e le rimuove
     * 
     *
     *
     * 
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // TODO usare le funzioni di ACL per verificare se l'azione è autorizzata

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un progetto
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID del progetto in oggetto
        $status['id_progetto'] = $_REQUEST['id'];

        // leggo l'elenco dei periodi di pausa
        $pause = mysqlQuery( 
            $cf['mysql']['connection'], 
            "SELECT * FROM pause_progetti WHERE id_progetto = ?",
            array(
                array( 's' => $_REQUEST['id'] )
            )
        );

        if( !empty( $pause ) ){

            foreach( $pause as $p ){

            // elimino le todo (e relative attività figlie) con data_programmazione compresa nel range di pausa
               $t = mysqlQuery(
                    $cf['mysql']['connection'],
                    "DELETE FROM todo WHERE id_progetto = ? AND (data_programmazione BETWEEN ? AND ?)",
                    array(
                        array( 's' => $_REQUEST['id'] ),
                        array( 's' => $p['data_inizio'] ),
                        array( 's' => $p['data_fine'] )
                    )
                );

                $status['todo'][] = 'eliminate ' . $t . ' todo per la pausa ' . $p['id'];

                // TODO prevedere eliminazione anche delle attività che non sono figlie di todo o che hanno
                // una propria data_programmazione

                // TODO potrebbe verificarsi il caso in cui un'attività è figlia di una todo e le date di programmazione
                // sono tali per cui la todo rientra nel range da eliminare ma l'attività no?

            }           
           
        }
       

    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}