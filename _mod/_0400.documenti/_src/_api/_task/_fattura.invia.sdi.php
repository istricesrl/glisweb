<?php

    /**
     * effettua l'eliminazione di un progetto e di tutti gli oggetti as esso collegati
     * - se riceve in ingresso un id, analizza quel progetto
     * - altrimenti analizza i progetti che hanno il flag se_cancellare = 1
     * 
     *
     *
     * 
     *
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // verifico se è arrivato un progetto
    if( ! empty( $_REQUEST['idFattura'] ) ) {

        // recupero l'ID azienda
        $idAzienda = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT anagrafica.codice_archivium FROM documenti '.
            'INNER JOIN anagrafica ON anagrafica.id = documenti.id_emittente '.
            'WHERE documenti.id = ?',
            array( array( 's' => $_REQUEST['idFattura'] ) )
        );

        // genero il token di autorizzazione
        $token = md5( time() );

        // imposto il token di autorizzazione per il documento
        mysqlQuery( $cf['mysql']['connection'], 'UPDATE documenti SET token = ?', array( array( 's' => $token ) ) );

        // prelevo l'XML
        $x = restCall(
            $cf['site']['url'] . 'print/0400.documenti/fattura.xml',
            METHOD_GET,
            array( '__documento__' => $_REQUEST['idFattura'], 'f' => 1, 't' => $token ),
            NULL,
            MIME_APPLICATION_JSON
        );

        // debug
        // var_dump( $idAzienda );
        // die( '<pre>' . htmlentities( readFromFile( $x['file'], FILE_READ_AS_STRING ) ) . '</pre>' );

        // chiamo la funzione archiviumPostInsertAzienda()
        if( ! empty( $x['file'] ) ) {
            $status['esito'] = archiviumPostInvioFeAttiva( $idAzienda, $_REQUEST['idFattura'], $x['file'] );
        } else {
            $status['err'][] = 'XML fattura vuoto';        
        }
    
        // output
        // echo '<pre>' . var_dump( $s ) . '</pre>';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
