<?php

    /**
     * task che viene richiamato manualmente, riceve in ingresso mese e anno e crea un job che compila la tabella cartellini
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

    // verifico se sono arrivati mese e anno
    if( ! empty( $_REQUEST['mese'] ) && ! empty( $_REQUEST['anno'] ) ) {

        // mese e anno
        $status['mese'] = $_REQUEST['mese'];
        $status['anno'] = $_REQUEST['anno'];

        $nomemese = int2month( $_REQUEST['mese'] );

        // creo il job
        $status['job'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO job ( nome, job, iterazioni, workspace ) VALUES ( ?, ?, ?, ? )',
            array(
                array( 's' => 'compilazione cartellini ' . $nomemese . ' ' . $_REQUEST['anno'] ),
                array( 's' => '_mod/_1120.cartellini/_src/_api/_job/_cartellini.create.php' ),
                array( 's' => 10 ),
                array( 's' => json_encode(
                    array(
                        'mese' => $_REQUEST['mese'],
                        'anno' => $_REQUEST['anno']
                    )
                ) )
            )
        );
        


    } else {

        // status
        $status['err'][] = 'mese o anno non passati';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
