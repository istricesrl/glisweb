<?php

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function updateReportCorsi( $idCorso ) {

        global $cf;

        $riga = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT progetti.id, progetti.id_periodo, tipologie_progetti.nome AS tipologia, progetti.nome, progetti.timestamp_inserimento, progetti.timestamp_aggiornamento, progetti.data_accettazione, progetti.data_chiusura, 
            if(
                progetti.data_accettazione > CURRENT_DATE(), "futuro",
                if( ( progetti.data_chiusura > CURRENT_DATE() OR progetti.data_chiusura IS NULL ), "attivo", "concluso" )
            ) AS stato
            FROM progetti LEFT JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia 
            WHERE progetti.id = ?',
            array( array( 's' => $idCorso ) )
        );

        /*
        `fasce` char(255) DEFAULT NULL,
        `discipline` char(255) DEFAULT NULL,
        `livelli` char(255) DEFAULT NULL,
        `giorni_orari_luoghi` char(255) DEFAULT NULL,
        `posti_disponibili` char(255) DEFAULT NULL,
        `timestamp_aggiornamento` int(11) DEFAULT NULL,        
        */

        // print_r( $riga );

        if( empty( $riga['timestamp_inserimento'] ) ) {
            $riga['timestamp_inserimento'] = time();
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE progetti SET timestamp_inserimento = ? WHERE id = ?',
                array(
                    array( 's' => $riga['timestamp_inserimento'] ),
                    array( 's' => $riga['id'] )
                )
            );
        }

        if( empty( $riga['timestamp_aggiornamento'] ) ) {
            $riga['timestamp_aggiornamento'] = time();
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE progetti SET timestamp_aggiornamento = ? WHERE id = ?',
                array(
                    array( 's' => $riga['timestamp_aggiornamento'] ),
                    array( 's' => $riga['id'] )
                )
            );
        }

        $riga['fasce'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT group_concat( DISTINCT if( f.id, categorie_progetti_path( f.id_categoria ), null ) SEPARATOR " | " ) 
            FROM progetti_categorie AS f INNER JOIN categorie_progetti AS c ON c.id = f.id_categoria 
            WHERE f.id_progetto = ? AND c.se_fascia = 1 GROUP BY f.id_progetto',
            array( array( 's' => $idCorso ) )
        );

        $riga['discipline'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT group_concat( DISTINCT if( f.id, categorie_progetti_path( f.id_categoria ), null ) SEPARATOR " | " ) 
            FROM progetti_categorie AS f INNER JOIN categorie_progetti AS c ON c.id = f.id_categoria 
            WHERE f.id_progetto = ? AND c.se_disciplina = 1 GROUP BY f.id_progetto',
            array( array( 's' => $idCorso ) )
        );

        $riga['livelli'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT group_concat( DISTINCT if( f.id, categorie_progetti_path( f.id_categoria ), null ) SEPARATOR " | " ) 
            FROM progetti_categorie AS f INNER JOIN categorie_progetti AS c ON c.id = f.id_categoria 
            WHERE f.id_progetto = ? AND c.se_classe = 1 GROUP BY f.id_progetto',
            array( array( 's' => $idCorso ) )
        );

        $riga['giorni_orari_luoghi'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT group_concat( DISTINCT
                concat_ws( " ", dayname( todo.data_programmazione ),
                concat_ws( " - ", todo.ora_inizio_programmazione, todo.ora_fine_programmazione ),
                luoghi_path( todo.id_luogo ) ) SEPARATOR " | " )
                FROM todo WHERE todo.id_progetto = ? AND todo.id_tipologia IN (14, 15) GROUP BY todo.id_progetto',
            array( array( 's' => $idCorso ) )
        );

        $dettagli['orari'] = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT
                dayname( todo.data_programmazione ) AS giorno,
                concat_ws( " - ", todo.ora_inizio_programmazione, todo.ora_fine_programmazione ) AS orario,
                luoghi_path( todo.id_luogo ) AS luogo
            FROM todo 
            WHERE todo.id_progetto = ? AND todo.id_tipologia IN (14, 15) 
            GROUP BY todo.id_progetto, dayname( todo.data_programmazione ), todo.ora_inizio_programmazione, todo.ora_fine_programmazione, todo.id_luogo
            ',
            array(
                array( 's' => $idCorso )
            )
        );

        $riga['posti_disponibili'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT concat( coalesce( count( DISTINCT ca.id_anagrafica ), 0 ), " / ", coalesce( max( m.testo ), "∞" ) )
            FROM metadati AS m
            LEFT JOIN contratti AS c ON c.id_progetto = m.id_progetto
            LEFT JOIN contratti_anagrafica AS ca ON ca.id_contratto = c.id
            LEFT JOIN anagrafica_categorie AS ac ON ac.id_anagrafica = ca.id_anagrafica 
            LEFT JOIN categorie_anagrafica AS a ON a.id = ac.id_categoria
            WHERE m.id_progetto = ?
            AND a.se_gestita IS NULL
            AND m.nome = "iscritti_max"
            GROUP BY m.id_progetto',
            array( array( 's' => $idCorso ) )
        );

        $riga['lista_attesa'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT coalesce( count( DISTINCT id_anagrafica ), 0 ) 
            FROM anagrafica_progetti WHERE anagrafica_progetti.se_attesa IS NOT NULL 
            AND anagrafica_progetti.id_progetto = ?',
            array( array( 's' => $idCorso ) )
        );

        $riga['prezzi'] = mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT group_concat(
                concat(
                    a.nome,
                    " ",
                    round( coalesce( p2.prezzo, p1.prezzo ), 2 )
                    )
                    separator " | "
                )
                FROM progetti
                INNER JOIN prodotti AS p ON p.id = progetti.id_prodotto
                INNER JOIN articoli AS a ON a.id_prodotto = p.id
                LEFT JOIN prezzi AS p1 ON p1.id_prodotto = p.id
                LEFT JOIN prezzi AS p2 ON p2.id_articolo = a.id
                WHERE progetti.id = ?
                GROUP BY p.id 
            ',
            array( array( 's' => $idCorso ) )
        );

        $riga['__label__'] = implode( ' ', array(
            $riga['id'],
            $riga['id_periodo'],
            $riga['nome'],
            $riga['fasce'],
            $riga['discipline'],
            $riga['livelli'],
            'dal',
            $riga['data_accettazione'],
            'al',
            $riga['data_chiusura'],
            $riga['giorni_orari_luoghi'],
            'posti',
            $riga['posti_disponibili']
        ) );

