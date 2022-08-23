<?php

    // debug
    // die( print_r( $_SESSION['carrello'] ) );

    // se è presente un ID carrello
    if( isset( $idCarrello ) && ! empty( $idCarrello ) ) {

        // debug
        $status = array();

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

        // log
        logWrite( 'valuto la creazione di un documento per il carrello #' . $carrello['id'], 'documenti' );

        // se è specificato l'ID del merchant per il profilo corrente
        if( isset( $cf['ecommerce']['profile']['fatturazione']['merchant'] ) && ! empty( $cf['ecommerce']['profile']['fatturazione']['merchant'] ) ) {

            // log
            logWrite( 'utilizzo il merchant #' . $cf['ecommerce']['profile']['fatturazione']['merchant'] . ' per il carrello #' . $carrello['id'], 'documenti' );

            // debug
            $status['info'][] = 'fatturazione per il merchant #' . $cf['ecommerce']['profile']['fatturazione']['merchant'];

            // se è settata una tipologia di documento di default
            if( ! isset( $carrello['fatturazione_id_tipologia_documento'] ) || empty( $carrello['fatturazione_id_tipologia_documento'] ) ) {
                $carrello['fatturazione_id_tipologia_documento'] = $cf['ecommerce']['profile']['fatturazione']['documento'];
            }

            // se è specificata la tipologia di documento da creare per il carrello
            if( isset( $carrello['fatturazione_id_tipologia_documento'] ) && ! empty( $carrello['fatturazione_id_tipologia_documento'] ) ) {

                // debug
                $status['info'][] = 'fatturazione con tipologia documento #' . $carrello['fatturazione_id_tipologia_documento'];

                // TODO creo o identifico l'anagrafica e valorizzo $idAnagrafica
                if( ! empty( $carrello['intestazione_id_anagrafica'] ) ) {

                    // TODO se nel carrello è specificato un ID anagrafica uso quello
                    $idAnagrafica = $carrello['intestazione_id_anagrafica'];

                } elseif( ! empty( $carrello['intestazione_id_account'] ) ) {

                    // TODO se nel carrello è specificato un ID account uso l'ID anagrafica collegato
                    $idAnagrafica = $carrello['intestazione_id_account'];

                } else {

                    // TODO se nel carrello non è specificato un ID anagrafica o un ID account inserisco l'anagrafica
                    $idAnagrafica = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'nome' => $carrello['intestazione_nome'],
                            'cognome' => $carrello['intestazione_cognome'],
                            'denominazione' => $carrello['intestazione_denominazione'],
                            'codice_fiscale' => $carrello['intestazione_codice_fiscale'],
                            'partita_iva' => $carrello['intestazione_partita_iva']
                        ),
                        'anagrafica'
                    );

                }

                // TODO inserisco la mail dell'anagrafica
                $idMail = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_anagrafica' => $idAnagrafica,
                        'indirizzo' => $carrello['intestazione_mail']
                    ),
                    'mail'
                );

                // TODO inserisco il telefono dell'anagrafica
                $idTel = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_anagrafica' => $idAnagrafica,
                        'id_tipologia' => 2,
                        'numero' => $carrello['intestazione_mail']
                    ),
                    'telefoni'
                );

                // TODO inserisco l'indirizzo
                $idIndirizzo = inserisciIndirizzo(
                    $carrello['intestazione_indirizzo'],
                    $carrello['intestazione_cap'],
                    $carrello['intestazione_citta'],
                    NULL,
                    NULL,
                    NULL,
                    NULL,
                    $carrello['intestazione_id_provincia']
                );

                // TODO associo l'indirizzo all'anagrafica
                $idIndirizzoAnagrafica = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_anagrafica' => $idAnagrafica,
                        'id_indirizzo' => $idIndirizzo,
                        'id_ruolo' => 1
                    ),
                    'anagrafica_indirizzi'
                );

                // strategia di fatturazione del carrello
                switch( $carrello['fatturazione_strategia'] ) {

                    case 'SINGOLA':

                        // debug
                        $status['info'][] = 'modalità documento singolo';

                        // genero il sezionale
                        $sezionale = implode( '/', array( $carrello['fatturazione_sezionale'], date( 'Y' ) ) );

                        // genero il numero di documento
                        $numero = generaProssimoNumeroDocumento(
                            $carrello['fatturazione_id_tipologia_documento'],
                            $sezionale,
                            $cf['ecommerce']['profile']['fatturazione']['merchant']
                        );

                        // cerco la sede legale del merchant
                        $idSedeEmittente = anagraficaGetIdSedeLegale( $cf['ecommerce']['profile']['fatturazione']['merchant'] );

                        // se esiste una sede per il merchant
                        if( ! empty( $idSedeEmittente ) ) {

                            // TODO creo il documento con tipologia $carrello['fatturazione_id_tipologia_documento'] e cliente $idAnagrafica
                            // TODO id_condizione_pagamento dovrebbe essere 1 per i pagamenti a rate
                            $idDocumento = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_tipologia' => $carrello['fatturazione_id_tipologia_documento'],
                                    'numero' => $numero,
                                    'sezionale' => $sezionale,
                                    'data' => date( 'Y-m-d' ),
                                    'nome' => 'documento generato automaticamente per il carrello #' . $carrello['id'],
                                    'id_emittente' => $cf['ecommerce']['profile']['fatturazione']['merchant'],
                                    'id_sede_emittente' => $idSedeEmittente,
                                    'id_destinatario' => $idAnagrafica,
                                    'id_sede_destinatario' => $idIndirizzo,
                                    'id_condizione_pagamento' => 2,
                                    'esigibilita' => 'I',
                                    'riferimento' => 'carrello #' . $carrello['id'],
                                    'timestamp_chiusura' => time(),
                                    'progressivo_invio' => generaNumeroProgressivoInvio( $cf['ecommerce']['profile']['fatturazione']['merchant'] ),
                                    'note_chiusura' => 'chiusura automatica contestuale al checkout del carrello #' . $carrello['id']
                                ),
                                'documenti'
                            );

                            // TODO aggiungo le righe al documento
                            foreach( $articoli as $articolo ) {

                                $idRiga[] = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_documento' => $idDocumento,
                                        'id_articolo' => $articolo['id_articolo'],
                                        'id_reparto' => trovaIdRepartoDaIdIva( $articolo['id_iva'] ),
                                        'id_mastro_provenienza' => $cf['ecommerce']['profile']['fatturazione']['magazzino'],
                                        'id_udm' => 1,
                                        'quantita' => $articolo['quantita'],
                                        'id_listino' => $carrello['id_listino'],
                                        'importo_netto_totale' => $articolo['prezzo_netto_totale'],
                                        'note' => 'riga inserita automaticamente per il carrello #' . $carrello['id'] . ' riga #' . $articolo['id']
                                    ),
                                    'documenti_articoli'
                                );

                            }

                            // TODO contemplare il caso delle modalità di pagamento ibride (ad esempio contanti+carta) che avranno due pagamenti diversi

                            // TODO aggiungo la scadenza al documento
                            // TODO se il carrello è già pagato, inserisco una scadenza immediata già pagata
                            // TODO se il carrello non è già pagato inserisco una scadenza non pagata
                            $idPagamento = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_tipologia' => NULL,
                                    'id_modalita_pagamento' => $cf['ecommerce']['profile']['provider'][ $carrello['provider_pagamento'] ]['modalita'],
                                    'nome' => 'pagamento inserito automaticamente per il carrello #' . $carrello['id'],
                                    'id_documento' => $idDocumento,
                                    'id_mastro_destinazione' => $cf['ecommerce']['profile']['fatturazione']['cassa'],
                                    'importo_lordo_totale' => $carrello['prezzo_lordo_finale'],
                                    'id_listino' => $carrello['id_listino'],
                                    'timestamp_scadenza' => time(),
                                    'timestamp_pagamento' => $carrello['timestamp_pagamento']
                                ),
                                'pagamenti'
                            );

                        } else {

                            // debug
                            logWrite( 'impossibile trovare una sede per il merchant #' . $cf['ecommerce']['profile']['merchant'], 'documenti', LOG_CRIT );

                        }

                    break;

                    case 'MULTIPLA':

                        // debug
                        $status['info'][] = 'modalità documenti multipli';

                        // TODO per ogni riga del carrello

                            // TODO creo il documento con tipologia $carrello['fatturazione_id_tipologia_documento'] e cliente $idAnagrafica

                            // TODO aggiungo la riga al documento

                            // TODO aggiungo la scadenza al documento

                                // TODO se il carrello è già pagato, inserisco una scadenza immediata già pagata

                                // TODO se il carrello non è già pagato inserisco una scadenza non pagata

                    break;

                    default:

                        // debug
                        $status['info'][] = 'nessuna strategia di fatturazione specificata';

                        // log
                        logWrite( 'strategia non riconosciuta o non impostata per la fatturazione del carrello #' . $carrello['id'], 'cart', LOG_ERR );

                    break;

                }
                
            } else {

                // debug
                $status['info'][] = 'nessuna tipologia di documento per la fatturazione specificata';

                // log
                logWrite( 'tipologia di documento per la fatturazione non impostata nel carrello #' . $carrello['id'], 'cart', LOG_ERR );

            }

        } else {

            // debug
            $status['info'][] = 'nessun merchant per la fatturazione specificato';

            // log
            logWrite( 'merchant non specificato per la fatturazione del carrello #' . $carrello['id'], 'cart', LOG_ERR );

        }

    }

    // debug
    // die( '<pre>' . print_r( $_SESSION['carrello'], true ) . '<pre>' );
    // die( '<pre>' . print_r( $status, true ) . '<pre>' );
