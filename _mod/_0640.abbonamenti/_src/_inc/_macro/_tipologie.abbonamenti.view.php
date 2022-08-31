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
    $ct['view']['table'] = 'categorie_risorse';

    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'categorie.risorse.form';

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'categoria',
        'membri' => 'membri',
        'template' => 'template',
        'schema_html' => 'schema',
        'tema_css' => 'tema'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none d-md-table-cell',
        '__label__' => 'text-left',
        'template' => 'text-left',
        'schema_html' => 'text-left',
        'tema_css' => 'text-left'
    );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';
