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


    // mastro quantitativo
     if( $_REQUEST['mastri']['id_tipologia'] == 4 || $_REQUEST['mastri']['id_tipologia'] == 2 ){
    
        // tabella della vista
        $ct['view']['table'] = '__report_giacenza_mastri__';


            // pagina per la gestione degli oggetti esistenti
        $ct['view']['open']['page'] = 'articoli.form';
        $ct['view']['open']['table'] = 'articoli';
        $ct['view']['open']['field'] = 'id_articolo'; 

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'id_articolo' => 'articolo',
            'descrizione' => 'descrizione',
            'matricola' => 'matricola',
            'quantita_totale' => 'quantità',
            'importo_totale' => 'importo',
            'id_todo' => 'todo',
            'id_progetto' => 'progetto'
        );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'd-none d-md-table-cell',
            'id_riga' => 'd-none',
            'descrizione' => 'text-left',
            'importo' => 'text-right'
        );
    }
      // mastro orario
      if( $_REQUEST['mastri']['id_tipologia'] == 3 ){
    
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

    // mastro quantitativo
    if( $_REQUEST['mastri']['id_tipologia'] == 1 ){
    
        // tabella della vista
        $ct['view']['table'] = '__report_giacenze_mastri_quantitativi_gerarchico__';


            // pagina per la gestione degli oggetti esistenti
        $ct['view']['open']['page'] = 'articoli.form';
        $ct['view']['open']['table'] = 'articoli';
        $ct['view']['open']['field'] = 'id_articolo'; 

        // campi della vista
        $ct['view']['cols'] = array(
            'id' => '#',
            'id_articolo' => 'articolo',
            'totale' => 'totale'
        );

        // stili della vista
        $ct['view']['class'] = array(
            'id' => 'd-none d-md-table-cell',
            'id_articolo' => 'text-left'
        );
    }

         // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );
 

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];
  
    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	///foreach( $ct['view']['data'] as &$row ) {
	//}

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
