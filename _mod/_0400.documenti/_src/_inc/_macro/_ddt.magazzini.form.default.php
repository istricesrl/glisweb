<?php

    // die('TEST');
    // print_r( $_REQUEST );
    // print_r( $ct['page']['etc']['tabs'] );

    // ...
    $idOrdine = NULL;

	// TODO trovare l'ordine collegato se c'è in base al ruolo, al tipo di documento, eccetera
    if( isset( $_REQUEST['documenti']['id'] ) ) {
        $idOrdine = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT id_documento_collegato FROM relazioni_documenti WHERE id_documento = ? LIMIT 1',
            array( array( 's' => $_REQUEST['documenti']['id'] ) )
        );
    }

    // se c'è un ordine collegato
    if( empty( $idOrdine ) ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['ddt.magazzini.form.ordine']
        );
    }
