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
            if( ( ! isset( $job['riga']['tipologia'] ) || empty( $job['riga']['tipologia'] ) ) && 
                ( ! isset( $job['riga']['numero'] ) || empty( $job['riga']['numero'] ) ) && 
                ( ! isset( $job['riga']['sezionale'] ) || empty( $job['riga']['sezionale'] ) ) && 
                ( ! isset( $job['riga']['codice'] ) || empty( $job['riga']['codice'] ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'tipologia, numero, sezionale e codice cliente non settati per la riga ' . $job['corrente'];

            } else {

                // tipologia
                $idTipologia = mysqlSelectCachedValue(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT id FROM tipologie_documenti WHERE nome = ?',
                    array( array( 's' => $job['riga']['tipologia'] ) )
                );

                // ...
                if( ! empty( $idTipologia ) ) {

                    // destinatario
                    $idDestinatario = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id_destinatario FROM documenti WHERE id_tipologia = ? AND numero = ? AND sezionale = ?',
                        array(
                            array( 's' => $idTipologia ),
                            array( 's' => $job['riga']['numero'] ),
                            array( 's' => $job['riga']['sezionale'] )
                        )
                    );

                    // ...
                    if( ! empty( $idDestinatario ) ) {
/*
                        // aggiornamento
			// TODO verificare che il codice non sia vuoto prima di fare l'aggiornamento
                        mysqlQuery(
                            $cf['mysql']['connection'],
                            'UPDATE anagrafica SET codice = ? WHERE id = ?',
                            array(
                                array( 's' => $job['riga']['codice'] ),
                                array( 's' => $idDestinatario )
                            )
                        );
*/
                        // status
                        $job['workspace']['status']['info'][] = 'assegno il codice ' . $job['riga']['codice'] . ' al cliente ' . $idDestinatario . ' per la riga ' . $job['corrente'];

                    } else {

                        // status
                        $job['workspace']['status']['error'][] = 'destinatario non trovato per la riga ' . $job['corrente'] . ' (tipologia: ' . $idTipologia . ' numero: ' . $job['riga']['numero'] . ' sezionale: ' . $job['riga']['sezionale'] . ')';
    
                    }

                } else {

                    // status
                    $job['workspace']['status']['error'][] = 'tipologia ' . $job['riga']['tipologia'] . ' non trovata per la riga ' . $job['corrente'];

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
