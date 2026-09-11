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

        // UN JOB CHE NON PUO' PARTIRE VA CHIUSO, non lasciato in coda
        //
        // Fino a qui i tre rami qui sotto scrivevano l'errore e basta: timestamp_completamento
        // restava vuoto, il job non usciva mai dalla coda e il cron lo ripescava ogni minuto
        // per sempre, riscrivendo lo stesso errore nel log. Il file di lavorazione viene
        // deciso quando il job viene accodato: se non c'e' adesso non comparira' dopo, quindi
        // riprovare all'infinito non serve a niente.
        $jobs = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
            array(
                array( 's' => time() ),
                array( 's' => $job['id'] )
            )
        );

        // debug
        logWrite( 'job ' . $job['id'] . ' chiuso con errore: questo job richiede un file su cui lavorare', 'job', LOG_ERR );

    } elseif( ! file_exists( DIR_BASE . $job['workspace']['file'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'impossibile trovare il file ' . $job['workspace']['file'];

        $jobs = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
            array(
                array( 's' => time() ),
                array( 's' => $job['id'] )
            )
        );

        // debug
        logWrite( 'job ' . $job['id'] . ' chiuso con errore: impossibile trovare il file ' . $job['workspace']['file'] . '', 'job', LOG_ERR );

    } elseif( ! is_readable( DIR_BASE . $job['workspace']['file'] ) ) {

        // status
        $job['workspace']['status']['error'][] = 'impossibile leggere il file ' . $job['workspace']['file'];

        $jobs = mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE job SET timestamp_completamento = ? WHERE id = ?',
            array(
                array( 's' => time() ),
                array( 's' => $job['id'] )
            )
        );

        // debug
        logWrite( 'job ' . $job['id'] . ' chiuso con errore: impossibile leggere il file ' . $job['workspace']['file'] . '', 'job', LOG_ERR );

    } else {

        // attività di avvio
        if( empty( $job['corrente'] ) ) {

            // inizializzo l'array
            $arr = csvFile2array( $job['workspace']['file'], NULL );

            // se memcache è diponibile, salvo $arr
            if( ! empty( $cf['memcache']['connection'] ) ) {
                $e = memcacheWrite( $cf['memcache']['connection'], 'JOB_' . $job['id'] . '_DATA', $arr );
                if( ! empty( $e ) ) {
                    $job['workspace']['status']['info'][] = 'dataset salvato in cache';
                }
            }

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

            // se memcache è diponibile, leggo $arr
            $arr = memcacheRead( $cf['memcache']['connection'], 'JOB_' . $job['id'] . '_DATA' );

            // leggo la lista
            if( empty( $arr ) ) {
                $arr = csvFile2array( $job['workspace']['file'], NULL );
            }

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

            // ...
            // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_view_static SELECT * FROM anagrafica_view' );
            // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_archiviati_view_static SELECT * FROM anagrafica_archiviati_view' );
            // mysqlQuery( $cf['mysql']['connection'], 'REPLACE INTO anagrafica_attivi_view_static SELECT * FROM anagrafica_attivi_view' );

        } else {

            // aggiusto l'indice di lavoro (gli array partono da zero)
            $widx = $job['corrente'] - 1;

            // prelevo la riga da lavorare
            $job['riga'] = $arr[ $widx ];

            // controlli formali e lavorazione riga
            if( ( ! isset( $job['riga']['codice'] ) || empty( $job['riga']['codice'] ) ) && 
                ( ! isset( $job['riga']['codice_fiscale'] ) || empty( $job['riga']['codice_fiscale'] ) ) && 
                ( ! isset( $job['riga']['partita_iva'] ) || empty( $job['riga']['partita_iva'] ) ) ) {

                // status
                $job['status']['error'][] = 'codice utente, codice fiscale e partita IVA non settati per la riga ' . $job['corrente'];

            } elseif( empty( ( ( isset( $job['riga']['nome'] ) ) ? $job['riga']['nome'] : NULL ) . ( ( isset( $job['riga']['cognome'] ) ) ? $job['riga']['cognome'] : NULL ) . ( ( isset( $job['riga']['denominazione'] ) ) ? $job['riga']['denominazione'] : NULL ) ) ) {

                // status
                $job['status']['error'][] = 'nome, cognome e denominazione non settati per la riga ' . $job['corrente'] . ' ' . ( ( ( isset( $job['riga']['nome'] ) ) ? $job['riga']['nome'] : NULL ) . ( ( isset( $job['riga']['cognome'] ) ) ? $job['riga']['cognome'] : NULL ) . ( ( isset( $job['riga']['denominazione'] ) ) ? $job['riga']['denominazione'] : NULL ) );

            } else {

                // tipologia
                if( ! empty( $job['riga']['codice_ipa'] ) ) {
                    $idTipologia = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT min( id ) FROM tipologie_anagrafica WHERE se_pubblica_amministrazione IS NOT NULL'
                    );
                } elseif( ! empty( $job['riga']['denominazione'] ) ) {
                    $idTipologia = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT min( id ) FROM tipologie_anagrafica WHERE se_persona_giuridica IS NOT NULL'
                    );
                } elseif( ! empty( $job['riga']['cognome'] ) ) {
                    $idTipologia = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT min( id ) FROM tipologie_anagrafica WHERE se_persona_fisica IS NOT NULL'
                    );
                } else {
                    $idTipologia = NULL;
                }

                // trovo l'ID dell'anagrafica
                $idAnagrafica = mysqlInsertRow(
                    $cf['mysql']['connection'],
                    array(
                        'id' => NULL,
                        'id_tipologia' => $idTipologia,
                        'codice' => ( ! empty( $job['riga']['codice'] ) ) ? $job['riga']['codice'] : NULL,
                        'partita_iva' => ( ! empty( $job['riga']['partita_iva'] ) ) ? $job['riga']['partita_iva'] : NULL,
                        'codice_fiscale' => ( ! empty( $job['riga']['codice_fiscale'] ) ) ? $job['riga']['codice_fiscale'] : NULL,
                        'codice_sdi' => ( ! empty( $job['riga']['codice_sdi'] ) ) ? $job['riga']['codice_sdi'] : NULL,
                        'codice_ipa' => ( ! empty( $job['riga']['codice_ipa'] ) ) ? $job['riga']['codice_ipa'] : NULL,
                        'nome' => ( ( isset( $job['riga']['nome'] ) ) ? $job['riga']['nome'] : NULL ),
                        'cognome' => ( ( isset( $job['riga']['cognome'] ) ) ? $job['riga']['cognome'] : NULL ),
                        'denominazione' => ( ( isset( $job['riga']['denominazione'] ) ) ? $job['riga']['denominazione'] : NULL ),
                        'note' => ( ( isset( $job['riga']['note'] ) ) ? $job['riga']['note'] : NULL ),
                        'note_commerciali' => ( ( isset( $job['riga']['note_commerciali'] ) ) ? $job['riga']['note_commerciali'] : NULL )
                    ),
                    'anagrafica'
                );

                // status
                $job['status']['info'][] = 'anagrafica inserita con ID ' . $idAnagrafica . ' per la riga ' . $job['corrente'];

                // se l'anagrafica non e' entrata la riga si ferma qui: senza il suo id,
                // indirizzi, mail, telefoni, url e categorie finirebbero in archivio con la
                // chiave esterna vuota, cioe' agganciati a nessuno. E' successo davvero il
                // 03/09/2026 su un deploy in cui mancava la colonna anagrafica.codice_ipa:
                // l'INSERT falliva, il job scriveva "anagrafica inserita con ID " con l'id
                // vuoto, il giro proseguiva e in anagrafica_indirizzi restavano tre righe
                // con id_anagrafica NULL, cioe' indirizzi di nessuno.
                if( empty( $idAnagrafica ) ) {

                    // debug
                    logWrite( 'anagrafica non inserita per la riga ' . $job['corrente'] . ': ' . print_r( $job['riga'], true ), 'job', LOG_ERR );

                    // status
                    $job['status']['error'][] = 'anagrafica non inserita per la riga ' . $job['corrente'] . ', riga saltata';

                } else {

                    // se è presente un indirizzo...
                    if( ( isset( $job['riga']['indirizzo'] ) && ! empty( $job['riga']['indirizzo'] ) ) &&
                        ( isset( $job['riga']['comune'] ) && ! empty( $job['riga']['comune'] ) ) ) {
    /*
                        // TODO trovo il paese
                        $idPaese = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT id FROM stati WHERE nome = ? OR iso31661alpha2 = ? OR iso31661alpha2 = ?',
                            array(
                                array( 's' => $job['riga']['stato'] )
                            )
                        );
    */
                        /**
                         * Fix 2026-09-12: il comune si cerca per nome, ma il nome NON e' univoco.
                         *
                         * In archivio convivono i comuni italiani e quelli esteri: "Lugo" e' sia in
                         * provincia di Ravenna sia in Galizia, e le omonimie fitte sono parecchie
                         * ( Fantanele sette volte, Stefan cel Mare sei, Viisoara sei ). Con la
                         * vecchia "SELECT id FROM comuni WHERE nome = ?" la riga che tornava
                         * dipendeva dal piano di esecuzione: su un'importazione di 14.500
                         * anagrafiche con 1.115 righe di Lugo andava bene solo perche' l'id
                         * italiano e' piu' basso, il che e' una coincidenza e non una garanzia.
                         *
                         * Il tracciato porta `comune`, `provincia` e `stato` — sono le colonne 16,
                         * 17 e 18 di _usr/_examples/_csv/anagrafica.import.csv, che e' il file che
                         * definisce il formato — e si usano tutte e tre, con l'ordinamento finale
                         * sull'id a tenere deterministica la scelta quando non bastano.
                         *
                         * La PROVINCIA non e' ridondante rispetto allo stato e non va tolta per
                         * "pulizia": e' l'unica cosa che separa due comuni italiani omonimi, dove
                         * lo stato vale "Italia" per tutti e due. Nell'archivio di oggi sono
                         * Calliano ( AT e TN ), Livo ( CO e TN ), Peglio ( CO e PU ) e Samone
                         * ( TN e TO ), e sono di piu' su un archivio completo.
                         *
                         * Il degrado e' voluto e verificato: con i parametri a NULL le espressioni
                         * booleane valgono NULL per ogni riga, quindi non ordinano niente e si
                         * scende sull'id, cioe' sul comportamento di prima. Un tracciato senza
                         * `provincia` o senza `stato` non peggiora.
                         *
                         * Lo stato si confronta sia col nome sia col codice ISO perche' il
                         * tracciato ammette tutt'e due le forme, come gia' prevedeva la ricerca
                         * del paese qui sopra.
                         */
                        $idComune = mysqlSelectValue(
                            $cf['mysql']['connection'],
                            'SELECT comuni.id
                               FROM comuni
                               LEFT JOIN provincie ON provincie.id = comuni.id_provincia
                               LEFT JOIN regioni ON regioni.id = provincie.id_regione
                               LEFT JOIN stati ON stati.id = regioni.id_stato
                              WHERE comuni.nome = ?
                              ORDER BY ( provincie.sigla = ? ) DESC,
                                       ( stati.nome = ? OR stati.iso31661alpha2 = ? ) DESC,
                                       comuni.id ASC
                              LIMIT 1',
                            array(
                                array( 's' => $job['riga']['comune'] ),
                                array( 's' => ( ( isset( $job['riga']['provincia'] ) ) ? $job['riga']['provincia'] : NULL ) ),
                                array( 's' => ( ( isset( $job['riga']['stato'] ) ) ? $job['riga']['stato'] : NULL ) ),
                                array( 's' => ( ( isset( $job['riga']['stato'] ) ) ? $job['riga']['stato'] : NULL ) )
                            )
                        );

                        // se ho il comune
                        if( ! empty( $idComune ) ) {

                            // TODO trovo l'indirizzo
                            // NOTA nel CSV ci sono le colonne indirizzo, civico, cap, comune, provincia, stato
                            // e localita: l'elenco completo delle 22 colonne del tracciato sta in
                            // _usr/_examples/_csv/anagrafica.import.csv
                            $idIndirizzo = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'indirizzo' => $job['riga']['indirizzo'],
                                    'civico' => $job['riga']['civico'],
                                    'cap' => ( ( isset( $job['riga']['cap'] ) ) ? $job['riga']['cap'] : NULL ),
                                    'id_comune' => $idComune,
                                    'localita' => ( ( isset( $job['riga']['localita'] ) ) ? $job['riga']['localita'] : NULL )
                                ),
                                'indirizzi',
                                true,
                                false,
                                array(
                                    'indirizzo',
                                    'civico',
                                    'cap',
                                    'id_comune',
                                    'localita'
                                )
                            );

                            // status
                            $job['status']['error'][] = 'comune ' . $job['riga']['comune'] . ' trovato (' . $idComune . ') per la riga ' . $job['corrente'];

                        } else {

                            // TODO trovo l'indirizzo
                            // NOTA nel CSV ci sono le colonne indirizzo, civico, cap, comune, provincia, stato
                            // e localita: l'elenco completo delle 22 colonne del tracciato sta in
                            // _usr/_examples/_csv/anagrafica.import.csv
                            $idIndirizzo = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'indirizzo' => $job['riga']['indirizzo'],
                                    'civico' => $job['riga']['civico'],
                                    'cap' => ( ( isset( $job['riga']['cap'] ) ) ? $job['riga']['cap'] : NULL ),
                                    'id_comune' => NULL,
                                    'localita' => $job['riga']['comune']
                                ),
                                'indirizzi',
                                true,
                                false,
                                array(
                                    'indirizzo',
                                    'civico',
                                    'cap',
                                    'id_comune',
                                    'localita'
                                )
                            );

                            // status
                            $job['status']['error'][] = 'comune ' . $job['riga']['comune'] . ' non trovato per la riga ' . $job['corrente'];

                            // log
                            logWrite( 'per anagrafica #' . $idAnagrafica . ' non trovato: ' . $row['comune'] . ' (' . $row['stato'] . ')', 'geografia/comuni', LOG_ERR );

                        }

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

                            // Fix 2026-07-10: allineo la copia inline dell'indirizzo su
                            // anagrafica_indirizzi (il job non passa da controller(), quindi il
                            // finally `src/inc/controllers/indirizzi.finally.php` non scatta).
                            if( function_exists( 'sincronizzaIndirizzoInline' ) ) {
                                sincronizzaIndirizzoInline( $idIndirizzo );
                            }

                            // status
                            if( empty( $idAssociazioneIndirizzo ) ) {
                                $job['status']['error'][] = 'indirizzo #' . $idIndirizzo . ' ' . 
                                    $job['riga']['indirizzo'] . $job['riga']['civico'] . ' ' . 
                                    $job['riga']['comune'] . ' non associato per la riga ' . $job['corrente'] . 
                                    ' anagrafica ' . $idAnagrafica;
                            }

                        } else {

                            // status
                            $job['status']['error'][] = 'indirizzo ' . $job['riga']['indirizzo'] . $job['riga']['civico'] . ' ' . $job['riga']['comune'] . ' non inserito per la riga ' . $job['corrente'];

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'indirizzo e comune non settati per la riga ' . $job['corrente'];

                    }

                    // se sono presenti delle categorie...
                    if( isset( $job['riga']['categorie'] ) && ! empty( $job['riga']['categorie'] ) ) {

                        // esplodo le categorie per pipe
                        $categorie = explode( '|', $job['riga']['categorie'] );

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
                                $job['status']['error'][] = 'categoria ' . $categoria . ' non trovata per la riga ' . $job['corrente'];

                            }

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'categoria non settata per la riga ' . $job['corrente'];

                    }

                    // se sono presenti delle mail...
                    if( isset( $job['riga']['mail'] ) && ! empty( $job['riga']['mail'] ) ) {

                        // esplodo le categorie per pipe
                        $indirizzi = explode( '|', $job['riga']['mail'] );

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

                    // se sono presenti delle mail...
                    if( isset( $job['riga']['pec'] ) && ! empty( $job['riga']['pec'] ) ) {

                        // esplodo le categorie per pipe
                        $indirizzi = explode( '|', $job['riga']['pec'] );

                        // TODO qui si potrebbe sotto esplodere per § e dare il ruolo alla mail
                        // tipo note#amministrazione@stocazzo.com§4|altre note#commerciale@stocazzo.com§2 eccetera

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
                                    'se_pec' => 1
                                ),
                                'mail'
                            );

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'PEC non settata per la riga ' . $job['corrente'];

                    }

                    // se sono presenti dei telefoni...
                    if( isset( $job['riga']['telefoni'] ) && ! empty( $job['riga']['telefoni'] ) ) {

                        // esplodo le categorie per pipe
                        $numeri = explode( '|', $job['riga']['telefoni'] );

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

                    // se sono presenti dei telefoni mobili...
                    if( isset( $job['riga']['mobile'] ) && ! empty( $job['riga']['mobile'] ) ) {

                        // esplodo le categorie per pipe
                        $numeri = explode( '|', $job['riga']['mobile'] );

                        // per ogni categoria...
                        foreach( $numeri as $numero ) {

                            // trovo l'ID della mail
                            $idTel = mysqlInsertRow(
                                $cf['mysql']['connection'],
                                array(
                                    'id' => NULL,
                                    'id_tipologia' => 2,
                                    'id_anagrafica' => $idAnagrafica,
                                    'numero' => $numero
                                ),
                                'telefoni'
                            );

                        }

                    } else {

                        // status
                        $job['status']['error'][] = 'telefono mobile non settato per la riga ' . $job['corrente'];

                    }

                    // se sono presenti degli URL...
                    if( isset( $job['riga']['url'] ) && ! empty( $job['riga']['url'] ) ) {

                        // esplodo le categorie per pipe
                        $urls = explode( '|', $job['riga']['url'] );

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
                    if( isset( $job['riga']['username'] ) && ! empty( $job['riga']['username'] ) ) {

                        // TODO se lo username esiste già aggiungo un numero finché non trovo un username non usato
                        // ...

                        // se la password non è settata, ne creo una casuale
                        if( ! isset( $job['riga']['password'] ) || empty( $job['riga']['password'] ) ) {
                            $job['riga']['password'] = getPassword();
                        }

                        // trovo l'ID dell'account
                        $idAccount = mysqlInsertRow(
                            $cf['mysql']['connection'],
                            array(
                                'id' => NULL,
                                'id_anagrafica' => $idAnagrafica,
                                'id_mail' => ( ( isset( $idMail ) && ! empty( $idMail ) ) ? $idMail : NULL ),
                                'username' => $job['riga']['username'],
                                'password' => md5( $job['riga']['password'] ),
                                'se_attivo' => 1
                            ),
                            'account'
                        );

                        // esplodo i gruppi per pipe
                        $gruppi = explode( '|', $job['riga']['gruppi'] );

                        // status
                        $job['status']['info'][] = 'gruppi trovati ' . implode( ',', $gruppi ) . ' per la riga ' . $job['corrente'];

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
                        if( isset( $job['riga']['notify'] ) && $job['riga']['notify'] == 'mail' ) {
                            if( is_array( $indirizzi ) && count( $indirizzi ) > 0 ) {
                                $idMailNotifica = queueMailFromTemplate(
                                    $cf['mysql']['connection'],
                                    $cf['mail']['tpl']['NOTIFICA_NUOVO_ACCOUNT'],
                                    array( 'dt' => $job['riga'], 'ct' => $ct ),
                                    strtotime( '-1 minute' ),
                                    array( $job['riga']['nome'] . ' ' . $job['riga']['cognome'] => $indirizzi[0] ),
                                    $cf['localization']['language']['ietf']
                                );
                            }
                        }

                        // TODO se è richiesta la notifica via SMS ed è settato un telefono per l'anagrafica, invio la notifica
                        // if( isset( $job['riga']['notify'] ) && $job['riga']['notify'] == 'sms' ) {
                        // 
                        // }

                    }

                    // aggiornamento vista statica
                    updateAnagraficaViewStatic( $idAnagrafica );

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

    /**
     * NOTA
     * è possibile produrre un CSV compatibile con questo job di importazione utilizzando la seguente query:
     * 
     * SELECT
     *   trim( replace( replace( replace( anagrafica.nome,              '\r', ''), '\n', ''), '\t', '' ) ) AS nome,
     *   trim( replace( replace( replace( anagrafica.cognome,           '\r', ''), '\n', ''), '\t', '' ) ) AS cognome,
     *   trim( replace( replace( replace( anagrafica.denominazione,     '\r', ''), '\n', ''), '\t', '' ) ) AS denominazione,
     *   trim( replace( replace( replace( anagrafica.codice,            '\r', ''), '\n', ''), '\t', '' ) ) AS codice,
     *   trim( replace( replace( replace( anagrafica.partita_iva,       '\r', ''), '\n', ''), '\t', '' ) ) AS partita_iva,
     *   trim( replace( replace( replace( anagrafica.codice_fiscale,    '\r', ''), '\n', ''), '\t', '' ) ) AS codice_fiscale
     * FROM
     *   anagrafica
     * 
     */
