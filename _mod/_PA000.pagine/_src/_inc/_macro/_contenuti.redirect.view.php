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
        'table' => 'redirect',
        'open' => array(
            'page' => 'redirect.form',
            'table' => 'redirect'
        ),
        'cols' => array(
            'id' => '#',
            'id_sito' => 'sito',
            'codice_stato_http' => 'codice',
            'sorgente' => 'sorgente',
            'destinazione' => 'destinazione',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'id_sito' => 'no-wrap text-start',
            'sorgente' => 'text-start',
            'destinazione' => 'text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
        ),
        '__sort__' => array(
            'sorgente' => 'ASC'
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

    $ct['etc']['include']['filters'] = 'inc/contenuti.pagine.view.filters.twig';

    /**
     * dati delle tendine
     * ==================
     * 
     * 
     * 
     * 
     */

    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];
    arraySortBy( ['__label__'], $ct['etc']['select']['siti'] );

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
    foreach ($ct['view']['data'] as &$row) {
        if (is_array($row)) {

            if( ! empty( $row['id_sito'] ) ) {
                if( isset( $cf['sites'][ $row['id_sito'] ] ) )
                    $row['id_sito'] = $cf['sites'][ $row['id_sito'] ]['__label__'];
                else
                    $row['id_sito'] = 'sito non definito';
            } else {
                $row['id_sito'] = 'nessun sito';
            }

            $buttons = [];

            $row[NULL] = implode($buttons);

        }
    }
