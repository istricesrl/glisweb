<?php
//print_r( $_REQUEST );
    if( isset( $_REQUEST['documenti']['id'] ) && !empty( $_REQUEST['documenti']['id'] ) ){

    $update = mysqlQuery( 
            $cf['mysql']['connection'], 
            'UPDATE documenti SET timestamp_chiusura = ? WHERE id = ?',
            array( 
                array( 's' => time() ), 
                array( 's' => $_REQUEST['documenti']['id'] ) ) );

    $ct['etc']['documento'] = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            'SELECT documenti_view.*, scadenze.id_modalita_pagamento, modalita_pagamento.nome AS modalita_pagamento FROM  documenti_view  '.
            'LEFT JOIN scadenze ON scadenze.id_documento = documenti_view.id '.
            'LEFT JOIN modalita_pagamento ON modalita_pagamento.id = scadenze.id_modalita_pagamento '.
            'WHERE documenti_view.id = ?',
            array( 
                array( 's' => $_REQUEST['documenti']['id'] ) ) );



    $ct['etc']['documento']['righe'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM documenti_articoli_view WHERE id_documento = ?',
        array( array( 's' =>  $_REQUEST['documenti']['id'] ) ) 
	);

    //print_r($ct['etc']['documento']);

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