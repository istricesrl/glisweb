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
            if( ( ! isset( $job['riga']['codice_cliente'] ) || empty( $job['riga']['codice_cliente'] ) ) ) {

                // status
                $job['status']['error'][] = 'codice cliente non settato per la riga ' . $job['corrente'];

            } else {

                // trovo l'ID dell'anagrafica
                $idAnagrafica = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'codice' => ( ! empty( $job['riga']['codice_cliente'] ) ) ? $job['riga']['codice_cliente'] : NULL,
                        'denominazione' => ( ( isset( $job['riga']['denominazione_cliente'] ) ) ? $job['riga']['denominazione_cliente'] : NULL ),
                    ),
                    'anagrafica'
                );

                // se è presente un ID cliente
                if( ! empty( $idAnagrafica ) ) {

                    // status
                    $job['status']['info'][] = 'anagrafica inserita con ID ' . $idAnagrafica . ' per la riga ' . $job['corrente'];

                    // se sono presenti delle mail...
                    if( isset( $job['riga']['mail_cliente'] ) && ! empty( $job['riga']['mail_cliente'] ) ) {

                        // esplodo le categorie per pipe
                        $indirizzi = explode( '|', $job['riga']['mail_cliente'] );

                        // TODO qui si potrebbe sotto esplodere per § e dare il ruolo alla mail
                        // tipo amministrazione@stocazzo.com§4|commerciale@stocazzo.com§2 eccetera

                        // per ogni categoria...
                        foreach( $indirizzi as $indirizzo ) {

                            // trovo l'ID della mail
                            $idMail = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id' => NULL,
                                    'id_ruolo' => 1,
                                    'id_anagrafica' => $idAnagrafica,
                                    'indirizzo' => $indirizzo,
                                    'se_pec' => NULL
                                ),
                                'mail'
                            );

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'mail non settata per la riga ' . $job['corrente'];

                    }

                    // se sono presenti dei telefoni...
                    if( isset( $job['riga']['telefoni_cliente'] ) && ! empty( $job['riga']['telefoni_cliente'] ) ) {

                        // esplodo le categorie per pipe
                        $numeri = explode( '|', $job['riga']['telefoni_cliente'] );

                        // per ogni categoria...
                        foreach( $numeri as $numero ) {

                            // trovo l'ID della mail
                            $idTel = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id' => NULL,
                                    'id_tipologia' => 1,
                                    'id_anagrafica' => $idAnagrafica,
                                    'numero' => $numero
                                ),
                                'telefoni'
                            );

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'telefono non settato per la riga ' . $job['corrente'];

                    }

                    // aggiornamento vista statica
                    updateAnagraficaViewStatic( $idAnagrafica );

                    // progetto
                    if( isset( $job['riga']['codice_progetto'] ) && ! empty( $job['riga']['codice_progetto'] ) ) {

                        // tipologia progetto
                        if( isset( $job['riga']['tipologia_progetto'] ) && ! empty( $job['riga']['tipologia_progetto'] ) ) {

                            // ID tipologia progetto
                            $idTipologiaProgetto = mysqlSelectCachedValue(
                                $cf['memcache']['connection'],
                                $cf['mysql']['connection'],
                                'SELECT id FROM tipologie_progetti WHERE nome = ?',
                                array(
                                    array( 's' => $job['riga']['tipologia_progetto'] )
                                )
                            );

                            // ID progetto
                            if( ! empty( $idTipologiaProgetto ) ) {
                                $idProgetto = mysqlInsertRow(
                                    $cf['mysql']['connection'],
                                    array(
                                        'id' => $job['riga']['codice_progetto'],
                                        'id_tipologia' => $idTipologiaProgetto,
                                        'nome' => $job['riga']['nome_progetto'],
                                        'note' => $job['riga']['note_progetto'],
                                        'entrate_previste' => ( ( isset( $job['riga']['entrate_previste'] ) ) ? $job['riga']['entrate_previste'] : NULL ),
                                        'costi_previsti' => ( ( isset( $job['riga']['costi_previsti'] ) ) ? $job['riga']['costi_previsti'] : NULL ),
                                        'ore_previste' => ( ( isset( $job['riga']['ore_previste'] ) ) ? $job['riga']['ore_previste'] : NULL ),
                                        'id_cliente' => $idAnagrafica
                                    ),
                                    'progetti'
                                );

                                // status
                                if( ! empty( $idProgetto ) ) {
                                    $job['status']['info'][] = 'progetto inserito con ID ' . $idProgetto . ' per la riga ' . $job['corrente'];
                                } else {
                                    $job['status']['error'][] = 'progetto non inserito per la riga ' . $job['corrente'];
                                }

                            } else {

                                // status
                                $job['status']['error'][] = 'tipologia progetto ' . $job['riga']['tipologia_progetto'] . ' non trovata per la riga ' . $job['corrente'];

                            }

                        } else {

                            // status
                            $job['status']['error'][] = 'tipologia progetto non settata per la riga ' . $job['corrente'];
    
                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'codice progetto non settato per la riga ' . $job['corrente'];

                    }

                    // attività pianificata
                    if( isset( $job['riga']['data_programmazione_attivita_seguente'] ) && ! empty( $job['riga']['data_programmazione_attivita_seguente'] ) ) {

                        // nome attività pianificata
                        if( isset( $job['riga']['nome_attivita_seguente'] ) && ! empty( $job['riga']['nome_attivita_seguente'] ) ) {

                            // inserimento attività
                            $idAttivita = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_tipologia' => 16,
                                    'data_programmazione' => $job['riga']['data_programmazione_attivita_seguente'],
                                    'nome' => $job['riga']['nome_attivita_seguente'],
                                    'id_cliente' => $idAnagrafica,
                                    'id_progetto' => ( ( isset( $idProgetto ) ) ? $idProgetto : NULL )
                                ),
                                'attivita',
                                true,
                                false,
                                array(
                                    'data_programmazione',
                                    'nome',
                                    'id_progetto'
                                )
                            );

                            // status
                            if( ! empty( $idAttivita ) ) {
                                $job['status']['info'][] = 'attività inserita con ID ' . $idAttivita . ' per la riga ' . $job['corrente'];
                            } else {
                                $job['status']['error'][] = 'attività non inserita per la riga ' . $job['corrente'];
                            }

                        } else {

                            // status
                            $job['status']['error'][] = 'nome attività seguente non settata per la riga ' . $job['corrente'];
    
                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'data pianificazione attività seguente non settata per la riga ' . $job['corrente'];

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
