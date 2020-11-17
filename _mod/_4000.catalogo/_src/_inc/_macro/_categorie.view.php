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
	$ct['view']['table'] = 'categorie_prodotti';

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'categorie.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
	    '__label__' => 'categoria',
        'id_tipologia_pubblicazione' => 'pubblicazione',
        'numero_prodotti' => 'prodotti',
        'id_pagina' => 'id_pagina'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    '__label__' => 'text-left'
	);

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

?>
