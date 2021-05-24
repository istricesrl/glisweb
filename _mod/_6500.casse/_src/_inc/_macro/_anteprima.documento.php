<?php

    if( isset( $_REQUEST['id'] ) && !empty( $_REQUEST['id'] ) ){

    $update = mysqlQuery( 
            $cf['mysql']['connection'], 
            'UPDATE documenti SET timestamp_chiusura = ? WHERE id = ?',
            array( 
                array( 's' => time() ), 
                array( 's' => $_REQUEST['id'] ) ) );

    $ct['etc']['documento'] = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            'SELECT * FROM  documenti_view  WHERE id = ?',
            array( 
                array( 's' => $_REQUEST['id'] ) ) );

    //print_r($documento);

    $ct['etc']['documento']['righe'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM documenti_articoli_view WHERE id_documento = ?',
        array( array( 's' =>  $_REQUEST['id'] ) ) 
	);

   // $ct['etc']['documento_json'] = $ct['etc']['documento'];

//print_r($ct['etc']['documento_json']);

    if( sizeof(  $ct['etc']['documento']['righe'] ) > 0 ){

        $ct['etc']['totale_parziale'] = array();
        $ct['etc']['totale'] = 0;

        foreach(  $ct['etc']['documento']['righe']  as $r ){
            if( !isset($ct['etc']['totale_parziale'][ $r['id_iva'] ]) ){ $ct['etc']['totale_parziale'][ $r['id_iva'] ] = 0;}
            $ct['etc']['totale_parziale'][ $r['id_iva'] ] += $r['importo_netto_totale'];
            $ct['etc']['totale'] += $r['importo_netto_totale'];
        }

    }
    }