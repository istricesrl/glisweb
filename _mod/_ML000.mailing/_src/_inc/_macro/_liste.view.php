<?php

    /**
     * vista delle liste
     *
     * Elenca le liste degli iscritti alla newsletter.
     *
     */

    // configurazione della vista
    $ct['view'] = array(
        'table' => 'liste',
        'open' => array( 'page' => 'liste.form' ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'nome',
            NULL => 'azioni'
        ),
        'class' => array(
            '__label__' => 'text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        )
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
