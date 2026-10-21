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
     */
    function trovaListinoDaCodice( $m, $c, $codice ) {

        return mysqlSelectCachedValue( $m, $c,
            'SELECT id FROM listini WHERE codice = ?',
            array(
                array( 's' => $codice )
            )
        );

    }

    /**
     * risolve un listino passato dall'esterno in un listini.id
     *
     * Accetta sia il codice del listino ( la forma da preferire: è la chiave con cui i gestionali esterni agganciano i
     * listini ) sia l'id numerico, di cui verifica l'esistenza. Restituisce NULL se il valore è vuoto ( nessun filtro ) e
     * false se non corrisponde a nessun listino: il chiamante lo tratta come un errore, non come "nessun prezzo", perché
     * un id di un altro sistema scambiato per listini.id darebbe i prezzi di un altro listino senza alcun segnale.
     * Portata nello standard dal progetto berni il 2026-10-01.
     *
     * @param  object  $m  la connessione a memcache
     * @param  object  $c  la connessione al database
     * @param  mixed   $v  il codice o l'id del listino
     *
     * @return mixed       l'id del listino, NULL se $v è vuoto, false se non si risolve
     */
    function risolviListino( $m, $c, $v ) {

        // nessun filtro
        if( ! isset( $v ) || trim( (string) $v ) === '' ) {
            return NULL;
        }

        // id numerico, se esiste
        $v = trim( (string) $v );
        if( is_numeric( $v ) ) {
            $id = mysqlSelectCachedValue( $m, $c, 'SELECT id FROM listini WHERE id = ?', array( array( 's' => (int) $v ) ) );
            return ( empty( $id ) ) ? false : (int) $id;
        }

        // codice
        $id = trovaListinoDaCodice( $m, $c, $v );
        return ( empty( $id ) ) ? false : (int) $id;

    }

    /**
     * trova la riga di prezzi valida per un articolo o un prodotto
     *
     * È la query unica del motore prezzi: la riga del listino $l per l'articolo o il prodotto, valida alla data
     * ( giorno di inizio e giorno di fine compresi ) e per la quantità ( qta_min e qta_max compresi ), la più recente e
     * la più specifica ( ORDER BY data_inizio DESC, qta_min DESC ). $tipo dice quale riga serve: 'prezzo' una riga con
     * un prezzo, 'sconto' una riga con sconto_articoli, 'provvigione' una riga con una provvigione; così una riga sconto
     * più recente non nasconde il prezzo, e viceversa.
     *
     * @param  object  $m     la connessione a memcache
     * @param  object  $c     la connessione al database
     * @param  string  $campo 'id_articolo' o 'id_prodotto'
     * @param  mixed   $id    l'id dell'articolo o del prodotto
     * @param  mixed   $l     l'id del listino
     * @param  float   $q     la quantità
     * @param  string  $date  la data, Y-m-d
     * @param  string  $tipo  'prezzo', 'sconto' o 'provvigione'
     *
     * @return array          prezzo, id_iva, sconto_articoli e provvigione_percentuale della riga, o un array vuoto
     */
    function trovaRigaPrezzo( $m, $c, $campo, $id, $l, $q, $date, $tipo = 'prezzo' ) {

        // il campo che la riga deve avere
        $condizioni = array( 'prezzo' => 'prezzo IS NOT NULL', 'sconto' => 'sconto_articoli IS NOT NULL', 'provvigione' => 'provvigione_percentuale IS NOT NULL' );

        // senza articolo o listino non c'è riga
        if( empty( $id ) || empty( $l ) || ! isset( $condizioni[ $tipo ] ) || ! in_array( $campo, array( 'id_articolo', 'id_prodotto' ) ) ) {
            return array();
        }

        $r = mysqlSelectCachedRow( $m, $c,
            'SELECT prezzo, id_iva, sconto_articoli, provvigione_percentuale
            FROM prezzi
            WHERE ' . $campo . ' = ?
            AND id_listino = ?
            AND ' . $condizioni[ $tipo ] . '
            AND ( qta_min IS NULL OR qta_min <= ? )
            AND ( qta_max IS NULL OR qta_max >= ? )
            AND ( data_inizio IS NULL OR data_inizio <= ? )
            AND ( data_fine IS NULL OR data_fine >= ? )
            ORDER BY data_inizio DESC, qta_min DESC
            LIMIT 1',
            array(
                array( 's' => $id ),
                array( 's' => $l ),
                array( 's' => $q ),
                array( 's' => $q ),
                array( 's' => $date ),
                array( 's' => $date )
            )
        );

        return ( is_array( $r ) ) ? $r : array();

    }

    /**
     * calcola il prezzo netto di un articolo, con il dettaglio di come ci si è arrivati
     *
     * È il cuore del motore prezzi; calcolaPrezzoNettoArticolo(), calcolaPrezzoLordoArticolo() e il simulatore dei
     * prezzi lo usano tutti, così netto e lordo non possono divergere. I candidati, tutti sul listino $l:
     *
     * - prodotto: il prezzo del prodotto dell'articolo, per la quantità del prodotto $qp;
     * - articolo: il prezzo dell'articolo, per la sua quantità $qa;
     * - paniere e riferimento: per ogni paniere di cui l'articolo fa parte ( $qb, id del prodotto paniere => quantità,
     *   da contaQuantitaArticoliCarrello() ) il prezzo del paniere e il suo sconto_articoli; se c'è lo sconto e il
     *   paniere ha il metadato conf_rif_sconto ( il codice di un listino ), anche il prezzo dell'articolo su quel listino
     *   di riferimento. Fra più panieri vale quello che dà il netto più basso ( prezzo del paniere, o di riferimento,
     *   scontato ); un paniere senza righe non azzera gli altri.
     *
     * Vince il candidato positivo più basso, e lo sconto del paniere scelto si applica al prezzo vincente ( decisione
     * del 01/10/2026: è la regola che i progetti usano in produzione ). Fino al 2026-10-01 il giorno di fine di un prezzo
     * era escluso, una riga sconto più recente nascondeva il prezzo, vinceva l'ultimo paniere del ciclo invece del più
     * conveniente e la query del listino di riferimento falliva sempre per una parentesi in più: le correzioni vengono
     * dal progetto berni.
     *
     * @param  object  $m     la connessione a memcache
     * @param  object  $c     la connessione al database
     * @param  mixed   $a     l'id dell'articolo
     * @param  mixed   $l     l'id del listino
     * @param  float   $qa    la quantità dell'articolo
     * @param  float   $qp    la quantità del prodotto
     * @param  array   $qb    le quantità dei panieri, id del prodotto paniere => quantità
     * @param  mixed   $date  la data, Y-m-d o timestamp ( default oggi )
     *
     * @return array          netto, id_iva della riga vincente, candidato vincente ( prodotto, articolo, paniere,
     *                        riferimento o NULL ), paniere scelto, sconto del paniere, candidati
     */
    function calcolaPrezzoArticolo( $m, $c, $a, $l, $qa = 1, $qp = 1, $qb = array(), $date = NULL ) {

        // data di riferimento
        $date = empty( $date ) ? date( 'Y-m-d' ) : $date;
        $date = is_numeric( $date ) ? date( 'Y-m-d', $date ) : $date;

        // il prodotto dell'articolo
        $p = mysqlSelectCachedValue( $m, $c, 'SELECT id_prodotto FROM articoli WHERE id = ?', array( array( 's' => $a ) ) );

        // candidati
        $cnd = array(
            'prodotto' => trovaRigaPrezzo( $m, $c, 'id_prodotto', $p, $l, $qp, $date ),
            'articolo' => trovaRigaPrezzo( $m, $c, 'id_articolo', $a, $l, $qa, $date ),
            'paniere' => array(),
            'riferimento' => array()
        );

        // il paniere più conveniente
        $bb = NULL;
        foreach( ( is_array( $qb ) ? $qb : array() ) as $bp => $qbn ) {

            // prezzo e sconto del paniere
            $p3 = trovaRigaPrezzo( $m, $c, 'id_prodotto', $bp, $l, $qbn, $date );
            $sc = trovaRigaPrezzo( $m, $c, 'id_prodotto', $bp, $l, $qbn, $date, 'sconto' );
            $sc1 = ( ! empty( $sc['sconto_articoli'] ) ) ? (float) $sc['sconto_articoli'] : 0;

            // prezzo dell'articolo sul listino di riferimento del paniere
            $p4 = array();
            if( ! empty( $sc1 ) ) {
                $rif = mysqlSelectCachedValue( $m, $c,
                    'SELECT testo FROM metadati_prodotti WHERE id_prodotto = ? AND nome = "conf_rif_sconto"',
                    array( array( 's' => $bp ) )
                );
                $idRif = ( ! empty( $rif ) ) ? trovaListinoDaCodice( $m, $c, $rif ) : NULL;
                if( ! empty( $idRif ) ) {
                    $p4 = trovaRigaPrezzo( $m, $c, 'id_articolo', $a, $idRif, $qa, $date );
                } elseif( ! empty( $rif ) ) {
                    logger( 'per il paniere ' . $bp . ' non trovo il listino di riferimento con codice ' . $rif, 'details/listini/prezzi/articolo.' . $a );
                }
            }

            // netto del paniere: il suo prezzo, o il prezzo di riferimento, scontato
            $nb = ( ! empty( $p3['prezzo'] ) && $p3['prezzo'] > 0 ) ? $p3['prezzo'] : ( ( ! empty( $p4['prezzo'] ) && $p4['prezzo'] > 0 ) ? $p4['prezzo'] : 0 );
            $nb = ( ! empty( $nb ) && ! empty( $sc1 ) ) ? ( $nb - ( $nb / 100 * $sc1 ) ) : $nb;

            // tengo il paniere che dà il netto più basso
            if( $nb > 0 && ( empty( $bb ) || $nb < $bb['netto'] ) ) {
                $bb = array( 'netto' => $nb, 'paniere' => $bp, 'p3' => $p3, 'p4' => $p4, 'sc1' => $sc1 );
            }

        }

        // i candidati del paniere scelto
        if( ! empty( $bb ) ) {
            $cnd['paniere'] = $bb['p3'];
            $cnd['riferimento'] = $bb['p4'];
        }

        // vince il prezzo positivo più basso
        $r = array( 'netto' => 0, 'id_iva' => NULL, 'candidato' => NULL, 'paniere' => ( ( ! empty( $bb ) ) ? $bb['paniere'] : NULL ), 'sconto_paniere' => ( ( ! empty( $bb ) ) ? $bb['sc1'] : 0 ), 'candidati' => array() );
        foreach( $cnd as $nome => $riga ) {
            $prezzo = ( ! empty( $riga['prezzo'] ) ) ? (float) $riga['prezzo'] : 0;
            $r['candidati'][ $nome ] = $prezzo;
            if( $prezzo > 0 && ( empty( $r['netto'] ) || $prezzo < $r['netto'] ) ) {
                $r['netto'] = $prezzo;
                $r['id_iva'] = $riga['id_iva'] ?? NULL;
                $r['candidato'] = $nome;
            }
        }

        // lo sconto del paniere si applica al prezzo vincente
        if( ! empty( $r['sconto_paniere'] ) && ! empty( $r['netto'] ) ) {
            $r['netto'] = $r['netto'] - ( $r['netto'] / 100 * $r['sconto_paniere'] );
        }

        // log
        logger( 'articolo ' . $a . ' listino ' . $l . ' quantità ' . $qa . '/' . $qp . ' data ' . $date . ': candidati ' . json_encode( $r['candidati'] ) . ', vince ' . $r['candidato'] . ( ( ! empty( $r['paniere'] ) ) ? ', paniere ' . $r['paniere'] . ' sconto ' . $r['sconto_paniere'] . '%' : '' ) . ', netto ' . $r['netto'], 'details/listini/prezzi/articolo.' . $a );

        return $r;

    }

    /**
     * calcola il prezzo netto unitario di un articolo
     *
     * Restituisce il netto di calcolaPrezzoArticolo(), messo in memcache; con $t === false il calcolo si rifà. Il
     * prefisso della chiave porta la versione del motore ( v2, dal 2026-10-01 ), perché i valori calcolati prima,
     * che non scadono, non vengano più serviti.
     *
     * @param  object  $m     la connessione a memcache
     * @param  object  $c     la connessione al database
     * @param  mixed   $a     l'id dell'articolo
     * @param  mixed   $l     l'id del listino
     * @param  float   $qa    la quantità dell'articolo
     * @param  float   $qp    la quantità del prodotto
     * @param  array   $qb    le quantità dei panieri
     * @param  mixed   $date  la data, Y-m-d o timestamp ( default oggi )
     * @param  mixed   $t     la durata in cache, false per non leggerla
     *
     * @return float          il prezzo netto, 0 se non c'è
     */
    function calcolaPrezzoNettoArticolo( $m, $c, $a, $l, $qa = 1, $qp = 1, $qb = array(), $date = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // data di riferimento
        $date = empty( $date ) ? date( 'Y-m-d' ) : $date;
        $date = is_numeric( $date ) ? date( 'Y-m-d', $date ) : $date;

        // cache
        $k = md5( PRICES_DATA . 'v2' . $a . $l . $qa . $qp . md5( serialize( $qb ) ) . $date );
        $r = ( $t === false ) ? false : memcacheRead( $m, $k );

        // calcolo
        if( empty( $r ) ) {
            $r = calcolaPrezzoArticolo( $m, $c, $a, $l, $qa, $qp, $qb, $date )['netto'];
            if( $t !== false ) {
                memcacheWrite( $m, $k, $r, $t );
            }
        }

        return (float) $r;

    }

    /**
     * calcola il prezzo lordo unitario di un articolo
     *
     * È il netto di calcolaPrezzoArticolo() con l'aliquota della riga di prezzo vincente, o dell'IVA $i se la riga non
     * ce l'ha. Fino al 2026-10-01 il lordo aveva una copia sua del calcolo, che ignorava la data di fine dei prezzi e
     * sceglieva i panieri in un altro modo, e poteva quindi non corrispondere al netto.
     *
     * @param  object  $m     la connessione a memcache
     * @param  object  $c     la connessione al database
     * @param  mixed   $a     l'id dell'articolo
     * @param  mixed   $l     l'id del listino
     * @param  mixed   $i     l'id dell'IVA di ripiego
     * @param  float   $qa    la quantità dell'articolo
     * @param  float   $qp    la quantità del prodotto
     * @param  array   $qb    le quantità dei panieri
     * @param  mixed   $date  la data, Y-m-d o timestamp ( default oggi )
     * @param  mixed   $t     la durata in cache, false per non leggerla
     *
     * @return float          il prezzo lordo, 0 se non c'è
     */
    function calcolaPrezzoLordoArticolo( $m, $c, $a, $l, $i, $qa = 1, $qp = 1, $qb = array(), $date = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // data di riferimento
        $date = empty( $date ) ? date( 'Y-m-d' ) : $date;
        $date = is_numeric( $date ) ? date( 'Y-m-d', $date ) : $date;

        // cache
        $k = md5( PRICES_DATA . 'v2' . 'L' . $a . $l . $i . $qa . $qp . md5( serialize( $qb ) ) . $date );
        $r = ( $t === false ) ? false : memcacheRead( $m, $k );

        // calcolo
        if( empty( $r ) ) {

            $p = calcolaPrezzoArticolo( $m, $c, $a, $l, $qa, $qp, $qb, $date );

            // aliquota della riga vincente, o di ripiego
            $iva = ( ! empty( $p['id_iva'] ) ) ? $p['id_iva'] : $i;
            $v = ( ! empty( $iva ) ) ? (float) mysqlSelectCachedValue( $m, $c, 'SELECT aliquota FROM iva WHERE id = ?', array( array( 's' => $iva ) ) ) : 0;

            // lordo
            $r = $p['netto'] + ( $p['netto'] / 100 * $v );

            if( $t !== false ) {
                memcacheWrite( $m, $k, $r, $t );
            }

        }

        return (float) $r;

    }

    /**
     * calcola la provvigione percentuale di un articolo
     *
     * Legge prezzi.provvigione_percentuale con le stesse regole di validità delle righe di prezzo ( trovaRigaPrezzo() ):
     * candidati sono la provvigione del prodotto, quella dell'articolo, la più bassa fra le righe di prezzo dei panieri e
     * la più bassa fra le loro righe sconto; vince la più bassa positiva. È la regola del progetto berni, da cui la
     * funzione è stata portata il 2026-10-01, con la sua correzione: un paniere senza riga su quel listino non azzera la
     * provvigione trovata su un altro.
     *
     * @param  object  $m     la connessione a memcache
     * @param  object  $c     la connessione al database
     * @param  mixed   $a     l'id dell'articolo
     * @param  mixed   $l     l'id del listino
     * @param  float   $qa    la quantità dell'articolo
     * @param  float   $qp    la quantità del prodotto
     * @param  array   $qb    le quantità dei panieri
     * @param  mixed   $date  la data, Y-m-d o timestamp ( default oggi )
     * @param  mixed   $t     la durata in cache, false per non leggerla
     *
     * @return float          la provvigione percentuale, 0 se non c'è
     */
    function calcolaProvvigioneArticolo( $m, $c, $a, $l, $qa = 1, $qp = 1, $qb = array(), $date = NULL, $t = MEMCACHE_DEFAULT_TTL ) {

        // data di riferimento
        $date = empty( $date ) ? date( 'Y-m-d' ) : $date;
        $date = is_numeric( $date ) ? date( 'Y-m-d', $date ) : $date;

        // cache
        $k = md5( PROVV_DATA . 'v2' . $a . $l . $qa . $qp . md5( serialize( $qb ) ) . $date );
        $r = ( $t === false ) ? false : memcacheRead( $m, $k );

        if( empty( $r ) ) {

            // il prodotto dell'articolo
            $p = mysqlSelectCachedValue( $m, $c, 'SELECT id_prodotto FROM articoli WHERE id = ?', array( array( 's' => $a ) ) );

            // provvigioni del prodotto e dell'articolo
            $cnd = array(
                trovaRigaPrezzo( $m, $c, 'id_prodotto', $p, $l, $qp, $date, 'provvigione' )['provvigione_percentuale'] ?? 0,
                trovaRigaPrezzo( $m, $c, 'id_articolo', $a, $l, $qa, $date, 'provvigione' )['provvigione_percentuale'] ?? 0
            );

            // la più bassa fra le righe di prezzo e fra le righe sconto dei panieri
            foreach( ( is_array( $qb ) ? $qb : array() ) as $bp => $qbn ) {
                $cnd[] = trovaRigaPrezzo( $m, $c, 'id_prodotto', $bp, $l, $qbn, $date, 'provvigione' )['provvigione_percentuale'] ?? 0;
                $sc = trovaRigaPrezzo( $m, $c, 'id_prodotto', $bp, $l, $qbn, $date, 'sconto' );
                $cnd[] = $sc['provvigione_percentuale'] ?? 0;
            }

            // vince la più bassa positiva
            $r = 0;
            foreach( $cnd as $pf ) {
                if( ! empty( $pf ) && $pf > 0 && ( empty( $r ) || $pf < $r ) ) {
                    $r = $pf;
                }
            }

            if( $t !== false ) {
                memcacheWrite( $m, $k, $r, $t );
            }

        }

        return (float) $r;

    }
