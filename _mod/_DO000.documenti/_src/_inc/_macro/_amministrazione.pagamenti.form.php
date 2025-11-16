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
    $ct['form']['table'] = 'pagamenti';

    // tendina tipologie anagrafica
    $ct['etc']['select']['modalita_pagamento'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM modalita_pagamento_view'
    );

    if( isset( $_REQUEST['pagamenti']['id_documento'] ) ){

        // tendina iban
        $ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT iban_view.id, iban_view.__label__ FROM iban_view '.
            'LEFT JOIN documenti ON documenti.id_emittente = iban_view.id_anagrafica '.
            'WHERE documenti.id = ? ',
            array( array( 's' => $_REQUEST['pagamenti']['id_documento'] ) )
        );

    } elseif( isset( $_REQUEST['__preset__']['pagamenti']['id_documento'] ) ){

        // tendina iban
        $ct['etc']['select']['iban'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT iban_view.id, iban_view.__label__ FROM iban_view '.
            'LEFT JOIN documenti ON documenti.id_emittente = iban_view.id_anagrafica '.
            'WHERE documenti.id = ? ',
            array( array( 's' => $_REQUEST['__preset__']['pagamenti']['id_documento'] ) )
        );

    }


    // tendina listini
    $ct['etc']['select']['listini'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM listini_view '
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
