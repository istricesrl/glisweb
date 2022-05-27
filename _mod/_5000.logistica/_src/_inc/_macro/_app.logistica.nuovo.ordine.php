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

    // elenco udm
    $ct['etc']['udm'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT * FROM udm_view'
	);

    // verifico se è presente uno scontrino aperto
    if( !isset( $_REQUEST[ $ct['form']['table'] ]) && isset( $_SESSION['account'] )  ){ 
             $_REQUEST[ $ct['form']['table'] ] = mysqlSelectRow(  $cf['mysql']['connection'],
             'SELECT * FROM documenti WHERE id_account_inserimento = ? AND timestamp_chiusura IS NULL AND id_tipologia = ?',
             array( array( 's' => $_SESSION['account']['id'] ), array( 's' => $ct['etc']['default_tipologia'] ) ) );
    }
    
    // eliminazione ordine
    if( isset( $_REQUEST['__delete__'] ) ){
    
            $del = mysqlQuery(  $cf['mysql']['connection'],
            'DELETE FROM documenti_articoli WHERE id_documento = ?',
            array( array( 's' => $_REQUEST['__delete__']['documenti']['id'] ) ) );
    
            $del = mysqlQuery(  $cf['mysql']['connection'],
            'DELETE FROM documenti WHERE id = ?',
            array( array( 's' => $_REQUEST['__delete__']['documenti']['id'] ) ) );
    }
    
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // inclusione modal
    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'aggiungi_ordine', 'include' => 'inc/aggiungi.a.ordine.modal.html' )
        );

    $ct['page']['contents']['metro'][NULL][] = array(
            'modal' => array( 'id' => 'rimuovi_prodotto', 'include' => 'inc/rimuovi.da.ordine.modal.html' )
        );

    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'chiudi_ordine', 'include' => 'inc/chiudi.ordine.modal.html' )
    );

    $ct['page']['contents']['metro'][NULL][] = array(
        'modal' => array( 'id' => 'cancella_ordine', 'include' => 'inc/cancella.ordine.modal.html' )
    );

    // macro per l'apertura dei modal
    require DIR_SRC_INC_MACRO . '_default.tools.php';

    require DIR_SRC_INC_MACRO . '_default.view.php';
