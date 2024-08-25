<?php

    // debug
    // var_dump( $_REQUEST['__pagamenti__'] );
    // die( print_r( $_REQUEST, true ) );
    // print_r( $_REQUEST );

/*
    // checkout carrello
    if( isset( $_REQUEST['ck_carrello'] ) ) {
        $_REQUEST['__pagamenti__']['id_carrello'] = $_REQUEST['ck_carrello'];
    }
*/

    // se è richiesto un carrello specifico
    if( isset( $_REQUEST['__pagamenti__'] ) ) {

        // debug
        // die( print_r( $_REQUEST['__pagamenti__'], true ) );

        // creo i documenti
        if( isset( $_REQUEST['__pagamenti__']['righe'] ) ) {

            // debug
            // die( print_r( $_REQUEST['__pagamenti__'], true ) );
            // die( $_SESSION['carrello']['fatturazione_strategia'] );
            // die( print_r( $_REQUEST, true ) );

            // ...
            if( empty( $_SESSION['carrello']['fatturazione_strategia'] ) && ! empty( $_REQUEST['__pagamenti__']['fatturazione_strategia'] ) ) {
                $_SESSION['carrello']['fatturazione_strategia'] = $_REQUEST['__pagamenti__']['fatturazione_strategia'];
            }

            // strategia di fatturazione documenti multipli
            if( $_SESSION['carrello']['fatturazione_strategia'] == 'MULTIPLA' ) {

                // per ogni documento richiesto
                foreach( $_REQUEST['__pagamenti__']['righe'] as $pagamento ) {

                    // debug
                    // die( print_r( $pagamento, true ) );

                    // se la checkbox è flaggata
                    if( ! empty( $pagamento['da_fare'] ) ) {

                        // debug
                        // die( print_r( $pagamento, true ) );

                        // se il totale è maggiore di zero
                        if( $pagamento['importo_lordo_totale'] > 0 ) {

                            // debug
                            // echo 'creazione rata (pagamento #' . $idPagamento . ')' . PHP_EOL;
                            // die( print_r( $pagamento, true ) );

                            // se sto creando una rata
                            if( empty( $pagamento['id_pagamento'] ) && ! empty( $_REQUEST['__pagamenti__']['data_rate'] ) ) {

                                // aggiungo il pagamento
                                $idPagamento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_creditore' => trovaIdAziendaGestita(),
                                        'id_debitore' => $pagamento['destinatario_id_anagrafica'],
                                        'id_carrelli_articoli' => $pagamento['id'],
                                        'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                        'importo_lordo_finale' => $pagamento['importo_lordo_finale'],
                                        'data_scadenza' => $_REQUEST['__pagamenti__']['data_rate'],
                                        'nome' => 'rata da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id'],
                                        'timestamp_inserimento' => time(),
                                        'id_account_inserimento' => $_SESSION['account']['id'],
                                        // TODO manca l'id listino
                                        // TODO manca coupon valore
                                        // TODO manca la modalità di pagamento
                                    ),
                                    'pagamenti'
                                );

                                // debug
                                // echo 'creazione rata (pagamento #' . $idPagamento . ')' . PHP_EOL;
                                // die( print_r( $pagamento, true ) );

                            } else {

                                // se sto pagando direttamente oppure sto pagando una rata

                                // debug
                                // die( print_r( $pagamento, true ) );
            
                                // TODO se non è settato il destinatario per riga, recuperare quello del carrello
                                if( empty( $pagamento['destinatario_id_anagrafica'] ) ) {
                                    $pagamento['destinatario_id_anagrafica'] = mysqlSelectValue(
                                        $cf['mysql']['connection'],
                                        'SELECT intestazione_id_anagrafica FROM carrelli WHERE id = ?',
                                        array( array( 's' => $pagamento['id_carrello'] ) )
                                    );
                                }

                                // imposto il documento
                                $nome = 'documento creato automaticamente per il ' . 
                                    ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'pagamento #' . $pagamento['id_pagamento'] . ' ' : NULL ) . 
                                    'carrello #' . $pagamento['id_carrello'] .  ' ' . 
                                    'anagrafica #'. $pagamento['destinatario_id_anagrafica'] .' (' . $pagamento['destinatario'] . ')';
                                $sezionale = 'C/' . date('Y');
                                $emittente = trovaIdAziendaGestita();

                                // debug
                                // var_dump( $emittente );

                                // debug
                                if( empty( $emittente ) ) {
                                    die( 'impossibile trovare l\'azienda gestita' );
                                }

                                $idSedeEmittente = anagraficaGetIdSedeLegale( $emittente );
                                $idSedeDestinatario = anagraficaGetIdSedeLegale( $pagamento['destinatario_id_anagrafica'] );
                                $numero = generaProssimoNumeroDocumento( $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'], $sezionale, $emittente );
                                $data = date('Y-m-d');

                                // creo il documento
                                $idDocumento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_tipologia' => $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'],
                                        'nome' => $nome,
                                        'numero' => $numero,
                                        'sezionale' => $sezionale,
                                        'esigibilita' => 'I',
                                        'id_condizione_pagamento' => 2,
                                        'id_emittente' => $emittente,
                                        'id_sede_emittente' => $idSedeEmittente,
                                        'id_destinatario' => $pagamento['destinatario_id_anagrafica'],
                                        'id_sede_destinatario' => $idSedeDestinatario,
                                        'data' => $data
                                    ),
                                    'documenti'
                                );

                                // trovo il reparto
                                $reparto = mysqlSelectRow(
                                    $cf['mysql']['connection'],
                                    'SELECT reparti.id, iva.aliquota FROM articoli
                                        INNER JOIN reparti ON reparti.id = articoli.id_reparto 
                                        INNER JOIN iva ON iva.id = reparti.id_iva 
                                        WHERE articoli.id = ?',
                                        array( array( 's' => $pagamento['id_articolo'] ) )
                                );

                                // debug
                                // print_r( $pagamento );
                                // die( print_r( $reparto, true ) );

                                // calcolo il netto
                                $pagamento['importo_netto_totale'] = $pagamento['importo_lordo_totale'] / ( 100 + $reparto['aliquota'] ) * 100;

                                // aggiungo la riga
                                $idRiga = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_documento' => $idDocumento,
                                        'id_articolo' => $pagamento['id_articolo'],
                                        'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                        'id_carrelli_articoli' => $pagamento['id'],
                                        'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                        'importo_lordo_totale' => $pagamento['importo_lordo_totale'],
                                        'quantita' => 1,
                                        'id_udm' => 1,
                                        'id_reparto' => $reparto['id'],
                                        'id_listino' => 1,
                                        'nome' => 'riga automatica da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                                    ),
                                    'documenti_articoli'
                                );

                                // calcolo il valore del coupon
                                $pagamento['coupon_valore'] = ( ! empty( $pagamento['id_coupon'] ) ) ? calcolaValoreCouponPerPagamento(
                                    $cf['mysql']['connection'],
                                    $pagamento['id_coupon'],
                                    $pagamento['id'],
                                    $pagamento['importo_lordo_totale']
                                ) : 0.0;

                                // calcolo il netto
                                $pagamento['importo_lordo_finale'] = $pagamento['importo_lordo_totale'] - $pagamento['coupon_valore'];

                                // associo il pagamento
                                $idPagamento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? $pagamento['id_pagamento'] : null ),
                                        'id_documento' => $idDocumento,
                                        'id_carrelli_articoli' => $pagamento['id'],
                                        'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                        'timestamp_pagamento' => time(),
                                        // 'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                        'importo_lordo_totale' => $pagamento['importo_lordo_totale'],
                                        'id_coupon' => ( ( isset( $pagamento['id_coupon'] ) ) ? $pagamento['id_coupon'] : NULL ),
                                        'coupon_valore' => $pagamento['coupon_valore'],
                                        'importo_lordo_finale' => $pagamento['importo_lordo_finale'],
                                        'nome' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'rata pagata' : 'pagamento diretto' ) . 
                                            ' da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id'],
                                        'timestamp_inserimento' => time(),
                                        'id_account_inserimento' => $_SESSION['account']['id'],
                                        // TODO manca l'id listino
                                        // TODO manca la modalità di pagamento
                                    ),
                                    'pagamenti'
                                );

                                if( isset( $pagamento['autoprint'] ) && ! empty( $pagamento['autoprint'] ) ) {

                                    // annoto l'attività di stampa
                                    $idAttivitaStampa = mysqlInsertRow(
                                        $cf['mysql']['connection'],
                                        array(
                                            'id_tipologia' => 23,
                                            'id_documento' => $idDocumento,
                                            'data_attivita' => date('Y-m-d'),
                                            'nome' => 'stampa documento (macro custom '.__FILE__.')',
                                            'ora_inizio' => date( 'H:i:s' ),
                                            'ora_fine' => date( 'H:i:s' )
                                        ),
                                        'attivita'
                                    );

                                    // debug
                                    // var_dump( $idAttivitaStampa );
                                    // var_dump( $idDocumento );

                                }

                                // debug
                                // echo 'creazione ricevuta (documento #' . $idDocumento . ', riga #' . $idRiga . ', pagamento #' . $idPagamento . ')' . PHP_EOL;
                                // die( print_r( $pagamento, true ) );

                            }

                        } else {

                            // debug
                            // echo 'creazione ricevuta (documento #' . $idDocumento . ', riga #' . $idRiga . ', pagamento #' . $idPagamento . ')' . PHP_EOL;
                            // die( print_r( $pagamento, true ) );

                        }

                    } else {

                        // debug
                        // ...

                    }


                }

            } else {

                // imposto il documento
                $nome = 'documento creato automaticamente per il ' . 
                    ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'pagamento #' . $pagamento['id_pagamento'] . ' ' : NULL ) . 
                    'carrello #' . $pagamento['id_carrello'] .  ' ' . 
                    'anagrafica #'. $pagamento['destinatario_id_anagrafica'] .' (' . $pagamento['destinatario'] . ')';
                $sezionale = 'C/' . date('Y');
                $emittente = trovaIdAziendaGestita();

                // debug
                // var_dump( $emittente );

                // debug
                if( empty( $emittente ) ) {
                    die( 'impossibile trovare l\'azienda gestita' );
                }

                $idSedeEmittente = anagraficaGetIdSedeLegale( $emittente );
                $idSedeDestinatario = anagraficaGetIdSedeLegale( $pagamento['destinatario_id_anagrafica'] );
                $numero = generaProssimoNumeroDocumento( $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'], $sezionale, $emittente );
                $data = date('Y-m-d');

                // creo il documento
                $idDocumento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_tipologia' => $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'],
                        'nome' => $nome,
                        'numero' => $numero,
                        'sezionale' => $sezionale,
                        'esigibilita' => 'I',
                        'id_condizione_pagamento' => 2,
                        'id_emittente' => $emittente,
                        'id_sede_emittente' => $idSedeEmittente,
                        'id_destinatario' => $pagamento['destinatario_id_anagrafica'],
                        'id_sede_destinatario' => $idSedeDestinatario,
                        'data' => $data
                    ),
                    'documenti'
                );

                // debug
                // print_r( $_REQUEST['__pagamenti__']['righe'] );

                // per ogni documento richiesto
                foreach( $_REQUEST['__pagamenti__']['righe'] as $pagamento ) {

                    // se la checkbox è flaggata
                    if( ! empty( $pagamento['da_fare'] ) ) {

                        // trovo il reparto
                        $reparto = mysqlSelectRow(
                            $cf['mysql']['connection'],
                            'SELECT reparti.id, iva.aliquota FROM articoli INNER JOIN reparti ON reparti.id = articoli.id_reparto 
                                INNER JOIN iva ON iva.id = reparti.id_iva WHERE articoli.id = ?',
                                array( array( 's' => $pagamento['id_articolo'] ) )
                        );

                        // debug
                        // die( print_r( $reparto, true ) );

                        // calcolo il netto
                        $pagamento['importo_netto_totale'] = $pagamento['importo_lordo_finale'] / ( 100 + $reparto['aliquota'] ) * 100;

                        // aggiungo la riga
                        $idRiga = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_documento' => $idDocumento,
                                'id_articolo' => $pagamento['id_articolo'],
                                'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                'id_carrelli_articoli' => $pagamento['id'],
                                'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                'importo_lordo_totale' => $pagamento['importo_lordo_finale'],
                                'id_mastro_provenienza' => $pagamento['id_mastro_provenienza'],
                                'quantita' => $pagamento['quantita'],
                                'id_udm' => 1,
                                'id_reparto' => $reparto['id'],
                                'id_listino' => 1,
                                'nome' => 'riga automatica da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                            ),
                            'documenti_articoli'
                        );

                        // debug
                        // print_r( $pagamento );

                        /*
                        // associo il pagamento
                        $idPagamento = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? $pagamento['id_pagamento'] : null ),
                                'id_documento' => $idDocumento,
                                'timestamp_pagamento' => time(),
                                'importo_lordo_totale' => $pagamento['importo_lordo_totale'],
                                'nome' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'rata pagata' : 'pagamento diretto' ) . 
                                    ' da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                            ),
                            'pagamenti'
                        );
                        */

                        // debug
                        // echo 'creazione ricevuta (documento #' . $idDocumento . ', riga #' . $idRiga . ', pagamento #' . $idPagamento . ')' . PHP_EOL;
                        // die( print_r( $pagamento, true ) );

                    }

                }

            }

            // debug
            // die( $_REQUEST['__pagamenti__'] );

            // se è richiesto un carrello specifico
            if( isset( $idDocumento ) ) {

                if( isset( $_REQUEST['__pagamenti__']['autoprint'] ) && ! empty( $_REQUEST['__pagamenti__']['autoprint'] ) ) {

                    // annoto l'attività di stampa
                    $idAttivitaStampa = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_tipologia' => 23,
                            'id_documento' => $idDocumento,
                            'data_attivita' => date('Y-m-d'),
                            'nome' => 'stampa documento (macro custom '.__FILE__.')',
                            'ora_inizio' => date( 'H:i:s' ),
                            'ora_fine' => date( 'H:i:s' )
                        ),
                        'attivita'
                    );

                    // debug
                    // var_dump( $idAttivitaStampa );
                    // var_dump( $idDocumento );

                }

            }

        } else {

            // debug
            // ...

        }

        // tipo di ricerca (carrello o cliente)
        if( isset( $_REQUEST['__pagamenti__']['id_carrello'] ) && ! empty( $_REQUEST['__pagamenti__']['id_carrello'] ) ) {

            // seleziono i dettagli del carrello
            $ct['etc']['carrello'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * '.
                'FROM carrelli '.
                'WHERE id = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_carrello'] ) )
            );

            // seleziono le righe del carrello
            $ct['etc']['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, 
                    concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione, 
                    carrelli.fatturazione_id_tipologia_documento, carrelli.id AS id_carrello, 
                    carrelli_articoli.* 
                    FROM carrelli_articoli 
                    INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo 
                    INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto 
                    INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello 
                    LEFT JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica 
                    WHERE id_carrello = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_carrello'] ) )
            );

            /*
            // seleziono i documenti da stampare
            $ct['etc']['stampe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT documenti_view.* FROM documenti_view LEFT JOIN attivita ON ( attivita.id_documento = documenti_view.id AND attivita.id_tipologia IN ( 22, 23, 24 ) ) WHERE id_destinatario = ? AND attivita.id IS NULL',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
            );
            */

            // debug
            // die( print_r( $ct['etc'], true ) );
            // die( print_r( $ct['etc']['righe'], true ) );

        } elseif( isset( $_REQUEST['__pagamenti__']['id_cliente'] ) && ! empty( $_REQUEST['__pagamenti__']['id_cliente'] ) ) {

            // seleziono le righe del carrello
            $ct['etc']['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, 
                    concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione, 
                    carrelli.fatturazione_id_tipologia_documento, 
                    carrelli_articoli.* 
                    FROM carrelli_articoli 
                    INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo 
                    INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto 
                    INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello 
                    LEFT JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica 
                    WHERE carrelli_articoli.destinatario_id_anagrafica = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
            );

            // seleziono le rate
            $ct['etc']['righe'] = array_merge(
                $ct['etc']['righe'],
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pagamenti.id AS id_pagamento, pagamenti.importo_lordo_finale, pagamenti.timestamp_pagamento, pagamenti.id_rinnovo, pagamenti.coupon_valore,
                        concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, 
                        concat_ws( " ", prodotti.nome, articoli.nome, " rata del ", pagamenti.data_scadenza ) AS descrizione, 
                        carrelli.id AS id_carrello, carrelli.fatturazione_id_tipologia_documento, 
                        carrelli_articoli.id, carrelli_articoli.id_articolo, carrelli_articoli.destinatario_id_anagrafica, carrelli_articoli.id_mastro_provenienza, carrelli_articoli.prezzo_lordo_finale 
                        FROM pagamenti 
                        INNER JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli 
                        INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello 
                        INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo 
                        INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto 
                        LEFT JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica 
                        WHERE pagamenti.id_debitore = ? -- AND pagamenti.id_documento IS NULL',
                    array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
                )
            );

            /*
            // seleziono i documenti da stampare
            $ct['etc']['stampe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT documenti_view.* FROM documenti_view LEFT JOIN attivita ON ( attivita.id_documento = documenti_view.id AND attivita.id_tipologia IN ( 22, 23, 24 ) ) WHERE id_destinatario = ? AND attivita.id IS NULL',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
            );
            */

        }

        // print_r( $_REQUEST );
        // var_dump( $_REQUEST['__pagamenti__']['id_carrello'] );
        // var_dump( $ct['etc']['righe'] );
        // die( print_r( $ct['etc']['righe'], true ) );

        // per ogni riga, cerco eventuali pagamenti già effettuati
        if( isset( $ct['etc']['righe'] ) ) {

            // ...
            foreach( $ct['etc']['righe'] as $chiave => &$riga ) {

                // debug
                // die( print_r( $riga, true ) );

                // totale pagato
                $riga['totale_lordo_pagato'] = 0;

                if( isset( $riga['id_pagamento'] ) ) {

                    // cerco righe di documenti che fanno riferimento a questa riga di carrello
                    // TODO in teoria bisognerebbe poi controllare che il documento abbia pagamenti pagati ecc.
                    $righe = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT documenti_articoli.*, pagamenti.timestamp_pagamento, pagamenti.coupon_valore, '.
                        'concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento '.
                        'FROM documenti '.
                        'INNER JOIN pagamenti ON documenti.id = pagamenti.id_documento '.
                        'INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id '.
                        'WHERE pagamenti.id = ? AND pagamenti.id_carrelli_articoli IS NOT NULL',
                        array( array( 's' => $riga['id_pagamento'] ) )
                    );

                    // totale già pagato
                    $riga['totale_lordo_pagato'] = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT pagamenti.importo_lordo_totale
                            FROM pagamenti 
                            WHERE pagamenti.id = ? AND pagamenti.timestamp_pagamento IS NOT NULL',
                        array( array( 's' => $riga['id_pagamento'] ) )
                    );

                } else {

                    // cerco righe di documenti che fanno riferimento a questa riga di carrello
                    // TODO in teoria bisognerebbe poi controllare che il documento abbia pagamenti pagati ecc.
                    /*
                    $righe = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT documenti_articoli.*, pagamenti.timestamp_pagamento, 
                            concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento 
                            FROM documenti_articoli 
                            INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento 
                            LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id 
                            WHERE documenti_articoli.id_carrelli_articoli = ? 
                            AND pagamenti.id_carrelli_articoli IS NULL',
                        array( array( 's' => $riga['id'] ) )
                    );
                    */

                    $righe = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT documenti_articoli.*, pagamenti.timestamp_pagamento, 
                            concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento 
                            FROM documenti_articoli 
                            INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento 
                            LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id 
                            WHERE documenti_articoli.id_carrelli_articoli = ?',
                        array( array( 's' => $riga['id'] ) )
                    );

                    // echo( $riga['id'] );
                    // die( print_r( $righe, true ) );

                    // totale già pagato
                    $riga['totale_lordo_pagato'] = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT sum( pagamenti.importo_lordo_totale ) '.
                        'FROM documenti '.
                        'INNER JOIN pagamenti ON documenti.id = pagamenti.id_documento '.
                        'INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id '.
                        'WHERE documenti_articoli.id_carrelli_articoli = ? AND pagamenti.timestamp_pagamento IS NOT NULL',
                        array( array( 's' => $riga['id'] ) )
                    );

                    // totale già pagato
                    $riga['coupon_valore'] = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT sum( pagamenti.coupon_valore ) '.
                        'FROM documenti '.
                        'INNER JOIN pagamenti ON documenti.id = pagamenti.id_documento '.
                        'INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id '.
                        'WHERE documenti_articoli.id_carrelli_articoli = ? AND pagamenti.timestamp_pagamento IS NOT NULL',
                        array( array( 's' => $riga['id'] ) )
                    );

                }

                // totale rateizzato
                $riga['totale_lordo_rateizzato'] = 0;

                // documenti da stampare
                $riga['documenti_da_stampare'] = array();

                // debug
                // echo 'riga ' . $riga['id'] . '/' . $riga['id_pagamento'] . ' - ' . $riga['totale_lordo_pagato'] . PHP_EOL;
                // die( 'riga ' . $riga['id'] . ' - ' . $riga['totale_lordo_pagato'] );
                // die( print_r( $righe, true ) );

                // calcolo il totale già pagato
                // NOTA faccio un ciclo così se in un secondo momento voglio i dettagli ce li ho già sgranati
                foreach( $righe as $rdoc ) {

                    // aggiungo il totale della riga
                    // $riga['totale_lordo_pagato'] += $rdoc['importo_lordo_finale'];

                    // ...
                    if( isset( $rdoc['id_documento'] ) && ! empty( $rdoc['id_documento'] ) ) {

                        // debug
                        // die( print_r( $rdoc, true ) );

                        // stampe del documento
                        $stampe = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT count( attivita.id ) FROM attivita 
                            INNER JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia 
                            WHERE attivita.id_documento = ? AND tipologie_attivita.se_stampa IS NOT NULL',
                            array( array( 's' => $rdoc['id_documento'] ) )
                        );

                        // ...
                        if( empty( $stampe ) ) {

                            // documenti da stampare
                            $riga['documenti_da_stampare'][] = array(
                                'id' => $rdoc['id_documento'],
                                'documento' => $rdoc['documento']
                            );

                        } else {

                            // documenti da stampare
                            $riga['documenti_stampati'][] = array(
                                'id' => $rdoc['id_documento'],
                                'documento' => $rdoc['documento']
                            );

                        }

                    }

                }

                // TODO trovare se ci sono documenti da generare
                $riga['documenti_generati'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT count( documenti_articoli.id ) 
                    FROM documenti_articoli
                    WHERE documenti_articoli.id_carrelli_articoli = ?',
                    array( array( 's' => $riga['id'] ) )
                );

                // pagamenti in sospeso (rate)
                $rate = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pagamenti.* '.
                    'FROM pagamenti '.
                    'WHERE id_documento IS NULL AND id_carrelli_articoli = ?',
                    array( array( 's' => $riga['id'] ) )
                );

                // calcolo il totale già pagato
                if( is_array( $rate ) ) {
                    foreach( $rate as $rata ) {

                        // aggiungo il totale della riga
                        $riga['totale_lordo_rateizzato'] += $rata['importo_lordo_finale'];
    
                    }
                }

                // totale da pagare
                if( empty( $riga['id_pagamento'] ) ) {
                    $riga['totale_lordo_da_pagare'] = $riga['prezzo_lordo_finale'] - $riga['totale_lordo_pagato'] - $riga['totale_lordo_rateizzato'];
                } else {
                    $riga['totale_lordo_da_pagare'] = $riga['importo_lordo_totale'] - $riga['totale_lordo_pagato'];
                }

                // se la riga è pagata e non ha documenti da stampare, non la mostro
                if( count( $riga['documenti_da_stampare'] ) == 0 ) {
                    if( ! empty( $riga['prezzo_lordo_totale'] ) ) {
                        if( ! empty( $riga['timestamp_pagamento'] ) ) {
                            unset( $ct['etc']['righe'][ $chiave ] );
                        } elseif( isset( $riga['id_carrello'] ) && empty( $riga['totale_lordo_da_pagare'] ) ) {
                            if( $riga['documenti_generati'] > 0 ) {
                                unset( $ct['etc']['righe'][ $chiave ] );
                            }
#                            unset( $ct['etc']['righe'][ $chiave ] );
                        }
                    } elseif( empty( $riga['totale_lordo_da_pagare'] ) && ! empty( $riga['documenti_stampati'] ) ) {
                        unset( $ct['etc']['righe'][ $chiave ] );
                    }
                }

                // print_r( $riga );

            }

        }

    }

    $ct['etc']['id_tipologia_documenti'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_documenti.nome AS __label__, tipologie_documenti.id '
        .'FROM tipologie_documenti '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'ORDER BY __label__  '
    );

    $ct['etc']['id_modalita_pagamento'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT modalita_pagamento.nome AS __label__, modalita_pagamento.id '
        .'FROM modalita_pagamento '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'WHERE id IN ( 1, 2, 23, 24 ) '
        .'ORDER BY __label__ '
    );

	$ct['etc']['strategie_fatturazione'] = array( 
	    array( 'id' => 'SINGOLA', '__label__' => 'documento unico' ),
	    array( 'id' => 'MULTIPLA', '__label__' => 'documenti separati' ),
	);

    $ct['etc']['default']['fatturazione_id_tipologia_documento'] = (
        ( isset( $_SESSION['carrello']['fatturazione_id_tipologia_documento'] ) && ! empty( $_SESSION['carrello']['fatturazione_id_tipologia_documento'] ) )
        ?
        $_SESSION['carrello']['fatturazione_id_tipologia_documento']
        :
        (
            ( isset( $ct['etc']['carrello']['fatturazione_id_tipologia_documento'] ) && ! empty( $ct['etc']['carrello']['fatturazione_id_tipologia_documento'] ) )
            ?
            $ct['etc']['carrello']['fatturazione_id_tipologia_documento']
            :
            $cf['ecommerce']['fields']['carrello']['fatturazione_id_tipologia_documento']['default']
        )
    );

    $ct['etc']['default']['fatturazione_strategia'] = (
        ( isset( $_SESSION['carrello']['fatturazione_strategia'] ) && ! empty( $_SESSION['carrello']['fatturazione_strategia'] ) )
        ?
        $_SESSION['carrello']['fatturazione_strategia']
        :
        (
            ( isset( $ct['etc']['carrello']['fatturazione_strategia'] ) && ! empty( $ct['etc']['carrello']['fatturazione_strategia'] ) )
            ?
            $ct['etc']['carrello']['fatturazione_strategia']
            :
            $cf['ecommerce']['fields']['carrello']['fatturazione_strategia']['default']
        )
    );
