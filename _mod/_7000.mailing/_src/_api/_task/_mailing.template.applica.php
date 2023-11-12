<?php

    /**
     *
     *
     *
     *
     * @todo commentare
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // status
	$status['info'][] = 'applicazione template al mailing';

    // ...
    $cnts = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT * FROM contenuti WHERE id_template = ?',
        array(
            array( 's' => $_REQUEST['__template__'] )
        )
    );

    // ...
	$status['info'][] = 'contenuti trovati: ' . count( $cnts );

    // ...
    foreach( $cnts as $cnt ) {

        $cnt['id_template'] = NULL;
        $cnt['id_mailing'] = $_REQUEST['__mailing__'];

        $idCnt = mysqlInsertRow(
            $cf['mysql']['connection'],
            $cnt,
            'contenuti',
            true,
            false,
            array(
                'id_mailing',
                'id_lingua'
            )
        );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
