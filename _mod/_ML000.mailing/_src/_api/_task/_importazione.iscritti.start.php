<?php

    /**
     * avvio dell'importazione degli iscritti
     *
     * Crea il job `_importazione.iscritti.php`, che legge il file caricato in `var/contenuti/upload/`.
     *
     */

    // inclusione del framework
    if( ! defined( 'CRON_RUNNING' ) ) {
        if( ! defined( 'INCLUDE_SUBDIR' ) ) {
            require '../../../../../_src/_config.php';
        } else {
            require INCLUDE_SUBDIR . '_config.php';
        }
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_IMPORT' );

    // inizializzo l'array del risultato
    $status = array();

    // nome file di default
    if( ! isset( $_REQUEST['file'] ) ) { $_REQUEST['file'] = 'iscritti.csv'; }

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'importazione automatica iscritti alla newsletter' ),
            array( 's' => '_mod/_ML000.mailing/_src/_api/_job/_importazione.iscritti.php' ),
            array( 's' => 10 ),
            array( 's' => 0 ),
            array( 's' => json_encode(
                array(
                    'file' => 'var/contenuti/upload/' . basename( $_REQUEST['file'] )
                )
            ) )
        )
    );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
