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

    // tipologie di documento che sono fatture ( le stesse della tendina della scheda )
    $ct['etc']['tipologie_fatture'] = mysqlSelectColumn(
        'id',
        $cf['mysql']['connection'],
        'SELECT id FROM tipologie_documenti WHERE se_fattura = 1'
    );

    // informazioni della vista
    $ct['view'] = array(
        'table' => 'pagamenti',
        'open' => array(
            'page' => 'amministrazione.archivio.documenti.pagamenti.form',
            'table' => 'pagamenti',
        ),
        'cols' => array(
            'id' => '#',
            'codice' => 'codice',
            'nome' => 'descrizione',
            '__label__' => 'pagamento',
            NULL => 'azioni'
        ),
        'class' => array(
            'id' => 'd-none',
            '__label__' => 'd-none',
            'nome' => 'text-start',
            NULL => 'no-wrap'
        ),
        'onclick' => array(
            NULL => 'event.stopPropagation();'
        ),
        '__restrict__' => array(
            'data_archiviazione' => array( 'NL' => true ),
            'id_tipologia_documento' => array( 'IN' => implode( '|', $ct['etc']['tipologie_fatture'] ) )
        ),
        '__sort__' => array(
            'id' => 'DESC'
        ),
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.view.php';
