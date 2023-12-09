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
     * 
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

            array_merge(
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

            $riga['carico'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( sum( documenti_articoli.quantita ), 0 ) FROM documenti_articoli WHERE id_articolo = ? AND id_mastro_destinazione = ? GROUP BY documenti_articoli.id_articolo, documenti_articoli.id_matricola',
                array(
                    array( 's' => $idArticolo ),
                    array( 's' => $mastro )
                )
            );

            $riga['scarico'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT coalesce( sum( documenti_articoli.quantita ), 0 ) FROM documenti_articoli WHERE id_articolo = ? AND id_mastro_provenienza = ? GROUP BY documenti_articoli.id_articolo, documenti_articoli.id_matricola',
                array(
                    array( 's' => $idArticolo ),
                    array( 's' => $mastro )
                )
            );

            $magazziniFigli = mysqlSelectCachedColumn(
                $cf['memcache']['connection'],
                'id',
                $cf['mysql']['connection'],
                'SELECT mastri.id FROM mastri WHERE id_genitore = ?',
                array(
                    array( 's' => $mastro )
                )
            );

            $riga['se_foglia'] = ( empty( $magazziniFigli ) ) ? 1 : 0;

            // TODO fare meglio 'sta cosa con tutti i parametri posizionali
            $riga['totale_figli'] = mysqlSelectValue(
                $cf['mysql']['connection'],
                'SELECT sum( totale ) 
                FROM __report_giacenza_magazzini__ 
                WHERE id_mastro IN (' . implode( ',', $magazziniFigli ) . ')
                AND id_articolo = ? '.( ( ! empty( $idMatricola ) ) ? ' AND id_matricola = ' . $idMatricola : NULL ),
                array(
                    array( 's' => $idArticolo )
                )
            );

            $riga['totale'] = $riga['carico'] - $riga['scarico'] + $riga['totale_figli'];

            $riga['peso'] = $riga['totale'] * $articolo['peso'];

            $riga['__label__'] = 
                $riga['categorie'] . ' ' .
                $riga['articolo'] . ' ' .
                ( ( ! empty( $riga['matricola'] ) ) ? 'matr. ' . $riga['matricola'] . ' ' : NULL ) .
                ( ( ! empty( $riga['data_scadenza'] ) ) ? 'scad. ' . $riga['data_scadenza'] . ' ' : NULL ) .
                'da ' . $riga['nome'] . ' ' .
                'giac. ' . $riga['totale'] . ' pz.'
            ;

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
    function updateReportMovimentiMagazzini() {}

    /**
     * 
     * @todo documentare
     * 
     */
    function cleanReportMovimentiMagazzini() {}
