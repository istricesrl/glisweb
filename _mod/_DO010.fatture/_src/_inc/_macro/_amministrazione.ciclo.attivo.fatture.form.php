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

    // tipologie di documenti
    $ct['etc']['select']['tipologie_documenti'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_documenti_view WHERE se_fattura = 1 ORDER BY __label__ ASC'
    );

    // esigibilità iva
    $ct['etc']['select']['esigibilita'] = array(
        array( 'id' => 'I', '__label__'=> 'I - immediata' ),
        array( 'id' =>'D', '__label__'=> 'D - differita' ),
        array( 'id' =>'S', '__label__'=> 'S - scissione dei pagamenti')
    );

    // tendina condizioni_pagamento
    $ct['etc']['select']['condizioni_pagamento'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM condizioni_pagamento_view ORDER BY __label__ ASC'
    );

    // tendina indirizzi mittenti
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) ){
        $ct['etc']['select']['id_sedi_emittente'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT anagrafica_indirizzi_view.id, __label__ FROM anagrafica_indirizzi_view WHERE anagrafica_indirizzi_view.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_emittente'] ) )
        );
    } 

    // tendina indirizzi destinatari
    if( isset( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) && !empty( $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) ){
        $ct['etc']['select']['id_sedi_destinatario'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT anagrafica_indirizzi_view.id, __label__ FROM anagrafica_indirizzi_view WHERE anagrafica_indirizzi_view.id_anagrafica = ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id_destinatario'] ) )
        );
    } 

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
