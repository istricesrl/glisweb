<?php

    /**
     * elimina le todo programmate in un determinato giorno di festività per i progetti che non prevedono lavori nelle giornate festive
     * riceve in ingresso:
     * - data: la data in cui sono programmate le todo
     * 
     * la funzione esclude le todo che sono genitori di eventuali pianificazioni
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

    // verifico se è arrivata una data
    if( ! empty( $_REQUEST['data'] )  ) {

        // data in oggetto
        $status['data'] = $_REQUEST['data'];

        // TODO - verifico se si tratta di un giorno festivo

        // elimino le todo di quel giorno che non abbiano pianificazioni figlie e che siano associate a progetti che non prevedono lavoro festivo
        $del = mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE t FROM todo AS t INNER JOIN progetti AS pr ON t.id_progetto = pr.id '
            .'LEFT JOIN pianificazioni AS p ON t.id = p.id_todo '
            .'WHERE pr.se_lavoro_festivo IS NULL AND p.id IS NULL AND t.data_programmazione = ?',
            array( array( 's' => $_REQUEST['data'] ) )
        );


        $status['info'][] = 'eliminate ' . $del . ' righe di todo';


    } else {

        // status
        $status['err'][] = 'data non passata';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
