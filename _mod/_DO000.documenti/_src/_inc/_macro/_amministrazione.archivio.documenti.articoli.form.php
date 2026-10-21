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

    // tipologie di riga ( fix 2026-09-28 ): leggeva tipologie_documenti_view, le tipologie di DOCUMENTO;
    // dal 14/09/2026 documenti_articoli.id_tipologia punta a tipologie_documenti_articoli
    $ct['etc']['select']['tipologie_documenti_articoli'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_documenti_articoli_view ORDER BY ordine, nome'
    );

    // tipologie di documenti
    $ct['etc']['select']['udm'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM udm_view ORDER BY __label__ ASC'
    );

    // tendina reparto
    // NOTA solo i reparti con un'aliquota IVA non archiviata ( come quelle con la natura generica N6, che lo SDI scarta ); il
    // reparto della riga resta nella tendina anche se archiviato, segnato, perché salvando il form non vada perso
    $ct['etc']['select']['reparti'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT reparti_view.id, concat( reparti_view.__label__, if( iva.timestamp_archiviazione IS NULL, "", " ( aliquota archiviata )" ) ) AS __label__ '.
        'FROM reparti_view LEFT JOIN iva ON iva.id = reparti_view.id_iva '.
        'WHERE iva.timestamp_archiviazione IS NULL OR reparti_view.id = ? '.
        'ORDER BY __label__ ASC',
        array( array( 's' => ( isset( $_REQUEST[ $ct['form']['table'] ]['id_reparto'] ) ) ? $_REQUEST[ $ct['form']['table'] ]['id_reparto'] : NULL ) )
    );
    
    // tendina listino
    $ct['etc']['select']['listini'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM listini_view ORDER BY __label__ ASC'
    );

    // macro di default
    require DIR_SRC_INC_MACRO . '_default/_default.form.php';
