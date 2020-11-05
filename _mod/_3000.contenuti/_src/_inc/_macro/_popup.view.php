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
    $ct['view']['table'] = 'popup';
    
    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'popup.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        '__label__' => 'nome',
        'tipologia' => 'tipologia',
        'tipologia_pubblicazione' => 'pubblicazione'
	);

    // stili della vista
	$ct['view']['class'] = array(
        'nome' => 'text-left no-wrap'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
