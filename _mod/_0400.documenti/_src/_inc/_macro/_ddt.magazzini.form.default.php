<?php

    // die('TEST');
    // print_r( $_REQUEST );
    // print_r( $ct['page']['etc']['tabs'] );

	// TODO trovare l'ordine collegato se c'è
    if( isset( $_REQUEST['documenti']['relazioni_documenti'] ) ) {
        foreach( $_REQUEST['documenti']['relazioni_documenti'] as $dc ) {
            if( true ) {
                $idOrdine = $dc['id_documento_collegato'];
            }
        }
    }

    // se c'è un ordine collegato
    if( ! isset( $idOrdine ) ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['ddt.magazzini.form.ordine']
        );
    }
