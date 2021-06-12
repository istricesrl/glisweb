<?php

    /**
     * modifica la data di fine contratto e crea una riga di attività di proroga
     * riceve in ingresso:
     * - id: l'id del contratto
     * - data: la nuova data di fine contratto
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

    // verifico se è arrivato un contratto
    if( ! empty( $_REQUEST['id'] ) && ! empty( $_REQUEST['data'] ) ) {

        // ID del contratto in oggetto
        $status['id_contratto'] = $_REQUEST['id'];
        $status['data'] = $_REQUEST['data'];

        // estraggo la data fine contratto attuale
        $df = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT data_fine FROM contratti WHERE id = ?',
            array( array( 's' => $_REQUEST['id'] ) )
        );

        // inserisco la riga di attività
        $nome = 'proroga contratto dal ' . $df . ' al ' . $_REQUEST['data'];
        $at = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO attivita ( id_contratto, nome ) VALUES ( ?, ? )',
            array(
                array( 's' => $_REQUEST['id'] ),
                array( 's' => $nome )
            )
        );

        $status['info'][] = 'inserita riga di attivita ' . $at;

        // aggiorno la data di fine contratto
        $upd = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE contratti SET data_fine = ? WHERE id = ?',
            array(
                array( 's' => $_REQUEST['data'] ),
                array( 's' => $_REQUEST['id'] )
            )
        );

        $status['info'][] = 'aggiornata ' . $upd . ' riga di contratto';


    } else {

        // status
        $status['err'][] = 'ID contratto o data non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
