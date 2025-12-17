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
    $ct['form']['table'] = 'documenti_articoli';

    // tipologie di documenti
    $ct['etc']['select']['tipologie_documenti'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_documenti_view ORDER BY __label__ ASC'
    );

    // tipologie di documenti
    $ct['etc']['select']['udm'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM udm_view ORDER BY __label__ ASC'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
