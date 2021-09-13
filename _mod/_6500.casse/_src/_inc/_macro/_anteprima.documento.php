<?php

    // tabella gestita
    // tabella gestita
//$ct['form']['table'] = 'documenti';
//print_r( $_REQUEST );
    if( isset( $_REQUEST['__documenti__']['id'] ) && !empty( $_REQUEST['__documenti__']['id'] ) ){

   /* $update = mysqlQuery( 
            $cf['mysql']['connection'], 
            'UPDATE documenti SET timestamp_chiusura = ? WHERE id = ?',
            array( 
                array( 's' => time() ), 
                array( 's' => $_REQUEST['__documenti__']['id'] ) ) );*/

    $ct['etc']['documento'] = mysqlSelectRow( 
            $cf['mysql']['connection'], 
            'SELECT documenti_view.*, scadenze.id_modalita_pagamento, modalita_pagamento.nome AS modalita_pagamento FROM  documenti_view  '.
            'LEFT JOIN scadenze ON scadenze.id_documento = documenti_view.id '.
            'LEFT JOIN modalita_pagamento ON modalita_pagamento.id = scadenze.id_modalita_pagamento '.
            'WHERE documenti_view.id = ?',
            array( 
                array( 's' => $_REQUEST['__documenti__']['id'] ) ) );



    $ct['etc']['documento']['documenti_articoli'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT documenti_articoli_view.*, attivita.ore, attivita.id_progetto, progetti.nome AS progetto FROM documenti_articoli_view '.
        'LEFT JOIN attivita ON attivita.id_documenti_articoli = documenti_articoli_view.id '.
        'LEFT JOIN progetti ON progetti.id = attivita.id_progetto '.
        'WHERE documenti_articoli_view.id_documento = ?',
        array( array( 's' =>  $_REQUEST['__documenti__']['id'] ) ) 
	);

    if( !empty($ct['etc']['documento']['coupon']) ){
        $ct['etc']['sconto'] = calcolaCoupon( $cf['mysql']['connection'], array(), $ct['etc']['documento'] );
        if( !empty( $ct['etc']['sconto'] ) && $ct['etc']['sconto'] > 0  )  {
            $ct['etc']['documento']['sconto'] = $ct['etc']['sconto'];
        }
       
    
    
    }

   // $barcode = str_pad( $ct['etc']['documento']['id'] ,8,"0", STR_PAD_LEFT);


    if( sizeof(  $ct['etc']['documento']['documenti_articoli'] ) > 0 ){

        $ct['etc']['totale_parziale'] = array();
        $ct['etc']['totale'] = 0;

        foreach(  $ct['etc']['documento']['documenti_articoli']  as &$r ){
            if( !isset($ct['etc']['totale_parziale'][ $r['id_iva'] ]) ){ $ct['etc']['totale_parziale'][ $r['id_iva'] ] = 0;}
            $ct['etc']['totale_parziale'][ $r['id_iva'] ] += $r['importo_netto_totale'] * $r['quantita'];
            $ct['etc']['totale'] += $r['importo_netto_totale'] * $r['quantita'];
            $r['importo'] = number_format($r['importo_netto_totale'] * ( 100.00 + $r['aliquota_iva'] ) /100.00, 2); 
        }
//print_r($ct['etc']['documento']);
        $ct['etc']['totale_iva'] = 0;

        foreach( $ct['etc']['totale_parziale'] as $iva => $tot){

                // tendina  iva
                $ct['etc']['select']['iva'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT aliquota FROM iva_view WHERE id = ?', array( array( 's' => $iva  ) )
                );
            $ct['etc']['totale_iva'] += $ct['etc']['select']['iva'] * $tot /100;
        }
    }
        if(  isset($ct['etc']['sconto']) && ( $ct['etc']['totale'] +  $ct['etc']['totale_iva']  ) <  $ct['etc']['sconto'] ){
            $ct['etc']['sconto'] = $ct['etc']['totale'] +  $ct['etc']['totale_iva'] ;
            $ct['etc']['documento']['sconto'] = $ct['etc']['sconto'];
        }

    }

	// macro di default
	//require DIR_SRC_INC_MACRO . '_default.form.php';
