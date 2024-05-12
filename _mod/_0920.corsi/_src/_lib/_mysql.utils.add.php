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
                progetti.nome AS corso, m1.testo AS se_prenotabile_online, group_concat( DISTINCT if( d.id, categorie_progetti_path( d.id ), null ) SEPARATOR " | " ) AS discipline,
                concat(
                    todo.nome,
                    coalesce( concat( " per ", a2.denominazione, concat( a2.cognome, " ", a2.nome ) ), "" ),
                    coalesce( concat( " su ", todo.id_progetto, " ", progetti.nome ), "" )
                ) AS __label__
            FROM todo
                LEFT JOIN tipologie_todo ON tipologie_todo.id = todo.id_tipologia
                LEFT JOIN anagrafica AS a1 ON a1.id = todo.id_anagrafica
                LEFT JOIN anagrafica AS a2 ON a2.id = todo.id_cliente
                LEFT JOIN progetti ON progetti.id = todo.id_progetto
                LEFT JOIN progetti_categorie ON progetti_categorie.id_progetto = progetti.id
                LEFT JOIN categorie_progetti AS d ON d.id = progetti_categorie.id_categoria AND d.se_disciplina = 1
                LEFT JOIN metadati AS m1 ON m1.id_progetto = progetti.id AND m1.nome = "prenotabile_online"
            WHERE todo.id = ? -- AND todo.id_tipologia IN (14, 15, 18) 
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

