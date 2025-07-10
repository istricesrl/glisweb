<?php

    /**
     * crea una nota di credito per il rimborso di un coupon
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

    // dati di partenza
    if( isset( $_REQUEST['coupon'] ) && ! empty( $_REQUEST['coupon'] ) ) {

        // ...
        $status['info'][] = 'ricevuto coupon: ' . $_REQUEST['coupon'];

        // recupero il coupon
        $status['coupon'] = getDettagliCoupon( $_REQUEST['coupon'] );

        // se il coupon vale più di zero procedo
        if( $status['coupon']['totale_finale'] > 0 ) {

            // creo una nota di credito intestata all'intestatario del coupon
            $status['nota_di_credito']['id'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_tipologia' => 3, // nota di credito
                    'codice' => 'NC-CPN-' . $status['coupon']['id'],
                    'sezionale' => 'R/'.date('Y'),
                    'numero' => generaProssimoNumeroDocumento( 3, 'R/'.date('Y'), trovaIdAziendaGestita() ),
                    'id_emittente' => trovaIdAziendaGestita(),
                    'id_sede_emittente' => trovaIdSedeLegale( trovaIdAziendaGestita() ),
                    'id_destinatario' => $status['coupon']['id_anagrafica'],
                    'id_sede_destinatario' => trovaIdSedeLegale( $status['coupon']['id_anagrafica'] ),
                    'data' => date('Y-m-d'),
                    'id_coupon' => $status['coupon']['id'],
                    'nome' => 'nota di credito generata automaticamente per il rimborso del coupon ' . $status['coupon']['id'],
                    'id_condizione_pagamento' => 2, // pagamento alla consegna
                    'esigibilita' => 'I', // immediata
                ),
                'documenti'
            );

            // aggiungo una riga con il totale residuo del coupon
            $status['nota_di_credito']['id_riga'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_documento' => $status['nota_di_credito']['id'],
                    'codice' => 'R-NC-CPN-' . $status['coupon']['id'],
                    'nome' => 'rimborso coupon ' . $status['coupon']['id'],
                ),
                'documenti_articoli'
            );

            // aggiungo un pagamento pagato per la nota di credito
            $status['nota_di_credito']['id_pagamento'] = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_documento' => $status['nota_di_credito']['id'],
                    'id_coupon' => $status['coupon']['id'],
                    'nome' => 'rimborso coupon ' . $status['coupon']['id'],
                    'codice' => 'P-NC-CPN-' . $status['coupon']['id'],
                    'importo_lordo_totale' => $status['coupon']['totale_finale'],
                    'importo_lordo_finale' => $status['coupon']['totale_finale'],
                    'timestamp_pagamento' => time(),
                ),
                'pagamenti'
            );

        } else {

            $status['err'][] = 'Il coupon non ha un importo residuo da rimborsare';

        }

    } else {

        $status['err'][] = 'Coupon non specificato';

    }

    // output
	if( ! defined( 'CRON_RUNNING' ) ) {
	    buildJson( $status );
	}
