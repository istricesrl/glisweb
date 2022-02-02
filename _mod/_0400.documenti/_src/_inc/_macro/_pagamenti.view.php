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
    $ct['view']['table'] = 'pagamenti';
    
    // id della vista
   # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'pagamenti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_ora_scadenza' => 'scadenza',
		'documento' => 'documento',
        'nome' => 'nome',
		'mastro_provenienza' => 'scarico',
		'mastro_destinazione' => 'carico',
        'importo_netto_totale' => 'importo netto'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left',
        'documento' => 'text-left',
        'numero' => 'text-left',
        'data' => 'text-left',
        '__label__' => 'text-left',
        'destinatario' => 'text-left',
        'emittente' => 'text-left',
        'tipologia' => 'text-left',
        'totale' => 'text-right' 
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

   