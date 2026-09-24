<?php

    /**
     * macro anagrafica form privacy
     * 
     * 
     * 
     * 
     * 
     * TODO implementare
     * TODO documentare
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'anagrafica';

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'consensi_anagrafica',
        'cols' => array(
            'id' => '#',
            'consenso' => 'consenso',
            'anagrafica' => 'anagrafica',
            'modulo' => 'modulo',
            'valore' => 'valore',
            'data_ora_inserimento' => 'data',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'data_riferimento' => 'no-wrap',
            'anagrafica_riferimento' => 'd-none',
            'ora_inizio_riferimento' => 'no-wrap',
            'ora_fine_riferimento' => 'no-wrap',
            'nome' => 'no-wrap text-start',
            'valore' => 'no-wrap text-center',
            'tipologia' => 'no-wrap',
            'codice' => 'no-wrap',
            'ore' => 'no-wrap',
            '__label__' => 'd-none',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_anagrafica' => array( 'EQ' => $_REQUEST['anagrafica']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );


    // gestione default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default per l'entità anagrafica
    require DIR_MOD . '_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

    // trasformazione icona attivo/inattivo
    foreach( $ct['view']['data'] as &$row ) {
        if( is_array( $row ) ) {
            if( $row['valore'] == 1 ) { 
                $row['valore'] = 'consenso prestato';
            } else {
                $row['valore'] = 'consenso non prestato';
            }
        }
    }
