<?php

    /* CODICE PRINCIPALE DEL JOB */

    // verifiche formali
    if( ! defined( 'CRON_RUNNING' ) && ! defined( 'JOB_RUNNING' ) ) {

        // status
        $status['error'][] = 'questo job non supporta la modalità standalone';

        // output
        buildJson( $status );

    } elseif( empty( $job['id'] ) ) {

        // status
        $status['error'][] = 'ID job non trovato';

    } elseif( isset( $job['corrente'] ) && $job['corrente'] >= $job['totale'] ) {

        // status
        $status['info'][] = 'iterazione a vuoto su job completato';

    } elseif( ! isset( $job['workspace']['data'] ) || empty( $job['workspace']['data'] ) ) {

        // status
        $status['error'][] = 'questo job richiede una data su cui lavorare';

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // inizializzo l'array
            $arr = array();

            // CUSTOM apro il file
            foreach( $job['workspace']['aziende'] as $azienda ) {
                $arr = array_merge(
                    $arr,
                    archiviumGetListaNoteAttive( $azienda, 0, 'ID=ASC', 'RIGHT', 'DataIns=' . $job['workspace']['data'] )
                );
            }

            // segno il totale delle cose da fare
            $job['totale'] = count( $arr );

            // salvo la lista
            $job['workspace']['lista'] = $arr;

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

        } else {

            // leggo la lista
            $arr = $job['workspace']['lista'];

            // incremento l'indice di lavoro
            $job['corrente']++;

        }

        // operazioni di chiusura
        if( empty( $job['totale'] ) || $job['corrente'] >= $job['totale'] ) {

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

            // importo la fattura
            $status['info'][] = archiviumRegistraNotaAttiva( $arr[ $widx ]['IDArchiviumAzienda'], $arr[ $widx ]['IDArchivium'] );

            // CUSTOM status
            $status['info'][] = 'ho lavorato la riga: ' . $arr[ $job['corrente'] ];

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
