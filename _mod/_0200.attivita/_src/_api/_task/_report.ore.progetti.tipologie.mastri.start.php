<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}
   
    // inizializzo l'array del risultato
	$status = array();

    // arrivano in request mese e anno
    if( isset( $_REQUEST['mese'] ) && isset( $_REQUEST['anno'] ) ){

        $nomemese = int2month( $_REQUEST['mese'] );

        // creo il job
        $status['inserimento'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT INTO job ( nome, job, iterazioni, workspace ) VALUES ( ?, ?, ?, ? )',
            array(
                array( 's' => 'esportazione ore progetti per tipologia e conto ore ' . $nomemese . ' ' . $_REQUEST['anno'] ),
                array( 's' => '_mod/_0200.attivita/_src/_api/_job/_report.ore.progetti.tipologie.mastri.php' ),
                array( 's' => 10 ),
                array( 's' => json_encode(
                    array(
                        'mese' => $_REQUEST['mese'],
                        'anno' => $_REQUEST['anno']
                    )
                ) )
            )
        );
    }
 

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
