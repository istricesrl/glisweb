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
     * @todo documentare
     * 
     */
    function calcolaPrezzoNettoArticoloCarrello( $a, $carrello, $rowKey ) {

        // globalizzazione di $cf
        global $cf;

        // timer
        timerCheck( $cf['speed'], '-> -> inizio calcolo quantità carrello per articolo #' . $a );

        // trovo la quantità dell'articolo
        $qs = contaQuantitaArticoliCarrello( $a, $carrello );

        // timer
        timerCheck( $cf['speed'], '-> -> fine calcolo quantità carrello per articolo #' . $a );

        // calcolo il prezzo netto
        $r = calcolaPrezzoNettoArticolo(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            $a,
            ( ( ! empty( $_SESSION['carrello']['articoli'][ $rowKey ]['id_listino'] ) ) ? $_SESSION['carrello']['articoli'][ $rowKey ]['id_listino'] : $carrello['id_listino'] ),
            $qs[0],
            $qs[1],
            $qs[2],
            ( ( empty( $carrello['timestamp_checkout'] ) ) ? date('Y-m-d') : $carrello['timestamp_checkout'] )
        );

        /* TODO implementare in futuro
        // sconti quantità
        $scQta = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT sconti.* FROM sconti 
            INNER JOIN sconti_articoli ON sconti_articoli.id_sconto = sconti.id 
            LEFT JOIN sconti_listini ON sconti_listini.id_sconto = sconti.id
            WHERE sconti_articoli.id_articolo = ? 
                AND ( sconti_listini.id_listino = ? OR sconti_listini.id_listino IS NULL ) 
                AND ( sconti.timestamp_inizio <= ? OR sconti.timestamp_inizio IS NULL )
                AND ( sconti.timestamp_fine >= ? OR sconti.timestamp_fine IS NULL )',
            array(
                array( 's' => $a ),
                array( 's' => $carrello['id_listino'] ),
                array( 's' => ( ( empty( $carrello['timestamp_checkout'] ) ) ? time() : $carrello['timestamp_checkout'] ) ),
                array( 's' => ( ( empty( $carrello['timestamp_checkout'] ) ) ? time() : $carrello['timestamp_checkout'] ) )
            )
        );

        // debug
        // die( print_r( $scQta, true ) );

        // per ogni sconto quantità, recupero i codici papabili

        // per ogni sconto quantità 

        */

        // debug
        // var_dump( $a );
        // die( print_r( $qs, true ) );

        // restituisco il risultato
        return $r;

    }

    /**
     * @todo documentare
     * 
     */
    function calcolaPrezzoLordoArticoloCarrello( $a, $carrello, $rowKey ) {

        // globalizzazione di $cf
        global $cf;

        // debug
        // die( 'listino: ' . $carrello['id_listino'] );
        // die( 'IVA: ' . $_SESSION['carrello']['articoli'][ $rowKey ]['id_iva'] );

        // trovo la quantità dell'articolo
        $qs = contaQuantitaArticoliCarrello( $a, $carrello );

        // timer
        timerCheck( $cf['speed'], '-> -> fine calcolo quantità carrello per articolo #' . $a );

        // calcolo il prezzo lordo
        $r = calcolaPrezzoLordoArticolo(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            $a,
            ( ( ! empty( $_SESSION['carrello']['articoli'][ $rowKey ]['id_listino'] ) ) ? $_SESSION['carrello']['articoli'][ $rowKey ]['id_listino'] : $carrello['id_listino'] ),
            $_SESSION['carrello']['articoli'][ $rowKey ]['id_iva'],
            $qs[0],
            $qs[1],
            $qs[2],
            ( ( empty( $carrello['timestamp_checkout'] ) ) ? date('Y-m-d') : $carrello['timestamp_checkout'] )
        );

        // restituisco il risultato
        return $r;

    }

    /**
     * @todo documentare
     * 
     */
    function contaQuantitaArticoliCarrello( $a, $carrello ) {

        // globalizzazione di $cf
        global $cf;

        // timer
        timerCheck( $cf['speed'], '-> -> chiamata funzione per calcolo quantità carrello per articolo #' . $a );

        // memcache
        $key = md5( $a . serialize( $carrello ) );
        $conteggi = memcacheRead( $cf['memcache']['connection'], $key );

        // log
        logger( '---', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

        // log
        logger( 'calcolo le quantità per ' . $a . ' nel carrello ' . $carrello['id'], 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

        // ...
        if( empty( $conteggi ) ) {

            // timer
            timerCheck( $cf['speed'], '-> -> inizio calcolo quantità carrello per articolo #' . $a );

            // il prodotto dell'articolo
            $p = mysqlSelectCachedValue(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT id_prodotto FROM articoli WHERE id = ?',
                array(
                    array( 's' => $a )
                )
            );

            // timer
            timerCheck( $cf['speed'], '-> -> fine recupero prodotto base per calcolo quantità carrello per articolo #' . $a );

            // log
            logger( 'il prodotto di ' . $a . ' nel carrello ' . $carrello['id'] . ' è ' . $p, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
            logger( 'inizio ad esaminare gli altri articoli nel carrello... ', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

            // i metadati dell'articolo
            $ma = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle FROM articoli AS a
                LEFT JOIN metadati_articoli AS m1 ON m1.id_articolo = a.id AND m1.nome = "conf_udm"
                LEFT JOIN metadati_articoli AS m2 ON m2.id_articolo = a.id AND m2.nome = "conf_qta"
                LEFT JOIN metadati_articoli AS m3 ON m3.id_articolo = a.id AND m3.nome = "conf_bundle"
                LEFT JOIN metadati_articoli AS m4 ON m4.id_articolo = a.id AND m4.nome = "conf_rif_sconto"
                WHERE a.id = ?',
                array(
                    array( 's' => $a )
                )
            );

            // timer
            timerCheck( $cf['speed'], '-> -> fine recupero metadati per calcolo quantità carrello per articolo #' . $a );

            // inizializzo il contatore
            $qa = 0;
            $qp = 0;

            // contatore per i bundle
            $qb = array();

            // ciclo sui prodotti
            foreach( $carrello['articoli'] as $k => $v ) {

                // log
                logger( '-> analizzo l\'articolo ' . $v['id_articolo'] . ' con quantità ' . $v['quantita'] . ' nel carrello ' . $carrello['id'], 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                // il prodotto dell'articolo
                $p1 = mysqlSelectCachedValue(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT id_prodotto FROM articoli WHERE id = ?',
                    array(
                        array( 's' => $v['id_articolo'] )
                    )
                );

                // timer
                timerCheck( $cf['speed'], '-> -> fine recupero prodotto per calcolo quantità carrello per articolo #' . $v['id_articolo'] );

                // log
                logger( '- il prodotto di ' . $v['id_articolo'] . ' nel carrello ' . $carrello['id'] . ' è ' . $p1, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                // i metadati dell'articolo
                $mt = mysqlSelectCachedRow(
                    $cf['memcache']['connection'],
                    $cf['mysql']['connection'],
                    'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle FROM articoli AS a
                    LEFT JOIN metadati_articoli AS m1 ON m1.id_articolo = a.id AND m1.nome = "conf_udm"
                    LEFT JOIN metadati_articoli AS m2 ON m2.id_articolo = a.id AND m2.nome = "conf_qta"
                    LEFT JOIN metadati_articoli AS m3 ON m3.id_articolo = a.id AND m3.nome = "conf_bundle"
                    LEFT JOIN metadati_articoli AS m4 ON m4.id_articolo = a.id AND m4.nome = "conf_rif_sconto"
                    WHERE a.id = ?',
                    array(
                        array( 's' => $v['id_articolo'] )
                    )
                );

                // timer
                timerCheck( $cf['speed'], '-> -> fine recupero metadati per calcolo quantità carrello per articolo #' . $v['id_articolo'] );

                // log
                // logger( '- i metadati di ' . $v['id_articolo'] . ' nel carrello ' . $carrello['id'] . ' sono ' . print_r( $mt, true ), 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                // divisori di default
                if( ! empty( $mt['conf_qta'] ) && $mt['conf_bundle'] == 'SI' ) {

                    $qd = $v['quantita'] / $mt['conf_qta'];

                    logger( '- dal momento che ' . $v['id_articolo'] . ' ha un divisore di ' . $mt['conf_qta'] . ', la quantità ' . $v['quantita'] . ' viene divisa per ' . $mt['conf_qta'] . ' e diventa ' . $qd, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                } else {

                    $qd = $v['quantita'];

                    logger( '- dal momento che ' . $v['id_articolo'] . ' non ha un divisore, la quantità ' . $v['quantita'] . ' rimane invariata e diventa ' . $qd, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                }

                // incremento i contatori
                if( $v['id_articolo'] == $a ) {

                    logger ( '- incremento la quantità dell\'articolo ' . $v['id_articolo'] . ' nel carrello ' . $carrello['id'] . ' ' . $qa . ' + ' . $v['quantita'], 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                    $qa += $v['quantita'];

                    logger( '- la quantità dell\'articolo ' . $v['id_articolo'] . ' nel carrello ' . $carrello['id'] . ' è ' . $qa, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                }
                
                // incremento i contatori
                if( $p1 == $p ) {

                    $qp += $v['quantita'];

                    logger( '- la quantità del prodotto ' . $p1 . ' nel carrello ' . $carrello['id'] . ' è ' . $qp, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                }

                // trovo i bundle di cui fa parte l'articolo
                $bs = mysqlSelectColumn(
                    'id_prodotto_collegato',
                    $cf['mysql']['connection'],
                    'SELECT id_prodotto_collegato FROM relazioni_articoli WHERE id_articolo = ? AND id_ruolo = 6',
                    array(
                        array( 's' => $a )
                    )
                );

                // debug
                // var_dump( $a );
                // var_dump( $bs );

                // timer
                timerCheck( $cf['speed'], '-> -> fine analisi righe carrello per calcolo quantità carrello per articolo #' . $a );

                // log
                logger( '- l\'articolo ' . $a . ' nel carrello ' . $carrello['id'] . ' è parte dei bundle ' . implode( ', ', $bs ), 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                // ciclo sui bundle
                foreach( $bs as $bd ) {

                    // log
                    logger( '- ' . ( ( ! isset( $qb[ $bd ] ) ) ? 'imposto a ' . $qd . ' la quantità per il bundle ' . $bd : 'aggiungo ' . $qd . ' alla quantità ' . $qb[ $bd ] . ' del bundle ' . $bd ), 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

                    // $qb[ $bd ] = ( ( ! isset( $qb[ $bd ] ) ) ? $v['quantita'] : $qb[ $bd ] + $v['quantita'] );
                    $qb[ $bd ] = ( ( ! isset( $qb[ $bd ] ) ) ? $qd : $qb[ $bd ] + $qd );

                    /*
                    if( $mt['conf_bundle'] == 'SI' ) {
                        logger( '- articolo ' . $a . ' quantità ' . $qa . ' riportata a ' . $qb[ $bd ] . ' per bundle ' . $bd, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
                        $qa = $qb[ $bd ];
                    }
                    */

                }

                // timer
                timerCheck( $cf['speed'], '-> -> fine applicazione quantità bundle per calcolo quantità carrello per articolo #' . $a );

                // log
                logger( '$qa = ' . $qa . ', $qp = ' . $qp . ' ( $a = ' . $a . ', $p = ' . $p . ' )', 'listini' );
                logger( '$qb = ' . print_r( $qb, true ), 'listini' );

            }

            /*
            // log
            logger( 'articolo ' . $a . ' nel carrello ' . $carrello['id'] . ' ha quantità ' . $qa . ' (il prodotto ' . $p . ' ha quantità ' . $qp . ')', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
            foreach( $qb as $k => $v ) {
                logger( 'il bundle ' . $k . ' per il carrello ' . $carrello['id'] . ' ha quantità ' . $v, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
            }
            */

            // ciclo sui bundle
            foreach( $bs as $bd ) {
                if( $ma['conf_bundle'] == 'SI' ) {
                    if( $qb[ $bd ] > 0 ) {
                        logger( 'per l\'articolo ' . $a . ' la quantità ' . $qa . ' è forzata a ' . $qb[ $bd ] . ' per il bundle ' . $bd . ' in quanto ha il flag conf_bundle settato a ' . $ma['conf_bundle'], 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
                        $qa = $qb[ $bd ];
                    } else {
                        logger( 'l\'articolo ' . $a . ' ha settato correttamente il flag conf_bundle (' . $ma['conf_bundle'] . ') ma la quantità di bundle è ' . $qb[ $bd ] . ' per il bundle ' . $bd . ' quindi non effettuo conversione di quantità', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
                    }
                } else {
                    logger( 'l\'articolo ' . $a . ' non ha il flag conf_bundle settato quindi non effettuo conversione di quantità', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
                }
            }

            // memorizzo il risultato
            memcacheWrite( $cf['memcache']['connection'], $key, array( 'qa' => $qa, 'qp' => $qp, 'qb' => $qb ) );

        } else {

            // ...
            $qa = $conteggi['qa'];
            $qp = $conteggi['qp'];
            $qb = $conteggi['qb'];

            // log
            logger( 'recupero le quantità per ' . $a . ' nel carrello ' . $carrello['id'] . ' da cache', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );

        }

        // log
        logger( 'l\'articolo ' . $a . ' nel carrello ' . $carrello['id'] . ' ha quantità ' . $qa . ' (il prodotto ' . $p . ' ha quantità ' . $qp . ')', 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
        foreach( $qb as $k => $v ) {
            logger( 'il bundle ' . $k . ' nel carrello ' . $carrello['id'] . ' ha quantità ' . $v, 'details/carrelli/conteggi/carrello.' . $carrello['id'] . '/articolo.' . $a );
        }

        // restituisco il risultato
        return array( $qa, $qp, $qb );

    }
