<?php

    // debug
    // var_dump( $_REQUEST['__pagamenti__'] );
    // die( print_r( $_REQUEST['__pagamenti__'] ) );
    // print_r( $_REQUEST );

/*
    // checkout carrello
    if( isset( $_REQUEST['ck_carrello'] ) ) {
        $_REQUEST['__pagamenti__']['id_carrello'] = $_REQUEST['ck_carrello'];
    }
*/

    // se è richiesto un carrello specifico
    if( isset( $_REQUEST['__pagamenti__'] ) ) {

        // creo i documenti
        if( isset( $_REQUEST['__pagamenti__']['righe'] ) ) {

            // per ogni documento richiesto
            foreach( $_REQUEST['__pagamenti__']['righe'] as $pagamento ) {

                // se la checkbox è flaggata
                if( ! empty( $pagamento['da_fare'] ) ) {

                    // se il totale è maggiore di zero
                    if( $pagamento['importo_netto_totale'] > 0 ) {

                        // se sto creando una rata
                        if( empty( $pagamento['id_pagamento'] ) && ! empty( $_REQUEST['__pagamenti__']['data_rate'] ) ) {

                            // aggiungo il pagamento
                            mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_anagrafica' => $pagamento['destinatario_id_anagrafica'],
                                    'id_carrelli_articoli' => $pagamento['id'],
                                    'importo_lordo_totale' => $pagamento['importo_netto_totale'],
                                    'data_scadenza' => $_REQUEST['__pagamenti__']['data_rate'],
                                    'nome' => 'rata da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                                ),
                                'pagamenti'
                            );                            

                        } else {

                            // se sto pagando direttamente oppure sto pagando una rata

                            // debug
                            // die( print_r( $pagamento, true ) );
        
                            // imposto il documento
                            $nome = 'documento creato automaticamente per il ' . ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'pagamento #' . $pagamento['id_pagamento'] . ' ' : NULL ) . 'carrello #' . $pagamento['id_carrello'] . ' anagrafica #'. $pagamento['destinatario_id_anagrafica'] .' (' . $pagamento['destinatario'] . ')';
                            $sezionale = 'C/' . date('Y');
                            $emittente = trovaIdAziendaGestita();
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
                                    'id_destinatario' => $pagamento['destinatario_id_anagrafica'],
                                    'data' => $data
                                ),
                                'documenti'
                            );

                            // aggiungo la riga
                            mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_documento' => $idDocumento,
                                    'id_articolo' => $pagamento['id_articolo'],
                                    'id_carrelli_articoli' => $pagamento['id'],
                                    'importo_netto_totale' => $pagamento['importo_netto_totale'],
                                    'quantita' => 1,
                                    'id_udm' => 1,
                                    'id_reparto' => 1,
                                    'id_listino' => 1,
                                    'nome' => 'riga automatica da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                                ),
                                'documenti_articoli'
                            );

                            // associo il pagamento
                            mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id' => $pagamento['id_pagamento'],
                                    'id_documento' => $idDocumento,
                                    'timestamp_pagamento' => time(),
                                    'importo_lordo_totale' => $pagamento['importo_netto_totale'],
                                    'nome' => ( ( ! empty( $pagamento['id_pagamento'] ) ) ? 'rata pagata' : 'pagamento diretto' ) . ' da carrello #' . $pagamento['id_carrello'] . ' riga #' . $pagamento['id']
                                ),
                                'pagamenti'
                            );

                        }

                    } else {

                        // debug
                        // ...

                    }

                } else {

                    // debug
                    // ...

                }


            }

            // debug
            // die( $_REQUEST['__pagamenti__'] );

        } else {

            // debug
            // ...

        }

        // tipo di ricerca (carrello o socio)
        if( isset( $_REQUEST['__pagamenti__']['id_carrello'] ) && ! empty( $_REQUEST['__pagamenti__']['id_carrello'] ) ) {

            // seleziono le righe del carrello
            $ct['etc']['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, '.
                'concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione, '.
                'carrelli.fatturazione_id_tipologia_documento, carrelli.id AS id_carrello, '.
                'carrelli_articoli.* '.
                'FROM carrelli_articoli '.
                'INNER JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica '.
                'INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo '.
                'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                'INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello '.
                'WHERE id_carrello = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_carrello'] ) )
            );

        } elseif( isset( $_REQUEST['__pagamenti__']['id_socio'] ) && ! empty( $_REQUEST['__pagamenti__']['id_socio'] ) ) {

            // seleziono le righe del carrello
            $ct['etc']['righe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, '.
                'concat_ws( " ", prodotti.nome, articoli.nome ) AS descrizione, '.
                'carrelli.fatturazione_id_tipologia_documento, '.
                'carrelli_articoli.* '.
                'FROM carrelli_articoli '.
                'INNER JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica '.
                'INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo '.
                'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                'INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello '.
                'WHERE carrelli_articoli.destinatario_id_anagrafica = ?',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_socio'] ) )
            );

            // seleziono le rate
            $ct['etc']['righe'] = array_merge(
                $ct['etc']['righe'],
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pagamenti.id AS id_pagamento, pagamenti.importo_lordo_totale, '.
                    'concat_ws( " ", a.nome, a.cognome, a.denominazione ) AS destinatario, '.
                    'concat_ws( " ", prodotti.nome, articoli.nome, " rata del ", pagamenti.data_scadenza ) AS descrizione, '.
                    'carrelli.id AS id_carrello, carrelli.fatturazione_id_tipologia_documento, '.
                    'carrelli_articoli.id, carrelli_articoli.id_articolo, carrelli_articoli.destinatario_id_anagrafica '.
                    'FROM pagamenti '.
                    'INNER JOIN carrelli_articoli ON carrelli_articoli.id = pagamenti.id_carrelli_articoli '.
                    'INNER JOIN carrelli ON carrelli.id = carrelli_articoli.id_carrello '.
                    'INNER JOIN anagrafica AS a ON a.id = carrelli_articoli.destinatario_id_anagrafica '.
                    'INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo '.
                    'INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto '.
                    'WHERE pagamenti.id_anagrafica = ? AND pagamenti.id_documento IS NULL',
                    array( array( 's' => $_REQUEST['__pagamenti__']['id_socio'] ) )
                )
            );

            // seleziono i documenti da stampare
            $ct['etc']['stampe'] = mysqlQuery(
                $cf['mysql']['connection'],
                'SELECT documenti_view.* FROM documenti_view LEFT JOIN attivita ON ( attivita.id_documento = documenti_view.id AND attivita.id_tipologia IN ( 22, 23, 24 ) ) WHERE id_destinatario = ? AND attivita.id IS NULL',
                array( array( 's' => $_REQUEST['__pagamenti__']['id_socio'] ) )
            );
        
        }

        // print_r( $_REQUEST );
        // var_dump( $_REQUEST['__pagamenti__']['id_carrello'] );
        // var_dump( $ct['etc']['righe'] );

        // per ogni riga, cerco eventuali pagamenti già effettuati
        if( isset( $ct['etc']['righe'] ) ) {
            foreach( $ct['etc']['righe'] as $chiave => &$riga ) {

                // cerco righe di documenti che fanno riferimento a questa riga di carrello
                // TODO in teoria bisognerebbe poi controllare che il documento abbia pagamenti pagati ecc.
                $righe = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT documenti_articoli.*, '.
                    'concat( documenti.numero, "/", date_format( documenti.data, "%y" ) ) AS documento '.
                    'FROM documenti_articoli '.
                    'INNER JOIN documenti ON documenti.id = documenti_articoli.id_documento '.
                    'WHERE id_carrelli_articoli = ?',
                    array( array( 's' => $riga['id'] ) )
                );

                // totale già pagato
                $riga['totale_netto_pagato'] = 0;

                // calcolo il totale già pagato
                // NOTA faccio un ciclo così se in un secondo momento voglio i dettagli ce li ho già sgranati
                foreach( $righe as $rdoc ) {

                    // aggiungo il totale della riga
                    $riga['totale_netto_pagato'] += $rdoc['importo_netto_totale'];

                    // documenti da stampare
                    $riga['documenti_da_stampare'][] = array(
                        'id' => $rdoc['id_documento'],
                        'documento' => $rdoc['documento']
                    );

                }

                // pagamenti in sospeso (rate)
                $rate = mysqlQuery(
                    $cf['mysql']['connection'],
                    'SELECT pagamenti.* '.
                    'FROM pagamenti '.
                    'WHERE id_documento IS NULL AND id_carrelli_articoli = ?',
                    array( array( 's' => $riga['id'] ) )
                );

                // calcolo il totale già pagato
                foreach( $rate as $rata ) {

                    // aggiungo il totale della riga
                    $riga['totale_netto_rateizzato'] += $rata['importo_lordo_totale'];

                }

                // totale da pagare
                $riga['totale_netto_da_pagare'] = $riga['prezzo_netto_finale'] - $riga['totale_netto_pagato'] - $riga['totale_netto_rateizzato'];

                // se la riga è pagata, non la mostro
                if( empty( $riga['id_pagamento'] ) && $riga['totale_netto_da_pagare'] <= 0 ) {
                    unset( $ct['etc']['righe'][ $chiave ] );
                }

            }

        }

    }

    $ct['etc']['id_tipologia_documenti'] = mysqlCachedQuery(
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT tipologie_documenti.nome AS __label__, tipologie_documenti.id '
        .'FROM tipologie_documenti '
        // TODO .'WHERE tipologie_documenti.se_ecommerce = 1 '
        .'ORDER BY __label__ '
    );

	$ct['etc']['strategie_fatturazione'] = array( 
	    array( 'id' => 'SINGOLA', '__label__' => 'documento unico' ),
	    array( 'id' => 'MULTIPLA', '__label__' => 'documenti separati' ),
	);
