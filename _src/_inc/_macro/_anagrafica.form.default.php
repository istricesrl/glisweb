<?php

    if( ! empty( $_REQUEST['anagrafica']['se_cliente'] ) ) {
        $seCliente = true;
    } else {
        $seCliente = false;
    }

    if( ! empty( $_REQUEST['anagrafica']['se_lead'] ) ) {
        $seLead = true;
    } else {
        $seLead = false;
    }
    
    if( ! empty( $_REQUEST['anagrafica']['se_prospect'] ) ) {
        $seProspect = true;
    } else {
        $seProspect = false;
    }

    if( $seCliente != true && $seLead != true && $seProspect != true ) {
        $ct['page']['etc']['tabs'] = array_diff(
            $ct['page']['etc']['tabs'],
            ['anagrafica.form.cliente','anagrafica.form.offerte']
        );
    }

?>
