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
    
            $riga['codice'] = mysqlSelectCachedValue(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT codice FROM mastri WHERE id = ?',
                array(
                    array( 's' => $mastro )
                )
            );

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
                'SELECT coalesce( sum( documenti_articoli.quantita ), 0 ) 
                FROM documenti_articoli 
                WHERE id_articolo = ? 
                AND id_mastro_destinazione = ? '.((!empty($idMatricola))?'
                AND id_matricola = '.$idMatricola:NULL).' 
                GROUP BY documenti_articoli.id_articolo, documenti_articoli.id_matricola',
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
                'SELECT coalesce( sum( documenti_articoli.quantita ), 0 ) 
                FROM documenti_articoli 
                WHERE id_articolo = ? 
                AND id_mastro_provenienza = ? '.((!empty($idMatricola))?'
                AND id_matricola = '.$idMatricola:NULL).' 
                GROUP BY documenti_articoli.id_articolo, documenti_articoli.id_matricola',
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
                AND id_articolo = ? '.( ( ! empty( $idMatricola ) ) ? ' 
                AND id_matricola = ' . $idMatricola : NULL );

                if( ! empty( $riga['totale_figli'] ) ) {
                    $giacenzaFigli = ' (nei figli ' . $riga['totale_figli'] . ')';
                }

            } else {
                $riga['se_foglia'] = 1;
                $riga['totale_figli'] = NULL;
                $riga['note_aggiornamento'] .= 'il magazzino ' . $mastro . ' non ha figli' . PHP_EOL;
                $giacenzaFigli = NULL;
            }

            $riga['totale_proprio'] = $riga['carico'] - $riga['scarico'];
            $riga['totale'] = $riga['carico'] - $riga['scarico'] + $riga['totale_figli'];

            $riga['peso'] = $riga['totale'] * $articolo['peso'];

            $riga['__label__'] = trim(
                ( $riga['categorie'] ?? '' ) . ' ' .
                $riga['articolo'] . ' ' .
                ( ( ! empty( $riga['matricola'] ) ) ? 'matr. ' . $riga['matricola'] . ' ' : NULL ) .
                ( ( ! empty( $riga['data_scadenza'] ) ) ? 'scad. ' . $riga['data_scadenza'] . ' ' : NULL ) .
                'da ' . $riga['nome'] . ' ' .
                'giac. ' . $riga['totale_proprio'] . ' pz.' . $giacenzaFigli
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
                    mastri_path( mastri.id ) AS nome,
                    mastri.codice
                FROM mastri
                WHERE id = ? ',
                array(
                    array( 's' => $riga['id_mastro_provenienza'] )
                )
            );

            if( ! empty( $mastro ) ) {
                $riga['mastro_provenienza'] = $mastro['nome'];
                $riga['codice_mastro_provenienza'] = $mastro['codice'];
            }

        }

        if( ! empty( $riga['id_mastro_destinazione'] ) ) {

            $mastro = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT mastri.id,
                    mastri_path( mastri.id ) AS nome,
                    mastri.codice
                FROM mastri
                WHERE id = ? ',
                array(
                    array( 's' => $riga['id_mastro_destinazione'] )
                )
            );

            if( ! empty( $mastro ) ) {
                $riga['mastro_destinazione'] = $mastro['nome'];
                $riga['codice_mastro_destinazione'] = $mastro['codice'];
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
    function cleanReportMovimentiMagazzini( $id = NULL) {

        global $cf;

        $query = 'DELETE FROM __report_movimenti_magazzini__ ';
        $params = array();

        if( ! empty( $id ) ) {
            $query .= ' WHERE id = ? ';
            $params[] = array( 's' => $id );
        }

        mysqlQuery(
            $cf['mysql']['connection'],
            $query,
            $params
        );

    }

    /**
     * SCORTE MINIME E RIFORNIMENTO DELLE UBICAZIONI ( 17/09/2026 )
     *
     * Le cinque funzioni che seguono sono il motore del sottoscorta: da una soglia dichiarata su
     * mastri_articoli arrivano alla missione di movimentazione che rifornisce l'ubicazione. Le
     * chiama _mod/_0500.mastri/_src/_api/_task/_rifornimenti.da.sottoscorta.php, e la scheda che
     * ne mostra l'esito e' logistica.sottoscorta.view ( modulo _5000.logistica ).
     *
     * Stanno qui e non nel modulo dei documenti perche' interrogano i mastri: giacenze
     * ( __report_giacenza_magazzini__ ), ubicazioni ( mastri, ruoli_mastri ), soglie
     * ( mastri_articoli ), confezionamento ( metadati_articoli ). Di documenti ne scrive una sola,
     * creaMissioneRifornimento, e lo fa in fondo alla catena.
     *
     * Il prefisso di stoccaggio e i mastri esclusi restano parametri, non costanti: la
     * nomenclatura delle ubicazioni e' di progetto, non dello standard. Il prefisso non ha un
     * default: senza prefisso dichiarato il ripiego non privilegia nessuna ubicazione per nome.
     */


    // quante confezioni sono, e se ha senso contarle
    //
    // Alcuni articoli hanno un'unita' di misura inventariale che NON e' il pezzo che si prende
    // in mano: le carte si inventariano a foglio ( umi = FF ), ma in magazzino nessuno prende
    // 500 fogli sciolti - prende 2 pacchi da 250. La quantita' di una riga di documento e'
    // sempre nell'unita' inventariale, quindi per quegli articoli e' un numero di fogli, e
    // contarci sopra pezzi da etichettare o da prelevare da' un numero senza senso.
    //
    // La dichiarazione sta in due metadati dell'articolo, che il progetto popola come vuole ( a
    // mano o dall'import del suo gestionale ): 'um_movimentazione' dice CHE si conta a confezioni
    // e in quale unita', 'conf_qta' QUANTO e' grande la confezione. Servono tutti e due: uno solo
    // non basta e la funzione risponde di no. L'unita' inventariale ( 'umi' ) si legge e si
    // riporta nell'esito, ma non decide niente: conta la dichiarazione, non l'unita'.
    //
    // Il metadato assente e' la norma e non un errore: senza, la risposta e' 'a_confezioni' => false
    // e chi chiama torna a fare quello che faceva prima. Nessuna maschera va scritta come se il
    // dato ci fosse.
    //
    // Il RESTO non e' un caso di scuola ( 25 fogli su una confezione da 100 ): un pacco aperto e'
    // comunque un pacco che sta nel collo, quindi 'confezioni' e' arrotondato per eccesso, e
    // 'intere'/'resto' restano separati per chi volesse dirlo all'operatore.
    //
    // 'um_nome' e 'um_nome_singolare' sono la parola da mostrare all'operatore al posto del codice
    // ( "20 SC" su un tablet non lo legge nessuno ). I codici delle unita' di misura sono quelli
    // del gestionale di ciascun progetto, quindi la decodifica NON sta qui: si dichiara in
    // $cf['mastri']['udm']['parole'], codice => array( singolare, plurale ), di solito nel ramo
    // mastri di src/config.json ( vedi _mod/_0500.mastri/_src/_config/_030.common.php ). Un codice
    // che non c'e' non e' un errore e non interrompe niente: si mostra cosi' com'e'.
    //
    // ATTENZIONE a 'confezioni' contro 'intere': 'confezioni' e' ARROTONDATO PER ECCESSO e serve
    // a contare le etichette ( un pacco aperto e' comunque un pacco che sta nel collo ). Per dire
    // a un operatore che cosa prendere in mano si usa 'intere' piu' il 'resto' in pezzi: su una
    // riga da 10 pezzi con confezione da 100, 'confezioni' vale 1 e scrivere "prendi 1 scatola"
    // gli farebbe portare via una scatola intera invece di 10 pezzi.
    //
    // Ritorna sempre un array, anche per un articolo che non esiste.
    function confezioniArticolo( $conn, $idArticolo, $quantita ) {

        // decodifica delle unita' di misura, dichiarata dal progetto; le chiavi si confrontano in
        // maiuscolo come i codici letti dai metadati
        $parole = array();
        if( ! empty( $GLOBALS['cf']['mastri']['udm']['parole'] ) && is_array( $GLOBALS['cf']['mastri']['udm']['parole'] ) ) {
            foreach( $GLOBALS['cf']['mastri']['udm']['parole'] as $codice => $nomi ) {
                if( is_array( $nomi ) && count( $nomi ) >= 2 ) {
                    $parole[ strtoupper( trim( (string) $codice ) ) ] = array_values( $nomi );
                }
            }
        }

        // i tre metadati in una query sola; max() perche' una riga per nome e' quello che ci si
        // aspetta, ma le due convenzioni di scrittura di metadati_articoli ( id_lingua NULL e
        // id_lingua 1 ) non sono mai state protette dall'indice UNIQUE, e un doppione renderebbe
        // il risultato dipendente dall'ordine di lettura
        $m = mysqlSelectRow(
            $conn,
            'SELECT max( case when nome = "umi" then testo end ) AS umi,
                    max( case when nome = "um_movimentazione" then testo end ) AS um_movimentazione,
                    max( case when nome = "conf_qta" then testo end ) AS conf_qta
                FROM metadati_articoli
                WHERE id_articolo = ? AND nome IN ( "umi", "um_movimentazione", "conf_qta" )',
            array(
                array( 's' => $idArticolo )
            )
        );

        // valori normalizzati
        $umi = ( ! empty( $m['umi'] ) ) ? strtoupper( trim( (string) $m['umi'] ) ) : NULL;
        $mov = ( ! empty( $m['um_movimentazione'] ) ) ? strtoupper( trim( (string) $m['um_movimentazione'] ) ) : NULL;
        $qta = ( isset( $m['conf_qta'] ) ) ? (float) $m['conf_qta'] : 0;

        // esito di partenza: non si conta a confezioni
        $esito = array(
            'a_confezioni' => false,
            'umi' => $umi,
            'um_movimentazione' => $mov,
            'um_nome' => ( ! empty( $mov ) ) ? ( isset( $parole[ $mov ] ) ? $parole[ $mov ][1] : $mov ) : NULL,
            'um_nome_singolare' => ( ! empty( $mov ) ) ? ( isset( $parole[ $mov ] ) ? $parole[ $mov ][0] : $mov ) : NULL,
            // la stessa decodifica sull'unita' INVENTARIALE, quella in cui parla il documento:
            // serve a chiamare per nome il numero che l'operatore batte quando NON conta
            // confezioni ( fogli, chilogrammi, scatole... ) invece del generico "pezzi"
            'umi_nome' => ( ! empty( $umi ) ) ? ( isset( $parole[ $umi ] ) ? $parole[ $umi ][1] : $umi ) : NULL,
            'umi_nome_singolare' => ( ! empty( $umi ) ) ? ( isset( $parole[ $umi ] ) ? $parole[ $umi ][0] : $umi ) : NULL,
            'conf_qta' => ( $qta > 0 ) ? $qta : NULL,
            'confezioni' => 0,
            'intere' => 0,
            'resto' => 0
        );

        // servono tutti e due: la dichiarazione del cliente e una confezione di dimensione
        // utile. L'unita' inventariale si legge e si riporta nell'esito - serve a chi vuole
        // dirlo all'operatore - ma NON decide piu' niente
        if( empty( $mov ) || $qta <= 0 ) {
            return $esito;
        }

        // conteggio
        $q = (float) $quantita;
        $esito['a_confezioni'] = true;
        $esito['intere'] = (int) floor( $q / $qta );
        $esito['resto'] = round( $q - ( $esito['intere'] * $qta ), 5 );
        $esito['confezioni'] = ( $esito['resto'] > 0 ) ? $esito['intere'] + 1 : $esito['intere'];

        return $esito;

    }


    // la quantita' battuta dall'operatore, portata in pezzi
    //
    // Il campo della quantita' nelle maschere di magazzino e' UNO SOLO, e il selettore accanto
    // dice in che unita' e' il numero appena battuto: 'pezzi' ( il comportamento storico ) oppure
    // 'confezioni', cioe' quello che l'operatore prende davvero in mano dove il cliente l'ha
    // dichiarato ( vedi confezioniArticolo() ). Il documento pero' parla SEMPRE in unita'
    // inventariale, quindi la conversione si fa qui, una volta sola e subito dopo aver risolto il
    // codice: tutto quello che viene dopo - le check function, il confronto ordinato/prelevato,
    // la riga scritta - continua a ragionare in pezzi come ha sempre fatto.
    //
    // Un moltiplicatore che arriva dal codice battuto ha la precedenza e SPEGNE il selettore: se
    // l'operatore ha scansionato il barcode di una confezione, il codice porta gia' con se' la
    // propria unita' ( '20' sono 20 confezioni di quel barcode ) e applicare anche conf_qta
    // moltiplicherebbe due volte. Le due conversioni non sono la stessa cosa - una viene dal
    // barcode, l'altra dal metadato conf_qta - e a comandare e' il codice battuto, che e'
    // l'unica cosa che l'operatore ha davvero in mano. Chi risolve il barcode e' il chiamante.
    //
    // E' fail-closed: se si chiede la conversione su un articolo che il cliente non ha
    // dichiarato NON si ripiega sui pezzi. Un 20 preso per 20 pezzi invece che per 20 scatole e'
    // esattamente il difetto che questa funzione esiste per togliere, ed e' muto: si torna NULL
    // e chi chiama lo dice all'operatore.
    function quantitaInPezzi( $conn, $idArticolo, $quantita, $um, $moltiplicatore = 1 ) {

        $m = ( is_numeric( $moltiplicatore ) && $moltiplicatore > 0 ) ? (float) $moltiplicatore : 1;
        $q = (float) $quantita * $m;

        // il numero e' gia' in pezzi: o lo dice il selettore, o lo ha gia' fatto il barcode
        if( $um != 'confezioni' || $m > 1 ) {
            return $q;
        }

        $conf = confezioniArticolo( $conn, $idArticolo, 0 );
        if( empty( $conf['a_confezioni'] ) ) {
            return NULL;
        }

        return round( $q * $conf['conf_qta'], 5 );

    }


    // da dove rifornire un'ubicazione andata sottoscorta
    //
    // La domanda e' quella di collocazioneArticolo() rovesciata: non "dove vado a prendere il
    // pezzo per il cliente", ma "dove sta la scorta con cui riempio l'ubicazione di prelievo".
    // Le fonti sono le stesse due, nello stesso ordine di fiducia, ma la preferenza e' rovesciata:
    //
    //   1. una riga di `mastri_articoli` con ruolo 'stoccaggio' e' una DICHIARAZIONE esplicita
    //      del cliente ( "questo articolo lo tengo in bulk li'" ) e vince su tutto, anche se in
    //      quel momento la giacenza registrata fosse zero: e' anagrafica, non fotografia.
    //
    //   2. altrimenti si guarda dove il pezzo si trova ADESSO ( __report_giacenza_magazzini__ ),
    //      preferendo le aree di stoccaggio - i mastri il cui nome comincia col prefisso
    //      dichiarato dal progetto, che sono il bulk vero del magazzino - e poi qualunque altra
    //      ubicazione con giacenza. Senza prefisso si guarda solo la giacenza.
    //      A parita' di categoria vince la piu' capiente: rifornire dalla catasta piu' grande
    //      e' quello che farebbe l'operatore, e riduce le probabilita' di doverci tornare.
    //
    // Si escludono sempre l'ubicazione da rifornire ( non ci si rifornisce da se' ), le aree di
    // ricevimento e i mastri tecnici di transito: sono zone di passaggio, non scorte, e prelevarci
    // dentro significherebbe rubare merce ancora da smistare.
    //
    // Il ruolo si risolve PER NOME e non per id: ruoli_mastri non ha auto_increment, quindi l'id
    // di 'stoccaggio' puo' essere diverso da ambiente ad ambiente ( vedi la migrazione
    // usr/database/migrazioni/2026090801.mastri.articoli.scorte.sql ).
    //
    // Ritorna array( 'id_mastro', 'codice', 'giacenza' ) oppure NULL se non c'e' da nessuna parte:
    // e' il "se possibile" della richiesta del cliente, e chi chiama ne fa un motivo da mostrare.
    function trovaUbicazioneBulk( $conn, $idArticolo, $idMastroSottoscorta, $esclusi = array(), $prefisso = NULL ) {

        // i mastri da non toccare mai: quello da rifornire piu' quelli di transito
        $esclusi[] = $idMastroSottoscorta;
        $esclusi = array_values( array_unique( array_filter( array_map( 'intval', $esclusi ) ) ) );

        // gli id sono gia' passati da intval(), quindi l'interpolazione e' sicura; non si puo'
        // parametrizzare una IN() di lunghezza variabile con mysqli
        $filtroEsclusi = ( ! empty( $esclusi ) ) ? ' AND mastri.id NOT IN ( ' . implode( ', ', $esclusi ) . ' ) ' : '';

        // 1. la collocazione di stoccaggio dichiarata
        $ris = mysqlSelectRow(
            $conn,
            'SELECT mastri.id AS id_mastro, mastri.codice,
                    coalesce( giacenza.totale_proprio, 0 ) AS giacenza
                FROM mastri_articoli
                INNER JOIN mastri ON mastri.id = mastri_articoli.id_mastro
                INNER JOIN ruoli_mastri ON ruoli_mastri.id = mastri_articoli.id_ruolo
                LEFT JOIN __report_giacenza_magazzini__ AS giacenza
                    ON giacenza.id_mastro = mastri.id AND giacenza.id_articolo = mastri_articoli.id_articolo
                WHERE mastri_articoli.id_articolo = ?
                  AND ruoli_mastri.nome = ?' . $filtroEsclusi . '
                ORDER BY coalesce( giacenza.totale_proprio, 0 ) DESC, mastri.codice ASC
                LIMIT 1',
            array(
                array( 's' => $idArticolo ),
                array( 's' => 'stoccaggio' )
            )
        );

        // 2. ripiego: dove il pezzo si trova adesso, con le aree di stoccaggio davanti a tutto
        if( empty( $ris['id_mastro'] ) ) {
            $ris = mysqlSelectRow(
                $conn,
                'SELECT mastri.id AS id_mastro, mastri.codice,
                        giacenza.totale_proprio AS giacenza
                    FROM __report_giacenza_magazzini__ AS giacenza
                    INNER JOIN mastri ON mastri.id = giacenza.id_mastro
                    WHERE giacenza.id_articolo = ?
                      AND giacenza.totale_proprio > 0' . $filtroEsclusi . '
                    ORDER BY ' . ( ( ! empty( $prefisso ) ) ? '( mastri.nome LIKE ? ) DESC, ' : '' ) . 'giacenza.totale_proprio DESC, mastri.codice ASC
                    LIMIT 1',
                array_merge(
                    array( array( 's' => $idArticolo ) ),
                    ( ! empty( $prefisso ) ) ? array( array( 's' => $prefisso . '%' ) ) : array()
                )
            );
        }

        // ...
        return ( ! empty( $ris['id_mastro'] ) ) ? array(
            'id_mastro' => $ris['id_mastro'],
            'codice' => $ris['codice'],
            'giacenza' => ( ! empty( $ris['giacenza'] ) ) ? $ris['giacenza'] : 0
        ) : NULL;

    }


    /**
     * decide se una riga sotto scorta e' rifornibile, e con quanto
     *
     * Riceve una riga cosi' com'esce dalla scheda sottoscorta ( id_articolo, id_mastro,
     * collocazione, giacenza, scorta_minima e scorta_massima gia' convertite nell'unita'
     * inventariale ) e le aggiunge il verdetto: da dove si riforniva, quanto si puo' chiedere,
     * e se non si puo', perche'.
     *
     * Sta qui e non dentro il task perche' la stessa domanda se la fanno in due: il task
     * pianificato e la generazione a mano dalla scheda. Due copie divergono al primo ritocco,
     * e divergendo darebbero all'operatore due risposte diverse sulla stessa riga.
     *
     * NB: qui si decide solo se la riga E' rifornibile. L'esito definitivo lo scrive la
     * creazione della missione: dire "rifornita" prima di averla creata farebbe apparire
     * righe risolte che non lo sono.
     *
     * @param $conn         connessione MySQL
     * @param $riga         la riga da valutare
     * @param $esclusi      id di mastri da non considerare come bulk
     * @param $prefisso     prefisso delle collocazioni di stoccaggio ( NULL: nessuna preferenza )
     * @return              la riga arricchita
     */
    function valutaRigaRifornimento( $conn, $riga, $esclusi = array(), $prefisso = NULL ) {

        $mancante = ( ! empty( $riga['scorta_massima'] ) ? $riga['scorta_massima'] : $riga['scorta_minima'] ) - $riga['giacenza'];

        $bulk = trovaUbicazioneBulk( $conn, $riga['id_articolo'], $riga['id_mastro'], $esclusi, $prefisso );

        $riga['mancante'] = $mancante;
        $riga['id_mastro_bulk'] = ( ! empty( $bulk['id_mastro'] ) ) ? $bulk['id_mastro'] : NULL;
        $riga['bulk'] = ( ! empty( $bulk['codice'] ) ) ? $bulk['codice'] : NULL;
        $riga['giacenza_bulk'] = ( ! empty( $bulk['giacenza'] ) ) ? $bulk['giacenza'] : 0;
        $riga['quantita_richiesta'] = 0;
        $riga['esito'] = 'non rifornibile';
        $riga['motivo'] = NULL;

        if( empty( $bulk ) ) {

            $riga['motivo'] = 'nessuna ubicazione di stoccaggio con giacenza per questo articolo';

        } elseif( $riga['giacenza_bulk'] <= 0 ) {

            // capita solo con una collocazione di stoccaggio dichiarata ma vuota: la
            // dichiarazione vince sulle giacenze, quindi il bulk c'e' ma non ha nulla
            $riga['motivo'] = 'la collocazione di stoccaggio ' . $riga['bulk'] . ' e\' vuota';

        } else {

            // non si chiede piu' di quello che il bulk ha davvero
            $riga['quantita_richiesta'] = min( $mancante, $riga['giacenza_bulk'] );
            $riga['esito'] = 'rifornibile';

            if( $riga['quantita_richiesta'] < $mancante ) {
                $riga['motivo'] = 'rifornimento parziale: nel bulk ci sono ' . $riga['giacenza_bulk'] . ' pezzi sui ' . $mancante . ' che servono';
            }

        }

        return $riga;

    }


    /**
     * crea una missione di rifornimento verso UNA ubicazione, con le sue righe
     *
     * E' il pezzo che il task pianificato e la generazione a mano dalla scheda sottoscorta
     * fanno identico, ed e' il motivo per cui sta qui: la forma dei documenti di rifornimento
     * ( una richiesta di tipologia 7, una missione di tipologia 36 per destinazione, le righe
     * appese alla richiesta e taggate con la missione, la relazione di ruolo 4 ) e' un modello,
     * non un dettaglio di chi la invoca.
     *
     * Tre cose da NON cambiare senza sapere cosa si tocca:
     *  - UNA MISSIONE PER DESTINAZIONE: la testata porta una sola id_mastro_destinazione, e la
     *    maschera di prelievo legge da li' dove scaricare la merce;
     *  - LE RIGHE NASCONO SENZA MASTRI: su documenti_articoli i due mastri sono un movimento
     *    gia' avvenuto, non un'intenzione, e updateReportGiacenzaMagazzini() li somma senza
     *    guardare tipologia o missione. Scriverli qui sposterebbe la merce sulla carta;
     *  - LA RELAZIONE DI RUOLO 4 E' L'ULTIMO PASSO: e' la condizione con cui si riconosce il
     *    lavoro gia' fatto, quindi se si muore prima, il giro successivo completa.
     *
     * Tutte le INSERT sono IGNORE ( $d = false ): il default di mysqlInsertRow() e' un upsert,
     * che su un codice gia' visto riscriverebbe un documento magari gia' lavorato.
     *
     * @param $conn             connessione MySQL
     * @param $idRichiesta      id del documento di richiesta che raccoglie le righe
     * @param $codiceRichiesta  codice della richiesta, da cui si compone quello della missione
     * @param $magazzino        array con id_anagrafica e id_indirizzo del magazzino emittente
     * @param $idDestinazione   id del mastro da rifornire
     * @param $righe            le righe da mettere in missione, gia' valutate
     * @param $nome             nome del documento; NULL = quello delle missioni automatiche
     * @return                  array( id, codice, righe, errore )
     */
    function creaMissioneRifornimento( $conn, $idRichiesta, $codiceRichiesta, $magazzino, $idDestinazione, $righe, $nome = NULL ) {

        $esito = array( 'id' => NULL, 'codice' => NULL, 'righe' => 0, 'errore' => NULL );

        // il codice porta l'id dell'ubicazione: e' cio' che lo rende deterministico e la
        // missione ritrovabile al rilancio
        $codice = 'M' . $codiceRichiesta . '-' . $idDestinazione;
        $esito['codice'] = $codice;

        // documenti.codice e' char(32): oltre i 32 caratteri MySQL troncherebbe in silenzio, e
        // due missioni diverse collidono sull'indice UNIQUE
        if( strlen( $codice ) > 32 ) {
            $esito['errore'] = 'il codice ' . $codice . ' supera i 32 caratteri';
            return $esito;
        }

        // il bulk e' lo stesso per tutte le righe della stessa destinazione? non
        // necessariamente: articoli diversi possono stare in bulk diversi. Sulla testata si
        // mette la provenienza solo se e' una sola, altrimenti resta NULL e la maschera di
        // prelievo la risolve articolo per articolo dalle giacenze.
        $bulkDistinti = array_unique( array_map( function( $r ) { return $r['id_mastro_bulk']; }, $righe ) );
        $idProvenienza = ( count( $bulkDistinti ) == 1 ) ? reset( $bulkDistinti ) : NULL;

        mysqlInsertRow(
            $conn,
            array(
                'codice' => $codice,
                'id_tipologia' => 36,
                'id_emittente' => $magazzino['id_anagrafica'],
                'id_sede_emittente' => $magazzino['id_indirizzo'],
                'id_mastro_provenienza' => $idProvenienza,
                'id_mastro_destinazione' => $idDestinazione,
                'data' => date( 'Y-m-d' ),
                'nome' => ( ! empty( $nome ) ) ? $nome : 'missione ' . $codice . ' generata automaticamente da sottoscorta',
                'timestamp_inserimento' => time(),
            ),
            'documenti',
            false
        );

        // su duplicato la INSERT IGNORE restituisce insert_id = 0: si rilegge per codice
        $esito['id'] = mysqlSelectValue(
            $conn,
            'SELECT id FROM documenti WHERE codice = ? AND id_tipologia = 36 LIMIT 1',
            array(
                array( 's' => $codice )
            )
        );

        if( empty( $esito['id'] ) ) {
            $esito['errore'] = 'la missione ' . $codice . ' non e\' stata creata ne\' ritrovata';
            return $esito;
        }

        // le righe da prelevare: tipologia 7 e id_genitore NULL perche' e' cosi' che la maschera di
        // prelievo riconosce una riga da evadere; id_documento valorizzato perche' senza
        // documento la stessa maschera non la vedrebbe affatto ( INNER JOIN )
        foreach( $righe as $riga ) {

            mysqlInsertRow(
                $conn,
                array(
                    'id_documento' => $idRichiesta,
                    'id_tipologia' => 7,
                    'id_missione' => $esito['id'],
                    'id_articolo' => $riga['id_articolo'],
                    'nome' => $riga['articolo'],
                    'quantita' => $riga['quantita_richiesta'],
                    'data' => date( 'Y-m-d' ),
                    'timestamp_inserimento' => time(),
                ),
                'documenti_articoli',
                false
            );

            $esito['righe']++;

        }

        // lego la missione alla richiesta, per ultimo
        mysqlInsertRow(
            $conn,
            array(
                'id_documento' => $esito['id'],
                'id_documento_collegato' => $idRichiesta,
                'id_ruolo' => 4
            ),
            'relazioni_documenti',
            false
        );

        return $esito;

    }
