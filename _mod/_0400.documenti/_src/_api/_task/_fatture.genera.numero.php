<?php

    /**
     * 
     * @todo documentare
     * 
     */

    // inclusione del framework
	if( ! defined( 'CRON_RUNNING' ) ) {
	    require '../../../../../_src/_config.php';
	}

    // inizializzo l'array del risultato
	$status = array();

    // non restituisco alcun progressivo
    $status['new'] = NULL;

    // se è specificata l'azienda
    if( empty( $_REQUEST['idAzienda'] ) ) {

        // errore
        $status['err'] = 'emittente documento non impostato';

    } elseif( empty( $_REQUEST['sezionale'] ) ) {

        // errore
        $status['err'] = 'sezionale documento non impostato';

    } elseif( empty( $_REQUEST['idTipologia'] ) ) {

        // errore
        $status['err'] = 'tipologia documento non impostata';

    } else {

        // seleziono l'ultimo progressivo utilizzato
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT documenti.id, coalesce( max( cast( numero as unsigned ) ), 0 ) AS numero FROM documenti '.
            'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
            'WHERE id_emittente = ? AND sezionale = ? '.
            'AND numerazione = ( SELECT numerazione FROM tipologie_documenti WHERE id = ? ) GROUP BY documenti.id, numero',
            array(
                array( 's' => $_REQUEST['idAzienda'] ),
                array( 's' => $_REQUEST['sezionale'] ),
                array( 's' => $_REQUEST['idTipologia'] )
            )
        );

        // propongo un nuovo progressivo
        $status['new'] = $status['current']['numero'] + 1;

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
