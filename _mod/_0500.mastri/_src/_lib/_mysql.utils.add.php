<?php

    /**
     * 
     * 
     * 
     * 
     * NOTA per sapere se ci sono delle righe di report obsolete usare:
     * 
     * SELECT da.id_articolo, da.id_matricola, da.id_mastro_provenienza, da.id_mastro_destinazione,
     * max( coalesce( da.timestamp_aggiornamento, da.timestamp_inserimento ) ) AS timestamp_ultimo_movimento,
     * rp.id AS id_report, max( rp.timestamp_aggiornamento ) AS timestamp_aggiornamento_report
     * FROM documenti_articoli AS da
     * LEFT JOIN __report_giacenza_magazzini__ AS rp
     * ON rp.id_articolo = da.id_articolo AND ( rp.id_mastro = da.id_mastro_provenienza OR rp.id_mastro = da.id_mastro_destinazione )
     * WHERE coalesce( id_mastro_provenienza, id_mastro_destinazione ) IS NOT NULL
     * GROUP BY da.id_articolo, da.id_matricola, da.id_mastro_provenienza, da.id_mastro_destinazione
     * HAVING timestamp_ultimo_movimento > timestamp_aggiornamento_report OR timestamp_aggiornamento_report IS NULL
     * 
     * 
     * 
     * 
     * 
     * NOTA IMPORTANTE
     * documentare bene questa funzione, aggiungendo tutti i ragionamenti passo passo, perché dovrebbe poi fare da
     * base per la scrittura di altre funzioni simili
     * 
     * NOTA DI FABIO
     * l'ho scritta un mese fa e già non mi ricordo che cazzo fa :-P
     * 
     * 
     * 
     * 
     * @todo documentare
     * 
     */
    function updateReportGiacenzaMagazzini( $idMastro, $idArticolo, $idMatricola = NULL ) {

        global $cf;

        // var_dump( $idMastro );
        // var_dump( $idArticolo );
        // var_dump( $idMatricola );

        $mastri = array();

        do {

            $mastri[] = $idMastro;

            $idMastro = mysqlSelectCachedValue(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT mastri.id_genitore FROM mastri WHERE id = ?',
                array(
                    array( 's' => $idMastro )
                )
            );

        } while( ! empty( $idMastro ) );

        // print_r( $mastri );

        $riga = array();

        if( ! empty( $idMatricola ) ) {
            $matricola = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT
                    matricole.id AS id_matricola,
                    matricole.matricola,
                    matricole.data_scadenza 
                FROM matricole
                WHERE id = ? ',
                array(
                    array( 's' => $idMatricola )
                )
            );

            $riga = array_merge(
                $riga,
                $matricola
            );

        }

        $articolo = mysqlSelectCachedRow(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT articoli.id,
                concat_ws(
                    " ",
                    articoli.id,
                    "/",
                    prodotti.nome,
                    articoli.nome,
                    coalesce(
                        concat(
                            articoli.larghezza, "x", articoli.lunghezza, "x", articoli.altezza,
                            " ",
                            udm_dimensioni.sigla
                        ),
                        concat(
                            articoli.peso,
                            " ",
                            udm_peso.sigla
                        ),
                        concat(
                            articoli.volume,
                            " ",
                            udm_volume.sigla
                        ),
                        concat(
                            articoli.capacita,
                            " ",
                            udm_capacita.sigla
                        ),
                        concat(
                            articoli.durata,
                            " ",
                            udm_durata.sigla
                        ),
                        ""
                    )
                ) AS articolo,
                articoli.id_prodotto AS id_prodotto,
                prodotti.nome AS prodotto,
                prodotti.codice_produttore,
                group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR " | " ) AS categorie,
                articoli.peso,
                udm_peso.sigla AS sigla_udm_peso 
            FROM articoli
                LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
                LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
                LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
                LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
                LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
                LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
                LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
            WHERE articoli.id = ?
            GROUP BY articoli.id
            ',
            array(
                array( 's' => $idArticolo )
            )
        );

        // ...
        // print_r( $articolo, true );
        // die();

        $riga['id_articolo'] = $articolo['id'];
        $riga['articolo'] = $articolo['articolo'];
        $riga['id_prodotto'] = $articolo['id_prodotto'];
        $riga['prodotto'] = $articolo['prodotto'];
        $riga['sigla_udm_peso'] = $articolo['sigla_udm_peso'];
    
        foreach( $mastri as $mastro ) {

            $riga['note_aggiornamento'] = 'aggiornamento automatico giacenza del ' . date('Y-m-d H:i:s') . PHP_EOL;
            $riga['note_aggiornamento'] .= 'mastro ' . $mastro . ' articolo ' . $riga['id_articolo'] . ' matricola ' . $idMatricola . PHP_EOL;
            $riga['note_aggiornamento'] .= 'mastri da aggiornare in quanto genitori ' . implode( ', ', $mastri ) . PHP_EOL;

            $riga['id'] = trim( implode( '|', array( $mastro, $idArticolo, $idMatricola ) ), '|' );

            $riga['id_mastro'] = $mastro;
    
            $riga['nome'] = mysqlSelectCachedValue(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT mastri_path( ? )',
                array(
                    array( 's' => $mastro )
                )
            );

            // TODO fare meglio poi con placeholders
            $riga['carico'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( sum( documenti_articoli.quantita ), 0 ) FROM documenti_articoli WHERE id_articolo = ? AND id_mastro_destinazione = ? '.((!empty($idMatricola))?'AND id_matricola = '.$idMatricola:NULL).' GROUP BY documenti_articoli.id_articolo, documenti_articoli.id_matricola',
                array(
                    array( 's' => $idArticolo ),
                    array( 's' => $mastro )
                )
            );

            if( empty( $riga['carico'] ) ) {
                $riga['carico'] = 0.0;
            }

            // TODO fare meglio poi con placeholders
            $riga['scarico'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( sum( documenti_articoli.quantita ), 0 ) FROM documenti_articoli WHERE id_articolo = ? AND id_mastro_provenienza = ? '.((!empty($idMatricola))?'AND id_matricola = '.$idMatricola:NULL).' GROUP BY documenti_articoli.id_articolo, documenti_articoli.id_matricola',
                array(
                    array( 's' => $idArticolo ),
                    array( 's' => $mastro )
                )
            );

            if( empty( $riga['scarico'] ) ) {
                $riga['scarico'] = 0.0;
            }

            $magazziniFigli = mysqlSelectCachedColumn(
                $cf['memcache']['connection'],
                'id',
                $cf['mysql']['connection'],
                'SELECT mastri.id FROM mastri WHERE id_genitore = ?',
                array(
                    array( 's' => $mastro )
                )
            );

            // TODO fare meglio 'sta cosa con tutti i parametri posizionali
            if( ! empty( $magazziniFigli ) ) {
                $riga['se_foglia'] = 0;
                $riga['totale_figli'] = mysqlSelectValue(
                    $cf['mysql']['connection'],
                    'SELECT sum( coalesce( totale, 0.0 ) ) AS t 
                    FROM __report_giacenza_magazzini__ 
                    WHERE id_mastro IN (' . implode( ',', $magazziniFigli ) . ')
                    AND id_articolo = ? '.( ( ! empty( $idMatricola ) ) ? ' AND id_matricola = ' . $idMatricola : NULL ),
                    array(
                        array( 's' => $idArticolo )
                    )
                );
                $riga['note_aggiornamento'] .= 'il magazzino ' . $mastro . ' ha come figli ' . implode( ', ', $magazziniFigli ) . PHP_EOL;
                $riga['note_aggiornamento'] .= 'totale figli ' . $riga['totale_figli'] . ' per articolo ' . $idArticolo . PHP_EOL;

                $riga['note_aggiornamento'] .= 'SELECT sum( coalesce( totale, 0.0 ) ) AS t 
                FROM __report_giacenza_magazzini__ 
                WHERE id_mastro IN (' . implode( ',', $magazziniFigli ) . ')
                AND id_articolo = ? '.( ( ! empty( $idMatricola ) ) ? ' AND id_matricola = ' . $idMatricola : NULL );


            } else {
                $riga['se_foglia'] = 1;
                $riga['totale_figli'] = 0.0;
                $riga['note_aggiornamento'] .= 'il magazzino ' . $mastro . ' non ha figli' . PHP_EOL;
            }

            $riga['totale'] = $riga['carico'] - $riga['scarico'] + $riga['totale_figli'];

            $riga['peso'] = $riga['totale'] * $articolo['peso'];

            $riga['__label__'] = trim(
                $riga['categorie'] . ' ' .
                $riga['articolo'] . ' ' .
                ( ( ! empty( $riga['matricola'] ) ) ? 'matr. ' . $riga['matricola'] . ' ' : NULL ) .
                ( ( ! empty( $riga['data_scadenza'] ) ) ? 'scad. ' . $riga['data_scadenza'] . ' ' : NULL ) .
                'da ' . $riga['nome'] . ' ' .
                'giac. ' . $riga['totale'] . ' pz.'
            );

            $riga['timestamp_aggiornamento'] = time();

            // print_r( $riga );

            mysqlInsertRow(
                $cf['mysql']['connection'],
                $riga,
                '__report_giacenza_magazzini__'
            );

        }

        // die();

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportGiacenzaMagazzini() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportGiacenzaMagazziniFoglie() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportGiacenzaMagazziniFoglie() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportGiacenzaMagazziniFoglieAttive() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportGiacenzaMagazziniFoglieAttive() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function updateReportMovimentiMagazzini( $idRiga ) {

        global $cf;

        // var_dump( $idRiga );

        $riga = mysqlSelectRow(
            $cf['mysql']['connection'],
            'SELECT id,
                id_documento,
                id_articolo,
                id_matricola,
                quantita,
                id_mastro_provenienza,
                id_mastro_destinazione,
                timestamp_aggiornamento
            FROM documenti_articoli
            WHERE id = ?',
            array(
                array( 's' => $idRiga )
            )
        );

        if( empty( $riga['timestamp_aggiornamento'] ) ) {

            $riga['timestamp_aggiornamento'] = time();

            mysqlQuery(
                $cf['mysql']['connection'],
                'UPDATE documenti_articoli SET timestamp_aggiornamento = ? WHERE id = ?',
                array(
                    array( 's' => $riga['timestamp_aggiornamento'] ),
                    array( 's' => $riga['id'] )
                )
            );

        }

        if( ! empty( $riga['id_articolo'] ) ) {

            $articolo = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT articoli.id,
                    concat_ws(
                        " ",
                        articoli.id,
                        "/",
                        prodotti.nome,
                        articoli.nome,
                        coalesce(
                            concat(
                                articoli.larghezza, "x", articoli.lunghezza, "x", articoli.altezza,
                                " ",
                                udm_dimensioni.sigla
                            ),
                            concat(
                                articoli.peso,
                                " ",
                                udm_peso.sigla
                            ),
                            concat(
                                articoli.volume,
                                " ",
                                udm_volume.sigla
                            ),
                            concat(
                                articoli.capacita,
                                " ",
                                udm_capacita.sigla
                            ),
                            concat(
                                articoli.durata,
                                " ",
                                udm_durata.sigla
                            ),
                            ""
                        )
                    ) AS articolo,
                    articoli.id_prodotto AS id_prodotto,
                    prodotti.nome AS prodotto,
                    prodotti.codice_produttore,
                    group_concat( DISTINCT categorie_prodotti_path( prodotti_categorie.id_categoria ) SEPARATOR " | " ) AS categorie,
                    articoli.peso,
                    udm_peso.sigla AS sigla_udm_peso 
                FROM articoli
                    LEFT JOIN prodotti ON prodotti.id = articoli.id_prodotto
                    LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
                    LEFT JOIN udm AS udm_dimensioni ON udm_dimensioni.id = articoli.id_udm_dimensioni
                    LEFT JOIN udm AS udm_peso ON udm_peso.id = articoli.id_udm_peso
                    LEFT JOIN udm AS udm_volume ON udm_volume.id = articoli.id_udm_volume
                    LEFT JOIN udm AS udm_capacita ON udm_capacita.id = articoli.id_udm_capacita
                    LEFT JOIN udm AS udm_durata ON udm_durata.id = articoli.id_udm_durata
                WHERE articoli.id = ?
                GROUP BY articoli.id
                ',
                array(
                    array( 's' => $riga['id_articolo'] )
                )
            );

            if( ! empty( $articolo ) ) {
                $riga['id_articolo'] = $articolo['id'];
                $riga['articolo'] = $articolo['articolo'];
                $riga['id_prodotto'] = $articolo['id_prodotto'];
                $riga['prodotto'] = $articolo['prodotto'];
                $riga['quantita_movimento'] = $riga['quantita'] * $articolo['peso'];
                $riga['udm_movimento'] = $articolo['sigla_udm_peso'];
            }

        }

        if( ! empty( $riga['id_matricola'] ) ) {

            $matricola = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT
                    matricole.id,
                    matricole.matricola,
                    matricole.data_scadenza 
                FROM matricole
                WHERE id = ? ',
                array(
                    array( 's' => $riga['id_matricola'] )
                )
            );

            if( ! empty( $matricola ) ) {
                $riga['matricola'] = $matricola['matricola'];
                $riga['data_scadenza'] = $matricola['data_scadenza'];
            }

        }

        if( ! empty( $riga['id_mastro_provenienza'] ) ) {

            $mastro = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT mastri.id,
                    mastri_path( mastri.id ) AS nome
                FROM mastri
                WHERE id = ? ',
                array(
                    array( 's' => $riga['id_mastro_provenienza'] )
                )
            );

            if( ! empty( $mastro ) ) {
                $riga['mastro_provenienza'] = $mastro['nome'];
            }

        }

        if( ! empty( $riga['id_mastro_destinazione'] ) ) {

            $mastro = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT mastri.id,
                    mastri_path( mastri.id ) AS nome
                FROM mastri
                WHERE id = ? ',
                array(
                    array( 's' => $riga['id_mastro_destinazione'] )
                )
            );

            if( ! empty( $mastro ) ) {
                $riga['mastro_destinazione'] = $mastro['nome'];
            }

        }

        if( ! empty( $riga['id_documento'] ) ) {

            $documento = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT
                    documenti.numero,
                    documenti.sezionale,
                    documenti.data,
                    documenti.id_tipologia,
                    tipologie_documenti.sigla AS sigla_tipologia,
                    tipologie_documenti.nome AS tipologia,
                    documenti.nome,
                    documenti.id_emittente,
                    documenti.id_destinatario
                FROM documenti
                LEFT JOIN tipologie_documenti ON tipologie_documenti.id = documenti.id_tipologia
                WHERE documenti.id = ? ',
                array(
                    array( 's' => $riga['id_documento'] )
                )
            );

            if( ! empty( $documento ) ) {

                $riga['data'] = $documento['data'];
                $riga['id_tipologia'] = $documento['id_tipologia'];
                $riga['tipologia'] = $documento['sigla_tipologia'];
                $riga['numero'] = $documento['numero'];
                $riga['sezionale'] = $documento['sezionale'];
                $riga['documento'] = implode(
                    ' ',
                    array(
                        $documento['sigla_tipologia'],
                        $documento['nome'],
                        'n.', $documento['numero'] . '/' . $documento['sezionale'],
                        // 'del', $documento['data']
                    )
                );

                if( ! empty( $documento['id_emittente'] ) ) {
                        
                    $emittente = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT
                            coalesce( anagrafica.denominazione, concat_ws( " ", anagrafica.cognome, anagrafica.nome ) ) AS emittente
                        FROM anagrafica
                        WHERE anagrafica.id = ? ',
                        array(
                            array( 's' => $documento['id_emittente'] )
                        )
                    );

                    if( ! empty( $emittente ) ) {
                        $riga['emittente'] = $emittente;
                    }
                    
                }

                if( ! empty( $documento['id_destinatario'] ) ) {
                        
                    $destinatario = mysqlSelectCachedValue(
                        $cf['memcache']['connection'],
                        $cf['mysql']['connection'],
                        'SELECT
                            coalesce( anagrafica.denominazione, concat_ws( " ", anagrafica.cognome, anagrafica.nome ) ) AS destinatario
                        FROM anagrafica
                        WHERE anagrafica.id = ? ',
                        array(
                            array( 's' => $documento['id_destinatario'] )
                        )
                    );

                    if( ! empty( $destinatario ) ) {
                        $riga['destinatario'] = $destinatario;
                    }
                    
                }

            }

        }

        // debug
        // die( print_r( $riga, true ) );

        mysqlInsertRow(
            $cf['mysql']['connection'],
            $riga,
            '__report_movimenti_magazzini__'
        );

    }

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportMovimentiMagazzini() {}
