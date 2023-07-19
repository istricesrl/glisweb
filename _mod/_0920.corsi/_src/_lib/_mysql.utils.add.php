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
            'SELECT progetti.id, progetti.id_periodo, tipologie_progetti.nome AS tipologia, progetti.nome, progetti.timestamp_aggiornamento, progetti.data_accettazione, progetti.data_chiusura, 
            if(
                progetti.data_accettazione > CURRENT_DATE(), "futuro",
                if( ( progetti.data_chiusura > CURRENT_DATE() OR progetti.data_chiusura IS NULL ), "attivo", "concluso" )
            ) AS stato
            FROM progetti INNER JOIN tipologie_progetti ON tipologie_progetti.id = progetti.id_tipologia 
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
                FROM todo WHERE todo.id_progetto = ? GROUP BY todo.id_progetto',
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

        mysqlQuery(
            $cf['mysql']['connection'],
            'DELETE __report_corsi__ FROM __report_corsi__
            LEFT JOIN progetti ON progetti.id = __report_corsi__.id
            WHERE progetti.id IS NULL;'
        );

    }
