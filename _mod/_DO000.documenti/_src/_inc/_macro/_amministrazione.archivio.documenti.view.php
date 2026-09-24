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
        'table' => 'documenti',
        'open' => array(
            'page' => 'amministrazione.archivio.documenti.form',
            'table' => 'documenti'
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'tipologia' => 'tipologia',
            'data' => 'data',
            'numero_sezionale' => 'numero',
            'nome' => 'documento',
            'emittente' => 'emittente',
            'destinatario' => 'destinatario',
            '__label__' => 'documento',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'codice' => 'no-wrap',
            'tipologia' => 'no-wrap text-start',
            'data' => 'no-wrap',
            'numero_sezionale' => 'no-wrap',
            'nome' => 'text-start',
            '__label__' => 'd-none',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
        ),
        '__sort__' => array(
            'data' => 'DESC'
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
