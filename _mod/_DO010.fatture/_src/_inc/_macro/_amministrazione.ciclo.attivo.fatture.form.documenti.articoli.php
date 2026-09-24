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

    // tabella gestita
    $ct['form']['table'] = 'documenti';

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'documenti_articoli',
        'open' => array(
            'page' => 'amministrazione.ciclo.attivo.fatture.documenti.articoli.form',
            'table' => 'documenti_articoli',
            'preset' => array(
                'field' => 'id_documento',
            )
        ),
        'insert' => array(
            'page' => 'amministrazione.ciclo.attivo.fatture.documenti.articoli.form',
            'table' => 'documenti_articoli',
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'nome' => 'descrizione',
            '__label__' => 'documento',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            'codice' => 'no-wrap',
            'nome' => 'text-start',
            '__label__' => 'd-none',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'id_documento' => array( 'EQ' => $_REQUEST['documenti']['id'] )
        ),
        '__sort__' => array(
            'id' => 'DESC'
        ),
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
