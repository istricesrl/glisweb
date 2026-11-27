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

    } elseif( isset( $job['corrente'] ) && $job['corrente'] > $job['totale'] ) {

        // status
        $status['info'][] = 'iterazione a vuoto su job completato';

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // pulizia ragionata report
            cleanReportCorsi();

            // pulisco il report
            cleanReportLezioniCorsi();

            // condizioni aggiuntive
            $whr = '';
            $cnd = array();

            // lezioni di uno specifico corso
            if( isset( $job['workspace']['id_corso'] ) && ! empty( $job['workspace']['id_corso'] ) ) {
                $whr = 'AND c.id_progetto = ?';
                $cnd[] = array( 's' => $job['workspace']['id_corso'] );
            } else {
                // $whr = 'LIMIT 10000';
            }

            // Fix 2026-07-29 (Polisportiva Masi): aggiunto `cast( c.id as char )` nella ON del LEFT
            // JOIN. `todo.id` è int mentre `__report_lezioni_corsi__.id` è char(255): senza cast
            // MySQL converte a numero la PK del report, che diventa inutilizzabile, e il join
            // degenera in una scansione completa del report per ogni riga di todo.
            // EXPLAIN: da `ALL` a `eq_ref` su PRIMARY. Misurato con 32k righe di todo e 32k di
            // report: query interrotta dopo 140 s senza completare, contro 0,5 s con il cast, a
            // parità di risultato.
            // NB: modifica a un file FRAMEWORK, sarà persa al prossimo `_gw.upgrade.sh`.
            // Fix 2026-10-26 ( polmasi ): il cast deve dire anche il charset, `character set utf8`. Il framework
            // si connette in utf8mb4, e un cast nudo produce una stringa utf8mb4 che non si confronta con la PK
            // utf8 del report senza convertirla: di nuovo niente PRIMARY, e al primo giro di cron la SELECT e'
            // rimasta appesa 3-4 minuti in prod; da CLI, in utf8, non si vedeva. Con il charset: eq_ref, 0,05 s.

            // il ricalcolo notturno ( lanciato dal cron, vedi report.lezioni.corsi.popolazione.start ) rifa' anche le
            // lezioni non cambiate da una settimana fa in avanti, perche' posti e scadenze cambiano con la data; le
            // passate restano ferme e si rifanno solo quando cambiano. Misura del 26/10/2026 su polmasi: 96 ms a
            // lezione, 7.285 lezioni future su 124.722, cioe' una dozzina di minuti invece di oltre tre ore
            $ntt = ( ! empty( $job['workspace']['notturno'] ) ) ? ' OR c.data_programmazione >= curdate() - INTERVAL 7 DAY' : '';

            // inizializzo l'array
            $arr = mysqlSelectColumn(
                'id',
                $cf['mysql']['connection'],
                'SELECT c.id FROM todo AS c INNER JOIN progetti ON progetti.id = c.id_progetto
                LEFT JOIN __report_lezioni_corsi__ AS r ON r.id = cast( c.id as char character set utf8 )
                WHERE ( r.timestamp_aggiornamento < c.timestamp_aggiornamento OR r.timestamp_aggiornamento IS NULL OR r.id IS NULL' . $ntt . ' )
                AND c.id_tipologia IN (14, 15, 18) ' . $whr,
                $cnd
            );

            // segno il totale delle cose da fare
            $job['totale'] = count( $arr );

            // avvio il contatore
            $job['corrente'] = 1;

            // lista
            // $job['workspace']['lista'] = $arr;
            memcacheWrite(
                $cf['memcache']['connection'],
                '_job_workspace_' . $job['id'] . '_lista',
                $arr
            );

            // ...
            // $job['workspace']['id_lista'] = '_job_workspace_' . $job['id'] . '_lista';

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
            $status['info'][] = 'requisiti formali soddisfatti, inizializzo il job';
            $status['info'][] = 'righe trovate: ' . $job['totale'];

        } else {

            // leggo la lista
            // $arr = $job['workspace']['lista'];
            $arr = memcacheRead(
                $cf['memcache']['connection'],
                '_job_workspace_' . $job['id'] . '_lista'
            );

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
            $status['elaborati'][ $row ] = array( 'esito' => 'OK' );

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
