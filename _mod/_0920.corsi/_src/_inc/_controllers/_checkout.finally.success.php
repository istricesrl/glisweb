<?php

    // NOTA
    // la logica è la seguente, al corso (progetto) è associato un prodotto, gli articoli rappresentano le varie modalità e periodi di iscrizione al corso stesso; l'anagrafica iscritta
    // la ricavo da destinatario_id_anagrafica e i dettagli dell'iscrizione dai metadati dell'articolo

    // debug
    // die( print_r( $_SESSION['carrello'] ) );

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

        // debug
        // print_r( $carrello );
        // print_r( $articoli );

        /**
         * NOTA IMPORTANTE!!!
         * 
         * La Melania ha detto che la logica per cui il rinnovo viene creato dopo il checkout non va più bene O MEGLIO va bene per l'acquisto online mentre per l'acquisto in segreteria
         * il rinnovo va creato al momento e poi pagato dopo QUINDI bisogna gestire i due casi:
         * 
         * 1) il carrello contiene il pagamento di un contratto senza rinnovo e quindi bisogna creare il rinnovo e poi associarlo al documento
         * 
         * 2) il carrello contiene il pagamento di un rinnovo, quindi si passa direttamente ad associare quel rinnovo al documento
         * 
         * ATTENZIONE questo ragionamento vale anche per i tesseramenti e gli abbonamenti!
         * 
         * NOTA il collegamento fra documenti e rinnovi è dato dal campo id_rinnovo della tabella documenti_articoli.
         * 
         * NOTA il collegamento fra carrelli e rinnovi è dato dal campo id_rinnovo della tabella carrelli_articoli.
         * 
         * 
         */

        // var_dump( $articoli );

        // cerco gli articoli che aggiungono crediti
        foreach( $articoli as $articolo ) {

            // ...
            if( ! empty( $articolo['destinatario_id_anagrafica'] ) ) {

                // recupero il corso associato
                $info = mysqlSelectRow(
                    $cf['mysql']['connection'],
                    'SELECT progetti.id, progetti.data_accettazione FROM progetti INNER JOIN prodotti ON prodotti.id = progetti.id_prodotto INNER JOIN articoli ON articoli.id_prodotto = prodotti.id WHERE articoli.id = ?',
                    array(
                        array( 's' => $articolo['id_articolo'] )
                    )
                );

                // debug
                // print_r( $info );
                // print_r( $articolo );

                // se c'è un corso cui effettuare l'iscrizione
                if( ! empty( $info['id'] ) ) {

                    // dati del corso associato
                    $corso = $info['id'];
                    $inizio = $info['data_accettazione'];

                    /*
                    // recupero il periodo di iscrizione
                    $periodo = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT testo FROM metadati WHERE id_articolo = ? AND nome = "periodo_iscrizione"',
                        array(
                            array( 's' => $articolo['id_articolo'] )
                        )
                    );
                    */

                    // ...
                    $giorni = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT periodicita.giorni FROM periodicita INNER JOIN articoli ON periodicita.id = articoli.id_periodicita WHERE articoli.id = ?',
                        array(
                            array( 's' => $articolo['id_articolo'] )
                        )
                    );

                    // seleziono l'iscritto, destinatario_id_anagrafica se presente altrimenti intestazione_id_anagrafica
                    // $iscritto = ( ! empty( $carrello['destinatario_id_anagrafica'] ) ) ? $carrello['destinatario_id_anagrafica'] : $carrello['intestazione_id_anagrafica'];
                    $iscritto = $articolo['destinatario_id_anagrafica'];

                    // TODO IMPORTANTE
                    // se la riga di carrello si riferisce ad un rinnovo, allora devo associare il pagamento al rinnovo e non creare un nuovo contratto e un nuovo rinnovo
                    // NOTA probabilmente in quel caso ho id_rinnovo vedi sopra

                    // creo il contratto di iscrizione
                    $contratto = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => NULL,
                            'id_tipologia' => 5,
                            'id_progetto' => $corso,
                            'nome' => 'iscrizione da carrello #' . $carrello['id'] . ' riga #' . $articolo['id'] . ' del ' . date('d/m/Y')
                        ),
                        'contratti'
                    );

                    // var_dump( $iscritto );

                    // associo l'anagrafica al contratto
                    mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => NULL,
                            'id_contratto' => $contratto,
                            'id_anagrafica' => $iscritto,
                            'id_ruolo' => 29
                        ),
                        'contratti_anagrafica'
                    );

                    /*
                    // determino la durata dell'iscrizione
                    switch( $periodo ) {
                        case 'quadrimestrale':
                            $incremento = '+4 months';
                            break;
                        case 'trimestrale':
                            $incremento = '+3 months';
                            break;
                        case 'bimestrale':
                            $incremento = '+2 months';
                            break;
                        case 'mensile':
                            $incremento = '+1 month';
                            break;
                        case 'settimanale':
                            $incremento = '+1 week';
                            break;
                        case 'giornata':
                            $incremento = '+1 day';
                            break;
                        default:
                            $incremento = NULL;
                            break;
                    }
                    */

                    // ...
                    $incremento = '+' . $giorni . ' days';

                    // creo il rinnovo per il periodo di iscrizione
                    $idRinnovo = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => NULL,
                            'id_tipologia' => 1,
                            'id_contratto' => $contratto,
                            'note' => 'rinnovo da carrello #' . $carrello['id'] . ' riga #' . $articolo['id'] . ' del ' . date('d/m/Y') . ' per iscrizione #' . $contratto,
                            'data_inizio' => $inizio,
                            'data_fine' => date('Y-m-d',strtotime($incremento,strtotime($inizio)))
                        ),
                        'rinnovi'
                    );

                    /*
                    // se il carrello è pagato...
                    if( ! empty( $carrello['timestamp_pagamento'] ) ) {

                        // iscrivo la persona alle lezioni
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'INSERT INTO attivita ( id, id_tipologia, id_anagrafica_programmazione, id_todo, note_programmazione ) SELECT NULL, 15, ?, todo.id, ? FROM todo WHERE todo.id_progetto = ?',
                            array(
                                array( 's' => $iscritto ),
                                array( 's' => 'frequenza da carrello #' . $carrello['id'] . ' riga #' . $articolo['id'] . ' del ' . date('d/m/Y') . ' per iscrizione #' . $contratto ),
                                array( 's' => $corso )
                            )
                        );

                        // creo la ricevuta

                        // debug
                        // die('carrello pagato!');

                    } else {

                        // debug
                        // die('carrello non pagato!');

                    }
                    */

                    // aggiorno il carrello
                    if( ! empty( $idRinnovo ) ) {

                        // log
                        logger( 'inserito rinnovo: ' . $idRinnovo, 'details/iscrizioni/rinnovi/' . $articolo['destinatario_id_anagrafica'] );

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
                        if( $cf['corsi']['checkout']['documento']['generazione']['automatica'] === true ) {

                            // log
                            logger( 'genero il documento per il rinnovo: ' . $idRinnovo, 'details/iscrizioni/documenti/' . $articolo['destinatario_id_anagrafica'] );

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
                                    'id_tipologia' => $cf['corsi']['checkout']['documento']['generazione']['id_tipologia'],
                                    'id_emittente' => trovaIdAziendaGestita(),
                                    'id_sede_emittente' => trovaIdSedeLegale( trovaIdAziendaGestita() ),
                                    'id_destinatario' => $articolo['destinatario_id_anagrafica'],
                                    'id_sede_destinatario' => trovaIdSedeLegale( $articolo['destinatario_id_anagrafica'] ),
                                    'id_condizione_pagamento' => 2,
                                    'esigibilita' => 'I',
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
                                        'id_udm' => 1,
                                        'importo_netto_totale' => $articolo['prezzo_netto_totale'],
                                        'importo_lordo_totale' => $articolo['prezzo_lordo_totale'],
                                        'sconto_valore' => $articolo['coupon_valore'],
                                        'importo_lordo_finale' => $articolo['prezzo_lordo_finale'],
                                        'id_listino' => 1,
                                        'id_reparto' => 5,
                                        'nome' => 'riga generata automaticamente per il carrello #' . $idCarrello . ' documento #' . $idDocumento
                                    ),
                                    'documenti_articoli'
                                );

                                // inserisco il pagamento
                                $idPagamento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_documento' => $idDocumento,
                                        'id_carrelli_articoli' => $articolo['id'],
                                        'id_tipologia' => NULL,
                                        'id_modalita_pagamento' => 24,  // TODO così è fisso a PayPal, rendere dinamico da carrello
                                        'id_coupon' => $articolo['id_coupon'],
                                        'coupon_valore' => $articolo['coupon_valore'],
                                        'importo_lordo_totale' => $articolo['prezzo_lordo_totale'],
                                        'importo_lordo_finale' => $articolo['prezzo_lordo_finale'],
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

                } else {

                    // debug
                    // die('nessun corso trovato!');

                }

            }

        }

        // debug
        // die( '<pre>' . print_r( $_SESSION['carrello'], true ) . '<pre>' );
        // die( '<pre>' . print_r( $carrello, true ) . '<pre>' );

    } else {

        // debug
        // die('nessun carrello trovato!');

    }
