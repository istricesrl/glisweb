<?php

    /**
     * svuotamento della coda degli SMS inviati
     *
     * Questo task cancella tutti gli SMS dell'archivio `sms_sent` e ottimizza la tabella; è la copia nel modulo del task del
     * core `_src/_api/_task/_sms.queue.clean.sent.php`, come per le mail in `MA000.mail`, e lo chiamano gli strumenti della
     * coda ( `sms.tools` ). Richiede il privilegio `GESTIONE_COMUNICAZIONI`.
     *
     * @file
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

    // log
	logWrite( 'richiesta di pulizia della coda degli SMS inviati', 'sms', LOG_DEBUG );

    // svuoto la coda
	if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM sms_sent' ) ) {
	    mysqlQuery( $cf['mysql']['connection'], 'OPTIMIZE TABLE sms_sent' );
	    $status['__status__'] = 'OK';
	} else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
