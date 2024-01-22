<?php

    /**
     * macro form categorie risorse
     *
     *
     *
     * @todo documentare
     * @todo filtrare la tendina dei gruppi in base all'account connesso
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'tipologie_contratti';

    // generazione nuovo prodotto
    if( isset( $_REQUEST[ $ct['form']['table'] ]['__crea_prodotto__'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['__crea_prodotto__'] ) ) {

        // debug
        // die('creazione rapida prodotto');

        // ID della todo in oggetto
        $idTipologia = $_REQUEST[ $ct['form']['table'] ]['id'];

        $tipologia = mysqlSelectRow($cf['mysql']['connection'],
            'SELECT * FROM ' . $ct['form']['table'] . '_view WHERE id = ?',           
            array(
                array( 's' => $idTipologia )
            )
        );

        $idProdotto = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => 'TESS.'.sprintf( '%04d', $idTipologia ),
                'id_tipologia' => 1,
                'nome' => $tipologia['nome']
            ),
            'prodotti'
        );

        mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => $idTipologia,
                'id_prodotto' => $idProdotto
            ),
            $ct['form']['table']
        );

        $_REQUEST[ $ct['form']['table'] ]['id_prodotto'] = $idProdotto;

    }

    // se è associato un prodotto
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_prodotto'] ) ) {

		// tendina prodotto
		$ct['etc']['select']['prodotti'] = mysqlCachedIndexedQuery(
			$cf['memcache']['index'],
			$cf['memcache']['connection'],
			$cf['mysql']['connection'],
			'SELECT id, __label__ FROM prodotti_view WHERE id = ?',
		    array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_prodotto'] ) )
		);

        // tendina tipologia tesseramento
        $ct['etc']['select']['tipologie_rinnovi'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM tipologie_rinnovi_view WHERE se_tesseramenti = 1'
        );

        // tendina tipologia abbonamento
        $ct['etc']['select']['periodicita'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM periodicita_view ORDER BY giorni ASC'
        );

        // tendina tipologia abbonamento
        $ct['etc']['select']['reparti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM reparti_view'
        );

        // tabella della vista
        $ct['view']['table'] = 'articoli';

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'ean' => 'ean',
            'id_prodotto' => 'id_prodotto',
            'tipologia_rinnovo' => 'rinnovo',
            'nome' => 'articolo',
            'prezzi' => 'prezzi'
        );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'text-left',
            'nome' => 'text-left',
            'id_prodotto' => 'd-none'
        );

        $ct['etc']['select']['periodi'] = array(
            array( 'id' => 'totale', '__label__' => 'totale' ),
            array( 'id' => 'quadrimestrale', '__label__' => 'quadrimestrale' ),
            array( 'id' => 'trimestrale', '__label__' => 'trimestrale' ),
            array( 'id' => 'bimestrale', '__label__' => 'bimestrale' ),
            array( 'id' => 'mensile', '__label__' => 'mensile' ),
            array( 'id' => 'settimanale', '__label__' => 'settimanale' ),
            array( 'id' => 'giornata', '__label__' => 'giornata' )
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
        // TODO il prodotto non va più selezionato in base al campo, ma al metadato (vedi abbonamenti e tesseramenti)
        $ct['view']['__restrict__']['id_prodotto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id_prodotto'];

        // inserimento rapido articolo e prezzo
        $ct['etc']['include']['insert'][] = array(
            'name' => 'insert',
            'file' => 'inc/tipologie.tesseramenti.form.acquisto.insert.html',
            'fa' => 'fa-plus-circle'
        );

        // gestione default
        require DIR_SRC_INC_MACRO . '_default.view.php';

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
