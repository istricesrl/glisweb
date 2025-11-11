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
        'table' => 'url',
        'open' => array(
            'page' => 'anagrafica.archivio.url.form',
            'table' => 'url'
        ),
        'cols' => array(
            'id' => '#',
            'anagrafica' => 'anagrafica',
            'url' => 'indirizzo',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'anagrafica' => 'text-start no-wrap',
            'url' => 'text-start no-wrap',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
        ),
        '__sort__' => array(
            'url' => 'ASC'
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

            $row[ NULL ] = implode( '', $buttons );

        }

    }
