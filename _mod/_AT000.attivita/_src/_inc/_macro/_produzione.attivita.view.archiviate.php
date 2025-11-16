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

    /**
     * configurazione della view
     * =========================
     * 
     * 
     * TODO documentare
     * TODO fare una tabella con tutte le chiavi possibili spiegate
     * 
     * 
     */

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'attivita',
        'open' => array(
            'page' => 'produzione.attivita.form',
            'table' => 'attivita'
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'tipologia' => 'tipologia',
            'data_riferimento' => 'data',
            'ora_inizio_riferimento' => 'inizio',
            'ora_fine_riferimento' => 'fine',
            'anagrafica_riferimento' => 'riferimento',
            'cliente' => 'cliente',
            'nome' => 'attività',
            'ore' => 'ore',
            '__label__' => 'attività',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'data_riferimento' => 'no-wrap',
            'anagrafica_riferimento' => 'no-wrap',
            'cliente' => 'no-wrap',
            'ora_inizio_riferimento' => 'no-wrap',
            'ora_fine_riferimento' => 'no-wrap',
            'nome' => 'no-wrap text-start',
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
            'data_archiviazione' => array( 'NN' => true )
        ),
        '__sort__' => array(
            'data_riferimento' => 'DESC'
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

            $row[ NULL ] = implode( $buttons );

        }

    }
