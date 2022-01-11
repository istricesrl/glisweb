<?php

    // tabella della vista
	$ct['view']['table'] = 'cron';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'cron.form';

    //campi della vista
    $ct['view']['cols'] =  array(
        'id' => '#',
        'nome' => 'nome',
        'token' => 'token',
        'delay' => 'delay',
        'task' => 'task'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'nome' => 'text-left',
        'token' => 'text-right',
        'delay' => 'text-right'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
