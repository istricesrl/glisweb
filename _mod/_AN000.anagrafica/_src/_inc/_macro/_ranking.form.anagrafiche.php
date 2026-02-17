<?php

    /**
     *
     *
     *
     *
     * TODO documentare
     *
     */
    
    // tabella gestita
    $ct['form']['table'] = 'ranking';


    /**
     * dati della view
     * ===============
     * 
     * 
     * 
     * 
     * 
     */

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'anagrafica',
        'open' => array(
            'page' => 'anagrafica.form',
            'table' => 'anagrafica',
            'field' => 'id'
        ),
        'cols' => array(
            'id' => '#',
            '__label__'=> 'anagrafica',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'id_anagrafica' => 'd-none',
            '__label__' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_ranking' => array( 'EQ' => $_REQUEST['ranking']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );



    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
    
    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