/*
    $ct['etc']['default']['fatturazione_id_modalita_pagamento'] = (
        ( isset( $_SESSION['carrello']['fatturazione_id_modalita_pagamento'] ) && ! empty( $_SESSION['carrello']['fatturazione_id_modalita_pagamento'] ) )
        ?
        $_SESSION['carrello']['fatturazione_id_modalita_pagamento']
        :
        (
            ( isset( $ct['etc']['carrello']['fatturazione_id_modalita_pagamento'] ) && ! empty( $ct['etc']['carrello']['fatturazione_id_modalita_pagamento'] ) )
            ?
            $ct['etc']['carrello']['fatturazione_id_modalita_pagamento']
            :
            $cf['ecommerce']['fields']['carrello']['fatturazione_id_modalita_pagamento']['default']
        )
    );
*/

/*
    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, coupon.id 
        FROM coupon 
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() ) AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        ORDER BY coupon.id '
    );
*/

    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, 
            coalesce( sum( pagamenti.coupon_valore ), 0 ) AS utilizzato, ( coupon.sconto_fisso - coalesce( sum( pagamenti.coupon_valore ), 0 ) ) AS residuo
        FROM coupon 
        LEFT JOIN pagamenti ON coupon.id = pagamenti.id_coupon
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() ) AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        GROUP BY coupon.id
        HAVING utilizzato < coupon.sconto_fisso
        ORDER BY coupon.id 
        '
    );

    // debug
    // print_r($ct['etc']['righe']);
    // die();
