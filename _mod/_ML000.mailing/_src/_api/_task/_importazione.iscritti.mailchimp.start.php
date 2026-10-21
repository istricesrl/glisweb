<?php

    /**
     * avvio dell'importazione degli iscritti da MailChimp
     *
     * Crea il job `_importazione.iscritti.mailchimp.php`, che legge il file caricato in `var/contenuti/upload/` e iscrive gli indirizzi alla lista indicata.
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
    if( ! isset( $_REQUEST['lista'] ) ) { $_REQUEST['lista'] = 'DEFAULT'; }

    // creo il job
    $status['inserimento'] = mysqlQuery(
        $cf['mysql']['connection'],
        'INSERT INTO job ( nome, job, iterazioni, se_foreground, workspace ) VALUES ( ?, ?, ?, ?, ? )',
        array(
            array( 's' => 'importazione automatica iscritti alla newsletter da MailChimp' ),
            array( 's' => '_mod/_ML000.mailing/_src/_api/_job/_importazione.iscritti.mailchimp.php' ),
            array( 's' => 10 ),
            array( 's' => 0 ),
            array( 's' => json_encode(
                array(
                    'file' => 'var/contenuti/upload/' . basename( $_REQUEST['file'] ),
                    'lista' => $_REQUEST['lista']
                )
            ) )
        )
    );

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
