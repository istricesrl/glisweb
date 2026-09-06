<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
    }

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_ECOMMERCE' );

    // debug
    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE FROM carrelli WHERE coalesce(
            destinatario_nome,
            destinatario_cognome,
            destinatario_denominazione,
            intestazione_nome,
            intestazione_cognome,
            intestazione_denominazione
        ) IS NULL
        AND ( 
            timestamp_inserimento IS NULL
            OR
            timestamp_inserimento < unix_timestamp( now( ) ) - 3600
        )'
    );

    buildJson( array( 'status' => 'ok' ) );
