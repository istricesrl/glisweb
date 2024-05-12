<?php

    // TODO implementare

    // se è presente un ID carrello
    if( isset( $idCarrello ) && ! empty( $idCarrello ) ) {

        // recupero il carrello
        $carrello = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli WHERE id = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // recupero gli articoli
        $articoli = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT * FROM carrelli_articoli WHERE id_carrello = ?',
            array(
                array( 's' => $idCarrello )
            )
        );

        // cerco gli articoli che aggiungono crediti
        foreach( $articoli as $articolo ) {

            // recupero l'abbonamento associato
            $info = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT tipologie_contratti.id FROM tipologie_contratti INNER JOIN prodotti ON prodotti.id = tipologie_contratti.id_prodotto INNER JOIN articoli ON articoli.id_prodotto = prodotti.id WHERE articoli.id = ?',
                array(
                    array( 's' => $articolo['id_articolo'] )
                )
            );

            // debug
            // print_r( $info );
            // print_r( $articolo );

            // log
            logger( 'esito ricerca tipologia abbonamento: ' . print_r( $info, true ), 'details/abbonamenti/rinnovi/' . $articolo['destinatario_id_anagrafica'] );

            // se c'è una tipologia di abbonamento
            if( ! empty( $info['id'] ) ) {

                // cerco se c'è un abbonamento scaduto da rinnovare
                $abbonamento = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT contratti.* FROM contratti 
                    INNER JOIN contratti_anagrafica ON contratti_anagrafica.id_contratto = contratti.id 
                    WHERE contratti.id_tipologia = ? AND contratti_anagrafica.id_anagrafica = ? ',
                    array(
                        array( 's' => $info['id'] ),
                        array( 's' => $articolo['destinatario_id_anagrafica'] )
                    )
                );

                // log
                logger( 'recuperato abbonamento: ' . print_r( $abbonamento, true ), 'details/abbonamenti/rinnovi/' . $articolo['destinatario_id_anagrafica'] );

            }
            
            // se non c'è un abbonamento da rinnovare
            if( empty( $abbonamento ) ) {

                // inserisco un nuovo abbonamento
                $idAbbonamento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_tipologia' => $info['id']
                    ),
                    'contratti'
                );

                // associo l'abbonamento all'anagrafica
                mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_contratto' => $idAbbonamento,
                        'id_anagrafica' => $articolo['destinatario_id_anagrafica']
                    ),
                    'contratti_anagrafica'
                );

                // ...
                $abbonamento['id'] = $idAbbonamento;

                // log
                logger( 'inserito abbonamento: ' . print_r( $abbonamento, true ), 'details/abbonamenti/rinnovi/' . $articolo['destinatario_id_anagrafica'] );

            }

            // cerco la durata del rinnovo
            $dettagliPeriodicita = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT articoli.id_periodicita, periodicita.giorni FROM articoli INNER JOIN periodicita ON periodicita.id = articoli.id_periodicita WHERE articoli.id = ?',
                array(
                    array( 's' => $articolo['id_articolo'] )
                )
            );

            // log
            logger( 'trovata periodicità: ' . print_r( $dettagliPeriodicita, true ), 'details/abbonamenti/rinnovi/' . $articolo['destinatario_id_anagrafica'] );

            // inserisco il rinnovo
            $idRinnovo = mysqlInsertRow(
                $cf['mysql']['connection'],
                array(
                    'id_contratto' => $abbonamento['id'],
                    'id_tipologia' => 1,
                    'id_periodicita' => $dettagliPeriodicita['id_periodicita'],
                    'data_inizio' => date( 'Y-m-d' ),
                    'data_fine' => date( 'Y-m-d', strtotime( '+ ' . $dettagliPeriodicita['giorni'] . ' days' ) )
                ),
                'rinnovi'
            );

            // aggiorno il carrello
            if( ! empty( $idRinnovo ) ) {

                // log
                logger( 'inserito rinnovo: ' . $idRinnovo, 'details/abbonamenti/rinnovi/' . $articolo['destinatario_id_anagrafica'] );

                // ...
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE carrelli_articoli SET id_rinnovo = ? WHERE id = ?',
                    array(
                        array( 's' => $idRinnovo ),
                        array( 's' => $articolo['id'] )
                    )
                );

                // ...
                if( $cf['abbonamenti']['checkout']['documento']['generazione']['automatica'] === true ) {

                    // log
                    logger( 'genero il documento per il rinnovo: ' . $idRinnovo, 'details/abbonamenti/documenti/' . $articolo['destinatario_id_anagrafica'] );

                    // ...
                    $sezionale = 'E/' . date( 'Y' );
                    $numero = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT coalesce( max( numero ), 0 ) + 1 FROM documenti WHERE sezionale = ?',
                        array(
                            array( 's' => $sezionale )
                        )
                    );

                    // ...
                    $idDocumento = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_tipologia' => $cf['abbonamenti']['checkout']['documento']['generazione']['id_tipologia'],
                            'id_emittente' => trovaIdAziendaGestita(),
                            'id_sede_emittente' => trovaIdSedeLegale( trovaIdAziendaGestita() ),
                            'id_destinatario' => $articolo['destinatario_id_anagrafica'],
                            'id_sede_destinatario' => trovaIdSedeLegale( $articolo['destinatario_id_anagrafica'] ),
                            'data' => date( 'Y-m-d' ),
                            'numero' => $numero,
                            'sezionale' => $sezionale,
                            'nome' => 'documento generato automaticamente per il carrello #' . $idCarrello
                        ),
                        'documenti'
                    );

                    // ...
                    if( ! empty( $idDocumento ) ) {

                        // inserisco la riga
                        $idDocumentiArticoli = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_documento' => $idDocumento,
                                'id_rinnovo' => $idRinnovo,
                                'id_carrelli_articoli' => $articolo['id'],
                                'id_articolo' => $articolo['id_articolo'],
                                'quantita' => 1,
                                'importo_lordo_totale' => $articolo['prezzo_lordo_finale'],
                                'id_listino' => 1,
                                'nome' => 'riga generata automaticamente per il carrello #' . $idCarrello . ' documento #' . $idDocumento
                            ),
                            'documenti_articoli'
                        );

                        // inserisco il pagamento
                        $idPagamento = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_documento' => $idDocumento,
                                'id_tipologia' => NULL,
                                'id_modalita_pagamento' => 24,  // TODO così è fisso a PayPal, rendere dinamico da carrello
                                'importo_lordo_totale' => $articolo['prezzo_lordo_finale'],
                                'timestamp_pagamento' => time(),
                                'provider_pagamento' => $carrello['provider_pagamento'],
                                'ordine_pagamento' => $carrello['ordine_pagamento'],
                                'codice_pagamento' => $carrello['codice_pagamento'],
                                'status_pagamento' => $carrello['status_pagamento'],
                                'importo_pagamento' => $carrello['importo_pagamento'],
                                'nome' => 'pagamento generato automaticamente per il carrello #' . $idCarrello . ' documento #' . $idDocumento
                            ),
                            'pagamenti'
                        );

                    }

                }

            }

        }

    }
