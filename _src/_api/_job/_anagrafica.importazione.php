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
            $row = $arr[ $widx ];

            // ...
            $job['riga'] = $row;

            // controlli formali e lavorazione riga
            if( ( ! isset( $row['codice'] ) || empty( $row['codice'] ) ) && 
                ( ! isset( $row['codice_fiscale'] ) || empty( $row['codice_fiscale'] ) ) && 
                ( ! isset( $row['partita_iva'] ) || empty( $row['partita_iva'] ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'codice utente, codice fiscale e partita IVA non settati per la riga ' . $job['corrente'];
                // $job['workspace']['status']['error'][] = $row;

            } elseif( empty( ( ( isset( $row['nome'] ) ) ? $row['nome'] : NULL ) . ( ( isset( $row['cognome'] ) ) ? $row['cognome'] : NULL ) . ( ( isset( $row['denominazione'] ) ) ? $row['denominazione'] : NULL ) ) ) {

                // status
                $job['workspace']['status']['error'][] = 'nome, cognome e denominazione non settati per la riga ' . $job['corrente'] . ' ' . ( ( ( isset( $row['nome'] ) ) ? $row['nome'] : NULL ) . ( ( isset( $row['cognome'] ) ) ? $row['cognome'] : NULL ) . ( ( isset( $row['denominazione'] ) ) ? $row['denominazione'] : NULL ) );
                // $job['workspace']['status']['error'][] = $row;

            } else {

                // trovo l'ID dell'anagrafica
                $idAnagrafica = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'codice' => ( ! empty( $row['codice'] ) ) ? $row['codice'] : NULL,
                        'partita_iva' => ( ! empty( $row['partita_iva'] ) ) ? $row['partita_iva'] : NULL,
                        'codice_fiscale' => ( ! empty( $row['codice_fiscale'] ) ) ? $row['codice_fiscale'] : NULL,
                        'nome' => ( ( isset( $row['nome'] ) ) ? $row['nome'] : NULL ),
                        'cognome' => ( ( isset( $row['cognome'] ) ) ? $row['cognome'] : NULL ),
                        'denominazione' => ( ( isset( $row['denominazione'] ) ) ? $row['denominazione'] : NULL ),
                        'note_commerciali' => ( ( isset( $row['note_commerciali'] ) ) ? $row['note_commerciali'] : NULL )
                    ),
                    'anagrafica'
                );

                // status
                $job['status']['info'][] = 'anagrafica inserita con ID ' . $idAnagrafica . ' per la riga ' . $job['corrente'];

                // se è presente un indirizzo...
                if( ( isset( $row['indirizzo'] ) && ! empty( $row['indirizzo'] ) ) &&
                    ( isset( $row['comune'] ) && ! empty( $row['comune'] ) ) ) {
/*
                    // TODO trovo il paese
                    $idPaese = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM stati WHERE nome = ? OR iso31661alpha2 = ? OR iso31661alpha2 = ?',
                        array(
                            array( 's' => $row['stato'] )
                        )
                    );
*/
                    // TODO trovo il comune
                    $idComune = mysqlSelectValue(
                        $cf['mysql']['connection'],
                        'SELECT id FROM comuni WHERE nome = ?',
                        array(
                            array( 's' => $row['comune'] )
                        )
                    );

                    // se ho il comune
                    if( ! empty( $idComune  ) ) {

                        // TODO trovo l'indirizzo
                        // NOTA nel CSV ci sono le colonne indirizzo, civico, cap, comune, stato
                        $idIndirizzo = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'indirizzo' => $row['indirizzo'],
                                'civico' => $row['civico'],
                                'id_comune' => $idComune
                            ),
                            'indirizzi',
                            true,
                            false,
                            array(
                                'indirizzo',
                                'civico',
                                'id_comune'
                            )
                        );

                        // TODO associo l'indirizzo all'anagrafica
                        if( ! empty( $idIndirizzo ) ) {

                            // associazione
                            $idAssociazioneIndirizzo = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id_ruolo' => 1,
                                    'id_anagrafica' => $idAnagrafica,
                                    'id_indirizzo' => $idIndirizzo
                                ),
                                'anagrafica_indirizzi'
                            );

                            // status
                            if( empty( $idAssociazioneIndirizzo ) ) {
                                $job['workspace']['status']['error'][] = 'indirizzo #' . $idIndirizzo . ' ' . $row['indirizzo'] . $row['civico'] . ' ' . $row['comune'] . ' non associato per la riga ' . $job['corrente'];
                            }

                        } else {

                            // status
                            $job['workspace']['status']['error'][] = 'indirizzo ' . $row['indirizzo'] . $row['civico'] . ' ' . $row['comune'] . ' non inserito per la riga ' . $job['corrente'];
                            // $job['workspace']['status']['error'][] = $row;

                        }

                    } else {

                        // status
                        $job['workspace']['status']['error'][] = 'comune ' . $row['comune'] . ' non trovato per la riga ' . $job['corrente'];
                        // $job['workspace']['status']['error'][] = $row;
                
                    }

                } else {

                    // status
                    $job['workspace']['status']['error'][] = 'indirizzo e comune non settati per la riga ' . $job['corrente'];
                    // $job['workspace']['status']['error'][] = $row;

                }

                // se sono presenti delle categorie...
                if( isset( $row['categorie'] ) && ! empty( $row['categorie'] ) ) {

                    // esplodo le categorie per pipe
                    $categorie = explode( '|', $row['categorie'] );

                    // per ogni categoria...
                    foreach( $categorie as $categoria ) {

                        // trovo l'ID della categoria
                        $idCategoria = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT id FROM categorie_anagrafica_view WHERE __label__ = ? OR id = ?',
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
                                    'id_anagrafica' => $idAnagrafica,
                                    'id_categoria' => $idCategoria
                                ),
                                'anagrafica_categorie'
                            );

                        } else {

                            // status
                            $job['workspace']['status']['error'][] = 'categoria ' . $categoria . ' non trovata per la riga ' . $job['corrente'];
                            // $job['workspace']['status']['error'][] = $row;

                        }

                    }

                } else {

                    // status
                    $job['workspace']['status']['error'][] = 'categoria non settata per la riga ' . $job['corrente'];
                    // $job['workspace']['status']['error'][] = $row;

                }

                // se sono presenti delle mail...
                if( isset( $row['mail'] ) && ! empty( $row['mail'] ) ) {

                    // esplodo le categorie per pipe
                    $indirizzi = explode( '|', $row['mail'] );

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
                    $job['workspace']['status']['error'][] = 'mail non settata per la riga ' . $job['corrente'];
                    // $job['workspace']['status']['error'][] = $row;

                }

                // se sono presenti dei telefoni...
                if( isset( $row['telefoni'] ) && ! empty( $row['telefoni'] ) ) {

                    // esplodo le categorie per pipe
                    $numeri = explode( '|', $row['telefoni'] );

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

                }

                // se sono presenti dei telefoni...
                if( isset( $row['url'] ) && ! empty( $row['url'] ) ) {

                    // esplodo le categorie per pipe
                    $urls = explode( '|', $row['url'] );

                    // per ogni categoria...
                    foreach( $urls as $url ) {

                        // trovo l'ID della mail
                        $idUrl = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => NULL,
                                'id_tipologia' => 1,
                                'id_anagrafica' => $idAnagrafica,
                                'url' => $numero
                            ),
                            'url'
                        );

                    }

                }

                // se è richiesta la creazione di un account...
                if( isset( $row['username'] ) && ! empty( $row['username'] ) ) {

                    // TODO se lo username esiste già aggiungo un numero finché non trovo un username non usato
                    // ...

                    // se la password non è settata, ne creo una casuale
                    if( ! isset( $row['password'] ) || empty( $row['password'] ) ) {
                        $row['password'] = getPassword();
                    }

                    // trovo l'ID dell'account
                    $idAccount = mysqlInsertRow(
                        $cf['mysql']['connection'],
                        array(
                            'id' => NULL,
                            'id_anagrafica' => $idAnagrafica,
                            'id_mail' => ( ( isset( $idMail ) && ! empty( $idMail ) ) ? $idMail : NULL ),
                            'username' => $row['username'],
                            'password' => md5( $row['password'] ),
                            'se_attivo' => 1
                        ),
                        'account'
                    );

                    // esplodo i gruppi per pipe
                    $gruppi = explode( '|', $row['gruppi'] );

                    // status
                    $job['workspace']['status']['info'][] = 'gruppi trovati ' . implode( ',', $gruppi ) . ' per la riga ' . $job['corrente'];

                    // per ogni gruppo...
                    foreach( $gruppi as $gruppo ) {

                        // trovo l'ID del gruppo
                        $idGruppo = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => NULL,
                                'nome' => $gruppo
                            ),
                            'gruppi'
                        );
    
                        // aggiungo il gruppo all'account
                        $idIscrizione = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => NULL,
                                'id_account' => $idAccount,
                                'id_gruppo' => $idGruppo
                            ),
                            'account_gruppi'
                        );

                    }

                    // se è richiesta la notifica via mail ed è settata una mail per l'anagrafica, invio la notifica
                    if( isset( $row['notify'] ) && $row['notify'] == 'mail' ) {
                        if( is_array( $indirizzi ) && count( $indirizzi ) > 0 ) {
                            $idMailNotifica = queueMailFromTemplate(
                                $cf['mysql']['connection'],
                                $cf['mail']['tpl']['NOTIFICA_NUOVO_ACCOUNT'],
                                array( 'dt' => $row, 'ct' => $ct ),
                                strtotime( '-1 minute' ),
                                array( $row['nome'] . ' ' . $row['cognome'] => $indirizzi[0] ),
                                $cf['localization']['language']['ietf']
                            );
                        }
                    }

                    // TODO se è richiesta la notifica via SMS ed è settato un telefono per l'anagrafica, invio la notifica
                    // if( isset( $row['notify'] ) && $row['notify'] == 'sms' ) {
                    // 
                    // }

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
