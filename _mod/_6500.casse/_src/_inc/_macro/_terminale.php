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
     if( isset( $_REQUEST['__close__'] ) && !empty($_REQUEST['__close__'] ) ){

        $update = mysqlQuery( 
            $cf['mysql']['connection'], 
            'UPDATE documenti SET timestamp_chiusura = ? WHERE id = ?',
            array( 
                array( 's' => time() ), 
                array( 's' => $_REQUEST['__close__'] ) ) );

     }


   
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'genera_matricola', 'include' => 'inc/ritiro.hardware.modal.html' )
        );

    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'crea_attivita', 'include' => 'inc/creazione.attivita.modal.html' )
        );

    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'carico_ore', 'include' => 'inc/carico.ore.mastro.todo.html' )
        );

    // mastro di carico [magazzino]
    $ct['etc']['mastro'] =  mysqlSelectValue(  $cf['mysql']['connection'],
    'SELECT id FROM mastri WHERE nome = "area espositiva"');
    // mastro di carico attivta[magazzino]
    $ct['etc']['mastro_attivita'] = NULL;

    // tabella gestita
	$ct['form']['table'] = 'documenti';

    $ct['etc']['default_listino'] = 1;
    $ct['etc']['default_reparto'] = '0';
    $ct['etc']['default_operazione'] = '1';
    $ct['etc']['default_tipologia'] = mysqlSelectValue(  $cf['mysql']['connection'],
                                    'SELECT id FROM tipologie_documenti WHERE nome = "scontrino"');

    $ct['etc']['id_tipologia_carico'] = mysqlSelectValue(  $cf['mysql']['connection'],
                                    'SELECT id FROM tipologie_attivita WHERE nome = "carico"');
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

    } elseif( !isset( $_REQUEST[ $ct['form']['table'] ]) && isset( $_SESSION['account'] )  ){ 

       // if( isset($_REQUEST[ $ct['form']['table'] ]) && !$_REQUEST[ $ct['form']['table'] ]['id'] ){ 
        // verifico se l'account ha uno scontrino in sospeso
        $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow(  $cf['mysql']['connection'],
        'SELECT * FROM documenti WHERE id_account_inserimento = ? AND timestamp_chiusura IS NULL AND id_tipologia = ?',
        array( array( 's' => $_SESSION['account']['id'] ), array( 's' => $ct['etc']['default_tipologia'] ) ) );
        
    }



    // tendina  reparti
	$ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM reparti_view'
	);

    $ct['etc']['select']['reparti'][] = array( 'id' => '0', '__label__' => 'default' );



    if( isset( $_REQUEST[ $ct['form']['table'] ]['__comando__'] ) ){
        $_REQUEST[ $ct['form']['table'] ]['__comando__'] = trim(  $_REQUEST[ $ct['form']['table'] ]['__comando__'] );
    }

    if(  isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST['__art__'] ) && !empty( $_REQUEST['__art__'] ) ){
        
        $_REQUEST[ $ct['form']['table'] ]['__comando__']  = $_REQUEST['__art__'];
        $_REQUEST[ $ct['form']['table'] ]['__operazione__'] = 1;
        $_REQUEST[ $ct['form']['table'] ]['__reparto__'] = 0;
    }

    if(  isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST['__cpon__'] ) && !empty( $_REQUEST['__cpon__'] ) ){
        
        $_REQUEST[ $ct['form']['table'] ]['__comando__']  = $_REQUEST['__cpon__'];
        $_REQUEST[ $ct['form']['table'] ]['__operazione__'] = 1;
        $_REQUEST[ $ct['form']['table'] ]['__reparto__'] = 0;
    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['__comando__'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['__comando__']  ) ){

        $comando = explode( '.', $_REQUEST[ $ct['form']['table'] ]['__comando__'] );
        //print_r($_REQUEST[ $ct['form']['table'] ]['__comando__']);
        // verifico se si tratta di un articolo
        if( $comando[0] == 'TRCKG' ){
            // gestisco il codice di tracking

            /*$insert = mysqlQuery( 
                $cf['mysql']['connection'], 
                "INSERT INTO contatti ( nome, id_campagna )  VALUES ( ?, ? )",
                array( 
                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                    array( 's' => date("Y-m-d") )
                ) );*/
            //print_r('tracking');
        } elseif( $comando[0] == 'CPON'){
            // gestisco il coupon
            $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * FROM documenti_articoli_view WHERE documenti_articoli_view.id_documento = ?',
                array( array( 's' =>  $_REQUEST[ $ct['form']['table'] ]['id'] ) ) 
            );
        
            $_REQUEST[ $ct['form']['table'] ]['coupon'] = $_REQUEST[ $ct['form']['table'] ]['__comando__']; 
            // controllo validità e valore coupon


            //print_r($_REQUEST[ $ct['form']['table'] ]);
            //
            $ct['etc']['sconto'] = calcolaCoupon( $cf['mysql']['connection'], array(),   $_REQUEST[ $ct['form']['table'] ] );

                mysqlQuery($cf['mysql']['connection'], 'UPDATE documenti SET coupon = ? WHERE id = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['coupon']), array('s' => $_REQUEST['documenti']['id']) ) );


            //print_r('coupon');
        } elseif( $comando[0] == 'TODO' ){
            // la todo

            $ct['etc']['todo'] =  mysqlSelectRow( $cf['mysql']['connection'], 'SELECT * FROM todo_completa_view WHERE id = ? ', array( array( 's' => str_replace('0', '', $comando[1]) ) ));
           
            // attività concluse della todo
            $ct['etc']['attivita_todo'] = mysqlQuery( $cf['mysql']['connection'], 'SELECT * FROM attivita_view_static WHERE id_todo = ? AND data_attivita IS NOT NULL ORDER BY data_attivita', array( array( 's' => str_replace('0', '', $comando[1]) ) ));

            $ct['etc']['mastro_attivita'] = mysqlSelectValue ( $cf['mysql']['connection'], 'SELECT id_mastro_attivita_default FROM todo WHERE id = ?', array( array( 's' => str_replace('0', '', $comando[1]) ) ));

            echo '<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script><script type="text/javascript">
            $(document).ready(function(){
                $("#todo_id").val('.$comando[1].');
                $("#carico_ore").modal("show");
             });</script>';

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
                case 'CMD.OPZ.0004':
                    $ct['etc']['default_operazione'] = '0';
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
                 //   $ct['etc']['default_tipologia'] = $ct['etc']['default_tipologia'];
                } else {
                   /* $ct['etc']['default_tipologia'] = mysqlSelectValue(  $cf['mysql']['connection'],
                                    'SELECT id FROM tipologie_documenti WHERE nome = "fattura"');*/
                }
            }

        } else{
            //print_r('articolo');
            // verifico se esiste l'atricolo e se ha un prezzo associato
            $articolo = mysqlSelectRow(
                $cf['mysql']['connection'],
                "SELECT articoli_view.*, prezzi.prezzo FROM articoli_view LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id AND prezzi.id_listino = ? WHERE articoli_view.id = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\" LIMIT 1"
                , array( array('s' => $ct['etc']['default_listino'])  ) );

            if( empty( $articolo )){
                // verifico se esiste l'atricolo associato all'ean  e se ha un prezzo associato
                $articolo = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    "SELECT articoli_view.*, prezzi.prezzo FROM articoli_view LEFT JOIN prezzi ON prezzi.id_articolo = articoli_view.id AND prezzi.id_listino = ? WHERE articoli_view.codice_produttore = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\" LIMIT 1"
                    , array( array('s' => $ct['etc']['default_listino'])  ) );

                
                    $_REQUEST[ $ct['form']['table'] ]['__comando__'] = $articolo['id'];

            }

            if( !empty($articolo) ){    

                if( $articolo['se_servizio'] == 1 ){
                    $ct['etc']['mastro'] =  mysqlSelectValue(  $cf['mysql']['connection'],
                    'SELECT id FROM mastri WHERE nome = "codici da lavorare"');
                } 


                if( $_REQUEST[ $ct['form']['table'] ]['__reparto__'] == 0 ){ $reparto = $articolo['id_reparto']; }
                else { $reparto = $_REQUEST[ $ct['form']['table'] ]['__reparto__']; }

                if( $reparto > 0 ){

                // verifico se l'articolo è già nel documento
                $in_doc = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    "SELECT * FROM documenti_articoli  WHERE  id_articolo = \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\"  AND id_documento = ?",
                    array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id']  ) )
                );

                if( $in_doc && !$articolo['se_matricola'] ){
                 //   print_r("articolo presente nel documento modifico la quantità ".$_REQUEST[ $ct['form']['table'] ]['__operazione__']);
                    
                    if( ( $in_doc['quantita'] == 1 && $_REQUEST[ $ct['form']['table'] ]['__operazione__'] == '-1') || $_REQUEST[ $ct['form']['table'] ]['__operazione__'] == '0' ){

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
                    
                                $insert = $in_doc['id'];
                     }

                 

                } elseif ( $_REQUEST[ $ct['form']['table'] ]['__operazione__'] != '-1' ) {

                 //   print_r("articolo NON presente nel documento lo aggiungo");

                    $id_iva = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id_iva FROM reparti WHERE id = ?', array( array( 's' => $reparto ) ) );

                    $insert = mysqlQuery( 
                                $cf['mysql']['connection'], 
                                "INSERT INTO documenti_articoli ( id_articolo, id_listino, id_todo, id_progetto, id_documento, data_lavorazione, importo_netto_totale, quantita, id_reparto, id_iva, id_udm, id_mastro_provenienza, id_tipologia )  VALUES ( \"".$_REQUEST[ $ct['form']['table'] ]['__comando__']."\", ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )",
                                array( 
                                    array( 's' => $ct['etc']['default_listino'] ),
                                    array( 's' => ( isset( $_REQUEST['__todo__']) && !empty($_REQUEST['__todo__'])  ?  $_REQUEST['__todo__'] : NULL ) ),
                                    array( 's' => ( isset( $_REQUEST['__progetto__']) && !empty($_REQUEST['__progetto__'])  ?  $_REQUEST['__progetto__'] : NULL ) ),
                                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                                    array( 's' => date("Y-m-d") ),
                                    array( 's' => $articolo['prezzo']  ), 
                                    array( 's' => ( isset( $_REQUEST['__qta__']) ?  $_REQUEST['__qta__'] : 1 ) ), 
                                    array( 's' => $reparto ),
                                    array( 's' => $id_iva ),
                                    array( 's' => $articolo['id_udm'] ),
                                    array( 's' => $ct['etc']['mastro'] ),
                                    array( 's' => $ct['etc']['default_tipologia'] )
                                ) );


                    if( !empty( $insert ) && array_key_exists( 'documenti_articoli', $_SESSION['account']['id_gruppi_attribuzione'] ) && isset( $_SESSION['account']['id_gruppi_attribuzione']['documenti_articoli'][0] ) ){

                        $acl = mysqlQuery( 
                            $cf['mysql']['connection'], 
                            'INSERT INTO __acl_documenti_articoli__ ( id_entita, id_gruppo, permesso ) VALUES ( ?, ?, ? )', 
                            array( array( 's' => $insert ), array( 's' => $_SESSION['account']['id_gruppi_attribuzione']['documenti_articoli'][0] ), array( 's' => 'FULL' )  ) );

                    } 
                }
            }

            if( $articolo['se_ore']  && isset( $insert ) && $insert > 0 && !isset( $_REQUEST['__ore__'] ) ){
                $ct['etc']['id_riga'] = $insert;
                echo '
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script><script type="text/javascript">
                $(document).ready(function(){
                    $("#id_documenti_articoli").val('.  $insert  .');
                    $("#crea_attivita").modal({
                        backdrop: "static",
                        keyboard: false
                      });

                    $("#crea_attivita").modal("show");

                });
            </script>';
            }

            if(  isset( $insert ) && $insert > 0 && isset( $_REQUEST['__ore__'] ) ){
                $insert_a = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    "INSERT INTO attivita ( nome, data_attivita, ore, id_mastro_destinazione, id_documenti_articoli, id_cliente, id_todo, id_progetto, id_tipologia )  VALUES ( ?,?,?,?, ?, ?, ?, ?, ?)",
                    array( 
                        array( 's' => 'carico ore da scontrino '.$_REQUEST[ $ct['form']['table'] ]['id'] ),
                        array( 's' => date("Y-m-d") ),
                        array( 's' => $_REQUEST['__ore__'] ),
                        array( 's' => $_REQUEST['__mastro__']),
                        array( 's' => $insert ),
                        array( 's' => $_REQUEST['__cliente__'] ),
                        array( 's' => $_REQUEST['__todo__'] ),
                        array( 's' => $_REQUEST['__progetto__'] ),
                        array( 's' => $ct['etc']['id_tipologia_carico'] )
                    ) );

                    if( empty($_REQUEST['documenti']['id_destinatario']) && isset($_REQUEST['__cliente__']) && !empty($_REQUEST['__cliente__']) ){
                        mysqlQuery($cf['mysql']['connection'], 'UPDATE documenti SET id_destinatario = ? WHERE id = ?',
                        array( array( 's' => $_REQUEST['__cliente__']), array('s' => $_REQUEST['documenti']['id']) ) );
                        $_REQUEST['documenti']['id_destinatario'] = $_REQUEST['__cliente__'];
                    } 

                    if( isset( $_SESSION['account']['id_gruppi_attribuzione']['attivita'] ) ){
                        $acl = mysqlQuery( 
                            $cf['mysql']['connection'], 
                            'INSERT INTO __acl_attivita__ ( id_entita, id_gruppo, permesso ) VALUES ( ?, ?, ? )', 
                            array( array( 's' => $insert_a ), array( 's' => $_SESSION['account']['id_gruppi_attribuzione']['attivita'][0] ), array( 's' => 'FULL' )  ) );
    
                    }
                   
                    mysqlQuery( $cf['mysql']['connection'],  'CALL attivita_view_static( ? )', array( array( 's' => $insert_a  ) ) );
                    logWrite( 'aggiornata view statica anagrafica per id #' .$insert_a , 'speed' );
            }

            if( $articolo['se_matricola'] && isset( $insert ) && $insert > 0){
                $ct['etc']['id_riga'] = $insert;
                echo '
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script><script type="text/javascript">
                $(document).ready(function(){
                    $("#id_riga").val('.  $insert  .');
                    $("#close_matricola").hide();
                    $("#barcode_matricola").removeAttr("hidden");
                    $("#legenda_1").removeAttr("hidden");
                    $("#legenda_2").removeAttr("hidden");
                    $("#elimina_articolo").removeAttr("hidden");
                    $("#annulla_matricola").hide();
                    $("#matricole_barcode").prop("autofocus");
                    $("#genera_matricola").modal({
                        backdrop: "static",
                        keyboard: false
                      });

                    $("#genera_matricola").modal("show");

                });
            </script>';
              }

            }
        }


    }

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] )  ){

        if( isset( $_REQUEST['__del_cpon__'] ) ){
            $update = mysqlQuery( 
                $cf['mysql']['connection'], 
                'UPDATE documenti SET coupon = NULL WHERE id = ?',
                array( 
                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) );

        $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow(  $cf['mysql']['connection'],
        'SELECT * FROM documenti WHERE id = ? ',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) );

                 
         }
        // righe del documento
         $ct['etc']['righe'] = mysqlQuery(
             $cf['mysql']['connection'],
             'SELECT documenti_articoli_view.*, attivita.id as id_attivita, attivita.ore, progetti.nome AS progetto FROM documenti_articoli_view '.
             'LEFT JOIN attivita ON attivita.id_documenti_articoli = documenti_articoli_view.id '.
             'LEFT JOIN progetti ON progetti.id = attivita.id_progetto '
             .'WHERE documenti_articoli_view.id_documento = ?',
             array( array( 's' =>  $_REQUEST[ $ct['form']['table'] ]['id'] ) ) 
         );
     


         if( sizeof( $ct['etc']['righe'] ) > 0 ){
     
             $ct['etc']['totale_parziale'] = array();
             $ct['etc']['totale'] = 0;
     
             foreach( $ct['etc']['righe'] as $r ){
                 if( !isset($ct['etc']['totale_parziale'][ $r['id_iva'] ]) ){ $ct['etc']['totale_parziale'][ $r['id_iva'] ] = 0;}
                 $ct['etc']['totale_parziale'][ $r['id_iva'] ] += $r['importo_netto_totale'] * $r['quantita'];
                 $ct['etc']['totale'] += $r['importo_netto_totale'] * $r['quantita'];
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
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) && isset( $_REQUEST[ $ct['form']['table'] ]['coupon'] ) && (!isset($ct['etc']['sconto']) || empty($ct['etc']['sconto']))  ){
        
        $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] = $ct['etc']['righe'];
        $ct['etc']['sconto'] = calcolaCoupon( $cf['mysql']['connection'], array(),   $_REQUEST[ $ct['form']['table'] ] );
       
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
            array( 'id' => '1', '__label__' => 'aggiungi' ),
            array( 'id' => '-1', '__label__' => 'togli' ),
            array( 'id' => '0', '__label__' => 'elimina' )
	);

    // tendina  anagrafica
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

    // tendina  anagrafica
	$ct['etc']['select']['id_articoli'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, id AS __label__ FROM articoli_view'
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
	    'SELECT id FROM anagrafica_view WHERE se_gestita = 1 LIMIT 1'
	);
    


