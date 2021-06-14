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

    // eliminazione scontrino in sospeso
    if( isset( $_REQUEST['__delete__'] ) ){

        $del = mysqlQuery(  $cf['mysql']['connection'],
        'DELETE FROM documenti_articoli WHERE id_documento = ?',
        array( array( 's' => $_REQUEST['__delete__']['documenti']['id'] ) ) );

        $del = mysqlQuery(  $cf['mysql']['connection'],
        'DELETE FROM documenti WHERE id = ?',
        array( array( 's' => $_REQUEST['__delete__']['documenti']['id'] ) ) );
    }

    // riapertura scontrino prima della stampa
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST['__open__'] ) ){
        $update = mysqlQuery( 
            $cf['mysql']['connection'], 
            'UPDATE documenti SET timestamp_chiusura = NULL WHERE id = ?',
            array( 
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) );

    } elseif( isset( $_SESSION['account'] )  ){ 

       // if( isset($_REQUEST[ $ct['form']['table'] ]) && !$_REQUEST[ $ct['form']['table'] ]['id'] ){ 
        // verifico se l'account ha uno scontrino in sospeso
        $_REQUEST[ $ct['form']['table'] ]['id'] = mysqlSelectValue(  $cf['mysql']['connection'],
        'SELECT id FROM documenti WHERE id_account_inserimento = ? AND timestamp_chiusura IS NULL',
        array( array( 's' => $_SESSION['account']['id'] ) ) );
        
    }

    $ct['etc']['default_reparto'] = '0';
    $ct['etc']['default_operazione'] = '1';
    $ct['etc']['default_tipologia'] = mysqlSelectValue(  $cf['mysql']['connection'],
                                    'SELECT id FROM tipologie_documenti WHERE nome = "scontrino"');

    // tendina  reparti
	$ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM reparti_view'
	);

    $ct['etc']['select']['reparti'][] = array( 'id' => '0', '__label__' => 'default' );



    

    if(  isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST['__art__'] ) && !empty( $_REQUEST['__art__'] ) ){
        
        $_REQUEST[ $ct['form']['table'] ]['__comando__']  = $_REQUEST['__art__'];
        $_REQUEST[ $ct['form']['table'] ]['__operazione__'] = 1;
        $_REQUEST[ $ct['form']['table'] ]['__reparto__'] = 0;
    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['__comando__'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['__comando__']  ) ){

        $comando = explode( '.', $_REQUEST[ $ct['form']['table'] ]['__comando__'] );
        //print_r($_REQUEST[ $ct['form']['table'] ]['__comando__']);
        // verifico se si tratta di un articolo
        if( $comando[0] == 'TRCKG' ){
            // gestisco il codice di tracking
            //print_r('tracking');
        } elseif( $comando[0] == 'CPON'){
            // gestisco il coupon
            //print_r('coupon');
        } elseif( $comando[0] == 'TODO' ){
            // la todo
            //print_r('coupon');
        } elseif( $comando[0] == 'DOC' ){
            // apro la pagina di gestione del documento
            header("Location: ".$cf['contents']['pages']['documenti.form']['url'][ $cf['localization']['language']['ietf'] ].'?documenti[id]='.str_replace('0', '', $comando[1]) );
            exit;
        } elseif( $comando[0] == 'CMD' ){
            // gestisco il comando rapido

            // comando aggiungi/rimuovi articolo
            if( $comando[1] == 'OPZ' ){
            switch( $_REQUEST[ $ct['form']['table'] ]['__comando__'] ){
                case 'CMD.OPZ.0001':
                    $ct['etc']['default_operazione'] = '1';
                    break;
                case 'CMD.OPZ.0002':
                    $ct['etc']['default_operazione'] = '-1';
                    break;
                case 'CMD.OPZ.0003':
                    //print_r($cf['contents']['pages']['anteprima.documento']['url'][ $cf['localization']['language']['ietf'] ].'?documenti[id]='.$_REQUEST['documenti']['id'] );
                    header("Location: ".$cf['contents']['pages']['anteprima.documento']['url'][ $cf['localization']['language']['ietf'] ].'?documenti[id]='.$_REQUEST['documenti']['id'] );
                    exit;
                    break;        
                }
            }    

            // comando per modificare il reparto
            if( $comando[1] == 'REP' ){

                foreach(  $ct['etc']['select']['reparti'] as $rep ){
                
                    if( $_REQUEST[ $ct['form']['table'] ]['__comando__'] == 'CMD.REP.000'.$rep['id']  ){
                        $ct['etc']['default_reparto'] = $rep['id'];
                    }

                }

            }

            // comando per modificare la modalità di pagamento
            if( $comando[1] == 'PGM' ){

                if( $_REQUEST[ $ct['form']['table'] ]['__comando__'] == 'CMD.PGM.0001' ){
                    // contanti
                    $_REQUEST[ $ct['form']['table'] ]['scadenze'][0]['id_modalita_pagamento'] = 1;

                } else {
                    // elettronico
                    $_REQUEST[ $ct['form']['table'] ]['scadenze'][0]['id_modalita_pagamento'] = 5;
                }
            }

            if( $comando[1] == 'TPL' ){

                if( $_REQUEST[ $ct['form']['table'] ]['__comando__'] == 'CMD.TPL.000'.$ct['etc']['default_tipologia']  ){
                    $ct['etc']['default_tipologia'] = $ct['etc']['default_tipologia'];
                } else {
                    $ct['etc']['default_tipologia'] = mysqlSelectValue(  $cf['mysql']['connection'],
                                    'SELECT id FROM tipologie_documenti WHERE nome = "fattura"');
                }
            }

        } else{
            //print_r('articolo');
            // verifico se esiste l'atricolo e se ha un prezzo associato
            $articolo = mysqlSelectRow(
                $cf['mysql']['connection'],
                "SELECT * FROM articoli LEFT JOIN prezzi ON prezzi.id_articolo = articoli.id AND prezzi.id_listino = 1 WHERE articoli.id = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\" LIMIT 1"
                );

            if( $articolo ){    

                if( $_REQUEST[ $ct['form']['table'] ]['__reparto__'] == 0 ){ $reparto = $articolo['id_reparto']; }
                else { $reparto = $_REQUEST[ $ct['form']['table'] ]['__reparto__']; }

                if( $reparto > 0 ){

                // verifico se l'articolo è già nel documento
                $in_doc = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    "SELECT * FROM documenti_articoli  WHERE  id_articolo = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\"  AND id_documento = ?",
                    array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id']  ) )
                );

                if( $in_doc ){
                 //   print_r("articolo presente nel documento modifico la quantità ".$_REQUEST[ $ct['form']['table'] ]['__operazione__']);
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

                 //   print_r("articolo NON presente nel documento lo aggiungo");

                    $id_iva = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_iva FROM reparti WHERE id = ?', array( array( 's' => $reparto ) ) );

                    $insert = mysqlQuery( 
                                $cf['mysql']['connection'], 
                                "INSERT INTO documenti_articoli ( id_articolo, id_documento, data_lavorazione, importo_netto_totale, quantita, id_reparto, id_iva, id_udm )  VALUES ( \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\", ?, ?, ?, 1, ?, ?, ? )",
                                array( 
                                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                                    array( 's' => date("Y-m-d") ),
                                    array( 's' => $articolo['prezzo'] ),
                                    array( 's' => $reparto ),
                                    array( 's' => $id_iva ),
                                    array( 's' => $articolo['id_udm'] )
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
	    'SELECT id, __label__ FROM tipologie_documenti_view WHERE nome = "scontrino" OR nome = "fattura" '
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

}