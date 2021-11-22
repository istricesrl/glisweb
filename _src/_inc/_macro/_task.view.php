<?php

    // tabella della vista
	$ct['view']['table'] = 'task';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'task.form';

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
        'data_ora_esecuzione' => 'text-right',
        'data_ora_completamento' => 'text-right',
        'se_foreground' => 'text-center'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';