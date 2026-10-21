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

    // verifica dei privilegi
    checkTaskPrivilege( 'CANCELLAZIONE_RICORSIVA' );

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

                $whr = array();
				$par = array();
                
                $whr[] = 'id_progetto = ?';
                $par[] = array( 's' => $_REQUEST['id'] );

                $whr[] = 'data_programmazione >= ?';
                $par[] = array( 's' => $p['data_inizio'] );

                if( !empty( $p['data_fine'] ) ) {
                    $whr[] = 'data_programmazione <= ?';
                    $par[] = array( 's' => $p['data_fine'] );
                }

                $q = 'DELETE FROM todo WHERE ('  . implode( ' AND ', $whr ) . ')';

                // elimino le todo (e relative attività figlie) con data_programmazione compresa nel range di pausa
                $t = mysqlQuery(
                    $cf['mysql']['connection'],
                    $q,
                    $par
                );

                $status['todo'][] = 'eliminate ' . $t . ' todo per la pausa ' . $p['id'];

                // TODO prevedere eliminazione anche delle attività che non sono figlie di todo o che hanno
                // una propria data_programmazione

                // TODO potrebbe verificarsi il caso in cui un'attività è figlia di una todo e le date di programmazione
                // sono tali per cui la todo rientra nel range da eliminare ma l'attività no?

            }     
            
           // aggiorno attivita_view_static e todo_view_static ( refresh_view_statiche e' stata dismessa il 2026-09-30 )
           cleanStaticView( $cf['mysql']['connection'], 'attivita' );
           refreshStaticView( $cf['mysql']['connection'], 'attivita' );

            cleanStaticView( $cf['mysql']['connection'], 'todo' );
            refreshStaticView( $cf['mysql']['connection'], 'todo' );
           
        }
       

    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
