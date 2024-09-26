<?php

    /**
     * libreria di funzioni di supporto per MySQL
     *
     * introduzione
     * ============
     *
     *
     *
     * prepared statements
     * -------------------
     *
     *
     *
     * cache delle query
     * -----------------
     *
     *
     *
     * costanti
     * --------
     *
     *
     *
     * dipendenze
     * ----------
     *
     *
     *
     *
     *
     * @todo raggruppare in una funzione mysqlHandleError() il codice per la gestione degli errori che è duplicato in mysqlQuery() e in mysqlPreparedQuery()
     * @todo documentare
     *
     * @file
     *
     */

    /**
     *
     * @todo documentare
     *
    function calcolaPrezzoNettoArticolo( $m, $c, $a, $l, $r = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // il prodotto dell'articolo
        $p = mysqlSelectCachedValue(
            $m,
            $c,
            'SELECT id_prodotto FROM articoli WHERE id = ?',
            array(
                array( 's' => $a )
            )
        );

        // debug
        // die( 'ID prodotto: ' . $p );

        // calcolo la quantità rilevante
        if( $r !== NULL ) {

            // la quantità del singolo articolo nel carrello
            $q1 = mysqlSelectValue(
                $c,
                'SELECT quantita FROM carrelli_articoli WHERE id_articolo = ? AND id_carrello = ?',
                array(
                    array( 's' => $a ),
                    array( 's' => $r )
                )
            );

            // debug
            // die( 'quantità articolo: ' . $q1 );

            // la quantità del prodotto nel carrello
            $q2 = mysqlSelectValue(
                $c,
                'SELECT sum( carrelli_articoli.quantita ) ù
                FROM carrelli_articoli
                INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
                WHERE articoli.id_prodotto = ? AND carrelli_articoli.id_carrello = ?',
                array(
                    array( 's' => $p ),
                    array( 's' => $r )
                )
            );

            // debug
            // die( 'quantità prodotto: ' . $q2 );

            // TODO quantità per gruppo di prodotti

            // la quantità $q è il valore più alto fra $q1 e $q2
            $q = max( $q1, $q2 );

        } else {

            $q = 1;

        }

        // debug
        // die( 'quantità: ' . $q );

        // calcolo la chiave della query
        $k = md5( PRICES_DATA . $a . $l . $q );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // trovo il prezzo per l'articolo
            $p1 = mysqlSelectCachedValue( $m, $c,
                'SELECT prezzo 
                FROM prezzi 
                WHERE id_articolo = ? 
                AND id_listino = ?
                AND ( qta_min IS NULL OR qta_min <= ? )
                AND data_inizio <= NOW() OR data_inizio IS NULL',
                array(
                    array( 's' => $a ),
                    array( 's' => $l ),
                    array( 's' => $q )
                )
            );

            // debug
            // die( 'prezzo articolo: ' . $p1 );

            // trovo il prezzo per il prodotto
            $p2 = mysqlSelectCachedValue( $m, $c,
                'SELECT prezzo 
                FROM prezzi 
                WHERE id_prodotto = ? 
                AND id_listino = ?
                AND ( qta_min IS NULL OR qta_min <= ? )
                AND data_inizio <= NOW() OR data_inizio IS NULL',
                array(
                    array( 's' => $p ),
                    array( 's' => $l ),
                    array( 's' => $q )
                )
            );

            // debug
            // die( 'prezzo prodotto: ' . $p2 );

            // calcolo le variazioni
            // TODO

            // calcolo il prezzo
            if( ! empty( $p1 ) && $p1 < $p2 ) {
                $r = $p1;
            } elseif( ! empty( $p2 ) ) {
                $r = $p2;
            } else {
                $r = 0.0;
            }

            // salvo il risultato in cache
            memcacheWrite( $m, $k, $r, $t );

        } else {

            // log
            logWrite( 'prezzo di ' . $a . ' letto dalla cache', 'speed' );

        }

        // restituisco il risultato
        return $r;

    }
     */

    /**
     *
     * @todo documentare
     *
    function calcolaPrezzoLordoArticolo( $m, $c, $a, $l, $i, $r = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // il prodotto dell'articolo
        $p = mysqlSelectCachedValue(
            $m,
            $c,
            'SELECT id_prodotto FROM articoli WHERE id = ?',
            array(
                array( 's' => $a )
            )
        );

        // debug
        // die( 'ID prodotto: ' . $p );
        // die( 'ID carrello: ' . $r );

        // calcolo la quantità rilevante
        if( $r !== NULL ) {

            // la quantità del singolo articolo nel carrello
            $q1 = mysqlSelectValue(
                $c,
                'SELECT quantita FROM carrelli_articoli WHERE id_articolo = ? AND id_carrello = ?',
                array(
                    array( 's' => $a ),
                    array( 's' => $r )
                )
            );

            // debug
            // die( 'quantità articolo: ' . $q1 );

            // la quantità del prodotto nel carrello
            $q2 = mysqlSelectValue(
                $c,
                'SELECT sum( carrelli_articoli.quantita )
                FROM carrelli_articoli
                INNER JOIN articoli ON articoli.id = carrelli_articoli.id_articolo
                WHERE articoli.id_prodotto = ? AND carrelli_articoli.id_carrello = ?',
                array(
                    array( 's' => $p ),
                    array( 's' => $r )
                )
            );

            // debug
            // die( 'quantità prodotto: ' . $q2 );

            // TODO quantità per gruppo di prodotti

            // la quantità $q è il valore più alto fra $q1 e $q2
            $q = max( $q1, $q2 );

        } else {

            $q = 1;

        }

        // debug
        // die( 'quantità: ' . $q );

        // calcolo la chiave della query
        $k = md5( PRICES_DATA . $a . $l . $i . $q );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // recupero il prezzo
            $n = calcolaPrezzoNettoArticolo( $m, $c, $a, $l, $r );

            // recupero l'aliquota
            $v = mysqlSelectCachedValue( $m, $c, 'SELECT aliquota FROM iva WHERE id = ?', array( array( 's' => $i ) ) );

            // calcolo il lordo
            $r = $n + ( $n / 100 * $v );

        } else {

            // log
            logWrite( 'prezzo di ' . $a . ' letto dalla cache', 'speed' );

        }

        // restituisco il risultato
        return $r;

    }
     */



    /**
     *
     * @todo documentare
     *
     */
    function calcolaPrezzoNettoArticolo( $m, $c, $a, $l, $qa = 1, $qp = 1, $qb = array(), $date = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // debug
        // die( 'listino: ' . $l );

        // data di riferimento
        $date = empty( $date ) ? date( 'Y-m-d' ) : $date;

        // calcolo la chiave della query
        $k = md5( PRICES_DATA . $a . $l . $qa . $qp . md5( serialize( $qb ) ) . $date );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // il prodotto dell'articolo
            $p = mysqlSelectCachedValue( $m, $c,
                'SELECT id_prodotto FROM articoli WHERE id = ?',
                array(
                    array( 's' => $a )
                )
            );

            // i metadati dell'articolo
            $mt = mysqlSelectCachedRow(
                $m,
                $c,
                'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle FROM articoli AS a
                LEFT JOIN metadati AS m1 ON m1.id_articolo = a.id AND m1.nome = "conf_udm"
                LEFT JOIN metadati AS m2 ON m2.id_articolo = a.id AND m2.nome = "conf_qta"
                LEFT JOIN metadati AS m3 ON m3.id_articolo = a.id AND m3.nome = "conf_bundle"
                LEFT JOIN metadati AS m4 ON m4.id_articolo = a.id AND m4.nome = "conf_rif_sconto"
                WHERE a.id = ?',
                array(
                    array( 's' => $a )
                )
            );

            // log
            logger( 'metadati per ' . $a . ': ' . print_r( $mt, true ), 'listini' );

            // trovo il prezzo per il prodotto
            $p1 = mysqlSelectCachedValue( $m, $c,
                'SELECT prezzo 
                FROM prezzi 
                WHERE id_prodotto = ? 
                AND id_listino = ?
                AND ( qta_min IS NULL OR qta_min <= ? )
                AND ( data_inizio IS NULL OR data_inizio <= ? )
                ORDER BY data_inizio DESC, qta_min DESC',
                array(
                    array( 's' => $p ),
                    array( 's' => $l ),
                    array( 's' => $qp ),
                    array( 's' => $date )
                )
            );

            // trovo il prezzo per l'articolo
            $p2 = mysqlSelectCachedValue( $m, $c,
                'SELECT prezzo  
                FROM prezzi 
                WHERE id_articolo = ? 
                AND id_listino = ?
                AND ( qta_min IS NULL OR qta_min <= ? )
                AND ( data_inizio IS NULL OR data_inizio <= ? )
                ORDER BY data_inizio DESC, qta_min DESC',
                array(
                    array( 's' => $a ),
                    array( 's' => $l ),
                    array( 's' => $qa ),
                    array( 's' => $date )
                )
            );

            // trovo il prezzo per il bundle
            if( ! empty( $qb ) ) {

                foreach( $qb as $bp => $qbn ) {

                    // i metadati del prodotto
                    $mp = mysqlSelectCachedRow(
                        $m,
                        $c,
                        'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle, m4.testo AS conf_rif_sconto
                        FROM prodotti AS p
                        LEFT JOIN metadati AS m1 ON m1.id_prodotto = p.id AND m1.nome = "conf_udm"
                        LEFT JOIN metadati AS m2 ON m2.id_prodotto = p.id AND m2.nome = "conf_qta"
                        LEFT JOIN metadati AS m3 ON m3.id_prodotto = p.id AND m3.nome = "conf_bundle"
                        LEFT JOIN metadati AS m4 ON m4.id_prodotto = p.id AND m4.nome = "conf_rif_sconto"
                        WHERE p.id = ?',
                        array(
                            array( 's' => $bp )
                        )
                    );

                    // log
                    logger( 'metadati per ' . $bp . ': ' . print_r( $mp, true ), 'listini' );

                    logger( 'calcolo il prezzo per il bundle ' . $bp, 'listini' );

                    // $bp = array_shift( array_keys( $qb ) );
                    // $qbn = array_shift( $qb );
                    $p3r = mysqlSelectCachedValue( $m, $c,
                        'SELECT prezzo  
                        FROM prezzi 
                        WHERE id_prodotto = ?
                        AND prezzo IS NOT NULL 
                        AND id_listino = ?
                        AND ( qta_min IS NULL OR qta_min <= ? )
                        AND ( data_inizio IS NULL OR data_inizio <= ? )
                        ORDER BY data_inizio DESC, qta_min DESC',
                        array(
                            array( 's' => $bp ),
                            array( 's' => $l ),
                            array( 's' => $qbn ),
                            array( 's' => $date )
                        )
                    );

                    $sc1r = mysqlSelectCachedValue( $m, $c,
                        'SELECT sconto_articoli  
                        FROM prezzi 
                        WHERE id_prodotto = ?
                        AND sconto_articoli IS NOT NULL 
                        AND id_listino = ?
                        AND ( qta_min IS NULL OR qta_min <= ? )
                        AND ( data_inizio IS NULL OR data_inizio <= ? )
                        ORDER BY data_inizio DESC, qta_min DESC',
                        array(
                            array( 's' => $bp ),
                            array( 's' => $l ),
                            array( 's' => $qbn ),
                            array( 's' => $date )
                        )
                    );

                    if( ! empty( $p3r ) ) {
                        $p3 = $p3r;
                    }

                    if( ! empty( $sc1r ) ) {
                        $sc1 = $sc1r;
                    }

                    // se è settato un listino di riferimento per lo sconto
                    if( ! empty( $sc1 ) && ! empty( $mp['conf_rif_sconto'] ) ) {

                        // log
                        logger( 'rilevato sconto ' . $sc1 . ', trovo il listino per il codice ' . $mp['conf_rif_sconto'], 'listini' );

                        // ...
                        $idlp = mysqlSelectCachedValue(
                            $m,
                            $c,
                            'SELECT id FROM listini WHERE codice = ?',
                            array(
                                array( 's' => $mp['conf_rif_sconto'] )
                            )
                        );

                        if( ! empty( $idlp ) ) {

                            $mp['conf_rif_sconto'] = $idlp;

                            // log
                            logger( 'per il bundle ' . $bp . ' ho trovato il listino ' . $mp['conf_rif_sconto'], 'listini' );

                        } else {

                            // log
                            logger( 'per il bundle ' . $bp . ' non ho trovato il listino con codice ' . $mp['conf_rif_sconto'], 'listini' );

                        }

                        // trovo il prezzo per l'articolo
                        $p4 = mysqlSelectCachedValue( $m, $c,
                            'SELECT prezzo
                            FROM prezzi 
                            WHERE id_articolo = ? 
                            AND id_listino = ?
                            AND ( qta_min IS NULL OR qta_min <= ? )
                            AND ( data_inizio IS NULL OR data_inizio <= ? )
                            ORDER BY data_inizio DESC, qta_min DESC',
                            array(
                                array( 's' => $a ),
                                array( 's' => $mp['conf_rif_sconto'] ),
                                array( 's' => $qa ),
                                array( 's' => $date )
                            )
                        );

                        // log
                        logger( 'per il bundle ' . $bp . ' ho trovato il prezzo di riferimento ' . $p4, 'listini' );

                    } else {

                        // log
                        logger( 'non è stato rilevato un listino di riferimento per lo sconto', 'listini' );

                    }

                }

            } else {

                $p3 = 0;
                $p4 = 0;
                $qbn = 0;
                $sc1 = 0;

            }

            // trovo lo sconto per il bunlde

            // defailt
            $r = 0;

            // prezzi candidati
            $pcnd = array( $p1, $p2, $p3, $p4 );

            // log
            logger( 'prezzi candidati: ' . print_r( $pcnd, true ), 'listini' );

            // trovo il prezzo
            foreach( $pcnd as $pf ) {
                if( ! empty( $pf ) ) {
                    if( $pf < $r || empty( $r ) ) {
                        $r = $pf;
                    }
                }
            }

            // log
            // logger( 'per ' . $qa . 'x' . $a . ' (' . $qp . ') fra ' . $p1 . ', ' . $p2 . ' e ' . $p3 . ' scelgo ' . $r, 'listini' );
            logger( 'per ' . $a . ' rilevate quantità ' . $qa . ' (articolo), ' . $qp . ' (prodotto) e ' . $qbn . ' (bundle) prezzo ' . $r, 'listini' );

            // se c'è uno sconto bundle
            if( ! empty( $sc1 ) ) {

                // calcolo lo sconto
                $sc = $r / 100 * $sc1;

                // applico lo sconto
                $r = $r - $sc;

                // log
                logger( 'per ' . $a . ' ho applicato uno sconto di ' . $sc . ' nuovo prezzo ' . $r . ' (bundle)', 'listini' );

            }

            // calcolo le variazioni
            // TODO

            // salvo il risultato in cache
            memcacheWrite( $m, $k, $r, $t );

        } else {

            // log
            logger( 'per ' . $a . ' (' . $qp . ') ho recuperato dalla cache il prezzo ' . $r, 'listini' );

        }

        // restituisco il risultato
        return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function calcolaPrezzoLordoArticolo( $m, $c, $a, $l, $i, $qa = 1, $qp = 1, $qb = array(), $date = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // debug
        // die( 'listino: ' . $l . ' aliquota: ' . $i );

        // data di riferimento
        $date = empty( $date ) ? date( 'Y-m-d' ) : $date;

        // calcolo la chiave della query
        $k = md5( PRICES_DATA . 'L' . $a . $l . $i . $qa . $qp . md5( serialize( $qb ) ) . $date );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // il prodotto dell'articolo
            $p = mysqlSelectCachedValue( $m, $c,
                'SELECT id_prodotto FROM articoli WHERE id = ?',
                array(
                    array( 's' => $a )
                )
            );

            // i metadati dell'articolo
            $mt = mysqlSelectCachedRow(
                $m,
                $c,
                'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle FROM articoli AS a
                LEFT JOIN metadati AS m1 ON m1.id_articolo = a.id AND m1.nome = "conf_udm"
                LEFT JOIN metadati AS m2 ON m2.id_articolo = a.id AND m2.nome = "conf_qta"
                LEFT JOIN metadati AS m3 ON m3.id_articolo = a.id AND m3.nome = "conf_bundle"
                LEFT JOIN metadati AS m4 ON m4.id_articolo = a.id AND m4.nome = "conf_rif_sconto"
                WHERE a.id = ?',
                array(
                    array( 's' => $a )
                )
            );

            // log
            logger( 'metadati per ' . $a . ': ' . print_r( $mt, true ), 'listini' );

            // trovo il prezzo per il prodotto
            $p1 = mysqlSelectCachedRow( $m, $c,
                'SELECT prezzo, id_iva 
                FROM prezzi 
                WHERE id_prodotto = ? 
                AND id_listino = ?
                AND ( qta_min IS NULL OR qta_min <= ? )
                AND ( data_inizio IS NULL OR data_inizio <= ? )
                ORDER BY data_inizio DESC, qta_min DESC',
                array(
                    array( 's' => $p ),
                    array( 's' => $l ),
                    array( 's' => $qp ),
                    array( 's' => $date )
                )
            );

            // trovo il prezzo per l'articolo
            $p2 = mysqlSelectCachedRow( $m, $c,
                'SELECT prezzo, id_iva  
                FROM prezzi 
                WHERE id_articolo = ? 
                AND id_listino = ?
                AND ( qta_min IS NULL OR qta_min <= ? )
                AND ( data_inizio IS NULL OR data_inizio <= ? )
                ORDER BY data_inizio DESC, qta_min DESC',
                array(
                    array( 's' => $a ),
                    array( 's' => $l ),
                    array( 's' => $qa ),
                    array( 's' => $date )
                )
            );

            // trovo il prezzo per il bundle
            if( ! empty( $qb ) ) {

                foreach( $qb as $bp => $qbn ) {

                    // i metadati del prodotto
                    $mp = mysqlSelectCachedRow(
                        $m,
                        $c,
                        'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle, m4.testo AS conf_rif_sconto
                        FROM prodotti AS p
                        LEFT JOIN metadati AS m1 ON m1.id_prodotto = p.id AND m1.nome = "conf_udm"
                        LEFT JOIN metadati AS m2 ON m2.id_prodotto = p.id AND m2.nome = "conf_qta"
                        LEFT JOIN metadati AS m3 ON m3.id_prodotto = p.id AND m3.nome = "conf_bundle"
                        LEFT JOIN metadati AS m4 ON m4.id_prodotto = p.id AND m4.nome = "conf_rif_sconto"
                        WHERE p.id = ?',
                        array(
                            array( 's' => $bp )
                        )
                    );

                    // log
                    logger( 'metadati per ' . $bp . ': ' . print_r( $mp, true ), 'listini' );

                    logger( 'calcolo il prezzo per il bundle ' . $bp, 'listini' );

                    // $bp = array_shift( array_keys( $qb ) );
                    // $qbn = array_shift( $qb );
                    $p3r = mysqlSelectCachedRow( $m, $c,
                        'SELECT prezzo, id_iva  
                        FROM prezzi 
                        WHERE id_prodotto = ?
                        AND prezzo IS NOT NULL 
                        AND id_listino = ?
                        AND ( qta_min IS NULL OR qta_min <= ? )
                        AND ( data_inizio IS NULL OR data_inizio <= ? )
                        ORDER BY data_inizio DESC, qta_min DESC',
                        array(
                            array( 's' => $bp ),
                            array( 's' => $l ),
                            array( 's' => $qbn ),
                            array( 's' => $date )
                        )
                    );

                    if( ! empty( $p3r ) ) {
                        $p3 = $p3r;
                    }

                    $sc1r = mysqlSelectCachedValue( $m, $c,
                        'SELECT sconto_articoli  
                        FROM prezzi 
                        WHERE id_prodotto = ?
                        AND sconto_articoli IS NOT NULL 
                        AND id_listino = ?
                        AND ( qta_min IS NULL OR qta_min <= ? )
                        AND ( data_inizio IS NULL OR data_inizio <= ? )
                        ORDER BY data_inizio DESC, qta_min DESC',
                        array(
                            array( 's' => $bp ),
                            array( 's' => $l ),
                            array( 's' => $qbn ),
                            array( 's' => $date )
                        )
                    );

                    if( ! empty( $p3r ) ) {
                        $p3 = $p3r;
                    }

                    if( ! empty( $sc1r ) ) {
                        $sc1 = $sc1r;
                    }

                    // se è settato un listino di riferimento per lo sconto
                    if( ! empty( $sc1 ) && ! empty( $mp['conf_rif_sconto'] ) ) {

                        // log
                        logger( 'rilevato sconto ' . $sc1 . ', trovo il listino per il codice ' . $mp['conf_rif_sconto'], 'listini' );

                        // ...
                        $idlp = mysqlSelectCachedValue(
                            $m,
                            $c,
                            'SELECT id FROM listini WHERE codice = ?',
                            array(
                                array( 's' => $mp['conf_rif_sconto'] )
                            )
                        );

                        if( ! empty( $idlp ) ) {

                            $mp['conf_rif_sconto'] = $idlp;

                            // log
                            logger( 'per il bundle ' . $bp . ' ho trovato il listino ' . $mp['conf_rif_sconto'], 'listini' );

                        } else {

                            // log
                            logger( 'per il bundle ' . $bp . ' non ho trovato il listino con codice ' . $mp['conf_rif_sconto'], 'listini' );

                        }

                        // trovo il prezzo per l'articolo
                        $p4 = mysqlSelectCachedRow( $m, $c,
                            'SELECT prezzo, id_iva  
                            FROM prezzi 
                            WHERE id_articolo = ? 
                            AND id_listino = ?
                            AND ( qta_min IS NULL OR qta_min <= ? )
                            AND ( data_inizio IS NULL OR data_inizio <= ? )
                            ORDER BY data_inizio DESC, qta_min DESC',
                            array(
                                array( 's' => $a ),
                                array( 's' => $mp['conf_rif_sconto'] ),
                                array( 's' => $qa ),
                                array( 's' => $date )
                            )
                        );

                        // log
                        logger( 'per il bundle ' . $bp . ' ho trovato il prezzo di riferimento ' . $p4['prezzo'], 'listini' );

                    } else {

                        // log
                        logger( 'non è stato rilevato un listino di riferimento per lo sconto', 'listini' );

                    }

                }

            } else {

                $p3 = 0;
                $p4 = 0;
                $qbn = 0;
                $sc1 = 0;

            }

            // debug
            // var_dump( $qb );

            // defailt
            $r = 0;
            $i = 0;

            // prezzi candidati
            $pcnd = array( $p1['prezzo'] => $p1['id_iva'], $p2['prezzo'] => $p2['id_iva'], $p3['prezzo'] => $p3['id_iva'], $p4['prezzo'] => $p4['id_iva'] );

            // log
            logger( 'prezzi candidati: ' . print_r( $pcnd, true ), 'listini' );

            // trovo il prezzo
            foreach( $pcnd as $pf => $pi ) {
                if( ! empty( $pf ) ) {
                    if( $pf < $r || empty( $r ) ) {
                        $r = $pf;
                        $i = $pi;
                    }
                }
            }

            // log
            // logger( 'per ' . $qa . 'x' . $a . ' (' . $qp . ') fra ' . $p1 . ', ' . $p2 . ' e ' . $p3 . ' scelgo ' . $r, 'listini' );
            logger( 'per ' . $a . ' rilevate quantità ' . $qa . ' (articolo), ' . $qp . ' (prodotto) e ' . $qbn . ' (bundle) prezzo ' . $r, 'listini' );

            // se c'è uno sconto bundle
            if( ! empty( $sc1 ) ) {

                // calcolo lo sconto
                $sc = $r / 100 * $sc1;

                // applico lo sconto
                $r = $r - $sc;

                // log
                logger( 'per ' . $a . ' ho applicato uno sconto di ' . $sc . ' nuovo prezzo ' . $r . ' (bundle)', 'listini' );

            }

            // debug
            // die( 'prezzo: ' . $r . ' aliquota: ' . $i );

            // recupero l'aliquota
            $v = mysqlSelectCachedValue( $m, $c, 'SELECT aliquota FROM iva WHERE id = ?', array( array( 's' => $i ) ) );

            // calcolo il lordo
            $r = $r + ( $r / 100 * $v );

            // log
            logger( 'per ' . $a . ' aliquota ' . $i . ' ho calcolato il prezzo lordo ' . $r, 'listini' );

            // log
            // logger( 'per ' . $qa . 'x' . $a . ' (' . $qp . ') fra ' . $p1 . ' e ' . $p2 . ' scelgo ' . $r, 'listini' );

            // calcolo le variazioni
            // TODO

            // salvo il risultato in cache
            memcacheWrite( $m, $k, $r, $t );

        } else {

            // log
            logger( 'per ' . $a . ' (' . $qp . ') ho recuperato dalla cache il prezzo ' . $r, 'listini' );

        }

        // restituisco il risultato
        return $r;

    }
