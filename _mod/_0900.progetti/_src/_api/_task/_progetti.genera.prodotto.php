<?php

    /**
     * effettua l'eliminazione di una todo e di tutti gli oggetti as essa collegati
     * - riceve in ingresso l'id della todo
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


    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivata un progetto
    if( ! empty( $_REQUEST['id'] ) ) {

        // ID della todo in oggetto
        $status['id_progetto'] = $_REQUEST['id'];

        $progetto =  mysqlSelectRow($cf['mysql']['connection'],
        'SELECT * FROM progetti_view WHERE id = ?',           
        array(
            array( 's' => $status['id_progetto'] )
        ));

        $status['insert_prodotto'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO prodotti ( id, id_tipologia, nome ) VALUES ( ?, ?, ? )',
            array(
                array( 's' => $status['id_progetto'] ),
                array( 's' => '1' ),
                array( 's' => $progetto['nome'] )
            )
        );

        $status['update_progetti'] = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE progetti SET id_prodotto = ? WHERE id = ?',
            array(
                array( 's' => $status['id_progetto'] ),
                array( 's' => $status['id_progetto'] )
            )
        );



    } else {

        // status
        $status['err'][] = 'ID progetto non passato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
