<?php

    // tabella della vista
	$ct['view']['table'] = 'task';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'task.form';

    //campi della vista
    $ct['view']['cols'] =  array(
        'id' => '#',
        'minuto' => 'min',
        'ora' => 'ora',
        'mese' => 'mese',
        'giorno_del_mese' => 'giorno/mese',
        'settimana' => 'settimana',
        'giorno_della_settimana' => 'giorno/settimana',
        'task' => 'nome',
        'iterazioni' => 'iterazioni',
        'delay' => 'delay',
        'data_ora_esecuzione' => 'ultima esecuzione'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'task' => 'text-left'
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';
