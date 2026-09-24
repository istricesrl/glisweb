<?php

/**
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
 *
 * @todo finire di documentare
 *
 * @file
 *
 */

// controllo cache
if( $cf['contents']['cached'] === false ) {

    // log
    if( ! empty( $cf['memcache']['connection'] ) ) {
        logWrite('struttura dei prodotti NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR);
    }

    // recupero le pagine dal database
    $pgs = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT prodotti.*, prodotti_categorie.id_categoria, tipologie_pubblicazioni.nome AS tipologia_pubblicazione 
            FROM prodotti 
            LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
            LEFT JOIN categorie_prodotti ON categorie_prodotti.id = prodotti_categorie.id_categoria
            INNER JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id
            INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia
            WHERE categorie_prodotti.id_sito = ?
            AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? )
            AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? )
            AND tipologie_pubblicazioni.se_pubblicato = 1 ',
        array(
            array('s' => SITE_CURRENT),
            array('s' => time()),
            array('s' => time())
        )
    );

    // timer
    timerCheck( $cf['speed'], ' -> fine recupero prodotti dal database' );

    // se ci sono pagine trovate le inserisco nell'array principale
    if( is_array( $pgs ) ) {

        // canonical
        $canon = NULL;

        // ciclo principale
        foreach( $pgs as $pg ) {

            // ID della categoria
            $cid = PREFX_CATEGORIE_PRODOTTI . $pg['id_categoria'];

            // ID della pagina
            $pid = $cid . '.' . PREFX_PRODOTTI . $pg['id'];
            //$pip = PREFX_PRODOTTI . $pg['id_genitore'];

            if (empty($pip)) {
                $pip = $pg['id_pagina'];
            }

            // ...
            $cf['contents']['reverse']['prodotti'][ $pg['id'] ] = $pid;

            // aggiornamento delle pagine
            if ($pg['timestamp_aggiornamento'] > $cf['contents']['updated']) {
                $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
            }

            // prelevo i dati dalla cache
            $age = memcacheGetKeyAge($cf['memcache']['connection'], $pid);
            $pgc = memcacheRead($cf['memcache']['connection'], $pid);

            // default
            $pg['template'] = ( empty( $pg['template'] ) ) ? $cf['prodotti']['pages']['scheda']['template'] : $pg['template'];
            $pg['schema_html'] = ( empty( $pg['schema_html'] ) ) ? $cf['prodotti']['pages']['scheda']['schema'] : $pg['schema_html'];
            $pg['tema_css'] = ( empty( $pg['tema_css'] ) ) ? $cf['prodotti']['pages']['scheda']['css'] : $pg['tema_css'];

            // valuto se i dati in cache sono ancora validi
            if ($pg['timestamp_aggiornamento'] > $age || empty($pgc)) {

                // blocco dati principale
                $cf['contents']['pages'][$pid] = array(
                    'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                    'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                    // TODO 'robots'        => $pg['robots'],
                    'parent'        => array('id'        => $cid),
                    'canonical'        => $canon,
                    'template'        => array(
#                        'path'    => $cf['prodotti']['pages']['scheda']['template'],
#                        'schema' => $cf['prodotti']['pages']['scheda']['schema'],
#                        'theme' => $cf['prodotti']['pages']['scheda']['css']
                        'path'      =>  $pg['template'],
                        'schema'    =>  $pg['schema_html'],
                        'theme'     =>  $pg['tema_css']
                    ),
                    'metadati'      => array('id_prodotto' => $pg['id']),
                    'etc'           => array( 'note' => array( 'tipologia_pubblicazione' => $pg['tipologia_pubblicazione'] ) ),
                    'macro'            => $cf['prodotti']['pages']['scheda']['macro']
                );

                aggiungiGruppi(
                    $cf['contents']['pages'][$pid],
                    $pg['id']
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_prodotto'
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_prodotto'
                );

                aggiungiImmagini(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_prodotto',
                    array(1, 3, 4, 5, 7, 8)
                );

                aggiungiMetadati(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_prodotto'
                );

                aggiungiCaratteristiche(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'prodotti_caratteristiche',
                    'id_prodotto'
                );

                aggiungiPrezzi(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_prodotto'
                );

/*
                aggiungiMenu(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_prodotto'
                );
*/

                // canonical
                $canon = $pid;

               // scrivo la pagina del prodotto in cache
               memcacheWrite( $cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid] );

            } else {

                $cf['contents']['pages'][$pid] = $pgc;
            }
        }
    }

    /**
     * LE SCHEDE PUBBLICHE DEGLI ARTICOLI
     * ===================================
     *
     * Fino a ieri il front-end sapeva pubblicare soltanto un PRODOTTO: le pubblicazioni stavano
     * tutte su pubblicazioni.id_prodotto e nessuna su id_articolo, e la colonna esisteva senza che
     * la usasse nessuno. Il modello a tre tipologie ( macchina base, opzione, macchina configurata )
     * ha bisogno del contrario: a essere pubblicata e' la scheda di un ARTICOLO.
     *
     * Questo blocco e' il gemello di quello dei prodotti qui sopra, con tre differenze, tutte e tre
     * conseguenza del fatto che un articolo non e' una pagina:
     *
     *  1. LA CATEGORIA E IL SITO arrivano dal PRODOTTO dell'articolo, perche' un articolo in
     *     prodotti_categorie non c'e'. Percio' la scheda di un articolo sta sotto la stessa
     *     categoria sotto cui starebbe quella del suo prodotto, e il filo di briciole non cambia.
     *  2. TEMPLATE, SCHEMA E TEMA arrivano dal PRODOTTO, perche' articoli quelle colonne non le ha.
     *  3. TUTTO IL RESTO E' IN RIPIEGO: contenuti, immagini, metadati e prezzi si cercano PRIMA
     *     sull'articolo e, se l'articolo non ne ha, si sale al prodotto. E' la regola del modello
     *     approvato il 05/09, e qui e' scritta una volta per ogni tipo di dato invece che con una
     *     fusione automatica: array_replace_recursive sovrascriverebbe con i NULL dell'articolo i
     *     valori buoni del prodotto.
     *
     * Le caratteristiche NON sono in questo elenco: le monta la macro della scheda
     * ( _articoli.scheda.php ), perche' sono un albero e non una lista piatta.
     */
    if( $cf['contents']['cached'] === false ) {

        // log
        if( ! empty( $cf['memcache']['connection'] ) ) {
            logWrite('struttura degli articoli NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR);
        }

        // gli articoli pubblicati, con la categoria e i dati di pagina del loro prodotto
        $art = mysqlQuery(
            $cf['mysql']['connection'],
            'SELECT articoli.id, articoli.id_prodotto, articoli.timestamp_aggiornamento,
                    prodotti.template, prodotti.schema_html, prodotti.tema_css,
                    prodotti.se_sitemap, prodotti.se_cacheable,
                    prodotti_categorie.id_categoria, tipologie_pubblicazioni.nome AS tipologia_pubblicazione
                FROM articoli
                INNER JOIN prodotti ON prodotti.id = articoli.id_prodotto
                LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id
                LEFT JOIN categorie_prodotti ON categorie_prodotti.id = prodotti_categorie.id_categoria
                INNER JOIN pubblicazioni ON pubblicazioni.id_articolo = articoli.id
                INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia
                WHERE categorie_prodotti.id_sito = ?
                AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? )
                AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? )
                AND tipologie_pubblicazioni.se_pubblicato = 1 ',
            array(
                array('s' => SITE_CURRENT),
                array('s' => time()),
                array('s' => time())
            )
        );

        // timer
        timerCheck( $cf['speed'], ' -> fine recupero articoli dal database' );

        if( is_array( $art ) ) {

            foreach( $art as $pg ) {

                // ID della categoria e della pagina
                $cid = PREFX_CATEGORIE_PRODOTTI . $pg['id_categoria'];
                $pid = $cid . '.' . PREFX_ARTICOLI . $pg['id'];

                // ...
                $cf['contents']['reverse']['articoli'][ $pg['id'] ] = $pid;

                // aggiornamento delle pagine
                if( $pg['timestamp_aggiornamento'] > $cf['contents']['updated'] ) {
                    $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
                }

                // prelevo i dati dalla cache
                $age = memcacheGetKeyAge( $cf['memcache']['connection'], $pid );
                $pgc = memcacheRead( $cf['memcache']['connection'], $pid );

                // default: prima il prodotto, poi la configurazione del modulo
                $pg['template'] = ( empty( $pg['template'] ) ) ? $cf['prodotti']['pages']['articolo']['template'] : $pg['template'];
                $pg['schema_html'] = ( empty( $pg['schema_html'] ) ) ? $cf['prodotti']['pages']['articolo']['schema'] : $pg['schema_html'];
                $pg['tema_css'] = ( empty( $pg['tema_css'] ) ) ? $cf['prodotti']['pages']['articolo']['css'] : $pg['tema_css'];

                // valuto se i dati in cache sono ancora validi
                if( $pg['timestamp_aggiornamento'] > $age || empty( $pgc ) ) {

                    // blocco dati principale
                    $cf['contents']['pages'][$pid] = array(
                        'sitemap'       => ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                        'cacheable'     => ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                        'parent'        => array( 'id' => $cid ),
                        'template'      => array(
                            'path'      => $pg['template'],
                            'schema'    => $pg['schema_html'],
                            'theme'     => $pg['tema_css']
                        ),
                        'metadati'      => array( 'id_articolo' => $pg['id'], 'id_prodotto' => $pg['id_prodotto'] ),
                        'etc'           => array( 'note' => array( 'tipologia_pubblicazione' => $pg['tipologia_pubblicazione'] ) ),
                        'macro'         => $cf['prodotti']['pages']['articolo']['macro']
                    );

                    // i contenuti: prima quelli dell'articolo, se non ne ha quelli del prodotto
                    //
                    // NON si chiamano tutte e due in sequenza: aggiungiContenuti() fonde con
                    // array_replace_recursive, quindi una riga dell'articolo con i campi vuoti
                    // cancellerebbe title, h1 e soprattutto l'indirizzo presi dal prodotto
                    if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM contenuti WHERE id_articolo = ? LIMIT 1', array( array( 's' => $pg['id'] ) ) ) ) {
                        aggiungiContenuti( $cf['contents']['pages'][$pid], $pg['id'], 'id_articolo' );
                    } else {
                        aggiungiContenuti( $cf['contents']['pages'][$pid], $pg['id_prodotto'], 'id_prodotto' );
                    }

                    // le immagini, con lo stesso ripiego
                    if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM immagini WHERE id_articolo = ? LIMIT 1', array( array( 's' => $pg['id'] ) ) ) ) {
                        aggiungiImmagini( $cf['contents']['pages'][$pid], $pg['id'], 'id_articolo', array( 1, 3, 4, 5, 7, 8 ) );
                    } else {
                        aggiungiImmagini( $cf['contents']['pages'][$pid], $pg['id_prodotto'], 'id_prodotto', array( 1, 3, 4, 5, 7, 8 ) );
                    }

                    // i metadati
                    if( mysqlSelectValue( $cf['mysql']['connection'], 'SELECT id FROM metadati WHERE id_articolo = ? LIMIT 1', array( array( 's' => $pg['id'] ) ) ) ) {
                        aggiungiMetadati( $cf['contents']['pages'][$pid], $pg['id'], 'id_articolo' );
                    } else {
                        aggiungiMetadati( $cf['contents']['pages'][$pid], $pg['id_prodotto'], 'id_prodotto' );
                    }

                    // i prezzi: qui il ripiego NON serve, il prezzo di un articolo e' suo
                    aggiungiPrezzi( $cf['contents']['pages'][$pid], $pg['id'], 'id_articolo' );

                    // scrivo la pagina dell'articolo in cache
                    memcacheWrite( $cf['memcache']['connection'], 'PAGE_' . $pid, $cf['contents']['pages'][$pid] );

                } else {

                    $cf['contents']['pages'][$pid] = $pgc;

                }

            }

        }

        // timer
        timerCheck( $cf['speed'], ' -> fine elaborazione articoli prelevati dal database' );

    }

    // timer
    timerCheck($cf['speed'], ' -> fine elaborazione prodotti prelevati dal database');

} else {

    // recupero la timestamp di aggiornamento più recente
    $cf['contents']['updated'] = max(
        $cf['contents']['updated'],
        mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( prodotti.timestamp_aggiornamento ) AS updated FROM prodotti ' .
                'LEFT JOIN prodotti_categorie ON prodotti_categorie.id_prodotto = prodotti.id ' .
                'LEFT JOIN categorie_prodotti ON categorie_prodotti.id = prodotti_categorie.id_categoria ' .
                'INNER JOIN pubblicazioni ON pubblicazioni.id_prodotto = prodotti.id ' .
                'WHERE categorie_prodotti.id_sito = ? ' .
                'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) ' .
                'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) ',
            array(
                array('s' => SITE_CURRENT),
                array('s' => time()),
                array('s' => time())
            )
        )
    );

    // debug
    // echo $cf['contents']['updated'] . PHP_EOL;

}
