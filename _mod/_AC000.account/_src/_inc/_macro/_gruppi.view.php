<?php

    /**
     * macro gruppi view
     * 
     * Questa macro imposta la view dei gruppi.
     * 
     * 
     * 
     * 
     * 
     */

    /**
     * configurazione della view
     * =========================
     * 
     * 
     */

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'gruppi',
        'open' => array(
            'page' => 'gruppi.form',
            'table' => 'gruppi'
        ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'gruppo',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            '__label__' => 'text-start no-wrap',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    /**
     * configurazione della pagina
     * ===========================
     * 
     * 
     * 
     * 
     */

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     */

    /**
     * macro di default
     * ================
     * 
     * 
     * 
     * 
     */

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    /**
     * elaborazione risultati della vista
     * ==================================
     * 
     * 
     * 
     */

    // elaborazione righe
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {

            $buttons = [];

            $row[ NULL ] = implode( '', $buttons );

        }

    }
