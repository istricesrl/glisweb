<?php

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // elimino i comuni senza indirizzi associati
    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE comuni FROM comuni LEFT JOIN indirizzi ON indirizzi.id_comune = comuni.id WHERE indirizzi.id IS NULL'
    );

    // elimino le provincie senza comuni associati
    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE provincie FROM provincie LEFT JOIN comuni ON comuni.id_provincia = provincie.id WHERE comuni.id IS NULL'
    );

    // elimino le regioni senza provincie associate
    mysqlQuery(
        $cf['mysql']['connection'],
        'DELETE regioni FROM regioni LEFT JOIN provincie ON provincie.id_regione = regioni.id WHERE provincie.id IS NULL'
    );

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
