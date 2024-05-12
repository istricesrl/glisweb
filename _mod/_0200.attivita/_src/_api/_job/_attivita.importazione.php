<?php

    /* CODICE PRINCIPALE DEL JOB */

    // verifiche formali
    if( ! defined( 'CRON_RUNNING' ) && ! defined( 'JOB_RUNNING' ) ) {

        // status
        $job['workspace']['status']['error'][] = 'questo job non supporta la modalità standalone';

        // output
        buildJson( $job['workspace']['status'] );

    } elseif( empty( $job['id'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'ID job non trovato';

    } elseif( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

        // status
        $job['workspace']['status']['info'][] = 'iterazione a vuoto su job completato';

    } elseif( ! isset( $job['workspace']['file'] ) || empty( $job['workspace']['file'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'questo job richiede un file su cui lavorare';

    } elseif( ! file_exists( DIR_BASE . $job['workspace']['file'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'impossibile trovare il file ' . $job['workspace']['file'];

    } elseif( ! is_readable( DIR_BASE . $job['workspace']['file'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'impossibile leggere il file ' . $job['workspace']['file'];

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // inizializzo l'array
            $arr = csvFile2array( $job['workspace']['file'], NULL );

            // segno il totale delle cose da fare
            $job['totale'] = count( $arr );

            // avvio il contatore
            $job['corrente'] = 1;

            // timestamp di avvio
            if( empty( $job['timestamp_apertura'] ) ) {
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE job SET totale = ?, timestamp_apertura = ? WHERE id = ?',
                    array(
                        array( 's' => $job['totale'] ),
                        array( 's' => time() ),
                        array( 's' => $job['id'] )
                    )
                );
            }

            // status
            $job['workspace']['status']['info'][] = 'file: ' . $job['workspace']['file'];
            $job['workspace']['status']['info'][] = 'requisiti formali soddisfatti, inizializzo il job';
            $job['workspace']['status']['info'][] = 'righe trovate: ' . $job['totale'];
            $job['workspace']['status']['info'][] = 'colonne trovate: ' . implode( ', ', array_keys( $arr[0] ) );

        } else {

            // leggo la lista
            $arr = csvFile2array( $job['workspace']['file'], NULL );

            // incremento l'indice di lavoro
            $job['corrente']++;

        }

        // operazioni di chiusura
        if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

            // scrivo la timestamp di completamento
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
                array(
                    array( 's' => time() ),
                    array( 's' => $job['id'] )
                )
            );

        } else {

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // prelevo la riga da lavorare
            $job['riga'] = $arr[ $widx ];

            // controlli formali e lavorazione riga
            if( ( ! isset( $job['riga']['codice_cliente'] ) || empty( $job['riga']['codice_cliente'] ) ) && 
                ( ! isset( $job['riga']['partita_iva_cliente'] ) || empty( $job['riga']['partita_iva_cliente'] ) ) ) {

                // status
                $job['status']['error'][] = 'codice e partita IVA non settati per la riga ' . $job['corrente'];

            } else {

                if( ! empty( $job['riga']['codice_cliente'] ) ) {
                    $q = 'SELECT * FROM anagrafica WHERE codice = ?';
                    $d = array( 's' => $job['riga']['codice_cliente'] );
                } elseif( ! empty( $job['riga']['partita_iva_cliente'] ) ) {
                    $q = 'SELECT * FROM anagrafica WHERE partita_iva = ?';
                    $d = array( 's' => $job['riga']['partita_iva_cliente'] );
                }

                // trovo il cliente
                $idCliente = mysqlSelectRow( $cf['mysql']['connection'], $q, array( $d ) );

/*
                // se non ho trovato il cliente e ho i dati per inserirlo
                if( empty( $idCliente ) && ! empty( $job['riga']['denominazione_cliente'] ) ) {



                }
*/
                // ...
                if( ! empty( $idCliente ) ) {

                    // trovo l'anagrafica di programmazione
                    $idAnagraficaProgrammazione = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica_view WHERE __label__ = ?',
                        array(
                            array( 's' => $job['riga']['anagrafica_programmazione_attivita'] )
                        )
                    );

                    // ...
                    if( ! empty( $idAnagraficaProgrammazione ) ) {
/*
                        // inserisco l'attività
                        $idAttivita = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id_tipologia' => 16,
                                'data_programmazione' => $job['riga']['data_programmazione_attivita'],
                                'nome' => $job['riga']['nome_attivita'],
                                'id_cliente' => $idCliente,
                                'id_anagrafica_programmazione' => $idAnagraficaProgrammazione,
                                'note_programmazione' => 'attività importata da CSV il ' . date( 'Y-m-d H:i:s' )
                            ),
                            'attivita'
                        );
*/
                        // status
                        $job['status']['info'][] = 'attività inserita ('.$idCliente.'/'.$idAnagraficaProgrammazione.') per la riga ' . $job['corrente'];

                    } else {

                        // status
                        $job['status']['error'][] = 'anagrafica programmazione (responsabile) per la riga ' . $job['corrente'];

                    }

                } else {

                    // status
                    $job['status']['error'][] = 'cliente non trovato per la riga ' . $job['corrente'];

                }

            }

            // aggiorno i valori di visualizzazione avanzamento
            $jobs = mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE job SET corrente = ? WHERE id = ?',
                array(
                    array( 's' => $job['corrente'] ),
                    array( 's' => $job['id'] )
                )
            );

        }

    }

    /* FINE CODICE PRINCIPALE DEL JOB */
