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

    // nome file di default
    if( ! empty( $_REQUEST['__lista__'] ) && ! empty( $_REQUEST['__categoria__'] ) ) { 

        // TODO in futuro inserire solo le mail per cui c'è il consenso oppure un flag apposito
        $mail = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT mail.id FROM mail
            INNER JOIN anagrafica ON anagrafica.id = mail.id_anagrafica
            INNER JOIN anagrafica_categorie ON anagrafica_categorie.id_anagrafica = anagrafica.id
            WHERE anagrafica_categorie.id_categoria = ?',
            array(
                array( 's' => $_REQUEST['__categoria__'] )
            )
        );

        foreach( $mail as $m ) {

            mysqlQuery(
                $cf['mysql']['connection'],
                'INSERT INTO liste_mail ( id_lista, id_mail ) VALUES ( ?, ? )',
                array(
                    array( 's' => $_REQUEST['__lista__'] ),
                    array( 's' => $m['id'] )
                )
            );

        }

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
