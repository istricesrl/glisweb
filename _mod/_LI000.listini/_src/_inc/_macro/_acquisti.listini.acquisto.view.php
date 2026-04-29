<?php

    /**
     * macro listini acquisto view
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
        'table' => 'listini',
        'open' => array(
            'page' => 'acquisti.listini.acquisto.form',
            'table' => 'listini'
        ),
        'cols' => array(
            'id' => '#',
            '__label__' => 'listino',
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
            'data_archiviazione' => array('NL' => true),
            'id_emittente' => array('NI' => implode( '|', array_column( tendinaAziendeGestite() ?? [], 'id' ) ) )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    // debug
    // die( print_r( $ct['view'], true ) );

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
    if(is_array($ct['view']['data'])){
        foreach ($ct['view']['data'] as &$row) {
            if (is_array($row)) {

                $buttons = [];

                $row[NULL] = implode($buttons);

            }
        }
    }