cat: cat: File o directory non esistente
<?php

    // debug
    // var_dump( $_REQUEST['__pagamenti__'] );
    // die( print_r( $_REQUEST, true ) );
    // print_r( $_REQUEST );

/*
    // checkout carrello
    if( isset( $_REQUEST['ck_carrello'] ) ) {
        $_REQUEST['__pagamenti__']['id_carrello'] = $_REQUEST['ck_carrello'];
    }
*/

    // se è richiesto un carrello specifico
    if( isset( $_REQUEST['__pagamenti__'] ) ) {

        // debug
        // die( print_r( $_REQUEST['__pagamenti__'], true ) );

        // creo i documenti
        if( isset( $_REQUEST['__pagamenti__']['righe'] ) ) {

            // debug
            // die( print_r( $_REQUEST['__pagamenti__'], true ) );
            // die( $_SESSION['carrello']['fatturazione_strategia'] );
            // die( print_r( $_REQUEST, true ) );

            // ...
            if( empty( $_SESSION['carrello']['fatturazione_strategia'] ) && ! empty( $_REQUEST['__pagamenti__']['fatturazione_strategia'] ) ) {
                $_SESSION['carrello']['fatturazione_strategia'] = $_REQUEST['__pagamenti__']['fatturazione_strategia'];
            }

            // strategia di fatturazione documenti multipli
            if( $_SESSION['carrello']['fatturazione_strategia'] == 'MULTIPLA' ) {

                // per ogni documento richiesto
                foreach( $_REQUEST['__pagamenti__']['righe'] as $pagamento ) {

                    // debug
                    // die( print_r( $pagamento, true ) );

                    // se la checkbox è flaggata
                    if( ! empty( $pagamento['da_fare'] ) ) {

                        // debug
                        // die( print_r( $pagamento, true ) );

                        // se il totale è maggiore di zero
                        if( $pagamento['importo_lordo_totale'] > 0 ) {

                            // debug
                            // echo 'creazione rata (pagamento #' . $idPagamento . ')' . PHP_EOL;
                            // die( print_r( $pagamento, true ) );

                            // se sto creando una rata
                            if( empty( $pagamento['id_pagamento'] ) && ! empty( $_REQUEST['__pagamenti__']['data_rate'] ) ) {

                                // aggiungo il pagamento
                                $idPagamento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_creditore' => trovaIdAziendaGestita(),
                                        'id_debitore' => $pagamento['destinatario_id_anagrafica'],
                                        'id_carrelli_articoli' => $pagamento['id'],
                                        'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                        'importo_lordo_finale' => $pagamento['importo_lordo_finale'],
                                        'data_scadenza' => $_REQUEST['__pagamenti__']['data_rate'],
                                        'nome' => 'rata da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id'],
                                        'timestamp_inserimento' => time(),
                                        'id_account_inserimento' => $_SESSION['account']['id'],
                                        // TODO manca l'id listino
                                        // TODO manca coupon valore
                                        // TODO manca la modalità di pagamento
                                    ),
                                    'pagamenti'
                                );

                                // debug
                                // echo 'creazione rata (pagamento #' . $idPagamento . ')' . PHP_EOL;
                                // die( print_r( $pagamento, true ) );

                            } else {

                                // se sto pagando direttamente oppure sto pagando una rata

                                // debug
                                // die( print_r( $pagamento, true ) );
            
                                // TODO se non è settato il destinatario per riga, recuperare quello del carrello
                                if( empty( $pagamento['destinatario_id_anagrafica'] ) ) {
                                    $pagamento['destinatario_id_anagrafica'] = mysqlSelectValue(
                                        $cf['mysql']['connection'],
                                        'SELECT intestazione_id_anagrafica FROM carrelli WHERE id = ?',
                                        array( array( 's' => $pagamento['id_carrello'] ) )
                                    );
                                }

                                // imposto il documento
                                $nome = 'documento creato automaticamente per il ' . 
                                    ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'pagamento #' . $pagamento['id_pagamento'] . ' ' : NULL ) . 
                                    'carrello #' . $pagamento['id_carrello'] .  ' ' . 
                                    'anagrafica #'. $pagamento['destinatario_id_anagrafica'] .' (' . $pagamento['destinatario'] . ')';
                                $sezionale = 'C/' . date('Y');
                                $emittente = trovaIdAziendaGestita();

                                // debug
                                // var_dump( $emittente );

                                // debug
                                if( empty( $emittente ) ) {
                                    die( 'impossibile trovare l\'azienda gestita' );
                                }

                                $idSedeEmittente = anagraficaGetIdSedeLegale( $emittente );
                                $idSedeDestinatario = anagraficaGetIdSedeLegale( $pagamento['destinatario_id_anagrafica'] );
                                $numero = generaProssimoNumeroDocumento( $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'], $sezionale, $emittente );
                                $data = date('Y-m-d');

                                // creo il documento
                                $idDocumento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_tipologia' => $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'],
                                        'nome' => $nome,
                                        'numero' => $numero,
                                        'sezionale' => $sezionale,
                                        'esigibilita' => 'I',
                                        'id_condizione_pagamento' => 2,
                                        'id_emittente' => $emittente,
                                        'id_sede_emittente' => $idSedeEmittente,
                                        'id_destinatario' => $pagamento['destinatario_id_anagrafica'],
                                        'id_sede_destinatario' => $idSedeDestinatario,
                                        'data' => $data
                                    ),
                                    'documenti'
                                );

                                // trovo il reparto
                                $reparto = mysqlSelectRow(
                                    $cf['mysql']['connection'],
                                    'SELECT reparti.id, iva.aliquota FROM articoli
                                        INNER JOIN reparti ON reparti.id = articoli.id_reparto 
                                        INNER JOIN iva ON iva.id = reparti.id_iva 
                                        WHERE articoli.id = ?',
                                        array( array( 's' => $pagamento['id_articolo'] ) )
                                );

                                // debug
                                // print_r( $pagamento );
                                // die( print_r( $reparto, true ) );

                                // calcolo il netto
                                $pagamento['importo_netto_totale'] = $pagamento['importo_lordo_totale'] / ( 100 + $reparto['aliquota'] ) * 100;

                                // aggiungo la riga
                                $idRiga = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id_documento' => $idDocumento,
                                        'id_articolo' => $pagamento['id_articolo'],
                                        'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                        'id_carrelli_articoli' => $pagamento['id'],
                                        'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                        'importo_lordo_totale' => $pagamento['importo_lordo_totale'],
                                        'quantita' => 1,
                                        'id_udm' => 1,
                                        'id_reparto' => $reparto['id'],
                                        'id_listino' => 1,
                                        'nome' => 'riga automatica da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                                    ),
                                    'documenti_articoli'
                                );

                                // calcolo il valore del coupon
                                $pagamento['coupon_valore'] = ( ! empty( $pagamento['id_coupon'] ) ) ? calcolaValoreCouponPerPagamento(
                                    $cf['mysql']['connection'],
                                    $pagamento['id_coupon'],
                                    $pagamento['id'],
                                    $pagamento['importo_lordo_totale']
                                ) : 0.0;

                                // calcolo il netto
                                $pagamento['importo_lordo_finale'] = $pagamento['importo_lordo_totale'] - $pagamento['coupon_valore'];

                                // associo il pagamento
                                $idPagamento = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? $pagamento['id_pagamento'] : null ),
                                        'id_documento' => $idDocumento,
                                        'id_carrelli_articoli' => $pagamento['id'],
                                        'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                        'timestamp_pagamento' => time(),
                                        // 'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                        'importo_lordo_totale' => $pagamento['importo_lordo_totale'],
                                        'id_coupon' => ( ( isset( $pagamento['id_coupon'] ) ) ? $pagamento['id_coupon'] : NULL ),
                                        'coupon_valore' => $pagamento['coupon_valore'],
                                        'importo_lordo_finale' => $pagamento['importo_lordo_finale'],
                                        'nome' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'rata pagata' : 'pagamento diretto' ) . 
                                            ' da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id'],
                                        'timestamp_inserimento' => time(),
                                        'id_account_inserimento' => $_SESSION['account']['id'],
                                        // TODO manca l'id listino
                                        // TODO manca la modalità di pagamento
                                    ),
                                    'pagamenti'
                                );

                                if( isset( $pagamento['autoprint'] ) && ! empty( $pagamento['autoprint'] ) ) {

                                    // annoto l'attività di stampa
                                    $idAttivitaStampa = mysqlInsertRow(
                                        $cf['mysql']['connection'],
                                        array(
                                            'id_tipologia' => 23,
                                            'id_documento' => $idDocumento,
                                            'data_attivita' => date('Y-m-d'),
                                            'nome' => 'stampa documento (macro custom '.__FILE__.')',
                                            'ora_inizio' => date( 'H:i:s' ),
                                            'ora_fine' => date( 'H:i:s' )
                                        ),
                                        'attivita'
                                    );

                                    // debug
                                    // var_dump( $idAttivitaStampa );
                                    // var_dump( $idDocumento );

                                }

                                // debug
                                // echo 'creazione ricevuta (documento #' . $idDocumento . ', riga #' . $idRiga . ', pagamento #' . $idPagamento . ')' . PHP_EOL;
                                // die( print_r( $pagamento, true ) );

                            }

                        } else {

                            // debug
                            // echo 'creazione ricevuta (documento #' . $idDocumento . ', riga #' . $idRiga . ', pagamento #' . $idPagamento . ')' . PHP_EOL;
                            // die( print_r( $pagamento, true ) );

                        }

                    } else {

                        // debug
                        // ...

                    }


                }

            } else {

                // imposto il documento
                $nome = 'documento creato automaticamente per il ' . 
                    ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'pagamento #' . $pagamento['id_pagamento'] . ' ' : NULL ) . 
                    'carrello #' . $pagamento['id_carrello'] .  ' ' . 
                    'anagrafica #'. $pagamento['destinatario_id_anagrafica'] .' (' . $pagamento['destinatario'] . ')';
                $sezionale = 'C/' . date('Y');
                $emittente = trovaIdAziendaGestita();

                // debug
                // var_dump( $emittente );

                // debug
                if( empty( $emittente ) ) {
                    die( 'impossibile trovare l\'azienda gestita' );
                }

                $idSedeEmittente = anagraficaGetIdSedeLegale( $emittente );
                $idSedeDestinatario = anagraficaGetIdSedeLegale( $pagamento['destinatario_id_anagrafica'] );
                $numero = generaProssimoNumeroDocumento( $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'], $sezionale, $emittente );
                $data = date('Y-m-d');

                // creo il documento
                $idDocumento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_tipologia' => $_REQUEST['__pagamenti__']['fatturazione_id_tipologia_documento'],
                        'nome' => $nome,
                        'numero' => $numero,
                        'sezionale' => $sezionale,
                        'esigibilita' => 'I',
                        'id_condizione_pagamento' => 2,
                        'id_emittente' => $emittente,
                        'id_sede_emittente' => $idSedeEmittente,
                        'id_destinatario' => $pagamento['destinatario_id_anagrafica'],
                        'id_sede_destinatario' => $idSedeDestinatario,
                        'data' => $data
                    ),
                    'documenti'
                );

                // debug
                // print_r( $_REQUEST['__pagamenti__']['righe'] );

                // per ogni documento richiesto
                foreach( $_REQUEST['__pagamenti__']['righe'] as $pagamento ) {

                    // se la checkbox è flaggata
                    if( ! empty( $pagamento['da_fare'] ) ) {

                        // trovo il reparto
                        $reparto = mysqlSelectRow(
                            $cf['mysql']['connection'],
                            'SELECT reparti.id, iva.aliquota FROM articoli INNER JOIN reparti ON reparti.id = articoli.id_reparto 
                                INNER JOIN iva ON iva.id = reparti.id_iva WHERE articoli.id = ?',
                                array( array( 's' => $pagamento['id_articolo'] ) )
                        );

                        // debug
                        // die( print_r( $reparto, true ) );

                        // calcolo il netto
                        $pagamento['importo_netto_totale'] = $pagamento['importo_lordo_finale'] / ( 100 + $reparto['aliquota'] ) * 100;

                        // aggiungo la riga
                        $idRiga = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_documento' => $idDocumento,
                                'id_articolo' => $pagamento['id_articolo'],
                                'id_rinnovo' => ( ( isset( $pagamento['id_rinnovo'] ) ) ? $pagamento['id_rinnovo'] : NULL ),
                                'id_carrelli_articoli' => $pagamento['id'],
                                'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                'importo_lordo_totale' => $pagamento['importo_lordo_finale'],
                                'id_mastro_provenienza' => $pagamento['id_mastro_provenienza'],
                                'quantita' => $pagamento['quantita'],
                                'id_udm' => 1,
                                'id_reparto' => $reparto['id'],
                                'id_listino' => 1,
                                'nome' => 'riga automatica da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                            ),
                            'documenti_articoli'
                        );

                        // debug
                        // print_r( $pagamento );

                        /*
                        // associo il pagamento
                        $idPagamento = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? $pagamento['id_pagamento'] : null ),
                                'id_documento' => $idDocumento,
                                'timestamp_pagamento' => time(),
                                'importo_lordo_totale' => $pagamento['importo_lordo_totale'],
                                'nome' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'rata pagata' : 'pagamento diretto' ) . 
                                    ' da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                            ),
                            'pagamenti'
                        );
                        */

                        // debug
                        // echo 'creazione ricevuta (documento #' . $idDocumento . ', riga #' . $idRiga . ', pagamento #' . $idPagamento . ')' . PHP_EOL;
                        // die( print_r( $pagamento, true ) );

                    }

                }

            }

            // debug
            // die( $_REQUEST['__pagamenti__'] );

            // se è richiesto un carrello specifico
            if( isset( $idDocumento ) ) {

                if( isset( $_REQUEST['__pagamenti__']['autoprint'] ) && ! empty( $_REQUEST['__pagamenti__']['autoprint'] ) ) {

                    // annoto l'attività di stampa
                    $idAttivitaStampa = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id_tipologia' => 23,
                            'id_documento' => $idDocumento,
                            'data_attivita' => date('Y-m-d'),
                            'nome' => 'stampa documento (macro custom '.__FILE__.')',
                            'ora_inizio' => date( 'H:i:s' ),
                            'ora_fine' => date( 'H:i:s' )
                        ),
                        'attivita'
                    );

                    // debug
                    // var_dump( $idAttivitaStampa );
                    // var_dump( $idDocumento );

                }

            }

        } else {

            // debug
            // ...

        }

        // tipo di ricerca (carrello o cliente)
        if( isset( $_REQUEST['__pagamenti__']['id_carrello'] ) && ! empty( $_REQUEST['__pagamenti__']['id_carrello'] ) ) {

            // seleziono i dettagli del carrello
            $ct['etc']['carrello'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT * '.
                'FROM carrelli '.
                'WHERE id = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_carrello'] ) )
            );

            // seleziono le righe del carrello
            $ct['etc']['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, 
                    concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione, 
                    carrelli.fatturazione_id_tipologia_documento, carrelli.id AS id_carrello, 
                    carrelli_articoli.* 
                    FROM carrelli_articoli 
                    INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo 
                    INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto 
                    INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello 
                    LEFT JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica 
                    WHERE id_carrello = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_carrello'] ) )
            );

            /*
            // seleziono i documenti da stampare
            $ct['etc']['stampe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT documenti_view.* FROM documenti_view LEFT JOIN attivita ON ( attivita.id_documento = documenti_view.id AND attivita.id_tipologia IN ( 22, 23, 24 ) ) WHERE id_destinatario = ? AND attivita.id IS NULL',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
            );
            */

            // debug
            // die( print_r( $ct['etc'], true ) );
            // die( print_r( $ct['etc']['righe'], true ) );

        } elseif( isset( $_REQUEST['__pagamenti__']['id_cliente'] ) && ! empty( $_REQUEST['__pagamenti__']['id_cliente'] ) ) {

            // seleziono le righe del carrello
            $ct['etc']['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, 
                    concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione, 
                    carrelli.fatturazione_id_tipologia_documento, 
                    carrelli_articoli.* 
                    FROM carrelli_articoli 
                    INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo 
                    INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto 
                    INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello 
                    LEFT JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica 
                    WHERE carrelli_articoli.destinatario_id_anagrafica = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
            );

            // seleziono le rate
            $ct['etc']['righe'] = array_merge(
                $ct['etc']['righe'],
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pagamenti.id AS id_pagamento, pagamenti.importo_lordo_finale, pagamenti.timestamp_pagamento, pagamenti.id_rinnovo, pagamenti.coupon_valore,
                        concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, 
                        concat_ws( " ", prodotti.nome, articoli.nome, " rata del ", pagamenti.data_scadenza ) AS descrizione, 
                        carrelli.id AS id_carrello, carrelli.fatturazione_id_tipologia_documento, 
                        carrelli_articoli.id, carrelli_articoli.id_articolo, carrelli_articoli.destinatario_id_anagrafica, carrelli_articoli.id_mastro_provenienza, carrelli_articoli.prezzo_lordo_finale 
                        FROM pagamenti 
                        INNER JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli 
                        INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello 
                        INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo 
                        INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto 
                        LEFT JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica 
                        WHERE pagamenti.id_debitore = ? -- AND pagamenti.id_documento IS NULL',
                    array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
                )
            );

            /*
            // seleziono i documenti da stampare
            $ct['etc']['stampe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT documenti_view.* FROM documenti_view LEFT JOIN attivita ON ( attivita.id_documento = documenti_view.id AND attivita.id_tipologia IN ( 22, 23, 24 ) ) WHERE id_destinatario = ? AND attivita.id IS NULL',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_cliente'] ) )
            );
            */

        }

        // print_r( $_REQUEST );
        // var_dump( $_REQUEST['__pagamenti__']['id_carrello'] );
        // var_dump( $ct['etc']['righe'] );
        // die( print_r( $ct['etc']['righe'], true ) );

        // per ogni riga, cerco eventuali pagamenti già effettuati
        if( isset( $ct['etc']['righe'] ) ) {

            // ...
            foreach( $ct['etc']['righe'] as $chiave => &$riga ) {

                // debug
                // die( print_r( $riga, true ) );

                // totale pagato
                $riga['totale_lordo_pagato'] = 0;

                if( isset( $riga['id_pagamento'] ) ) {

                    // cerco righe di documenti che fanno riferimento a questa riga di carrello
                    // TODO in teoria bisognerebbe poi controllare che il documento abbia pagamenti pagati ecc.
                    $righe = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT documenti_articoli.*, pagamenti.timestamp_pagamento, pagamenti.coupon_valore, '.
                        'concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento '.
                        'FROM documenti '.
                        'INNER JOIN pagamenti ON documenti.id = pagamenti.id_documento '.
                        'INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id '.
                        'WHERE pagamenti.id = ? AND pagamenti.id_carrelli_articoli IS NOT NULL',
                        array( array( 's' => $riga['id_pagamento'] ) )
                    );

                    // totale già pagato
                    $riga['totale_lordo_pagato'] = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT pagamenti.importo_lordo_totale
                            FROM pagamenti 
                            WHERE pagamenti.id = ? AND pagamenti.timestamp_pagamento IS NOT NULL',
                        array( array( 's' => $riga['id_pagamento'] ) )
                    );

                } else {

                    // cerco righe di documenti che fanno riferimento a questa riga di carrello
                    // TODO in teoria bisognerebbe poi controllare che il documento abbia pagamenti pagati ecc.
                    /*
                    $righe = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT documenti_articoli.*, pagamenti.timestamp_pagamento, 
                            concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento 
                            FROM documenti_articoli 
                            INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento 
                            LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id 
                            WHERE documenti_articoli.id_carrelli_articoli = ? 
                            AND pagamenti.id_carrelli_articoli IS NULL',
                        array( array( 's' => $riga['id'] ) )
                    );
                    */

                    $righe = mysqlQuery(
                        $cf['mysql']['connection'],
                        'SELECT documenti_articoli.*, pagamenti.timestamp_pagamento, 
                            concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento 
                            FROM documenti_articoli 
                            INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento 
                            LEFT JOIN pagamenti ON pagamenti.id_documento = documenti.id 
                            WHERE documenti_articoli.id_carrelli_articoli = ?',
                        array( array( 's' => $riga['id'] ) )
                    );

                    // echo( $riga['id'] );
                    // die( print_r( $righe, true ) );

                    // totale già pagato
                    $riga['totale_lordo_pagato'] = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT sum( pagamenti.importo_lordo_totale ) '.
                        'FROM documenti '.
                        'INNER JOIN pagamenti ON documenti.id = pagamenti.id_documento '.
                        'INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id '.
                        'WHERE documenti_articoli.id_carrelli_articoli = ? AND pagamenti.timestamp_pagamento IS NOT NULL',
                        array( array( 's' => $riga['id'] ) )
                    );

                    // totale già pagato
                    $riga['coupon_valore'] = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT sum( pagamenti.coupon_valore ) '.
                        'FROM documenti '.
                        'INNER JOIN pagamenti ON documenti.id = pagamenti.id_documento '.
                        'INNER JOIN documenti_articoli ON documenti_articoli.id_documento = documenti.id '.
                        'WHERE documenti_articoli.id_carrelli_articoli = ? AND pagamenti.timestamp_pagamento IS NOT NULL',
                        array( array( 's' => $riga['id'] ) )
                    );

                }

                // totale rateizzato
                $riga['totale_lordo_rateizzato'] = 0;

                // documenti da stampare
                $riga['documenti_da_stampare'] = array();

                // debug
                // echo 'riga ' . $riga['id'] . '/' . $riga['id_pagamento'] . ' - ' . $riga['totale_lordo_pagato'] . PHP_EOL;
                // die( 'riga ' . $riga['id'] . ' - ' . $riga['totale_lordo_pagato'] );
                // die( print_r( $righe, true ) );

                // calcolo il totale già pagato
                // NOTA faccio un ciclo così se in un secondo momento voglio i dettagli ce li ho già sgranati
                foreach( $righe as $rdoc ) {

                    // aggiungo il totale della riga
                    // $riga['totale_lordo_pagato'] += $rdoc['importo_lordo_finale'];

                    // ...
                    if( isset( $rdoc['id_documento'] ) && ! empty( $rdoc['id_documento'] ) ) {

                        // debug
                        // die( print_r( $rdoc, true ) );

                        // stampe del documento
                        $stampe = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT count( attivita.id ) FROM attivita 
                            INNER JOIN tipologie_attivita ON tipologie_attivita.id = attivita.id_tipologia 
                            WHERE attivita.id_documento = ? AND tipologie_attivita.se_stampa IS NOT NULL',
                            array( array( 's' => $rdoc['id_documento'] ) )
                        );

                        // ...
                        if( empty( $stampe ) ) {

                            // documenti da stampare
                            $riga['documenti_da_stampare'][] = array(
                                'id' => $rdoc['id_documento'],
                                'documento' => $rdoc['documento']
                            );

                        } else {

                            // documenti da stampare
                            $riga['documenti_stampati'][] = array(
                                'id' => $rdoc['id_documento'],
                                'documento' => $rdoc['documento']
                            );

                        }

                    }

                }

                // TODO trovare se ci sono documenti da generare
                $riga['documenti_generati'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT count( documenti_articoli.id ) 
                    FROM documenti_articoli
                    WHERE documenti_articoli.id_carrelli_articoli = ?',
                    array( array( 's' => $riga['id'] ) )
                );

                // pagamenti in sospeso (rate)
                $rate = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pagamenti.* '.
                    'FROM pagamenti '.
                    'WHERE id_documento IS NULL AND id_carrelli_articoli = ?',
                    array( array( 's' => $riga['id'] ) )
                );

                // calcolo il totale già pagato
                if( is_array( $rate ) ) {
                    foreach( $rate as $rata ) {

                        // aggiungo il totale della riga
                        $riga['totale_lordo_rateizzato'] += $rata['importo_lordo_finale'];
    
                    }
                }

                // totale da pagare
                if( empty( $riga['id_pagamento'] ) ) {
                    $riga['totale_lordo_da_pagare'] = $riga['prezzo_lordo_finale'] - $riga['totale_lordo_pagato'] - $riga['totale_lordo_rateizzato'];
                } else {
                    $riga['totale_lordo_da_pagare'] = $riga['importo_lordo_totale'] - $riga['totale_lordo_pagato'];
                }

                // se la riga è pagata e non ha documenti da stampare, non la mostro
                if( count( $riga['documenti_da_stampare'] ) == 0 ) {
                    if( ! empty( $riga['prezzo_lordo_totale'] ) ) {
                        if( ! empty( $riga['timestamp_pagamento'] ) ) {
                            unset( $ct['etc']['righe'][ $chiave ] );
                        } elseif( isset( $riga['id_carrello'] ) && empty( $riga['totale_lordo_da_pagare'] ) ) {
                            if( $riga['documenti_generati'] > 0 ) {
                                unset( $ct['etc']['righe'][ $chiave ] );
                            }
#                            unset( $ct['etc']['righe'][ $chiave ] );
                        }
                    } elseif( empty( $riga['totale_lordo_da_pagare'] ) && ! empty( $riga['documenti_stampati'] ) ) {
                        unset( $ct['etc']['righe'][ $chiave ] );
                    }
                }

                // print_r( $riga );

            }

        }

    }

    $ct['etc']['id_tipologia_documenti'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_documenti.nome AS __label__, tipologie_documenti.id '
        .'FROM tipologie_documenti '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'ORDER BY __label__  '
    );

    $ct['etc']['id_modalita_pagamento'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT modalita_pagamento.nome AS __label__, modalita_pagamento.id '
        .'FROM modalita_pagamento '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'WHERE id IN ( 1, 2, 23, 24 ) '
        .'ORDER BY __label__ '
    );

	$ct['etc']['strategie_fatturazione'] = array( 
	    array( 'id' => 'SINGOLA', '__label__' => 'documento unico' ),
	    array( 'id' => 'MULTIPLA', '__label__' => 'documenti separati' ),
	);

    $ct['etc']['default']['fatturazione_id_tipologia_documento'] = (
        ( isset( $_SESSION['carrello']['fatturazione_id_tipologia_documento'] ) && ! empty( $_SESSION['carrello']['fatturazione_id_tipologia_documento'] ) )
        ?
        $_SESSION['carrello']['fatturazione_id_tipologia_documento']
        :
        (
            ( isset( $ct['etc']['carrello']['fatturazione_id_tipologia_documento'] ) && ! empty( $ct['etc']['carrello']['fatturazione_id_tipologia_documento'] ) )
            ?
            $ct['etc']['carrello']['fatturazione_id_tipologia_documento']
            :
            $cf['ecommerce']['fields']['carrello']['fatturazione_id_tipologia_documento']['default']
        )
    );

    $ct['etc']['default']['fatturazione_strategia'] = (
        ( isset( $_SESSION['carrello']['fatturazione_strategia'] ) && ! empty( $_SESSION['carrello']['fatturazione_strategia'] ) )
        ?
        $_SESSION['carrello']['fatturazione_strategia']
        :
        (
            ( isset( $ct['etc']['carrello']['fatturazione_strategia'] ) && ! empty( $ct['etc']['carrello']['fatturazione_strategia'] ) )
            ?
            $ct['etc']['carrello']['fatturazione_strategia']
            :
            $cf['ecommerce']['fields']['carrello']['fatturazione_strategia']['default']
        )
    );
