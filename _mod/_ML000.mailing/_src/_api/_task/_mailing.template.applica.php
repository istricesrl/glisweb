<?php

    /**
     * applicazione di un template mail a un mailing
     *
     * Copia sul mailing i contenuti ( mittente, oggetto e testo per lingua ) di un template mail di
     * `_TE000.template`; se il mailing ha già il testo in una lingua, lo sostituisce.
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
    checkTaskPrivilege( 'GESTIONE_COMUNICAZIONI' );

    // inizializzo l'array del risultato
    $status = array();

    // applicazione del template
    if( ! empty( $_REQUEST['__template__'] ) && ! empty( $_REQUEST['__mailing__'] ) ) {

        // status
        $status['info'][] = 'applicazione template al mailing';

        // contenuti del template
        $cnts = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM contenuti WHERE id_template = ?',
            array(
                array( 's' => $_REQUEST['__template__'] )
            )
        );

        // status
        $status['info'][] = 'contenuti trovati: ' . count( $cnts );

        // copia dei contenuti sul mailing
        foreach( $cnts as $cnt ) {
            $cnt['id'] = NULL;
            $cnt['id_template'] = NULL;
            $cnt['id_mailing'] = $_REQUEST['__mailing__'];
            $status['contenuti'][] = mysqlInsertRow(
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

    } else {

        // status
        $status['err'][] = 'template o mailing non specificato';

    }

    // output
    if( ! defined( 'CRON_RUNNING' ) ) {
        buildJson( $status );
    }
