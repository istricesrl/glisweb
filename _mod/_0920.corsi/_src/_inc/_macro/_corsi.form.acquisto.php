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

    // generazione nuovo prodotto
    if( isset( $_REQUEST[ $ct['form']['table'] ]['__crea_prodotto__'] ) && ! empty( $_REQUEST[ $ct['form']['table'] ]['__crea_prodotto__'] ) ) {

        // debug
        // die('creazione rapida prodotto');

        // ID della todo in oggetto
        $idProgetto = $_REQUEST[ $ct['form']['table'] ]['id'];

        $progetto = mysqlSelectRow($cf['mysql']['connection'],
            'SELECT * FROM progetti_view WHERE id = ?',           
            array(
                array( 's' => $idProgetto )
            )
        );

        $idProdotto = mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => $idProgetto,
                'id_tipologia' => 1,
                'nome' => $progetto['nome']
            ),
            'prodotti'
        );

        mysqlInsertRow(
            $cf['mysql']['connection'],
            array(
                'id' => $idProgetto,
                'id_prodotto' => $idProdotto
            ),
            'progetti'
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

        $ct['etc']['select']['periodi'] = array(
            array( 'id' => 'totale', '__label__' => 'totale' ),
            array( 'id' => 'quadrimestrale', '__label__' => 'quadrimestrale' ),
            array( 'id' => 'trimestrale', '__label__' => 'trimestrale' ),
            array( 'id' => 'bimestrale', '__label__' => 'bimestrale' ),
            array( 'id' => 'mensile', '__label__' => 'mensile' ),
            array( 'id' => 'settimanale', '__label__' => 'settimanale' ),
            array( 'id' => 'giornata', '__label__' => 'giornata' )
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

    }

	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // debug
    // print_r( strtotime("2022-07-01T15:56") );
