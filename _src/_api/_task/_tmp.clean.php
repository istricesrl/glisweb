<?php

    /**
     * svuota la cartella dei file temporanei
     *
     * Cancella il contenuto di tmp/ tranne il cestino tmp/.garbage/: i file che trashFile() ci sposta restano per i giorni
     * di $cf['common']['garbage']['giorni'] ( runlevel 030 ), e li toglie solo _garbage.clean.php. Fino al 04/11/2026
     * cancellava anche la cartella tmp/, che il bootstrap ricrea alla richiesta successiva.
     *
     * @file
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {

	    $cf['lvls']['skip'] = array(
		'300', '310', '320', '330', '345',
		'400', '420',
		'950', '980'
	    );

	    require '../../_config.php';

	}

    // verifica dei privilegi
    checkTaskPrivilege( 'GESTIONE_SISTEMA' );

    // inizializzo l'array del risultato
	$status = array();

    // svuoto tmp/ tranne il cestino
	$status['esito'] = recursiveDelete( DIR_TMP, false, array( basename( DIR_TMP_GARBAGE ) ) );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
