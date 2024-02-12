<?php

    /**
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
    $ct['form']['table'] = 'articoli';
    $ct['view']['data']['__report_mode__'] = 1;

    // tabella della vista
    $ct['view']['table'] = '__report_giacenza_magazzini__';

    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'articoli.form';
    $ct['view']['open']['table'] = 'articoli';
    $ct['view']['open']['field'] = 'id_articolo'; 

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'id_articolo' => 'codice articolo',
        'id_prodotto' => 'codice prodotto',
        'prodotto' => 'prodotto',
        'codice_produttore' => 'cod. produttore',
        'articolo' => 'descrizione',
//        'categorie' => 'categoria',
//        'carico' => 'carico',
//        'scarico' => 'scarico',
        'totale_figli' => 'totale figli',
        'nome' => 'magazzino',
        'totale' => 'totale',
        'peso' => 'totale peso',
        'sigla_udm_peso' => 'udm peso'
    );

	// RELAZIONI CON IL MODULO MATRICOLE
	if( in_array( "4110.matricole", $cf['mods']['active']['array'] ) ) {

		// colonna matricola
		arrayInsertAssoc( 'articolo', $ct['view']['cols'], array( 'matricola' => 'matricola' ) );

        // OPZIONE scadenze
        if( ! empty( $cf['matricole']['scadenze'] ) ) {
            arrayInsertAssoc( 'matricola', $ct['view']['cols'], array( 'data_scadenza' => 'scadenza' ) );
        }

    }

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'id_prodotto' => 'd-none',
        'prodotto' => 'd-none',
        'codice_produttore' => 'd-none',
        'id_articolo' => 'd-none',
        'articolo' => 'd-none',
        'nome' => 'text-left',
        'totale_figli' => 'd-none',
        'totale' => 'text-right',
        'peso' => 'text-right',
        'carico' => 'text-right',
        'scarico' => 'text-right',
        'sigla_udm_peso' => 'd-none',
        'categorie' => 'text-left'
    );

    // preset filtro custom mastro corrente
	if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ) {
        $ct['view']['__restrict__']['id_articolo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
    }

    // ...
    $ct['view']['__restrict__']['totale']['GT'] = 0;

    // ...
    $ct['view']['__restrict__']['totale_figli']['NL'] = 1;

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
    if( isset(  $ct['view']['data'] ) && !empty( $ct['view']['data'] ) ){
        foreach( $ct['view']['data'] as &$row ) {
            if( is_array( $row ) ) {
                if(isset($row['peso'])){ $row['peso'] = $row['peso'].' '.$row['sigla_udm_peso'];}
            }
        }
    
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
