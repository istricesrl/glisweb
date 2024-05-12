<?php

    /**
     * TODO prende in input un ID mailing e trascrive nella tabella mailing_mail tutte le associazioni liste_mail pertinenti partendo da mailing_liste
     * 
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // TODO verificare che le mail già inviate non vengano generate nuovamente
    // avendo sostituito REPLACE con INSERT IGNORE

    // nome file di default
    if( isset( $_REQUEST['idMailing'] ) ) { 

        $status['inserimento'] = mysqlQuery(
            $cf['mysql']['connection'],
            'INSERT IGNORE INTO mailing_mail ( id_mailing, id_mail )
                SELECT mailing_liste.id_mailing, liste_mail.id_mail 
                FROM liste_mail 
                INNER JOIN mailing_liste ON mailing_liste.id_lista = liste_mail.id_lista 
                WHERE mailing_liste.id_mailing = ?',
            array(
                array( 's' => $_REQUEST['idMailing'] )
            )
        );

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
