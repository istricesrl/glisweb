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
            $arr = csvFile2array( $job['workspace']['file'], ';' );

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
            $arr = csvFile2array( $job['workspace']['file'], ';' );

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
            if( ( ! isset( $row['codice'] ) || empty( $row['codice'] ) ) && ( ! isset( $row['codice_fiscale'] ) || empty( $row['codice_fiscale'] ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'codice utente e codice fiscale non settati per la riga ' . $job['corrente'];
                $job['workspace']['status']['error'][] = $row;

            } else {

                // trovo l'ID dell'anagrafica
                $idAnagrafica = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'codice' => ( ! empty( $row['codice'] ) ) ? $row['codice'] : NULL,
                        'codice_fiscale' => ( ! empty( $row['codice_fiscale'] ) ) ? $row['codice_fiscale'] : NULL,
                        'nome' => $row['nome'],
                        'cognome' => $row['cognome'],
                        'denominazione' => $row['denominazione']
                    ),
                    'anagrafica'
                );

                // status
                $job['workspace']['status']['info'][] = 'anagrafica inserita con ID ' . $idAnagrafica . ' per la riga ' . $job['corrente'];

                // trovo l'ID della categoria
                if( isset( $row['categoria'] ) ) {
                    $idCategoria = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM categorie_anagrafica_view WHERE __label__ = ?',
                        array( array( 's' => $row['categoria'] ) )
                    );
                    if( ! empty( $idCategoria ) ) {
                        mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => NULL,
                                'id_anagrafica' => $idAnagrafica,
                                'id_categoria' => $idCategoria
                            ),
                            'anagrafica_categorie'
                        );
                    } else {
                        $job['workspace']['status']['error'][] = 'categoria ' . $row['categoria'] . ' per la riga ' . $job['corrente'];
                    }
                }

                // trovo l'ID della mail
                $idMail = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'id_anagrafica' => $idAnagrafica,
                        'indirizzo' => $row['mail'],
                        'se_pec' => NULL
                    ),
                    'mail'
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
