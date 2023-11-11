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

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // pulizia ragionata report
            cleanReportCorsi();

            // pulisco il report
            cleanReportLezioniCorsi();

            // condizioni aggiuntive
            $whr = NULL;
            $cnd = array();

            // lezioni di uno specifico corso
            if( isset( $job['workspace']['id_corso'] ) && ! empty( $job['workspace']['id_corso'] ) ) {
                $whr = 'AND c.id_progetto = ?';
                $cnd[] = array( 's' => $job['workspace']['id_corso'] );
            } else {
                $whr = 'LIMIT 1000';
            }

            // inizializzo l'array
            $arr = mysqlSelectColumn(
                'id',
                $cf['mysql']['connection'],
                'SELECT c.id FROM todo AS c LEFT JOIN __report_lezioni_corsi__ AS r ON r.id = c.id
                WHERE ( r.timestamp_aggiornamento < c.timestamp_aggiornamento OR r.timestamp_aggiornamento IS NULL OR r.id IS NULL )
                AND c.id_tipologia IN (14, 15, 18) ' . $whr,
                $cnd
            );

            // segno il totale delle cose da fare
            $job['totale'] = count( $arr );

            // avvio il contatore
            $job['corrente'] = 1;

            // lista
            $job['workspace']['lista'] = $arr;

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
            $arr = $job['workspace']['lista'];

            // incremento l'indice di lavoro
            $job['corrente']++;

        }

        // operazioni di chiusura
        if( empty( $job['totale'] ) || $job['corrente'] > $job['totale'] ) {

            // scrivo la riga
            if( isset( $job['workspace']['id_corso'] ) && ! empty( $job['workspace']['id_corso'] ) ) {
                updateReportCorsi( $job['workspace']['id_corso'] );
            }

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
            $row = $arr[ $widx ];

            // scrivo la riga
            updateReportLezioniCorsi( $row );

            // status
            $job['workspace']['status']['elaborati'][ $row ] = array( 'esito' => 'OK' );

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
