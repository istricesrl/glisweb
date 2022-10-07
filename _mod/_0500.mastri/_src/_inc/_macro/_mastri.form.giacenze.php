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
    $ct['form']['table'] = 'mastri';
    $ct['view']['data']['__report_mode__'] = 1;

    // verifiche dinamiche sulla tipologia
    $checkType = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM tipologie_mastri WHERE id = ?',
        array( array( 's' => $_REQUEST['mastri']['id_tipologia'] ) )
    );

    // magazzino
     if( ! empty( $checkType['se_magazzino'] ) ) {
    
        // tabella della vista
        $ct['view']['table'] = '__report_giacenza_magazzini__';

        // pagina per la gestione degli oggetti esistenti
        $ct['view']['open']['page'] = 'articoli.form';
        $ct['view']['open']['table'] = 'articoli';
        $ct['view']['open']['field'] = 'id_articolo'; 

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'id_articolo' => 'codice',
            'articolo' => 'descrizione',
            'matricola' => 'matricola',
            'carico' => 'carico',
            'scarico' => 'scarico',
            'totale' => 'totale'
        );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'd-none d-md-table-cell',
            'articolo' => 'text-left',
            'carico' => 'text-right',
            'scarico' => 'text-right',
            'totale' => 'text-right'
        );
    }

    // crediti
    if( ! empty( $checkType['se_credito'] ) ) {
    
        // tabella della vista
        $ct['view']['table'] = '__report_giacenza_crediti__';

        // pagina per la gestione degli oggetti esistenti
        $ct['view']['open']['page'] = 'articoli.form';
        $ct['view']['open']['table'] = 'articoli';
        $ct['view']['open']['field'] = 'id_articolo'; 

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'account' => 'account',
            'carico' => 'carico',
            'scarico' => 'scarico',
            'totale' => 'totale'
        );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'd-none d-md-table-cell',
            'account' => 'text-left',
            'carico' => 'text-right',
            'scarico' => 'text-right',
            'totale' => 'text-right'
        );
    }

/*
    // conto
    if( in_array( $_REQUEST['mastri']['id_tipologia'], array( 2 ) ) ) {

    // tabella della vista
        $ct['view']['table'] = '__report_giacenza_mastri_orari__';

                    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'progetti.produzione.form.attivita';
    $ct['view']['open']['table'] = 'progetti';
    $ct['view']['open']['field'] = 'id_progetto'; 

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'id_progetto' => 'progetto',
        'ore' => 'ore',
        'cliente' => 'cliente'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'id_progetto' => 'text-left',
        'descrizione' => 'text-left',
        'cliente' => 'text-left'
    );
    }

    // registro
    if( in_array( $_REQUEST['mastri']['id_tipologia'], array( 3 ) ) ) {
    
        // tabella della vista
        $ct['view']['table'] = '__report_giacenze_mastri_quantitativi_gerarchico__';


            // pagina per la gestione degli oggetti esistenti
        $ct['view']['open']['page'] = 'articoli.form.movimenti';
        $ct['view']['open']['table'] = 'articoli';
        $ct['view']['open']['field'] = 'id_articolo'; 

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'id_articolo' => 'articolo',
            'articolo' => 'descrizione',
            'totale' => 'totale'
        );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'd-none d-md-table-cell',
            'id_articolo' => 'text-left',
            'articolo' => 'text-left'
        );
    }
*/

    // preset filtro custom mastro corrente
	$ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