/*
    $ct['etc']['default']['fatturazione_id_modalita_pagamento'] = (
        ( isset( $_SESSION['carrello']['fatturazione_id_modalita_pagamento'] ) && ! empty( $_SESSION['carrello']['fatturazione_id_modalita_pagamento'] ) )
        ?
        $_SESSION['carrello']['fatturazione_id_modalita_pagamento']
        :
        (
            ( isset( $ct['etc']['carrello']['fatturazione_id_modalita_pagamento'] ) && ! empty( $ct['etc']['carrello']['fatturazione_id_modalita_pagamento'] ) )
            ?
            $ct['etc']['carrello']['fatturazione_id_modalita_pagamento']
            :
            $cf['ecommerce']['fields']['carrello']['fatturazione_id_modalita_pagamento']['default']
        )
    );
*/

/*
    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, coupon.id 
        FROM coupon 
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() ) AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        ORDER BY coupon.id '
    );
*/

    $ct['etc']['coupon'] = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT coupon.id, coupon.sconto_fisso, coupon.id_anagrafica, 
            coalesce( sum( pagamenti.coupon_valore ), 0 ) AS utilizzato, ( coupon.sconto_fisso - coalesce( sum( pagamenti.coupon_valore ), 0 ) ) AS residuo
        FROM coupon 
        LEFT JOIN pagamenti ON coupon.id = pagamenti.id_coupon
        WHERE ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= NOW() ) AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= NOW() )
        GROUP BY coupon.id
        HAVING utilizzato < coupon.sconto_fisso
        ORDER BY coupon.id 
        '
    );

    // debug
    // print_r($ct['etc']['righe']);
    // die();

