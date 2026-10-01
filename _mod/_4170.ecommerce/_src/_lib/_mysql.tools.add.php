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
     * trova la modalità di spedizione che vale per un articolo in una zona
     *
     * Una riga di modalita_spedizione può riguardare un articolo, un prodotto, una categoria di prodotti o tutta la zona
     * ( nessuno dei tre ): vale la più specifica che c'è, nell'ordine articolo, prodotto, categoria del prodotto, zona.
     * Fino al 2026-10-01 si leggevano solo le righe per articolo, e le altre che la maschera permette di scrivere non
     * davano nessun costo.
     *
     * @param  mysqli  $c  connessione
     * @param  integer $a  id dell'articolo
     * @param  integer $z  id della zona
     *
     * @return array       importo_netto, lotto_spedizione e id_iva della riga, o un array vuoto
     */
    function trovaModalitaSpedizioneArticolo( $c, $a, $z ) {

        $r = mysqlSelectRow(
            $c,
            'SELECT modalita_spedizione.importo_netto, modalita_spedizione.lotto_spedizione, modalita_spedizione.id_iva
            FROM modalita_spedizione
            LEFT JOIN articoli ON articoli.id = ?
            WHERE modalita_spedizione.id_zona = ? AND (
                modalita_spedizione.id_articolo = articoli.id
                OR ( modalita_spedizione.id_articolo IS NULL AND modalita_spedizione.id_prodotto = articoli.id_prodotto )
                OR ( modalita_spedizione.id_articolo IS NULL AND modalita_spedizione.id_prodotto IS NULL
                    AND modalita_spedizione.id_categoria_prodotti IN ( SELECT id_categoria FROM prodotti_categorie WHERE id_prodotto = articoli.id_prodotto ) )
                OR ( modalita_spedizione.id_articolo IS NULL AND modalita_spedizione.id_prodotto IS NULL AND modalita_spedizione.id_categoria_prodotti IS NULL )
            )
            ORDER BY ( modalita_spedizione.id_articolo IS NULL ), ( modalita_spedizione.id_prodotto IS NULL ),
                ( modalita_spedizione.id_categoria_prodotti IS NULL ), modalita_spedizione.id
            LIMIT 1',
            array(
                array( 's' => $a ),
                array( 's' => $z )
            )
        );

        return ( is_array( $r ) ) ? $r : array();

    }

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

            // recupero il costo: l'importo per ogni lotto di pezzi, e senza lotto una volta sola per la spedizione
            // ( prima un lotto vuoto dava costo zero anche con l'importo indicato )
            $ms = trovaModalitaSpedizioneArticolo( $c, $a, $z );
            if( ! empty( $ms ) && is_numeric( $ms['importo_netto'] ) ) {
                $lotti = ( ! empty( $ms['lotto_spedizione'] ) && $ms['lotto_spedizione'] > 0 ) ? ceil( $q / $ms['lotto_spedizione'] ) : 1;
                $r = $ms['importo_netto'] * $lotti;
            } else {
                $r = 0.0;
            }

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

            // se $n è un numero
            if( is_numeric( $n ) ) {

                // recupero l'eventuale aliquota della modalità di spedizione, la stessa riga che ha dato il costo
                $ms = trovaModalitaSpedizioneArticolo( $c, $a, $z );
                $ie = $ms['id_iva'] ?? NULL;

                // ...
                $i = ( ! empty( $ie ) ) ? $ie : $i;

                // recupero l'aliquota
                $v = mysqlSelectCachedValue( $m, $c, 'SELECT aliquota FROM iva WHERE id = ?', array( array( 's' => $i ) ) );

                // calcolo il lordo
                $r = $n + ( $n / 100 * $v );

            } else {

                // imposto a zero
                $r = 0.0;

            }

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
    function calcolaValoreCouponPerRiga( $c, $coupon, $id, $limit ) {

        // recupero il valore del coupon, solo se è nella sua finestra di validità
        // ( NULL su timestamp_inizio / timestamp_fine significa nessun limite ): senza questo
        // filtro un coupon scaduto continuava a scontare le righe del carrello
        $r = mysqlSelectValue(
            $c,
            'SELECT coalesce( coupon.sconto_fisso, 0 )
            FROM coupon
            WHERE coupon.id = ?
            AND ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= ? )
            AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= ? )
            LIMIT 1',
            array(
                array( 's' => $coupon ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

        // recupero il totale già usato del coupon
        $t1 = mysqlSelectValue(
            $c,
            'SELECT coalesce( sum( carrelli_articoli.coupon_valore ), 0 ) 
            FROM carrelli_articoli 
            WHERE carrelli_articoli.id_coupon = ? AND carrelli_articoli.id != ?
            GROUP BY carrelli_articoli.id_coupon',
            array(
                array( 's' => $coupon ),
                array( 's' => $id )
            )
        );

        // se $t è vuoto
        $t1 = ( empty( $t1 ) ) ? 0 : $t1;

        // recupero il totale già usato del coupon
        $t2 = mysqlSelectValue(
            $c,
            'SELECT coalesce( sum( pagamenti.coupon_valore ), 0 ) 
            FROM pagamenti 
            WHERE pagamenti.id_coupon = ?
            GROUP BY pagamenti.id_coupon',
            array(
                array( 's' => $coupon )
            )
        );

        // se $t è vuoto
        $t2 = ( empty( $t2 ) ) ? 0 : $t2;

        // calcolo il valore residuo del coupon
        $r = $r - ( $t1 + $t2 );

        // calcolo il valore del coupon
        $r = ( $r > $limit ) ? $limit : $r;

        // debug
        // echo 'coupon: ' . $coupon . ' valore: ' . $r . ' totale: ' . $t . ' limite: ' . $limit . ' riga: ' . $id . '<br />';

        // restituisco il risultato
        return $r;

    }

    /**
     *
     * @todo documentare
     *
     */
    function calcolaValoreCouponPerPagamento( $c, $coupon, $id, $limit ) {

        // recupero il valore del coupon, solo se è nella sua finestra di validità
        // ( NULL su timestamp_inizio / timestamp_fine significa nessun limite )
        $r = mysqlSelectValue(
            $c,
            'SELECT coalesce( coupon.sconto_fisso, 0 )
            FROM coupon
            WHERE coupon.id = ?
            AND ( coupon.timestamp_inizio IS NULL OR coupon.timestamp_inizio <= ? )
            AND ( coupon.timestamp_fine IS NULL OR coupon.timestamp_fine >= ? )
            LIMIT 1',
            array(
                array( 's' => $coupon ),
                array( 's' => time() ),
                array( 's' => time() )
            )
        );

        // recupero il totale già usato del coupon
        $t1 = mysqlSelectValue(
            $c,
            'SELECT coalesce( sum( carrelli_articoli.coupon_valore ), 0 ) 
            FROM carrelli_articoli 
            WHERE carrelli_articoli.id_coupon = ?
            GROUP BY carrelli_articoli.id_coupon',
            array(
                array( 's' => $coupon )
            )
        );

        // se $t è vuoto
        $t1 = ( empty( $t1 ) ) ? 0 : $t1;

        // recupero il totale già usato del coupon
        $t2 = mysqlSelectValue(
            $c,
            'SELECT coalesce( sum( pagamenti.coupon_valore ), 0 ) 
            FROM pagamenti 
            WHERE pagamenti.id_coupon = ? AND pagamenti.id != ?
            GROUP BY pagamenti.id_coupon',
            array(
                array( 's' => $coupon ),
                array( 's' => $id )
            )
        );

        // se $t è vuoto
        $t2 = ( empty( $t2 ) ) ? 0 : $t2;

        // calcolo il valore residuo del coupon
        $r = $r - ( $t1 + $t2 );

        // calcolo il valore del coupon
        $r = ( $r > $limit ) ? $limit : $r;

        // debug
        // echo 'coupon: ' . $coupon . ' valore: ' . $r . ' totale: ' . $t . ' limite: ' . $limit . ' riga: ' . $id . '<br />';

        // restituisco il risultato
        return $r;

    }

    /**
     * costo di spedizione di un ordine
     *
     * Con $cf['ecommerce']['spedizione'] = 'ordine' la spedizione si paga una volta per carrello: vale la riga di
     * modalita_spedizione della zona senza articolo, prodotto né categoria ( la stessa che in modalità 'articolo' fa da
     * ripiego per ogni riga ), senza lotti. L'IVA è quella della riga di modalita_spedizione, o $i se non ce l'ha.
     *
     * @param  mysqli  $c  connessione
     * @param  integer $z  id della zona del carrello
     * @param  integer $i  id dell'IVA di ripiego
     *
     * @return array       netto, lordo e id_iva; netto e lordo a zero se per la zona non c'è un costo
     */
    function calcolaCostoSpedizioneOrdine( $c, $z, $i = NULL ) {

        // la riga generica della zona
        $ms = mysqlSelectRow(
            $c,
            'SELECT importo_netto, id_iva FROM modalita_spedizione
            WHERE id_zona = ? AND id_articolo IS NULL AND id_prodotto IS NULL AND id_categoria_prodotti IS NULL
            ORDER BY id LIMIT 1',
            array(
                array( 's' => $z )
            )
        );

        // senza costo per la zona la spedizione è gratuita
        if( empty( $ms ) || ! is_numeric( $ms['importo_netto'] ) ) {
            return array( 'netto' => 0.0, 'lordo' => 0.0, 'id_iva' => $i );
        }

        // IVA della spedizione
        $iva = ( ! empty( $ms['id_iva'] ) ) ? $ms['id_iva'] : $i;
        $aliquota = ( ! empty( $iva ) ) ? mysqlSelectValue( $c, 'SELECT aliquota FROM iva WHERE id = ?', array( array( 's' => $iva ) ) ) : 0;

        // risultato
        return array(
            'netto' => (float) $ms['importo_netto'],
            'lordo' => round( $ms['importo_netto'] / 100 * ( 100 + (float) $aliquota ), 2 ),
            'id_iva' => $iva
        );

    }

    /**
     * aggiunge a un documento la riga delle spese di spedizione
     *
     * I documenti del checkout scrivono le righe degli articoli senza la spedizione, e la spedizione in una riga a parte,
     * col reparto dell'articolo indicato ( serve per l'aliquota ). Non scrive niente se il lordo è zero.
     *
     * @param  mysqli  $c          connessione
     * @param  integer $d          id del documento
     * @param  float   $netto      importo netto della spedizione
     * @param  float   $lordo      importo lordo della spedizione
     * @param  integer $reparto    id del reparto
     * @param  string  $nome       descrizione della riga
     *
     * @return integer|null        id della riga, NULL se non c'era niente da scrivere
     */
    function aggiungiRigaSpedizioneDocumento( $c, $d, $netto, $lordo, $reparto, $nome = 'spese di spedizione' ) {

        // niente da scrivere
        if( empty( $d ) || empty( $lordo ) || $lordo <= 0 ) {
            return NULL;
        }

        // la riga
        return mysqlInsertRow(
            $c,
            array(
                'id_documento' => $d,
                'nome' => $nome,
                'quantita' => 1,
                'id_udm' => 1,
                'id_reparto' => $reparto,
                'importo_netto_totale' => round( $netto, 5 ),
                'importo_lordo_totale' => round( $lordo, 5 )
            ),
            'documenti_articoli'
        );

    }

    /**
     * spese di spedizione d'ordine di un carrello
     *
     * Legge carrelli.costo_spedizione_netto e costo_spedizione_lordo, che il controller del carrello scrive con la
     * spedizione per ordine ( $cf['ecommerce']['spedizione'] = 'ordine' ); con la spedizione per articolo valgono zero.
     *
     * @param  mysqli  $c  connessione
     * @param  integer $id id del carrello
     *
     * @return array       netto e lordo, a zero se il carrello non ha una spedizione d'ordine
     */
    function trovaCostoSpedizioneCarrello( $c, $id ) {

        $r = mysqlSelectRow(
            $c,
            'SELECT costo_spedizione_netto, costo_spedizione_lordo FROM carrelli WHERE id = ?',
            array(
                array( 's' => $id )
            )
        );

        return array(
            'netto' => (float) ( $r['costo_spedizione_netto'] ?? 0 ),
            'lordo' => (float) ( $r['costo_spedizione_lordo'] ?? 0 )
        );

    }

