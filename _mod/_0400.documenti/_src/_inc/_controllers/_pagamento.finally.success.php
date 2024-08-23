<?php

    // log
    logger( 'dati in ingresso: ' . print_r( $result, true ), 'details/documenti/pagamenti/controller' );
    logger( 'riga pagamento: ' . print_r( $pagamento, true ), 'details/documenti/pagamenti/controller' );
    logger( 'dati pagamento: ' . print_r( $payment, true ), 'details/documenti/pagamenti/controller' );
    logger( 'dettagli pagamento: ' . print_r( $dettagli, true ), 'details/documenti/pagamenti/controller' );

    // dati per il documento
    $idTipologia = ( ! empty( $dettagli['id_tipologia_documento'] ) ) ? $dettagli['id_tipologia_documento'] : 8;
    $sezionale = ( ! empty( $dettagli['sezionale'] ) ) ? $dettagli['sezionale'] : 'C';
    $idCreditore = ( ! empty( $dettagli['id_creditore'] ) ) ? $dettagli['id_creditore'] : 1;
    $idDebitore = ( ! empty( $dettagli['id_debitore'] ) ) ? $dettagli['id_debitore'] : 1;

    // riga di carrello
    $dettagliCarrelliArticoli = mysqlSelectRow(
        $cf['mysql']['connection'],
        'SELECT * FROM carrelli_articoli WHERE id = ?',
        array( array( 's' => $dettagli['id_carrelli_articoli'] ) )
    );

    // genero il numero di documento
    $numero = generaProssimoNumeroDocumento(
        $idTipologia,
        $sezionale,
        $idCreditore
    );

    // altre info
    $idSedeEmittente = trovaIdSedeLegale( $idCreditore );
    $idSedeDestinatario = trovaIdSedeLegale( $idDebitore );

    // creazione del documento
    $idDocumento = mysqlInsertRow(
        $cf['mysql']['connection'],
        array(
            'id_tipologia' => $idTipologia,
            'numero' => $numero,
            'sezionale' => $sezionale,
            'data' => date( 'Y-m-d' ),
            'nome' => 'documento generato automaticamente per il ' . $dettagli['tipologia'] . ' #' . ( ( $dettagli['tipologia'] == 'carrello' ) ? $dettagli['id_carrello'] . '/' . $dettagli['id_carrelli_articoli'] : $dettagli['id'] ),
            'id_emittente' => $idCreditore,
            'id_sede_emittente' => $idSedeEmittente,
            'id_destinatario' => $idDebitore,
            'id_sede_destinatario' => $idSedeDestinatario,
            'id_condizione_pagamento' => 2,
            'esigibilita' => 'I',
            'riferimento' => $dettagli['tipologia'] . ' #' . ( ( $dettagli['tipologia'] == 'carrello' ) ? $dettagli['id_carrello'] . '/' . $dettagli['id_carrelli_articoli'] : $dettagli['id'] ),
            'timestamp_chiusura' => time(),
            'progressivo_invio' => generaNumeroProgressivoInvio( $idCreditore ),
            'note_chiusura' => 'documento generato da ' . __FILE__
        ),
        'documenti'
    );

    // contenuto del documento
    $idDocumentiArticoli = mysqlInsertRow(
        $cf['mysql']['connection'],
        array(
            'id_documento' => $idDocumento,
            'id_articolo' => $dettagliCarrelliArticoli['id_articolo'],
            'id_rinnovo' => $dettagliCarrelliArticoli['id_rinnovo'],
            'id_carrelli_articoli' => $dettagli['id_carrelli_articoli'],
            'quantita' => 1,
            'id_udm' => 1,
            'id_listino' => 1,
            'id_reparto' => 5,
            'importo_netto_totale' => $payment['importo_pagamento'],
            'importo_lordo_totale' => $payment['importo_pagamento'],
            'nome' => 'riga per pagamento debito carrello #' . $dettagli['id_carrello'] . '/' . $dettagli['id_carrelli_articoli']
        ),
        'documenti_articoli'
    );

    // collego il pagamento al documento
    mysqlQuery(
        $cf['mysql']['connection'],
        'UPDATE pagamenti SET id_documento = ? WHERE id = ?',
        array(
            array( 's' => $idDocumento ),
            array( 's' => $pagamento['id'] )
        )
    );
