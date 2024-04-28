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
            logger( 'esito ricerca tipologia abbonamento: ' . print_r( $info, true ), 'details/rinnovi-abbonamenti/' . $articolo['destinatario_id_anagrafica'] );

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
                logger( 'recuperato abbonamento: ' . print_r( $abbonamento, true ), 'details/rinnovi-abbonamenti/' . $articolo['destinatario_id_anagrafica'] );

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
                logger( 'inserito abbonamento: ' . print_r( $abbonamento, true ), 'details/rinnovi-abbonamenti/' . $articolo['destinatario_id_anagrafica'] );

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
            logger( 'trovata periodicità: ' . print_r( $dettagliPeriodicita, true ), 'details/rinnovi-abbonamenti/' . $articolo['destinatario_id_anagrafica'] );

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

            // log
            logger( 'inserito rinnovo: ' . $idRinnovo, 'details/rinnovi-abbonamenti/' . $articolo['destinatario_id_anagrafica'] );

        }

    }
