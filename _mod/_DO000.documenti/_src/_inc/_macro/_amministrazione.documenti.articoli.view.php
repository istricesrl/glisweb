<?php

    /**
     * 
     * 
     * 
     * 
     * 
     * TODO documentare
     * 
     * 
     */

    // informazioni della vista
	$ct['view'] = array(
        'table' => 'documenti_articoli',
        'open' => array(
            'page' => 'amministrazione.documenti.articoli.form',
            'table' => 'documenti_articoli',
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'tipologia' => 'tipologia',
            'documento' => 'documento',
            'nome' => 'descrizione',
            '__label__' => 'documento',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'codice' => 'no-wrap',
            'tipologia' => 'no-wrap text-start',
            'documento' => 'no-wrap text-start',
            'nome' => 'text-start',
            '__label__' => 'd-none',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'data_archiviazione' => array( 'NL' => true )
        ),
        '__sort__' => array(
            'id' => 'DESC'
        ),
    );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default/_default.view.php';
