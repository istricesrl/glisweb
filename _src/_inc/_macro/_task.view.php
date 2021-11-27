<?php

    // tabella della vista
	$ct['view']['table'] = 'task';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'task.form';

    //campi della vista
    $ct['view']['cols'] =  array(
        'id' => '#',
        '__label__' => 'nome',
        'token' => 'token',
        'delay' => 'delay'
    );

    // stili della vista
    $ct['view']['class'] = array(
        '__label__' => 'text-left',
        'token' => 'text-right',
        'delay' => 'text-right'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
