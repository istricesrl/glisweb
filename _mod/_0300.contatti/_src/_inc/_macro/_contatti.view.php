<?php

    /**
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * @todo finire di documentare
     *
     * @file
     *
     */

    // tabella della vista
    $ct['view']['table'] = 'contatti';
    
    // id della vista
  #  $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contatti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',        
        'data_contatto' => 'data',
        'ora_contatto' => 'ora',
        'tipologia' => 'tipologia',
        'anagrafica' => 'anagrafica',
#        'segnalatore' => 'segnalatore',
#        'campagna' => 'campagna',
        'note' => 'testo'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'note' => 'text-left',
        'data_contatto' => 'no-wrap',
        'tipologia' => 'text-left no-wrap',
        'anagrafica' => 'text-left',
        'segnalatore' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   