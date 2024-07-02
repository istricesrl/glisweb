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
    function calcolaPrezzoNettoArticolo( $m, $c, $a, $l, $t = MEMCACHE_DEFAULT_TTL ) {

        // calcolo la chiave della query
        $k = md5( PRICES_DATA . $a . $l );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // recupero il prezzo
            $r = mysqlSelectValue(
                $c,
                'SELECT coalesce( p1.prezzo, p2.prezzo, 0.0 ) '.
                'FROM articoli '.
                'LEFT JOIN prezzi AS p1 ON ( p1.id_listino = ? AND p1.id_articolo = articoli.id ) '.
                'LEFT JOIN prezzi AS p2 ON ( p2.id_listino = ? AND p2.id_prodotto = articoli.id_prodotto ) '.
                'WHERE articoli.id = ? ',
                array(
                    array( 's' => $l ),
                    array( 's' => $l ),
                    array( 's' => $a )
                )
            );

            // calcolo le variazioni
            // TODO

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
    function calcolaPrezzoLordoArticolo( $m, $c, $a, $l, $i, $t = MEMCACHE_DEFAULT_TTL ) {

        // calcolo la chiave della query
        $k = md5( PRICES_DATA . $a . $l . $i );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // recupero il prezzo
            $n = calcolaPrezzoNettoArticolo( $m, $c, $a, $l );

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
    function calcolaCostoSpedizioneNettoArticolo( $m, $c, $a, $q, $l, $z, $t = MEMCACHE_DEFAULT_TTL ) {

        // debug
        // die( $q );
        // die( $z );

        // calcolo la chiave della query
        $k = md5( SHIPPING_COST_DATA . $a . $q . $l . $z );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // recupero il prezzo
            $r = mysqlSelectValue(
                $c,
                'SELECT coalesce( modalita_spedizione.importo_netto, 0.0 ) * ceil( ? / modalita_spedizione.lotto_spedizione )
                FROM modalita_spedizione
                WHERE modalita_spedizione.id_articolo = ? AND modalita_spedizione.id_zona = ?',
                array(
                    array( 's' => $q ),
                    array( 's' => $a ),
                    array( 's' => $z )
                )
            );

            // calcolo le variazioni
            // TODO

            // salvo il risultato in cache
            memcacheWrite( $m, $k, $r, $t );

        } else {

            // log
            logWrite( 'prezzo di ' . $a . ' letto dalla cache', 'speed' );

        }

        // restituisco il risultato
        return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function calcolaCostoSpedizioneLordoArticolo( $m, $c, $a, $q, $l, $i, $z, $t = MEMCACHE_DEFAULT_TTL ) {

        // debug
        // die( $z );

        // calcolo la chiave della query
        $k = md5( SHIPPING_COST_DATA . $a . $q . $l . $i . $z );

        // cerco il valore in cache
        $r = memcacheRead( $m, $k );

        // se il valore non è stato trovato
        if( empty( $r ) || $t === false ) {

            // recupero il prezzo
            $n = calcolaCostoSpedizioneNettoArticolo( $m, $c, $a, $q, $l, $z, $t );

            // recupero l'eventuale esenzione
            $ie = mysqlSelectCachedValue( $m, $c,
                'SELECT id_iva FROM modalita_spedizione WHERE id_articolo = ? AND id_zona = ?',
                array( array( 's' => $a ), array( 's' => $z ) )
            );

            // ...
            $i = ( ! empty( $ie ) ) ? $ie : $i;

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
