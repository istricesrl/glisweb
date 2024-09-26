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

        // trovo la quantità dell'articolo
        $qs = contaQuantitaArticoliCarrello( $a, $carrello );

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

        // il prodotto dell'articolo
        $p = mysqlSelectCachedValue(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id_prodotto FROM articoli WHERE id = ?',
            array(
                array( 's' => $a )
            )
        );

        // inizializzo il contatore
        $qa = 0;
        $qp = 0;

        // contatore per i bundle
        $qb = array();

        // ciclo sui prodotti
        foreach( $carrello['articoli'] as $k => $v ) {

            // il prodotto dell'articolo
            $p1 = mysqlSelectCachedValue(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT id_prodotto FROM articoli WHERE id = ?',
                array(
                    array( 's' => $v['id_articolo'] )
                )
            );

            // i metadati dell'articolo
            $mt = mysqlSelectCachedRow(
                $cf['memcache']['connection'],
                $cf['mysql']['connection'],
                'SELECT m1.testo AS conf_udm, m2.testo AS conf_qta, m3.testo AS conf_bundle FROM articoli AS a
                LEFT JOIN metadati AS m1 ON m1.id_articolo = a.id AND m1.nome = "conf_udm"
                LEFT JOIN metadati AS m2 ON m2.id_articolo = a.id AND m2.nome = "conf_qta"
                LEFT JOIN metadati AS m3 ON m3.id_articolo = a.id AND m3.nome = "conf_bundle"
                LEFT JOIN metadati AS m4 ON m4.id_articolo = a.id AND m4.nome = "conf_rif_sconto"
                WHERE a.id = ?',
                array(
                    array( 's' => $v['id_articolo'] )
                )
            );

            // divisori di default
            if( ! empty( $mt['conf_qta'] ) ) {
                $qd = $v['quantita'] / $mt['conf_qta'];
            } else {
                $qd = $v['quantita'];
            }

            // incremento i contatori
            if( $v['id_articolo'] == $a ) {
                $qa += $v['quantita'];
            }
            
            // incremento i contatori
            if( $p1 == $p ) {
                $qp += $v['quantita'];
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

            // ciclo sui bundle
            foreach( $bs as $bd ) {
                // $qb[ $bd ] = ( ( ! isset( $qb[ $bd ] ) ) ? $v['quantita'] : $qb[ $bd ] + $v['quantita'] );
                $qb[ $bd ] = ( ( ! isset( $qb[ $bd ] ) ) ? $qd : $qb[ $bd ] + $qd );
                if( $mt['conf_bundle'] == 'SI' ) {
                    $qa = $qb[ $bd ];
                }
            }

            // log
            logger( 'contaQuantitaArticoliCarrello(): $qa = ' . $qa . ', $qp = ' . $qp . ' ( $a = ' . $a . ', $p = ' . $p . ' )', 'listini' );
            logger( 'contaQuantitaArticoliCarrello(): $qb = ' . print_r( $qb, true ), 'listini' );

        }

        // restituisco il risultato
        return array( $qa, $qp, $qb );

    }
