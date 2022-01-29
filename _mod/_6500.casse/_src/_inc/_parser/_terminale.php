<?php

if( isset( $_REQUEST[ 'documenti' ]['__comando__'] ) ){

    if( $_REQUEST[ 'documenti' ]['__comando__'] == 'CMD.TPL.0001'  ){

        $_REQUEST[ 'documenti' ]['id_tipologia'] = 1;
    
    } elseif( $_REQUEST[ 'documenti' ]['__comando__'] == 'CMD.TPL.0009'  ){
    
        $_REQUEST[ 'documenti' ]['id_tipologia'] = 9;
    
    }

    if( $_REQUEST[  'documenti' ]['__comando__'] == 'CMD.PGM.0001' ){
        // contanti
        $_REQUEST[  'documenti' ]['scadenze'][0]['id_modalita_pagamento'] = 1;

    } elseif( $_REQUEST[  'documenti' ]['__comando__'] == 'CMD.PGM.0002' ) {
        // elettronico
        $_REQUEST[  'documenti' ]['scadenze'][0]['id_modalita_pagamento'] = 5;
    }

}


/*
if( !isset( $_REQUEST['documenti']['scadenze'] ) && isset( $_REQUEST['documenti']['id']) ){

    $_REQUEST['documenti']['scadenze'] = mysqlQuery(
        $cf['mysql']['connection'],
        "SELECT * FROM scadenze_view  WHERE id_documento = ?", array( array( 's' =>  $_REQUEST['documenti']['id'] ) )
        );

}
*/