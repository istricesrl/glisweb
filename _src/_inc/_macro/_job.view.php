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
        'timestamp_esecuzione' => 'esecuzione',
        'timestamp_completamento' => 'completamento',
        'se_foreground' => 'foreground'
        
    );

    // stili della vista
    $ct['view']['class'] = array(
        '__label__' => 'text-left',
        'totale' => 'text-left',
        'corrente' => 'text-left',
        'timestamp_esecuzione' => 'text-left',
        'timestamp_completamento' => 'text-left'

    );




    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