if( !isset( $_REQUEST['documenti']['scadenze'] ) && isset( $_REQUEST['documenti']['id']) ){

            $_REQUEST['documenti']['scadenze'] = mysqlQuery(
                $cf['mysql']['connection'],
                "SELECT * FROM scadenze_view  WHERE id_documento = ?", array( array( 's' =>  $_REQUEST['documenti']['id'] ) )
                );
        
        }



    if( isset( $_SESSION['assistenza']['id_cliente'] ) ){

             // tendina clienti
        $ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static WHERE id = ? ', array( array( 's' => $_SESSION['assistenza']['id_cliente'] ) ) );

    	$ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE timestamp_chiusura IS NULL AND progetti_view.id_cliente = ? ORDER BY __label__',
             array( array( 's' => $_SESSION['assistenza']['id_cliente'] ) ) );
    
    } else {

   
        // tendina clienti
        $ct['etc']['select']['id_cliente'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, __label__ FROM anagrafica_view_static WHERE se_lead = 1 OR se_cliente = 1 OR se_prospect = 1' );

    	$ct['etc']['select']['id_progetto'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'], 
            'SELECT id, concat( cliente, " | ", __label__ ) AS __label__ FROM progetti_view WHERE timestamp_chiusura IS NULL ORDER BY __label__' );
    
    }

    $ct['etc']['select']['mastri_ore'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'], 
        'SELECT id, __label__ FROM mastri_view WHERE id_tipologia = 3' );

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';

