<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'categorie_risorse';
    
    // tabella della vista
	$ct['view']['table'] = 'risorse_categorie';

    // campi della vista
	$ct['view']['cols'] = array(
	    'id' => '#',
        'id_risorsa' => 'id_risorsa'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'id' => 'd-none d-md-table-cell',
        'id_risorsa' => 'no-wrap'
	);

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'risorse.form';
    $ct['view']['open']['table'] = 'risorse';
    $ct['view']['open']['field'] = 'id_risorsa';

    // pagina per l'inserimento di un nuovo oggetto
	$ct['view']['insert']['page'] = 'risorse.form';

    // campo per il preset di apertura
	$ct['view']['open']['preset']['field'] = 'id_categoria';
	$ct['view']['open']['preset']['subform'] = 'risorse_categorie';

    // preset filtro custom progetti aperti
	$ct['view']['__restrict__']['id_categoria']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';