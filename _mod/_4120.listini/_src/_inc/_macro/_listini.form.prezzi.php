<?php

    /**
     * macro form prodotti prezzi
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
	$ct['form']['table'] = 'listini';

    // tabella della vista
	$ct['view']['table'] = 'prezzi';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'id_listino' => 'ID listino',
        'listino' => 'listino',
        'id_prodotto' => 'prodotto',
        'id_articolo' => 'articolo',
        'articolo' => 'descrizione',
        'prezzo' => 'prezzo',
        'valuta_utf8' => 'valuta',
        'qta_min' => 'q.tà min',
        'qta_max' => 'q.tà max',
	    'data_inizio' => 'valido_dal'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left',
        'id' => 'd-none',
        'valuta_utf8' => 'd-none', 
        'prezzo' => 'text-right',
        'articolo' => 'text-left',
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'prezzi.form';
    $ct['view']['open']['table'] = 'prezzi';
    $ct['view']['open']['field'] = 'id';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'prezzi.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_listino';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_listino']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // codici di prodotti e articoli, per id: l'id e' un numero, quello che si mostra e' il codice;
    // due query per tutta la pagina, non una per riga
    $codici = array( 'id_prodotto' => array(), 'id_articolo' => array() );
    foreach( array( 'id_prodotto' => 'prodotti', 'id_articolo' => 'articoli' ) as $colonna => $tabella ) {
        $ids = array();
        foreach( $ct['view']['data'] as $row ) {
            if( is_array( $row ) && ! empty( $row[ $colonna ] ) ) {
                $ids[] = (int) $row[ $colonna ];
            }
        }
        if( ! empty( $ids ) ) {
            $rows = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT id, codice FROM ' . $tabella . ' WHERE id IN ( ' . implode( ', ', array_unique( $ids ) ) . ' ) AND codice IS NOT NULL'
            );
            if( is_array( $rows ) ) {
                foreach( $rows as $r ) {
                    $codici[ $colonna ][ $r['id'] ] = $r['codice'];
                }
            }
        }
    }

    // elaborazione risultato
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            $row['prezzo'] = number_format( $row['prezzo'], 2, ',', '.' ) . ' ' . $row['valuta_utf8'];
            foreach( $codici as $colonna => $mappa ) {
                if( isset( $row[ $colonna ] ) && isset( $mappa[ $row[ $colonna ] ] ) ) {
                    $row[ $colonna ] = $mappa[ $row[ $colonna ] ];
                }
            }
        }
    }
