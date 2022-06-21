<?php

    /**
     * macro form progetti produzione tools
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
	$ct['form']['table'] = 'progetti';

    // tabella della vista
	$ct['view']['table'] = 'articoli';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    'nome' => 'articolo',
        'id_prodotto' => 'id_prodotto',
        'ean' => 'ean'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'text-left',
	    'nome' => 'text-left',
        'id_prodotto' => 'd-none'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'articoli.form';
    $ct['view']['open']['table'] = 'articoli';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'articoli.form';

        // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_prodotto';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_prodotto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id_prodotto'];

    // inserimento rapido articolo e prezzo
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/corsi.form.acquisto.insert.html',
        'fa' => 'fa-plus-circle'
    );

         // tendina id_tipologia_pubblicazioni
	$ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
	);

    if( isset($_REQUEST[ $ct['form']['table'] ]['id_prodotto']) ){
        $_REQUEST['prodotti']['pubblicazioni'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM pubblicazioni WHERE id_prodotto = ?',
                array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_prodotto']) )
            );
            
        if($_REQUEST['prodotti']['pubblicazioni']){
            foreach($_REQUEST['prodotti']['pubblicazioni'] as &$p){
                $p['timestamp_inizio'] = date( 'Y-m-d\TH:i', $p['timestamp_inizio'] );
                $p['timestamp_fine'] = date( 'Y-m-d\TH:i', $p['timestamp_fine'] );
                }
        }

    }

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
//print_r( strtotime("2022-07-01T15:56") );
