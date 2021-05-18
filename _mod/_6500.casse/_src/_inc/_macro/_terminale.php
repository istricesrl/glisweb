<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
     *
     *
     *
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */



    // tabella gestita
	$ct['form']['table'] = 'documenti';

  //  $_REQUEST[ $ct['form']['table'] ]['id'] = 12;

   // print_r($_REQUEST);

    if(  isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST['__art__'] ) && !empty( $_REQUEST['__art__'] ) ){
        
        $_REQUEST[ $ct['form']['table'] ]['__comando__']  = $_REQUEST['__art__'];
        $_REQUEST[ $ct['form']['table'] ]['__operazione__'] = 1;
        $_REQUEST[ $ct['form']['table'] ]['__reparto__'] = 0;
        print_r( "trovato articolo da aggiungere codice ".$_REQUEST[ $ct['form']['table'] ]['__comando__'] );
    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['__comando__'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['__comando__']  ) ){

        // verifico se si tratta di un articolo
        if( true ){

            // verifico se esiste l'atricolo e se ha un prezzo associato
            $articolo = mysqlSelectRow(
                $cf['mysql']['connection'],
#                'SELECT * FROM articoli LEFT JOIN prezzi ON prezzi.id_articolo = articoli.id AND prezzi.id_listino = ? WHERE articoli.id = ? LIMIT 1',
#                array( array( 's' => 1 ), array( 's' => '`'.$_REQUEST[ $ct['form']['table'] ]['__comando__'].'`' ) )
                "SELECT * FROM articoli LEFT JOIN prezzi ON prezzi.id_articolo = articoli.id AND prezzi.id_listino = 1 WHERE articoli.id = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\" LIMIT 1"
                );

            if( $articolo ){    

                if( $_REQUEST[ $ct['form']['table'] ]['__reparto__'] == 0 ){ $reparto = $articolo['id_reparto']; }
                else { $reparto = $_REQUEST[ $ct['form']['table'] ]['__reparto__']; }

                if( $reparto > 0 ){

                // verifico se l'articolo è già nel documento
                $in_doc = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    "SELECT * FROM documenti_articoli  WHERE  id_articolo = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\" "
                );

                if( $in_doc ){
                    
                    if( $in_doc['quantita'] == 1 && $_REQUEST[ $ct['form']['table'] ]['__operazione__'] == '-1' ){

                        $delete = mysqlQuery( 
                            $cf['mysql']['connection'], 
                            'DELETE FROM documenti_articoli WHERE id = ?',
                            array( array( 's' => $in_doc['id'] ) ) );

                    } else {

                        $update = mysqlQuery( 
                            $cf['mysql']['connection'], 
                            'UPDATE documenti_articoli SET quantita = ? WHERE id = ?',
                            array( 
                                array( 's' => $in_doc['quantita'] + $_REQUEST[ $ct['form']['table'] ]['__operazione__'] ), 
                                array( 's' => $in_doc['id'] ) ) );
                    }


                } elseif ( $_REQUEST[ $ct['form']['table'] ]['__operazione__'] != '-1' ) {
                    $insert = mysqlQuery( 
                                $cf['mysql']['connection'], 
                                "INSERT INTO documenti_articoli ( id_articolo, id_documento, data_lavorazione, importo_netto_totale, quantita, id_reparto )  VALUES ( \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\", ?, ?, ?, 1, ? )",
                                array( 
                                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                                    array( 's' => date("Y-m-d") ),
                                    array( 's' => $articolo['prezzo'] ),
                                    array( 's' => $reparto )
                                ) );
                }
            }

            }
        }


    }

    // tendina tipologie documenti
	$ct['etc']['select']['tipologie_documenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_documenti_view'
	);

    // tendina tipologie documenti
	$ct['etc']['select']['operazioni'] = array(
            array( 'id' => '1', '__label__' => '&#xf067;' ),
            array( 'id' => '-1', '__label__' => '&#xf068;' )
	);

    // tendina  anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

    // tendina  reparti
	$ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM reparti_view'
	);

    $ct['etc']['select']['reparti'][] = array( 'id' => '0', '__label__' => 'default' );

    // articoli recenti
	$ct['etc']['articoli_frequenti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT articoli_view.id, articoli_view.__label__, contenuti.testo FROM articoli_view '.
        'LEFT JOIN contenuti ON contenuti.id_articolo = articoli_view.id AND contenuti.id_lingua = 1'
	);
    
    // id emittente
	$ct['etc']['id_emittente'] = mysqlSelectValue(
	    $cf['mysql']['connection'],
	    'SELECT id FROM anagrafica_view WHERE se_azienda_gestita = 1 LIMIT 1'
	);
    
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] )  ){
   // righe del documento
	$ct['etc']['righe'] = mysqlQuery(
	    $cf['mysql']['connection'],
	    'SELECT * FROM documenti_articoli_view WHERE id_documento = ?',
        array( array( 's' =>  $_REQUEST[ $ct['form']['table'] ]['id'] ) ) 
	);


    if( sizeof( $ct['etc']['righe'] ) > 0 ){

        $ct['etc']['totale_parziale'] = array();
        $ct['etc']['totale'] = 0;

        foreach( $ct['etc']['righe'] as $r ){
            if( !isset($ct['etc']['totale_parziale'][ $r['id_iva'] ]) ){ $ct['etc']['totale_parziale'][ $r['id_iva'] ] = 0;}
            $ct['etc']['totale_parziale'][ $r['id_iva'] ] += $r['importo_netto_totale'];
            $ct['etc']['totale'] += $r['importo_netto_totale'];
        }

    }

}