<?php

    // tabella della vista
	$ct['view']['table'] = 'job';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'job.form';

    //campi della vista
    $ct['view']['cols'] =  array(
        'id' => '#',
        '__label__' => 'nome',
        'totale' => 'totale',
        'corrente' => 'corrente',
#        'avanzamento' => 'avanzamento',
        'data_ora_esecuzione' => 'esecuzione',
        'data_ora_completamento' => 'completamento',
        'se_foreground' => 'foreground'
        
    );

    // stili della vista
    $ct['view']['class'] = array(
        '__label__' => 'text-left',
        'totale' => 'text-right',
        'corrente' => 'text-right',
        'data_ora_esecuzione' => 'text-right no-wrap',
        'data_ora_completamento' => 'text-right no-wrap',
        'se_foreground' => 'text-center'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // trasformazione icona attivo/inattivo
	foreach( $ct['view']['data'] as &$row ) {
	    if( $row['se_foreground'] == 1 ) { $row['se_foreground'] = '<i class="fa fa-check"></i>'; }
        // $row['avanzamento'] = sprintf( '%01.2f', ( $row['totale'] > 0 ) ? ( ( $row['corrente'] / $row['totale'] ) * 100 ) : 0 ) . '%';
	}
