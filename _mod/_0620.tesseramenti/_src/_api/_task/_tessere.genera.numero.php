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
    if( true ) {

/*
        // seleziono l'ultimo progressivo utilizzato
        $status['current'] = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT documenti.id, documenti.sezionale, coalesce( cast( numero as unsigned ), 0 ) AS numero, numerazione FROM documenti '.
            'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
            'WHERE id_emittente = ? AND sezionale = ? '.
            'AND tipologie_documenti.numerazione = ( SELECT numerazione FROM tipologie_documenti AS t1 WHERE t1.id = ? ) '.
            'ORDER BY coalesce( cast( numero as unsigned ), 0 ) DESC LIMIT 1',
            array(
                array( 's' => $_REQUEST['idAzienda'] ),
                array( 's' => $_REQUEST['sezionale'] ),
                array( 's' => $_REQUEST['idTipologia'] )
            )
        );

        if( ! isset( $status['current']['numero'] ) ) {
            $status['current']['numero'] = 0;
        }
*/

        // seleziono l'ultimo progressivo utilizzato
/*
        $status['current'] = generaInfoNumeroDocumento(
            array( 's' => $_REQUEST['idTipologia'] ),
            array( 's' => $_REQUEST['sezionale'] ),
            array( 's' => $_REQUEST['idAzienda'] )
        );
*/
        $status['current'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT contratti.codice FROM contratti LEFT JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia WHERE tipologie_contratti.se_tesseramento IS NOT NULL ORDER BY CAST( codice as SIGNED INTEGER ) DESC'
        );

        // propongo un nuovo progressivo
        $status['new'] = $status['current'] + 1;

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
