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
        'table' => 'prezzi',
        'open' => array(
            'page' => 'catalogo.archivio.prezzi.form',
            'table' => 'prezzi'
        ),
        'cols' => array(
            'id' => '#',
            'reparto' => 'reparto',
            'listino' => 'listino',
            'valuta' => 'valuta',
            'prodotto' => 'prodotto',
            'articolo' => 'articolo',
            'prefisso' => 'prefisso',
            'prezzo' => 'prezzo',
            'suffisso' => 'suffisso',
            'sconto_articoli' => '% su articoli',
            'iva' => 'iva',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'reparto' => 'text-start no-wrap',
            'listino' => 'text-start no-wrap',
            'valuta' => 'text-start no-wrap',
            'prodotto' => 'text-start no-wrap',
            'articolo' => 'text-start no-wrap',
            'prefisso' => 'text-start no-wrap',
            'prezzo' => 'text-start no-wrap',
            'suffisso' => 'text-start no-wrap',
            'sconto_articoli' => 'text-start no-wrap',
            'iva' => 'text-start no-wrap',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
           
        ),
        '__sort__' => array(
            'listino' => 'ASC'
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
    if (!empty($ct['view']['data'])){
        foreach( $ct['view']['data'] as &$row ) {
            if( is_array( $row ) ) {

                $buttons = [];

                $row[ NULL ] = implode( $buttons );

            }

        }
    }
