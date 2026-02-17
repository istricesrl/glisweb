<?php

    /**
     * macro form anagrafica
     *
     *
     * TODO documentare
     *
     */

    /**
     * configurazione del form
     * =======================
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form'] = array(
        'table' => 'categorie_anagrafica',
    );

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
        'table' => 'anagrafica_categorie',
        'open' => array(
            'page' => 'anagrafica.form',
            'table' => 'anagrafica',
            'field' => 'id_anagrafica'
        ),
        'cols' => array(
            'id' => '#',
            'id_anagrafica' => 'ID anagrafica',
            'anagrafica' => 'anagrafica',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'id_anagrafica' => 'd-none',
            'anagrafica' => 'no-wrap text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_categoria' => array( 'EQ' => $_REQUEST['categorie_anagrafica']['id'] ?? NULL )
        ),
        '__sort__' => array(
            'anagrafica' => 'ASC'
        ),
    );

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

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    /**
     * debug del form
     * ==============
     * 
     * 
     * 
     */

    // debug
    // print_r( $_REQUEST );
