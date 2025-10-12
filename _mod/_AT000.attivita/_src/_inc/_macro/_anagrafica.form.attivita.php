<?php

    /**
     * macro anagrafica form attivita
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
        'table' => 'attivita',
        'open' => array(
            'page' => 'produzione.archivio.attivita.form',
            'table' => 'attivita',
            'preset' => array(
                'field' => 'id_cliente',
            )
        ),
        'insert' => array(
            'page' => 'produzione.archivio.attivita.form',
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'tipologia' => 'tipologia',
            'data_riferimento' => 'data',
            'ora_inizio_riferimento' => 'inizio',
            'ora_fine_riferimento' => 'fine',
            'anagrafica_riferimento' => 'riferimento',
            'nome' => 'attività',
            'ore' => 'ore',
            '__label__' => 'attività',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'data_riferimento' => 'no-wrap',
            'anagrafica_riferimento' => 'no-wrap',
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
            'id_cliente' => array( 'EQ' => $_REQUEST['anagrafica']['id'] ?? NULL )
        ),
        '__sort__' => array(
            '__label__' => 'ASC'
        ),
    );

    // configurazione pagina
    $ct['etc'] = array(
        'include' => array(
            'insert' => array(
                array(
                    'name' => 'insert',
                    'file' => 'inc/anagrafica.form.attivita.insert.twig',
                    'fa' => 'fa-plus-circle'
                ),
                array(
                    'name' => 'insert_memo',
                    'file' => 'inc/anagrafica.form.attivita.insert.promemoria.twig',
                    'fa' => 'fa-calendar-plus'
                )
            )
        )
    );

    // tendina tipologie attivita
    $ct['etc']['select']['tipologie_attivita'] = tendinaTipologieAttivita();

    // gestione default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default per l'entità anagrafica
	require DIR_MOD . '_AN000.anagrafica/_src/_inc/_macro/_anagrafica.form.default.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';

