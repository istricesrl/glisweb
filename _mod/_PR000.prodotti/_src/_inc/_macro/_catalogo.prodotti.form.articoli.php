<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'prodotti';

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'articoli',
        'open' => array(
            'page' => 'catalogo.articoli.form',
            'table' => 'articoli',
            'preset' => array(
                'field' => 'id_prodotto',
            )
        ),
        'insert' => array(
            'page' => 'catalogo.articoli.form',
        ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'articolo',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            '__label__' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_prodotto' => array( 'EQ' => $_REQUEST['prodotti']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

