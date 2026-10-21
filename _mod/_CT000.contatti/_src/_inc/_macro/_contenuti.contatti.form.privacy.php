<?php

    /**
     * macro contatti form privacy
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
    $ct['form']['table'] = 'contatti';

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'consensi_contatti',
        'cols' => array(
            'id' => '#',
            'consenso' => 'consenso',
            'modulo' => 'modulo',
            'valore' => 'valore',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'valore' => 'no-wrap text-center',
            '__label__' => 'd-none',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_contatto' => array( 'EQ' => $_REQUEST['contatti']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // trasformazione del valore del consenso
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            if( $row['valore'] == 1 ) { 
                $row['valore'] = 'consenso prestato';
            } else {
                $row['valore'] = 'consenso non prestato';
            }
        }
    }