/*
		concat_ws(
			' ',
			progetti.id,
			progetti.nome,
			group_concat( DISTINCT if( d.id, categorie_progetti_path( d.id ), null ) SEPARATOR ' | ' ),
			group_concat( DISTINCT concat_ws( '/', f.nome, l.nome ) SEPARATOR ' | ' ),
			' dal ',
			coalesce( progetti.data_accettazione, '-' ),
			' al ',
			coalesce( progetti.data_chiusura, '-' ),
			group_concat( DISTINCT concat_ws( ' ', dayname( todo.data_programmazione ), concat_ws( ' - ', todo.ora_inizio_programmazione, todo.ora_fine_programmazione ) ), luoghi_path( todo.id_luogo ) SEPARATOR ' | ' ),
			'posti',
			coalesce( m.testo, '∞' )
		) AS __label__

*/

        // ...
        $riga['dettagli'] = json_encode( $dettagli );

        // print_r( $riga );

        mysqlInsertRow(
            $cf['mysql']['connection'],
            $riga,
            '__report_corsi__'
        );

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function cleanReportCorsi() {

        global $cf;

        return mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE __report_corsi__ FROM __report_corsi__
            LEFT JOIN progetti ON progetti.id = __report_corsi__.id
            WHERE progetti.id IS NULL;'
        );

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function updateReportLezioniCorsi( $idLezione ) {

        global $cf;

        // var_dump( $idLezione );

        $riga = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT todo.id, todo.id_tipologia, tipologie_todo.nome AS tipologia, todo.codice, 
                tipologie_todo.se_agenda, todo.id_anagrafica, 
                coalesce( a1.denominazione, concat( a1.cognome, " ", a1.nome ), "" ) AS anagrafica,
		        todo.id_cliente, coalesce( a2.denominazione, concat( a2.cognome, " ", a2.nome ), "" ) AS cliente,
		        todo.id_indirizzo, todo.id_luogo, 
                todo.timestamp_apertura,
                todo.data_scadenza, todo.ora_scadenza, todo.data_programmazione, todo.ora_inizio_programmazione,
                dayname( todo.data_programmazione ) AS note_programmazione,
                todo.ora_fine_programmazione, todo.anno_programmazione, todo.settimana_programmazione, todo.ore_programmazione,
                todo.data_chiusura, todo.nome, todo.id_contatto, todo.id_progetto, todo.id_pianificazione, todo.id_immobile,
                todo.data_archiviazione, todo.id_account_inserimento, todo.timestamp_inserimento, 
                todo.id_account_aggiornamento, todo.timestamp_aggiornamento,
                progetti.nome AS corso, m1.testo AS se_prenotabile_online, max( d.id ) AS id_disciplina, group_concat( DISTINCT if( d.id, categorie_progetti_path( d.id ), null ) SEPARATOR " | " ) AS discipline,
                concat(
                    todo.nome,
                    coalesce( concat( " per ", a2.denominazione, concat( a2.cognome, " ", a2.nome ) ), "" ),
                    coalesce( concat( " su ", todo.id_progetto, " ", progetti.nome ), "" )
                ) AS __label__
            FROM todo
                LEFT JOIN progetti ON progetti.id = todo.id_progetto
                LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
                LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
                LEFT JOIN categorie_progetti AS d ON d.id = progetti_categorie.id_categoria AND d.se_disciplina = 1
                LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
                LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
                LEFT JOIN metadati AS m1 ON m1.id_progetto = progetti.id AND m1.nome = "prenotabile_online"
            WHERE todo.id = ? AND tipologie_todo.id_genitore = 6 
            GROUP BY todo.id ',
            array( array( 's' => $idLezione ) )
        );

        if( isset( $riga['id'] ) && ! empty( $riga['id'] ) ) {

            if( empty( $riga['timestamp_aggiornamento'] ) ) {
                $riga['timestamp_aggiornamento'] = time();
                mysqlQuery(
                    $cf['mysql']['connection'],
                    'UPDATE todo SET timestamp_aggiornamento = ? WHERE id = ?',
                    array(
                        array( 's' => $riga['timestamp_aggiornamento'] ),
                        array( 's' => $riga['id'] )
                    )
                );
            }

            $riga['numero_posti'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( max( m.testo ), "∞" )
                FROM metadati AS m
                WHERE m.id_progetto = ?
                AND m.nome = "iscritti_max"
                GROUP BY m.id_progetto',
                array( array( 's' => $riga['id_progetto'] ) )
            );

            $riga['numero_alunni'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( count( distinct( id_anagrafica ) ), 0 )
                FROM attivita
                WHERE attivita.id_todo = ?
                AND attivita.id_tipologia IN ( 15, 32 )',
                array( array( 's' => $riga['id'] ) )
            );

            $riga['posti_disponibili'] = $riga['numero_alunni'] . ' / ' . $riga['numero_posti'];

            $riga['numero_alunni_in_attesa'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( count( distinct( id_anagrafica ) ), 0 )
                FROM attivita
                WHERE attivita.id_todo = ?
                AND attivita.id_tipologia IN ( 40 )',
                array( array( 's' => $riga['id'] ) )
            );

            $riga['posti_prova'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT metadati.testo 
                    FROM metadati
                    WHERE metadati.id_todo = ? 
                    AND metadati.nome = "posti_prova"',
                array( array( 's' => $riga['id'] ) )
            );

            if( ! empty( $riga['posti_prova'] ) || $riga['id_tipologia'] == 18 ) {
                $riga['se_prova'] = 1;                
            }

            $riga['docenti'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT group_concat( DISTINCT concat( docenti.nome, " ", docenti.cognome ) SEPARATOR ", " ) AS docenti 
                    FROM attivita AS docenze
                        LEFT JOIN anagrafica AS docenti ON docenti.id = docenze.id_anagrafica_programmazione
                    WHERE docenze.id_todo = ? 
                    AND docenze.id_tipologia IN ( 30, 31 )
                    GROUP BY docenze.id_todo ',
                array( array( 's' => $riga['id'] ) )
            );

            $riga['indirizzo'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT concat_ws(
                        " ",
                        indirizzo,
                        indirizzi.civico,
                        indirizzi.cap,
                        indirizzi.localita,
                        comuni.nome,
                        provincie.sigla
                    ) AS indirizzo
                FROM indirizzi
                    LEFT JOIN comuni ON comuni.id = indirizzi.id_comune
                    LEFT JOIN provincie ON provincie.id = comuni.id_provincia
                WHERE indirizzi.id = ?',
                array( array( 's' => $riga['id_indirizzo'] ) )
            );

            $riga['luogo'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT luoghi_path( ? ) AS luogo',
                array( array( 's' => $riga['id_luogo'] ) )
            );















        // ricavo il giorno della settimana in formato numerico
        $riga['id_giorno_programmazione'] = date( 'N', strtotime( $riga['data_programmazione'] ) );

        // tipologie contratti da inserire nel report
        $abbonamentiCompatibili = array();

        // recupero l'elenco degli abbonamenti
        $abbonamenti = mysqlCachedQuery(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT tipologie_contratti.id, tipologie_contratti.nome
                FROM tipologie_contratti
                WHERE tipologie_contratti.se_abbonamento = 1'
        );

        // ciclo sugli abbonamenti
        foreach( $abbonamenti as $abbonamento ) {

            // orari in cui è valido l'abbonamento
            $orari = mysqlCachedQuery(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT orari.*, giorni.nome AS giorno
                    FROM orari 
                    LEFT JOIN giorni ON orari.id_giorno = giorni.id
                    WHERE id_tipologia_contratti = ?',
                array(
                    array( 's' => $abbonamento['id'] )
                )
            );

            // check sugli orari
            if( empty( $orari ) ) {

                $checkOrari = true;

            } else {

                $checkOrari = false;

                // ciclo sugli orari
                foreach( $orari as $orario ) {

                    // check sul giorno
                    if( $orario['id_giorno'] == $riga['id_giorno_programmazione'] ) {

                        // check sull'orario
                        if(
                            $riga['ora_inizio_programmazione'] >= $orario['ora_inizio']
                            &&
                            $riga['ora_fine_programmazione'] <= $orario['ora_fine']
                        ) {

                            $checkOrari = true;

                        } elseif( empty( $orario['ora_inizio'] ) && empty( $orario['ora_fine'] ) ) {

                            $checkOrari = true;

                        }

                    }

                }

            }

            // cerco le discipline associate alla tipologia di abbonamento
            $discipline = mysqlSelectCachedColumn(
                $cf['memcache']['connection'],
                'testo',
                $cf['mysql']['connection'],
                'SELECT testo
                FROM metadati
                WHERE id_tipologia_contratti = ? AND nome = "abbonamento|discipline"',
                array(
                    array( 's' => $abbonamento['id'] )
                )
            );

            // controllo compatibilità discipline
            if( ! empty( $discipline ) ) {

                // controllo compatibilità discipline
                if( in_array( $riga['id_disciplina'], $discipline ) ) {

                    $checkDiscipline = true;

                } else {

                    $checkDiscipline = false;

                }

            } else {

                $checkDiscipline = false;

            }

            // cerco i corsi associati alla tipologia di abbonamento
            $corsi = mysqlSelectCachedColumn(
                $cf['memcache']['connection'],
                'testo',
                $cf['mysql']['connection'],
                'SELECT testo
                FROM metadati
                WHERE id_tipologia_contratti = ? AND nome = "abbonamento|corsi"',
                array(
                    array( 's' => $abbonamento['id'] )
                )
            );

            // controllo compatibilità corsi
            if( ! empty( $corsi ) ) {

                // controllo compatibilità corsi
                if( in_array( $riga['id_progetto'], $corsi ) ) {

                    $checkCorsi = true;

                } else {

                    $checkCorsi = false;

                }

            } else {

                $checkCorsi = false;

            }

            // compatibilità generale
            $checkGlobale = $checkOrari && ( $checkDiscipline || $checkCorsi );

            // aggiunta dell'abbonamento compatibile alla riga
            if( $checkGlobale == true ) {
                $abbonamentiCompatibili[] = $abbonamento['id'];
            }

        }

        // abbonamenti compatibili
        $riga['tipologie_abbonamenti'] = '|' . implode( '|', $abbonamentiCompatibili ) . '|';













/*
            $riga['numero_alunni'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT count( DISTINCT presenze.id_anagrafica_programmazione ) AS numero_alunni 
                    FROM attivita AS presenze 
                    WHERE presenze.id_todo = ? AND presenze.id_tipologia = 15',
                array( array( 's' => $riga['id'] ) )
            );
*/
            // inserisco la riga
            $idLezione = mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                '__report_lezioni_corsi__'
            );

            // ...
            // var_dump( $idLezione );

            // aggiorno le tabelle collegate che possono innescare l'aggiornamento
            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE attivita SET timestamp_aggiornamento = ? WHERE id_todo = ? AND timestamp_aggiornamento IS NULL',
                array(
                    array( 's' => time() ),
                    array( 's' => $idLezione )
                )
            );

        } else {

            mysqlQuery(
                $cf['mysql']['connection'],
                'DELETE FROM __report_lezioni_corsi__ WHERE id = ?',
                array( array( 's' => $idLezione ) )
            );

        }

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function cleanReportLezioniCorsi() {

        global $cf;

        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE __report_lezioni_corsi__ FROM __report_lezioni_corsi__
            LEFT JOIN todo ON todo.id = __report_lezioni_corsi__.id
            WHERE todo.id IS NULL;'
        );

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function updateReportLezioniTipologieAbbonamenti( $idLezione ) {

        // globalizzazione di $cf
        global $cf;

        // debug
        // print_r( $cf['debug'] );
         error_reporting( E_ALL );
         ini_set( 'display_errors', TRUE );

        // log
        logger( 'aggiorno il report della compatibilità fra lezioni e tipologie abbonamenti per la lezione ' . $idLezione, 'details/lezioni/' . $idLezione );

        // dettagli della lezione
        $lezione = mysqlSelectCachedRow(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT todo.id, todo.data_programmazione, todo.ora_inizio_programmazione, todo.ora_fine_programmazione, 
            todo.timestamp_inserimento, todo.timestamp_aggiornamento, todo.id_progetto, progetti_categorie.id_categoria AS id_disciplina
            FROM todo
            LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = todo.id_progetto
            WHERE todo.id = ?',
            array( array( 's' => $idLezione ) )
        );

        // ricavo il giorno della settimana in formato numerico
        $lezione['id_giorno'] = date( 'N', strtotime( $lezione['data_programmazione'] ) );

        // log
        logger( 'dettagli della lezione #' . $idLezione . ': ' . print_r( $lezione, true ), 'details/lezioni/' . $idLezione );

        // righe da inserire nel report
        $righe = array();
        $tipologie = array();

        // recupero l'elenco degli abbonamenti
        $abbonamenti = mysqlCachedQuery(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT tipologie_contratti.id, tipologie_contratti.nome
                FROM tipologie_contratti
                WHERE tipologie_contratti.se_abbonamento = 1'
        );

        // ciclo sugli abbonamenti
        foreach( $abbonamenti as $abbonamento ) {

            // log
            logger( 'verifico la compatibilità fra la lezione ' . $idLezione . ' e l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ')', 'details/lezioni/' . $idLezione );

            // orari in cui è valido l'abbonamento
            $orari = mysqlCachedQuery(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT orari.id_giorno, orari.ora_inizio, orari.ora_fine, giorni.nome AS giorno
                    FROM orari 
                    LEFT JOIN giorni ON orari.id_giorno = giorni.id
                    WHERE id_tipologia_contratti = ?',
                array(
                    array( 's' => $abbonamento['id'] )
                )
            );

            // check sugli orari
            if( empty( $orari ) ) {

                // log
                logger( 'l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ') non ha orari definiti', 'details/lezioni/' . $idLezione );

                // ...
                $checkOrari = true;

            } else {

                // log
                logger( 'l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ') ha orari definiti: ' . print_r( $orari, true ), 'details/lezioni/' . $idLezione );

                // ...
                $checkOrari = false;

                // ciclo sugli orari
                foreach( $orari as $orario ) {

                    // log
                    logger( 'verifico la compatibilità fra la lezione ' . $idLezione . ' e l\'orario ' . $orario['giorno'] . ' ' . ( ( ! empty( $orario['ora_inizio'] ) ) ? $orario['ora_inizio'] : 'inizio giornata' ) . ' - ' . ( ( ! empty( $orario['ora_fine'] ) ) ? $orario['ora_fine'] : 'fine giornata' ), 'details/lezioni/' . $idLezione );

                    // check sul giorno
                    if( $orario['id_giorno'] == $lezione['id_giorno'] ) {

                        // log
                        logger( 'il giorno ' . $orario['giorno'] . ' è compatibile con il giorno della lezione ' . $lezione['id_giorno'], 'details/lezioni/' . $idLezione );

                        // check sull'orario
                        if( 
                            ( $lezione['ora_inizio_programmazione'] > $orario['ora_inizio'] 
                            ||
                            empty( $orario['ora_inizio'] ) )
                            && 
                            ( $lezione['ora_fine_programmazione'] < $orario['ora_fine'] 
                            ||
                            empty( $orario['ora_fine'] ) )
                        ) {

                            // log
                            logger( 'l\'orario ' . $lezione['ora_inizio_programmazione'] . ' - ' . $lezione['ora_fine_programmazione'] . ' è compatibile con l\'orario ' . ( ( ! empty( $orario['ora_inizio'] ) ) ? $orario['ora_inizio'] : 'inizio giornata' ) . ' - ' . ( ( ! empty( $orario['ora_fine'] ) ) ? $orario['ora_fine'] : 'fine giornata' ), 'details/lezioni/' . $idLezione );

                            // ...
                            $checkOrari = true;

                        }

                    }

                }

            }

            // log
            logger( '-> esito del check orari: ' . ( ( $checkOrari == true ) ? 'ok' : 'ko' ), 'details/lezioni/' . $idLezione );

            // cerco le discipline associate alla tipologia di abbonamento
            $discipline = mysqlSelectCachedColumn(
                $cf['memcache']['connection'],
                'testo',
                $cf['mysql']['connection'],
                'SELECT testo
                FROM metadati
                WHERE id_tipologia_contratti = ? AND nome = "abbonamento|discipline"',
                array(
                    array( 's' => $abbonamento['id'] )
                )
            );

            // controllo compatibilità discipline
            if( ! empty( $discipline ) ) {

                // log
                logger( 'l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ') ha discipline associate: ' . implode( ', ', $discipline ), 'details/lezioni/' . $idLezione );

                // controllo compatibilità discipline
                if( in_array( $lezione['id_disciplina'], $discipline ) ) {

                    // log
                    logger( 'la disciplina ' . $lezione['id_disciplina'] . ' è compatibile con l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ')', 'details/lezioni/' . $idLezione );

                    // ...
                    $checkDiscipline = true;

                } else {

                    // log
                    logger( 'la disciplina ' . $lezione['id_disciplina'] . ' non è compatibile con l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ')', 'details/lezioni/' . $idLezione );

                    // ...
                    $checkDiscipline = false;

                }

            } else {

                // log
                logger( 'l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ') non ha discipline associate', 'details/lezioni/' . $idLezione );

                // ...
                $checkDiscipline = false;

            }

            // log
            logger( '-> esito del check discipline: ' . ( ( $checkDiscipline == true ) ? 'ok' : 'ko' ), 'details/lezioni/' . $idLezione );

            // cerco i corsi associati alla tipologia di abbonamento
            $corsi = mysqlSelectCachedColumn(
                $cf['memcache']['connection'],
                'testo',
                $cf['mysql']['connection'],
                'SELECT testo
                FROM metadati
                WHERE id_tipologia_contratti = ? AND nome = "abbonamento|corsi"',
                array(
                    array( 's' => $abbonamento['id'] )
                )
            );

            // controllo compatibilità corsi
            if( ! empty( $corsi ) ) {

                // log
                logger( 'l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ') ha corsi associati: ' . implode( ', ', $corsi ), 'details/lezioni/' . $idLezione );

                // controllo compatibilità corsi
                if( in_array( $lezione['id_progetto'], $corsi ) ) {

                    // log
                    logger( 'il corso ' . $lezione['id_progetto'] . ' è compatibile con l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ')', 'details/lezioni/' . $idLezione );

                    // ...
                    $checkCorsi = true;

                } else {

                    // log
                    logger( 'il corso ' . $lezione['id_progetto'] . ' non è compatibile con l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ')', 'details/lezioni/' . $idLezione );

                    // ...
                    $checkCorsi = false;

                }

            } else {

                // log
                logger( 'l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . ') non ha corsi associati', 'details/lezioni/' . $idLezione );

                // ...
                $checkCorsi = false;

            }

            // log
            logger( '-> esito del check corsi: ' . ( ( $checkCorsi == true ) ? 'ok' : 'ko' ), 'details/lezioni/' . $idLezione );

            // compatibilità generale
            $checkGlobale = $checkOrari && ( $checkDiscipline || $checkCorsi );

            // log
            logger( '-> esito del check globale: ' . ( ( $checkGlobale == true ) ? 'ok' : 'ko' ) . ' (check orari: ' . ( ( $checkOrari == true ) ? 'ok' : 'ko' ) . ', check discipline: ' . ( ( $checkDiscipline == true ) ? 'ok' : 'ko' ) . ', check corsi: ' . ( ( $checkCorsi == true ) ? 'ok' : 'ko' ) . ')', 'details/lezioni/' . $idLezione );

            // log
            logger( 'la lezione ' . $idLezione . ' è ' . ( ( $checkGlobale == true ) ? 'compatibile' : 'incompatibile' ) . ' con l\'abbonamento ' . $abbonamento['nome'] . ' (' . $abbonamento['id'] . '), check orari: ' . ( ( $checkOrari == true ) ? 'ok' : 'ko' ) . ', check discipline: ' . ( ( $checkDiscipline == true ) ? 'ok' : 'ko' ) . ', check corsi: ' . ( ( $checkCorsi == true ) ? 'ok' : 'ko' ), 'lezioni' );

            // composizione della riga di report
            $righe[] = array(
                'id_todo' => $idLezione,
                'id_tipologia_contratti' => $abbonamento['id'],
                'se_compatibile' => ( ( $checkGlobale == true ) ? 1 : 0 ),
                'timestamp_inserimento' => $lezione['timestamp_inserimento'],
                'timestamp_aggiornamento' => $lezione['timestamp_aggiornamento']
            );

            // tipologie abbonamenti compatibili
            if( $checkGlobale == true ) {
                $tipologie[] = $abbonamento['id'];
            }

            // log
            logger( '---', 'details/lezioni/' . $idLezione );

        }

        // inserimento delle righe di report
        foreach( $righe as $riga ) {

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                '__report_lezioni_tipologie_abbonamenti__'
            );

        }

        // aggiorno il report lezioni corsi
        mysqlQuery(
            $cf['mysql']['connection'],
            'UPDATE __report_lezioni_corsi__ SET tipologie_abbonamenti = ? WHERE id = ?',
            array(
                array( 's' => '|' . implode( '|', $tipologie ) . '|' ),
                array( 's' => $idLezione )
            )
        );

    }

    /**
     * 
     * 
     * @todo documentare
     * 
     */
    function cleanReportLezioniTipologieAbbonamenti() {

        global $cf;

        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE __report_lezioni_tipologie_abbonamenti__ FROM __report_lezioni_tipologie_abbonamenti__
            LEFT JOIN todo ON todo.id = __report_lezioni_tipologie_abbonamenti__.id
            WHERE todo.id IS NULL;'
        );

    }
