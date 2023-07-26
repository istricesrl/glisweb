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
            if( ( ! isset( $job['riga']['id'] ) || empty( $job['riga']['id'] ) ) && 
                ( ! isset( $job['riga']['nome'] ) || empty( $job['riga']['nome'] ) ) ) {

                // status
                $job['status']['error'][] = 'id e nome non settati per la riga ' . $job['corrente'];

            } else {

                // tipologia
                if( ! empty( $job['riga']['tipologia'] ) ) {
                    $idTipologia = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT id FROM tipologie_prodotti_view WHERE __label__ = ?',
                        array( array( 's' => $job['riga']['tipologia'] ) )
                    );
                } else {
                    $idTipologia = 1;
                }

                // trovo l'ID del prodotto
                $idProdotto = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => $job['riga']['id'],
                        'id_tipologia' => $idTipologia,
                        'nome' => ( ( isset( $job['riga']['nome'] ) ) ? $job['riga']['nome'] : NULL )
                    ),
                    'prodotti'
                );

                // se il prodotto è stato inserito correttamente...
                if( ! empty( $idProdotto ) ) {

                    // status
                    $job['status']['info'][] = 'prodotto inserito con ID ' . $idProdotto . ' per la riga ' . $job['corrente'];

                    // se sono presenti delle categorie...
                    if( isset( $job['riga']['categorie'] ) && ! empty( $job['riga']['categorie'] ) ) {

                        // esplodo le categorie per pipe
                        $categorie = explode( '|', $job['riga']['categorie'] );

                        // per ogni categoria...
                        foreach( $categorie as $categoria ) {

                            // trovo l'ID della categoria
                            $idCategoria = mysqlSelectValue(
                                $cf['mysql']['connection'],
                                'SELECT id FROM categorie_prodotti_view WHERE __label__ = ? OR id = ?',
                                array(
                                    array( 's' => $categoria ),
                                    array( 's' => $categoria )
                                )
                            );

                            // se esiste la categoria
                            if( ! empty( $idCategoria ) ) {

                                // inserisco la categoria
                                mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id' => NULL,
                                        'id_prodotto' => $idProdotto,
                                        'id_categoria' => $idCategoria
                                    ),
                                    'prodotti_categorie'
                                );

                            } else {

                                // status
                                $job['status']['error'][] = 'categoria ' . $categoria . ' non trovata per la riga ' . $job['corrente'];

                            }

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'categoria non settata per la riga ' . $job['corrente'];

                    }

                    if( ( isset( $job['riga']['id_articolo'] ) || ! empty( $job['riga']['id_articolo'] ) ) && 
                        ( isset( $job['riga']['nome_articolo'] ) || ! empty( $job['riga']['nome_articolo'] ) ) ) {

                        // status
                        $job['status']['info'][] = 'inserimento articolo ' . $job['riga']['id_articolo'] . ' / ' . $job['riga']['nome_articolo'] . ' per la riga ' . $job['corrente'];

                        // trovo l'ID del prodotto
                        $idArticolo = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => $job['riga']['id_articolo'],
                                'id_prodotto' => $idProdotto,
                                'nome' => ( ( isset( $job['riga']['nome_articolo'] ) ) ? $job['riga']['nome_articolo'] : NULL )
                            ),
                            'articoli'
                        );

                        // ...
                        if( ! empty( $idArticolo ) ) {
                            $job['status']['info'][] = 'articolo ' . $idArticolo . ' inserito per la riga ' . $job['corrente'];
                        } else {
                            $job['status']['error'][] = 'articolo ' . $idArticolo . ' NON inserito per la riga ' . $job['corrente'];
                        }

                    } else {

                        // status
                        $job['status']['info'][] = 'dettagli articolo insufficienti per la riga ' . $job['corrente'];

                    }
    
                } else {

                    // status
                    $job['status']['info'][] = 'prodotto NON inserito per la riga ' . $job['corrente'];

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
