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
            $job['workspace']['status']['info'][] = 'requisiti formali soddisfatti, inizializzo il job';
            $job['workspace']['status']['info'][] = 'righe trovate: ' . $job['totale'];

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
            if( ( ! isset( $job['riga']['codice_emittente'] ) || empty( $job['riga']['codice_emittente'] ) ) && 
                ( ! isset( $job['riga']['codice_fiscale_emittente'] ) || empty( $job['riga']['codice_fiscale_emittente'] ) ) && 
                ( ! isset( $job['riga']['partita_iva_emittente'] ) || empty( $job['riga']['partita_iva_emittente'] ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'codice emittente, codice fiscale emittente e partita IVA emittente non settati per la riga ' . $job['corrente'];

            } elseif( ( ! isset( $job['riga']['codice_destinatario'] ) || empty( $job['riga']['codice_destinatario'] ) ) && 
                ( ! isset( $job['riga']['codice_fiscale_destinatario'] ) || empty( $job['riga']['codice_fiscale_destinatario'] ) ) && 
                ( ! isset( $job['riga']['partita_iva_destinatario'] ) || empty( $job['riga']['partita_iva_destinatario'] ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'codice destinatario, codice fiscale destinatario e partita IVA destinatario non settati per la riga ' . $job['corrente'];

            } elseif( (
                (   ! isset( $job['riga']['numero'] ) || 
                    empty( $job['riga']['numero'] ) || 
                    ! isset( $job['riga']['sezionale'] ) || 
                    empty( $job['riga']['sezionale'] ) ) )
                &&
                ( ! isset( $job['riga']['codice'] ) || empty( $job['riga']['codice'] ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'numero e sezionale oppure codice non settati per la riga ' . $job['corrente'];

            } elseif( empty( $job['riga']['tipologia_documento'] ) ) {

                // status
                $job['workspace']['status']['error'][] = 'tipologia documento non settata per la riga ' . $job['corrente'];

            } else {

                // tipologia
                $idTipologia = mysqlSelectCachedValue(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT id FROM tipologie_documenti WHERE nome = ?',
                    array( array( 's' => $job['riga']['tipologia_documento'] ) )
                );

                // emittente
                if( ! empty( $job['riga']['codice_emittente'] ) ) {
                    $idEmittente = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica WHERE codice = ?',
                        array( array( 's' => $job['riga']['codice_emittente'] ) )
                    );
                } elseif( ! empty( $job['riga']['codice_fiscale_emittente'] ) ) {
                    $idEmittente = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica WHERE codice_fiscale = ?',
                        array( array( 's' => $job['riga']['codice_fiscale_emittente'] ) )
                    );
                } elseif( ! empty( $job['riga']['partita_iva_emittente'] ) ) {
                    $idEmittente = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica WHERE partita_iva = ?',
                        array( array( 's' => $job['riga']['partita_iva_emittente'] ) )
                    );
                }

                // destinatario
                if( ! empty( $job['riga']['codice_destinatario'] ) ) {
                    $idDestinatario = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica WHERE codice = ?',
                        array( array( 's' => $job['riga']['codice_destinatario'] ) )
                    );
                } elseif( ! empty( $job['riga']['codice_fiscale_destinatario'] ) ) {
                    $idDestinatario = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica WHERE codice_fiscale = ?',
                        array( array( 's' => $job['riga']['codice_fiscale_destinatario'] ) )
                    );
                } elseif( ! empty( $job['riga']['partita_iva_destinatario'] ) ) {
                    $idDestinatario = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM anagrafica WHERE partita_iva = ?',
                        array( array( 's' => $job['riga']['partita_iva_destinatario'] ) )
                    );
                }

                // trovo l'ID dell'anagrafica
                $idDocumento = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'id_tipologia' => $idTipologia,
                        'codice' => ( ! empty( $job['riga']['codice'] ) ) ? $job['riga']['codice'] : NULL,
                        'numero' => ( ! empty( $job['riga']['numero'] ) ) ? $job['riga']['numero'] : NULL,
                        'sezionale' => ( ! empty( $job['riga']['sezionale'] ) ) ? $job['riga']['sezionale'] : NULL,
                        'data' => ( ! empty( $job['riga']['data'] ) ) ? date( 'Y-m-d', strtotime( $job['riga']['data'] ) ) : NULL,
                        'id_emittente' => $idEmittente,
                        'id_destinatario' => $idDestinatario,
                        'nome' => ( ( isset( $job['riga']['nome'] ) ) ? $job['riga']['nome'] : NULL ),
                        'note' => ( ( isset( $job['riga']['note'] ) ) ? $job['riga']['note'] : NULL ),
                        'note_invio' => ( ( isset( $job['riga']['note_invio'] ) ) ? $job['riga']['note_invio'] : NULL )
                    ),
                    'documenti',
                    true,
                    false,
                    array(
                        'numero',
                        'sezionale',
                        'codice'
                    )
                );

                // status
                $job['status']['info'][] = 'documento inserita con ID ' . $idDocumento . ' per la riga ' . $job['corrente'];

                // se è presente un ID documento, inserisco la riga
                if( ! empty( $idDocumento ) ) {

                    // se posso identificare univocamente la riga
                    // TODO fare meglio, ci sono condizioni di unicità più complicate?
                    if( empty( $job['riga']['id_articolo'] ) && empty( $job['riga']['codice'] ) ) {

                        // status
                        $job['workspace']['status']['error'][] = 'articolo e codice non settati per la riga ' . $job['corrente'];

                    } else {
        
                        // status
                        $job['workspace']['status']['info'][] = 'requisiti formali di riga soddisfatti per la riga ' . $job['corrente'];

                        // inserisco la riga

                    }

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
