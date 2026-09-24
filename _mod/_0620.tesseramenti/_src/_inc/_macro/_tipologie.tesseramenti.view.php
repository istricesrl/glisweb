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
    $ct['view']['table'] = 'tipologie_contratti';

    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'tipologie.tesseramenti.form';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'categoria'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        '__label__' => 'text-left'
    );

    // ...
    $ct['view']['__restrict__']['se_tesseramento']['EQ'] = 1;

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';
