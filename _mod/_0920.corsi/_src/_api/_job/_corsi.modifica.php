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

            // lista
            $arr = $job['workspace']['lista'];

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
            $arr = $job['workspace']['lista'];

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

            // vecchio corso
            $job['corso'] = mysqlSelectRow(
                $cf['mysql']['connection'],
                'SELECT * FROM progetti WHERE id = ?',
                array( array( 's' => $job['riga'] ) )
            );

            // modifico il periodo
            // TODO

            // modifico il riferimento interno
            // TODO

            // modifico la fascia d'età
            // TODO

            // modifico il prezzo
            if( isset( $job['workspace']['sostituzioni']['prezzo'] ) && ! empty( $job['workspace']['sostituzioni']['prezzo'] ) && isset( $job['workspace']['sostituzioni']['periodo_prezzi'] ) && ! empty( $job['workspace']['sostituzioni']['periodo_prezzi'] ) ) {

                // ...
                $job['workspace']['status']['info'][] = 'modifica prezzo: ' . $job['workspace']['sostituzioni']['prezzo'] . ' periodo ' . $job['workspace']['sostituzioni']['periodo_prezzi'];

                // cerco il prodotto (progetti.id_prodotto -> prodotti.id) o lo creo
                if( empty( $job['corso']['id_prodotto'] ) ) {

                    $job['corso']['id_prodotto'] = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => $job['corso']['id'],
                            'id_tipologia' => 1,
                            'nome' => $job['corso']['nome']
                        ),
                        'prodotti'
                    );
            
                    mysqlQuery(
                        $cf['mysql']['connection'],
                        'UPDATE progetti SET id_prodotto = ? WHERE id = ?',
                        array(
                            array( 's' => $job['corso']['id_prodotto'] ),
                            array( 's' => $job['corso']['id'] )
                        )
                    );

                }

                // cerco l'articolo relativo al periodo selezionato o lo creo
                $idArticolo = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT articoli.id FROM articoli INNER JOIN metadati ON metadati.id_articolo = articoli.id WHERE articoli.id_prodotto = ? AND metadati.nome = "periodo_iscrizione" AND metadati.testo = ?',
                    array(
                        array( 's' => $job['corso']['id_prodotto'] ),
                        array( 's' => $job['workspace']['sostituzioni']['periodo_prezzi'] )
                    )
                );

                // se l'articolo non esiste, lo inserisco
                if( empty( $idArticolo ) ) {

                    $job['workspace']['status']['err'][] = 'articolo non trovato per il prodotto: ' . $job['corso']['id_prodotto'] . ' periodo ' . $job['workspace']['sostituzioni']['periodo_prezzi'];

                    $idArticolo = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => time(),
                            'id_prodotto' => $job['corso']['id_prodotto'],
                            'nome' => 'iscrizione ' . $job['workspace']['sostituzioni']['periodo_prezzi'] . ' al corso ' . $job['corso']['nome']
                        ),
                        'articoli'
                    );

                    $idMetadato = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => time(),
                            'id_lingua' => 1,
                            'id_articolo' => $idArticolo,
                            'nome' => 'periodo_iscrizione',
                            'testo' => $job['workspace']['sostituzioni']['periodo_prezzi']
                        ),
                        'metadati'
                    );

                }

                // modifico il prezzo dell'articolo o lo creo
                mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id_articolo' => $idArticolo,
                        'id_listino' => 1,
                        'id_iva' => 5,
                        'prezzo' => $job['workspace']['sostituzioni']['prezzo']
                    ),
                    'prezzi'
                );

            } else {

                // ...
                $job['workspace']['status']['err'][] = 'modifica prezzo impossibile: ' . $job['workspace']['sostituzioni']['prezzo'] . ' periodo ' . $job['workspace']['sostituzioni']['periodo_prezzi'];

            }

            // modifico il numero massimo di iscritti
            // TODO

            // modifico l'istruttore
            // TODO

            // debug
            // print_r( $job );

            // scrivo la riga
            updateReportCorsi( $job['corso']['id'] );

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
