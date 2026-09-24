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
    $ct['form']['table'] = 'marchi';

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'prodotti',
        'open' => array(
            'page' => 'catalogo.prodotti.form',
            'table' => 'prodotti',
            'preset' => array(
                'field' => 'id_marchio',
            )
        ),
        'insert' => array(
            'page' => 'catalogo.prodotti.form',
        ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'prodotto',
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
            'id_marchio' => array( 'EQ' => $_REQUEST['marchi']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

