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

    // tendina tesserato
	$ct['etc']['select']['anagrafica'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM anagrafica_view'
	);

    $ct['etc']['gestita'] = mysqlSelectCachedValue(
		$cf['memcache']['connection'],
		$cf['mysql']['connection'],
		'SELECT id FROM anagrafica_view WHERE se_gestita = 1'
	);

    if( empty( $_REQUEST[ $ct['form']['table'] ]['codice'] ) ) {
        $_REQUEST[ $ct['form']['table'] ]['codice'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT coalesce( max( codice ), 0 ) FROM contratti INNER JOIN tipologie_contratti ON tipologie_contratti.id = contratti.id_tipologia WHERE tipologie_contratti.se_tesseramento IS NOT NULL'
        ) + 1;
    }

    // tendina tipologia tesseramento
    $ct['etc']['select']['tipologia'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_contratti_view WHERE se_tesseramento = 1'
    );

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
        'file' => 'inc/tesseramenti.form.rinnovi.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // tendina tipologia tesseramento
    $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_rinnovi_view WHERE se_tesseramenti = 1'
    );

	$ct['etc']['select']['materie'] = mysqlCachedIndexedQuery(
	    $cf['memcache']['index'],
	    $cf['memcache']['connection'],
	    $cf['mysql']['connection'],
	    'SELECT id, __label__ FROM categorie_progetti_view WHERE se_disciplina = 1'
	);

    // data di fine tesseramento
    // TODO aggiungere se_tesseramenti a tipologie_periodi
    $ct['etc']['data_fine'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT max( data_fine ) FROM periodi WHERE data_inizio <= now()'
    );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // azioni
    foreach( $ct['view']['data'] as &$row ) {
        $pagato = mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM documenti_articoli INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento INNER JOIN pagamenti ON pagamenti.id_documento = documenti.id WHERE id_rinnovo = ? AND pagamenti.data_pagamento IS NOT NULL', array( array( 's' => $row['id'] ) ) );
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

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
