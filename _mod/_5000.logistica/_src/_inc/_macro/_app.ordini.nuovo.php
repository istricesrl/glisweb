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

    //$_SESSION['account']['id'] = 1;

    $ct['etc']['numero'] = mysqlSelectValue(  
        $cf['mysql']['connection'],          
        'SELECT  coalesce( max( cast( numero as unsigned ) ), 0 ) AS numero FROM documenti '.
        'INNER JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia '.
        'WHERE tipologie_documenti.se_ordine = 1 ') + 1;

    $ct['etc']['azienda'] = mysqlSelectValue(  
        $cf['mysql']['connection'],          
        'SELECT  id FROM anagrafica_view_static '.
        'WHERE se_gestita = 1 ORDER BY id ASC LIMIT 1') ;
    
    if( isset( $_SESSION['account']['id_anagrafica'] ) ){

            $ct['etc']['select']['emittenti'] = mysqlCachedIndexedQuery(
                $cf['memcache']['index'],
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],       
                'SELECT  anagrafica_view_static.id, anagrafica_view_static.__label__ FROM anagrafica_view_static INNER JOIN relazioni_anagrafica ON relazioni_anagrafica.id_anagrafica_collegata = anagrafica_view_static.id WHERE anagrafica_view_static.se_gestita = 1 AND relazioni_anagrafica.id_ruolo = 16 AND relazioni_anagrafica.id_anagrafica = ? UNION SELECT  anagrafica_view_static.id, anagrafica_view_static.__label__ FROM anagrafica_view_static INNER JOIN relazioni_anagrafica ON relazioni_anagrafica.id_anagrafica = anagrafica_view_static.id  WHERE anagrafica_view_static.se_gestita = 1 AND relazioni_anagrafica.id_ruolo = 16 AND relazioni_anagrafica.id_anagrafica_collegata = ?',
                array( array( 's' =>  $_SESSION['account']['id_anagrafica']  ),array( 's' =>  $_SESSION['account']['id_anagrafica']  ) )
            );
    
            if( $ct['etc']['select']['emittenti'] ){
                $ct['etc']['emittente'] =  $ct['etc']['select']['emittenti'][0]['id'];
            }
    
    } 

    $ct['form']['table'] = 'documenti';


    // tabella della vista
    $ct['view']['table'] = '__report_giacenza_magazzini__';

    $ct['view']['cols'] = array(
        'id' => '#',
        'nome' => 'nome',
        'categorie' => 'categorie',
        'totale' => 'totale',
        'prodotto' => 'prodotto',
        'id_prodotto' => 'id_prodotto'   
    );

    $ct['view']['id'] = md5(
        $ct['page']['id'] . $ct['view']['table'] . $_SESSION['__view__']['__site__']
        );

    $ct['view']['data']['__report_mode__'] = 1;

    $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['nome'] = 'ASC';
    $_REQUEST['__view__'][ $ct['view']['id'] ]['__pager__']['rows'] = 20000;

    $ct['view']['__restrict__']['totale']['GE'] = 1;
    $ct['view']['__restrict__']['id']['EQ'] = 2;

    // tipologia ordine
    $ct['etc']['default_tipologia'] = mysqlSelectCachedValue(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id FROM tipologie_documenti WHERE nome = "ordine"'
	);

    $ct['etc']['default_mastro'] = mysqlSelectCachedValue(
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id FROM mastri WHERE nome = "codici da evadere"'
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

    if( !isset( $_REQUEST[ $ct['form']['table'] ]) && isset( $_REQUEST['__documento__'] )  ){ 
        $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow(  $cf['mysql']['connection'],
        'SELECT * FROM documenti WHERE id = ?',
        array( array( 's' => $_REQUEST['__documento__'] ) ) );

    }


    // verifico se è presente uno scontrino aperto
    if( !isset( $_REQUEST[ $ct['form']['table'] ]) && isset( $_SESSION['account'] )  ){ 
             $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow(  $cf['mysql']['connection'],
             'SELECT * FROM documenti WHERE id_account_inserimento = ? AND timestamp_invio IS NULL AND id_tipologia = ?',
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
                    "INSERT INTO documenti_articoli ( id_prodotto, id_documento, quantita, id_udm, id_mastro_provenienza, id_tipologia )  VALUES (?, ?, ?, ?, ?, ? )",
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

