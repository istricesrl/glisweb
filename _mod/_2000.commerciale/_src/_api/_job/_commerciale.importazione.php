<?php

    /**
     * importazione massiva attività commerciali
     * 
     * questo job importa un file CSV con le attività commerciali da svolgere
     * 
     * introduzione
     * ============
     * 
     * 
     * 
     * struttura del file
     * ==================
     * 
     * 
     * 
     * campo                                        | descrizione
     * ---------------------------------------------|---------------------------------------------------------
     * codice_campagna                              | il codice della campagna commerciale a cui appartiene l'attività (se non esiste verrà creato)
     * tipologia_campagna                           | la tipologia della campagna commerciale a cui appartiene l'attività (obbligatoria se si setta il codice campagna)
     * nome_campagna                                | il nome della campagna commerciale a cui appartiene l'attività (se non esiste verrà creata)
     * codice_cliente                               | il codice del cliente (se non esiste ed è presente la denominazione verrà creato altrimenti verrà segnalato l'errore)
     * mail_cliente                                 | l'indirizzo mail del cliente (opzionale, è possibile specificare indirizzi multipli separati da pipe)
     * telefoni_cliente                             | il numero di telefono del cliente (opzionale, è possibile specificare numeri multipli separati da pipe)
     * codice_progetto                              | il codice del progetto cui si riferisce l'attività (se non esiste verrà creato)
     * tipologia_progetto                           | la tipologia del progetto cui si riferisce l'attività (obbligatoria se si setta il codice progetto)
     * codice_todo                                  | il codice della todo cui si riferisce l'attività (se non esiste verrà creata)
     * tipologia_todo                               | la tipologia della todo cui si riferisce l'attività (obbligatoria se si setta il codice todo)
     * responsabile_todo                            | nome e cognome del responsabile della todo cui si riferisce l'attività (opzionale, se non viene trovato viene ignorato)
     * nome_todo                                    | il nome della todo cui si riferisce l'attività (obbligatorio)
     * anagrafica_programmazione_attivita_seguente  | nome e cognome del responsabile dell'attività seguente
     * data_programmazione_attivita_seguente        | la data di programmazione dell'attività seguente
     * tipologia_attivita_seguente                  | la tipologia dell'attività seguente
     * nome_attivita_seguente                       | il nome dell'attività seguente
     * ore_programmazione_attivita_seguente         | le ore previste per l'attività seguente
     * 
     * 
     */

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

        /**
         * 01. avvio del job
         * =================
         * 
         * 
         * 
         */

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
            $job['workspace']['status']['info'][] = 'file: ' . $job['workspace']['file'];
            $job['workspace']['status']['info'][] = 'requisiti formali soddisfatti, inizializzo il job';
            $job['workspace']['status']['info'][] = 'righe trovate: ' . $job['totale'];
            $job['workspace']['status']['info'][] = 'colonne trovate: ' . implode( ', ', array_keys( $arr[0] ) );

        } else {

            // leggo la lista
            $arr = csvFile2array( $job['workspace']['file'], NULL );

            // incremento l'indice di lavoro
            $job['corrente']++;

        }

        /**
         * 02. chiusura o lavorazione del job
         * ==================================
         * 
         * 
         * 
         * 
         */

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

                /**
                 * 02.1. LAVORAZIONE RIGA
                 * ======================
                 * 
                 * 
                 * 
                 */

                // trovo l'ID dell'anagrafica
                $idAnagrafica = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'codice' => ( ! empty( $job['riga']['codice_cliente'] ) ) ? $job['riga']['codice_cliente'] : NULL,
                        'denominazione' => ( ( isset( $job['riga']['denominazione_cliente'] ) ) ? $job['riga']['denominazione_cliente'] : NULL ),
                    ),
                    'anagrafica',
                    true,
                    false,
                    array(
                        'codice'
                    )
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

                    // campagna
                    if( isset( $job['riga']['codice_campagna'] ) && ! empty( $job['riga']['codice_campagna'] ) ) {

                        // campagna
                        if( isset( $job['riga']['nome_campagna'] ) && ! empty( $job['riga']['nome_campagna'] ) ) {

                            // cerco la tipologia di campagna

                            // cerco il responsabile della campagna

                            // inserisco la campagna

                        } else {

                            // status
                            $job['status']['error'][] = 'codice campagna non settato per la riga ' . $job['corrente'];

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'codice campagna non settato per la riga ' . $job['corrente'];

                    }

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

                    // todo
                    if( isset( $job['riga']['codice_todo'] ) && ! empty( $job['riga']['codice_todo'] ) ) {

                        // todo
                        if( isset( $job['riga']['nome_todo'] ) && ! empty( $job['riga']['nome_todo'] ) ) {

                            // cerco la tipologia di todo
                            $idTipologiaTodo = mysqlSelectCachedValue(
                                $cf['memcache']['connection'],
                                $cf['mysql']['connection'],
                                'SELECT id FROM tipologie_todo_view WHERE __label__ = ?',
                                array(
                                    array( 's' => $job['riga']['tipologia_todo'] )
                                )
                            );

                            // cerco il responsabile della todo
                            $idResponsabileTodo = mysqlSelectCachedValue(
                                $cf['memcache']['connection'],
                                $cf['mysql']['connection'],
                                'SELECT id FROM anagrafica_view_static WHERE __label__ = ?',
                                array(
                                    array( 's' => $job['riga']['responsabile_todo'] )
                                )
                            );

                            // inserisco la todo
                            $idTodo = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'codice' => $job['riga']['codice_todo'],
                                    'id_tipologia' => $idTipologiaTodo,
                                    'nome' => $job['riga']['nome_todo'],
                                    'id_responsabile' => $idResponsabileTodo,
                                    'id_cliente' => $idAnagrafica
                                ),
                                'todo'
                            );

                        } else {

                            // status
                            $job['status']['error'][] = 'codice todo non settato per la riga ' . $job['corrente'];

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'codice todo non settato per la riga ' . $job['corrente'];

                    }

                    // attività pianificata
                    if( isset( $job['riga']['data_programmazione_attivita_seguente'] ) && ! empty( $job['riga']['data_programmazione_attivita_seguente'] ) ) {

                        // nome attività pianificata
                        if( isset( $job['riga']['nome_attivita_seguente'] ) && ! empty( $job['riga']['nome_attivita_seguente'] ) ) {

                            // cerco la tipologia di attività
                            $idTipologiaAttivita = mysqlSelectCachedValue(
                                $cf['memcache']['connection'],
                                $cf['mysql']['connection'],
                                'SELECT id FROM tipologie_attivita_view WHERE __label__ = ?',
                                array(
                                    array( 's' => $job['riga']['tipologia_attivita_seguente'] )
                                )
                            );

                            // cerco il responsabile dell'attività seguente
                            $idResponsabileAttivita = mysqlSelectCachedValue(
                                $cf['memcache']['connection'],
                                $cf['mysql']['connection'],
                                'SELECT id FROM anagrafica_view_static WHERE __label__ = ?',
                                array(
                                    array( 's' => $job['riga']['anagrafica_programmazione_attivita_seguente'] )
                                )
                            );

                            // inserimento attività
                            $idAttivita = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_tipologia' => $idTipologiaAttivita,
                                    'data_programmazione' => $job['riga']['data_programmazione_attivita_seguente'],
                                    'id_anagrafica_programmazione' => $idResponsabileAttivita,
                                    'nome' => $job['riga']['nome_attivita_seguente'],
                                    'id_cliente' => $idAnagrafica,
                                    'id_progetto' => ( ( isset( $idProgetto ) ) ? $idProgetto : NULL ),
                                    'id_todo' => ( ( isset( $idTodo ) ) ? $idTodo : NULL )
                                ),
                                'attivita',
                                true,
                                false,
                                array(
                                    'data_programmazione',
                                    'id_anagrafica_programmazione',
                                    'nome',
                                    'id_progetto',
                                    'id_todo'
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

                } else {

                    // status
                    $job['status']['error'][] = 'anagrafica non trovata per la riga ' . $job['corrente'];

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
