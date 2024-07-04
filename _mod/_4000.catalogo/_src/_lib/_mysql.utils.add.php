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
    function calcolaPrezzoNettoArticoloCarrello( $a, $carrello ) {

        // globalizzazione di $cf
        global $cf;

        // trovo la quantità dell'articolo
        $qs = contaQuantitaArticoliCarrello( $a, $carrello );

        // calcolo il prezzo netto
        $r = calcolaPrezzoNettoArticolo(
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            $a,
            $carrello['id_listino'],
            $qs[0],
            $qs[1],
            ( ( empty( $carrello['timestamp_checkout'] ) ) ? date('Y-m-d') : $carrello['timestamp_checkout'] )
        );

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
            $carrello['id_listino'],
            $_SESSION['carrello']['articoli'][ $rowKey ]['id_iva'],
            $qs[0],
            $qs[1],
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

            // incremento i contatori
            if( $v['id_articolo'] == $a ) {
                $qa += $v['quantita'];
            }
            
            // incremento i contatori
            if( $p1 == $p ) {
                $qp += $v['quantita'];
            }

            // log
            logger( 'contaQuantitaArticoliCarrello(): $qa = ' . $qa . ', $qp = ' . $qp . ' ( $a = ' . $a . ', $p = ' . $p . ' )', 'listini' );

        }

        // restituisco il risultato
        return array( $qa, $qp );

    }
