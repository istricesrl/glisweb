<?php

    /**
     * macro della form reparti dell'archivio dell'amministrazione
     * 
     * Questa macro imposta la scheda di gestione di un reparto: la tabella gestita e le tendine
     * dell'aliquota IVA e del settore.
     * 
     * 
     * 
     * 
     */

    // tabella gestita
    $ct['form']['table'] = 'reparti';

    // tendina iva
    $ct['etc']['select']['iva'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, concat( __label__, if( timestamp_archiviazione IS NULL, "", " ( aliquota archiviata )" ) ) AS __label__ '.
        'FROM iva_view WHERE timestamp_archiviazione IS NULL OR id = ? ORDER BY __label__',
        array( array( 's' => ( isset( $_REQUEST[ $ct['form']['table'] ]['id_iva'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id_iva'] : NULL ) )
    );

    // tendina settori
    $ct['etc']['select']['settori'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM settori_view ORDER BY __label__'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
