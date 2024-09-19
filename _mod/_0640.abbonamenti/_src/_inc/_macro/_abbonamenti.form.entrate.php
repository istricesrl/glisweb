<?php

    /**
     * macro form abbonamenti stampe
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
	$ct['form']['table'] = 'contratti';

     // tabella della vista
     $ct['view']['table'] = 'attivita';

     // pagina per la gestione degli oggetti esistenti
     // $ct['view']['open']['page'] = 'presenze.form';
     $ct['view']['open']['table'] = 'attivita';
 
      // campi della vista
      $ct['view']['cols'] = array(
         'id' => '#',
         'data_attivita' => 'presenza',
         'data_programmazione' => 'data',
         'id_anagrafica' => 'ID iscritto',
         'anagrafica' => 'iscritto',
         'tipologia' => 'tipologia',
         'id_tipologia' => 'ID tipologia',
         'ora_inizio_programmazione' => 'ora',
         'ora_fine_programmazione' => 'ora fine',
 /*
         'cliente' => 'cliente',
         'data_programmazione' => 'programmata',
         'anagrafica_programmazione' => 'assegnata a',
         'data_programmazione' => 'eseguita',
         'anagrafica' => 'svolta da',
         'nome' => 'attività',
         'ore' => 'ore',
 */
        'ora_inizio' => 'oi',
         'ora_fine' => 'of',
         'timestamp_archiviazione' => 'archiviazione',
         'discipline' => 'discipline',
         'id_progetto' => 'ID corso',
         'progetto' => 'corso',
         'luogo' => 'luogo',
         'data_attivita' => 'frequentata',
         NULL => 'azioni'
       );
 
     // stili della vista
     $ct['view']['class'] = array(
         'id' => 'd-none d-md-table-cell',
         '__label__' => 'text-left',
         'cliente' => 'text-left d-none d-md-table-cell',
         'id_anagrafica' => 'd-none',
         'anagrafica_programmazione' => 'text-left',
         'data_programmazione' => 'd-none',
         'ora_inizio_programmazione' => 'd-none',
         'ora_fine_programmazione' => 'd-none',
         'ora_inizio' => 'd-none',
         'ora_fine' => 'd-none',
         'data_attivita' => 'no-wrap',
         'id_tipologia' => 'd-none',
         'anagrafica' => 'text-left no-wrap',
         'nome' => 'text-left',
         'id_progetto' => 'd-none',
         'progetto' => 'text-left',
         'timestamp_archiviazione' => 'd-none',
         'discipline' => 'text-left',
         'luogo' => 'd-none',
         'ora_inizio' => 'd-none',
         'ora_fine' => 'd-none',
         NULL => 'nowrap'
     );
 
     // javascript della vista
     $ct['view']['onclick'] = array(
         NULL => 'event.stopPropagation();'
     );
 
     // preset filtro custom progetti aperti
     $ct['view']['__restrict__']['id_tipologia']['IN'] = '15|19|32|33|38|39|40';
     $ct['view']['__restrict__']['id_anagrafica']['EQ'] = $_REQUEST['contratti']['contratti_anagrafica'][0]['id_anagrafica'];
     $ct['view']['__restrict__']['id_contratto']['EQ'] = $_REQUEST['contratti']['id'];
 
 
	// macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    if( !empty( $ct['view']['data'] ) ){
        foreach ( $ct['view']['data'] as &$row ){
    
            $buttons = '';
    
            $row['data_attivita'] .= ' ' . substr( $row['ora_fine'], 0, 5 );

        }

    }
