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

    // se è specificata l'azienda
    if( ! empty( $_REQUEST['idAzienda'] ) ) {

/*
        // seleziono l'ultimo progressivo utilizzato
        $status['current'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT coalesce( max( progressivo_invio ), 0 ) FROM documenti WHERE id_emittente = ?',
#            'SELECT coalesce( max( progressivo_invio ), 0 ) FROM documenti WHERE id_emittente IN ( SELECT id FROM anagrafica WHERE codice_fiscale = ( SELECT codice_fiscale FROM anagrafica AS a1 WHERE a1.id = ? ) )',
            array(
                array( 's' => $_REQUEST['idAzienda'] )
            )
        );
*/
        $status['current'] = generaInfoProgressivoInvio( $_REQUEST['idAzienda'] );

        // debug
        $status['new'] = base_convert( $status['current'], 36, 10 );
        $status['new']++;
        $status['new'] = base_convert( $status['new'], 10, 36 );

        // propongo un nuovo progressivo
        $status['new'] = strtoupper( str_pad( $status['new'], 5, '0', STR_PAD_LEFT ) );

    } else {

        // non restituisco alcun progressivo
        $status['new'] = NULL;

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
