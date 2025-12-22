<?php

    /**
     * macro anagrafica view
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'reparti',
        'open' => array(
            'page' => 'amministrazione.archivio.reparti.form',
            'table' => 'reparti',
        ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'reparto',
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
            '__label__' => 'DESC'
        ),
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
