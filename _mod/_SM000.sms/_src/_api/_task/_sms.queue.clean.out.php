<?php

    /**
     * svuotamento della coda degli SMS in uscita
     *
     * Questo task cancella tutti gli SMS della coda `sms_out`, senza inviarli, e ottimizza la tabella; è la copia nel modulo
     * del task del core `_src/_api/_task/_sms.queue.clean.out.php`, come per le mail in `MA000.mail`, e lo chiamano gli
     * strumenti della coda ( `sms.tools` ). Richiede il privilegio `GESTIONE_COMUNICAZIONI`.
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
	logWrite( 'richiesta di pulizia della coda degli SMS in uscita', 'sms', LOG_DEBUG );

    // svuoto la coda
	if( mysqlQuery( $cf['mysql']['connection'], 'DELETE FROM sms_out' ) ) {
	    mysqlQuery( $cf['mysql']['connection'], 'OPTIMIZE TABLE sms_out' );
	    $status['__status__'] = 'OK';
	} else {
	    $status['__status__'] = 'NO';
	}

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
