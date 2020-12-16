<?php

    /**
     *
     *
     *
     *
     * @file
     *
     */

   // tabella della vista
    $ct['view']['table'] = 'contratti';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'contratti.form';

    // campi della vista
	$ct['view']['cols'] = array(
        'id' => '#',
        'data_inizio' => 'data inizio',
        'data_fine' => 'data fine',
	    '__label__' => 'contratto'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left no-wrap'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
