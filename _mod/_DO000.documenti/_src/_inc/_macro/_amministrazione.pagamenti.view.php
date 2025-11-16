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

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'pagamenti',
        'open' => array(
            'page' => 'amministrazione.pagamenti.form',
            'table' => 'pagamenti',
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'nome' => 'descrizione',
            '__label__' => 'pagamento',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            '__label__' => 'd-none',
            'nome' => 'text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'data_archiviazione' => array( 'NL' => true )
        ),
        '__sort__' => array(
            'id' => 'DESC'
        ),
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
