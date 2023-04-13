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
        die('creazione rapida prodotto');

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
        // TODO il prodotto non va più selezionato in base al campo, ma al metadato (vedi abbonamenti e tesseramenti)
        $ct['view']['__restrict__']['id_prodotto']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id_prodotto'];

        // inserimento rapido articolo e prezzo
        $ct['etc']['include']['insert'][] = array(
            'name' => 'insert',
            'file' => 'inc/abbonamenti.form.acquisto.insert.html',
            'fa' => 'fa-plus-circle'
        );

        // gestione default
        require DIR_SRC_INC_MACRO . '_default.view.php';

    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
