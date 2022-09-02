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

    } elseif( ! isset( $job['workspace']['key'] ) || empty( $job['workspace']['key'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'questo job richiede una chiave memcache su cui lavorare';

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // leggo i dati
            $arr = unserialize(
                memcacheRead(
                    $cf['memcache']['connection'],
                    $job['workspace']['key']
                )
            );

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
/*
		    // apro il documento per leggere il numero di righe
			$xls = \PhpOffice\PhpSpreadsheet\IOFactory::load( DIR_BASE . $job['workspace']['file'] );

		    // converto il foglio attivo in un array
			$arr = $xls->getActiveSheet()->toArray();

            // scarto l'intestazione
            array_shift( $arr );
*/
            // leggo i dati
            $arr = unserialize(
                memcacheRead(
                    $cf['memcache']['connection'],
                    $job['workspace']['key']
                )
            );

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
            $row = $arr[ $widx ];

            // controlli formali e lavorazione riga
            if( empty( $row['nome_comune'] ) ) {

                // log
                logWrite( 'nome comune mancante alla riga #' . $widx . ' del job #' . $job['id'], 'job', LOG_ERR );

            } else {

                // trovo la regione
                $idRegione = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_stato' => 1,
                        'nome' => $row['nome_regione'],
                        'codice_istat' => $row['codice_istat_regione']
                    ),
                    'regioni'
                );

                // trovo la provincia
                $idProvincia = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_regione' => $idRegione,
                        'nome' => $row['nome_provincia'],
                        'sigla' => $row['sigla_auto'],
                        'codice_istat' => $row['codice_istat_provincia']
                    ),
                    'provincie'
                );

                // inserisco il comune
                $idComune = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_provincia' => $idProvincia,
                        'nome' => $row['nome_comune'],
                        'codice_istat' => $row['codice_istat_comune'],
                        'codice_catasto' => $row['codice_catasto_comune']
                    ),
                    'comuni'
                );

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