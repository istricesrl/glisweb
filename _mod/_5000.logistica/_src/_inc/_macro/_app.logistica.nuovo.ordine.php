<?php

    /**
     * macro dashboard
     *
     *
     *
     *
     * @todo implementare
     * @todo documentare
     *
     * @file
     *
     */

    $_SESSION['account']['id'] = 1;

    $ct['form']['table'] = 'documenti';

    $ct['view']['data']['__report_mode__'] = 1;

    // tabella della vista
    $ct['view']['table'] = '__report_giacenza_magazzini__';

    $ct['view']['cols'] = array(
        'id' => '#',
        'id_prodotto' => 'id_prodotto',
        'prodotto' => 'prodotto',
        'id_articolo' => 'codice',
        'articolo' => 'descrizione',
        'categorie' => 'categoria',
        'carico' => 'carico',
        'scarico' => 'scarico',
        'totale' => 'totale',
        'peso' => 'peso',
        'sigla_udm_peso' => 'udm peso'
    );

    $ct['view']['__restrict__']['id']['EQ'] = 2;

    // dati per tendine ed elenco
    // elenco prodotti disponibili
    /*$ct['etc']['prodotti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT * FROM prodotti_view'
	);*/
    // tipologia ordine
    $ct['etc']['default_tipologia'] = mysqlSelectCachedValue(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id FROM tipologie_documenti WHERE nome = "ordine"'
	);

    $ct['etc']['default_mastro'] = mysqlSelectCachedValue(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id FROM mastri WHERE nome = "ordini da evadere"'
	);

    // elenco udm
    $ct['etc']['select']['udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT * FROM udm_view WHERE se_massa = 1 OR se_quantita = 1 OR se_volume = 1'
	);

    // eliminazione ordine
    if( isset( $_REQUEST['__delete__']['documenti'] )   ){
    
            $del = mysqlQuery(  $cf['mysql']['connection'],
            'DELETE FROM documenti_articoli WHERE id_documento = ?',
            array( array( 's' => $_REQUEST['__delete__']['documenti']['id'] ) ) );
    
            $del = mysqlQuery(  $cf['mysql']['connection'],
            'DELETE FROM documenti WHERE id = ?',
            array( array( 's' => $_REQUEST['__delete__']['documenti']['id'] ) ) );
    }

    // verifico se è presente uno scontrino aperto
    if( !isset( $_REQUEST[ $ct['form']['table'] ]) && isset( $_SESSION['account'] )  ){ 
             $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow(  $cf['mysql']['connection'],
             'SELECT * FROM documenti WHERE id_account_inserimento = ? AND timestamp_chiusura IS NULL AND id_tipologia = ?',
             array( array( 's' => $_SESSION['account']['id'] ), array( 's' => $ct['etc']['default_tipologia'] ) ) );
    }
    

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id']) && isset($_REQUEST['__action__']) & isset($_REQUEST['__p__']) && isset($_REQUEST['__qta__']) && isset($_REQUEST['__udm__']) ){

        if( $_REQUEST['__action__'] == 'add' ){
            $quantita_riga = mysqlSelectValue( 
                $cf['mysql']['connection'], 
                'SELECT quantita FROM documenti_articoli WHERE id_prodotto = ? AND id_documento = ? AND id_udm = ?',
                array( 
                    array( 's' => $_REQUEST['__p__'] ),
                    array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                    array( 's' => $_REQUEST['__udm__'] )
                )
            );
    
            if( $quantita_riga ){
    
                $update = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    "UPDATE documenti_articoli SET quantita = ? WHERE id_prodotto = ? AND id_documento = ? AND id_udm = ?",
                    array( 
                        array( 's' => $quantita_riga + $_REQUEST['__qta__']),
                        array( 's' => $_REQUEST['__p__'] ),
                        array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                        array( 's' => $_REQUEST['__udm__'] )
                    )
                    );
    
            } else {
                $insert = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    "INSERT INTO documenti_articoli ( id_prodotto, id_documento, quantita, id_udm, id_mastro_destinazione, id_tipologia )  VALUES (?, ?, ?, ?, ?, ? )",
                    array( 
                        array( 's' => $_REQUEST['__p__'] ),
                        array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ),
                        array( 's' => $_REQUEST['__qta__'] ),
                        array( 's' => $_REQUEST['__udm__'] ),
                        array( 's' => $ct['etc']['default_mastro'] ),
                        array( 's' => $ct['etc']['default_tipologia'] )
                        
         
                    ) );
            }
        }


        if( $_REQUEST['__action__'] == 'edit' ){
    
                $update = mysqlQuery( 
                    $cf['mysql']['connection'], 
                    "UPDATE documenti_articoli SET quantita = ?, id_udm = ?  WHERE id_prodotto = ? AND id_documento = ? ",
                    array( 
                        array( 's' => $_REQUEST['__qta__']),
                        array( 's' => $_REQUEST['__udm__'] ),
                        array( 's' => $_REQUEST['__p__'] ),
                        array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
                        
                    )
                    );
        }




    }

   if( isset( $_REQUEST[ $ct['form']['table'] ]['id']) ){

        $_REQUEST[ $ct['form']['table'] ]['documenti_articoli'] = mysqlQuery(
            $cf['mysql']['connection'], 
            'SELECT documenti_articoli.*, prodotti.nome AS prodotto, udm.sigla AS sigla_udm   FROM documenti_articoli '.
            'LEFT JOIN prodotti ON prodotti.id = documenti_articoli.id_prodotto  '.
            'LEFT JOIN udm ON udm.id = documenti_articoli.id_udm '.
            'WHERE documenti_articoli.id_documento = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );

   }


    // inclusione modal
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'aggiungi_a_ordine', 'include' => 'inc/aggiungi.a.ordine.modal.html' )
        );

    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'chiudi_ordine', 'include' => 'inc/chiudi.ordine.modal.html' )
    );

    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'modifica_prodotto', 'include' => 'inc/modifica.ordine.modal.html' )
    );

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';

    require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.view.php';
