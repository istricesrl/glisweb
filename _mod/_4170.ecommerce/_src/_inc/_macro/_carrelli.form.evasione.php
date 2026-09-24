<?php

    // tabella gestita
	$ct['form']['table'] = 'carrelli';

    // tabella della vista
    $ct['view']['table'] = 'carrelli_articoli';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        'id_articolo' => 'articolo',
        'quantita' => 'q.tà',
#        'ean' => 'ean'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'text-left',
        'id_articolo' => 'text-left',
        'quantita' => 'text-right'
    );

    $ct['view']['__restrict__']['id_carrello']['EQ'] = $_REQUEST[ $ct['form']['table'] ]['id'];

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';

