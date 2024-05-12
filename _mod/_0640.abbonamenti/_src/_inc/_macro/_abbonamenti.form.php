<?php

    /**
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
	$ct['form']['table'] = 'contratti';

    $ct['form']['subtable'] = 'contratti_anagrafica';
/*
    // tendina tesserato
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);
*/
	// tendina per le tipologie di contratto
    $ct['etc']['select']['tipologie_contratti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_abbonamento = 1'
    );

    // tendina badge
	$ct['etc']['select']['badge'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM badge_view'
    );

    // tendina progetti
	$ct['etc']['select']['progetti'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view '
    );

    // tendina progetti
	$ct['etc']['select']['corsi'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM corsi_view '
    );

    // tendina categorie progetti
	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

    // ID della scuola
	$ct['etc']['gestita'] = mysqlSelectCachedValue(
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id FROM anagrafica_view WHERE se_gestita = 1'
	);

	// debug
	// print_r( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
	// print_r( $_REQUEST );

    // ...
    if( isset( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] ) ) {
		arraySortBy( 'data_inizio', $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
		$ct['etc']['sub']['primo_rinnovo'] = array_shift( $_REQUEST[ $ct['form']['table'] ]['rinnovi'] );
	}

	// ...
	// $ct['etc']['sub']['primo_rinnovo']['idx'] = 0;

    // tabella della vista
    $ct['view']['table'] = 'rinnovi';

    $ct['view']['open']['page'] = 'rinnovi.contratti.form';
    $ct['view']['open']['table'] = 'rinnovi';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
    $ct['view']['insert']['page'] = 'rinnovi.contratti.form';
    $ct['view']['insert']['field'] = 'id_contratto';

    // campo per il preset di apertura
    $ct['view']['open']['preset']['field'] = 'id_contratto';

    // campi della vista
    $ct['view']['cols'] = array(
      'id' => '#',
      'data_inizio' => 'data inizio',
      'data_fine' => 'data fine',
      'id_tipologia' => 'id_tipologia',
      'tipologia' => 'tipologia',
        'id_contratto' => 'id_contratto',
      '__label__' => 'contratto',
      NULL => 'azioni'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id_tipologia' => 'd-none',
        'id_contratto' => 'd-none',
      '__label__' => 'text-left no-wrap'
    );

    // preset filtro contratto attuale
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){
        $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // javascript della vista
    $ct['view']['onclick'] = array(
        NULL => 'event.stopPropagation();'
    );

    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/abbonamenti.form.rinnovi.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // tendina tipologia tesseramento
    $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_rinnovi_view WHERE se_abbonamenti = 1'
    );

	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

	// debug
	// print_r( $ct['etc']['sub']['primo_rinnovo'] );
	// print_r( $_REQUEST );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $pagato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT documenti_articoli.id FROM documenti_articoli INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento INNER JOIN pagamenti ON pagamenti.id_documento = documenti.id WHERE id_rinnovo = ? AND pagamenti.timestamp_pagamento IS NOT NULL', array( array( 's' => $row['id'] ) ) );
            if( empty( $pagato ) ) {
                $articolo = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT articoli.id FROM articoli INNER JOIN metadati ON metadati.id_articolo = articoli.id WHERE metadati.nome = "acquisto_rinnovi|id_tipologia" AND metadati.testo = ?', array( array( 's' => $row['id_tipologia'] ) ) );
                if( isset( $_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'] ) ) {
                    $ordinato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT carrelli.id FROM carrelli_articoli INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello WHERE id_articolo = ? AND carrelli_articoli.destinatario_id_anagrafica = ? AND carrelli.session = ?', array( array( 's' => $articolo ), array( 's' => $_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'] ), array( 's' => $cf['session']['id'] ) ) );
                    if( empty( $ordinato ) ) {
                        $row[ NULL ] =  '<a href="#" onclick="$(this).metroWs(\'/task/4170.ecommerce/aggiungi.al.carrello?__carrello__[__articolo__][id_articolo]='.$articolo.'&__carrello__[__articolo__][destinatario_id_anagrafica]='.$_REQUEST[ $ct['form']['table'] ]['contratti_anagrafica'][0]['id_anagrafica'].'\', aggiornaCarrello );"><span class="media-left"><i class="fa fa-cart-plus"></i></span></a>';
                    }
                }
            }
        }
    }

	if( isset( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) ) {

        $idProdotto = mysqlSelectValue(
			$cf['mysql']['connection'],
            'SELECT id_prodotto FROM tipologie_contratti WHERE id = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_tipologia'] ) )
        );

        $ct['etc']['rinnovi_da_pagare'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT rinnovi.*, articoli.id AS id_articolo, format( prezzi.prezzo, 2, "it_IT" ) AS prezzo, tipologie_rinnovi.nome AS tipologia, prezzi.id_iva FROM rinnovi 
            LEFT JOIN documenti_articoli ON documenti_articoli.id_rinnovo = rinnovi.id 
            LEFT JOIN carrelli_articoli ON carrelli_articoli.id_rinnovo = rinnovi.id 
            LEFT JOIN articoli ON articoli.id_prodotto = ? AND articoli.id_tipologia_rinnovo = rinnovi.id_tipologia
            LEFT JOIN prezzi ON prezzi.id_articolo = articoli.id AND prezzi.id_listino = 1
            LEFT JOIN tipologie_rinnovi ON tipologie_rinnovi.id = rinnovi.id_tipologia
            WHERE rinnovi.id_contratto = ? AND documenti_articoli.id IS NULL AND carrelli_articoli.id IS NULL
            GROUP BY rinnovi.id',
            array(
                array( 's' => $idProdotto ),
                array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] )
            )
        );

        // debug
        // print_r( $ct['etc']['rinnovi_da_pagare'] );

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
