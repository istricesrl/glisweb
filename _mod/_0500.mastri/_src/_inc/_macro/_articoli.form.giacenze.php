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
    
    $ct['view']['table'] = '__report_giacenze_mastri_quantitativi_gerarchico__';

    $ct['view']['etc']['__report_mode__'] = 1;

    // pagina per la gestione degli oggetti esistenti
/*	$ct['view']['open']['page'] = 'documenti.articoli.form';
    $ct['view']['open']['table'] = 'documenti_articoli';
    $ct['view']['open']['field'] = 'id_riga';*/

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'mastro' => 'mastro',
            'id_articolo' => 'articolo',
            'descrizione' => 'descrizione',
            'totale' => 'quantità',
           );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'd-none',
            'id_articolo' => 'd-none',
            'descrizione' => 'text-left',
            'quantita_totale' => 'text-right',
            'mastro' => 'text-left'
        );

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_articolo']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
