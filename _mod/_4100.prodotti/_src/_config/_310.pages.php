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
if ($cf['contents']['cached'] === false) {

    // log
    if( ! empty( $cf['memcache']['connection'] ) ) {
        logWrite('struttura dei prodotti NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR);
    }

    // recupero le pagine dal database
    $pgs = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT prodotti.*, prodotti_categorie.id_categoria FROM prodotti ' .
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
    );

    // timer
    timerCheck($cf['speed'], ' -> fine recupero prodotti dal database');

    // se ci sono pagine trovate le inserisco nell'array principale
    if (is_array($pgs)) {

        // canonical
        $canon = NULL;

        // ciclo principale
        foreach ($pgs as $pg) {

            // ID della categoria
            $cid = PREFX_CATEGORIE_PRODOTTI . $pg['id_categoria'];

            // ID della pagina
            $pid = $cid . '.' . PREFX_PRODOTTI . $pg['id'];
            //$pip = PREFX_PRODOTTI . $pg['id_genitore'];

            if (empty($pip)) {
                $pip = $pg['id_pagina'];
            }

            // aggiornamento delle pagine
            if ($pg['timestamp_aggiornamento'] > $cf['contents']['updated']) {
                $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
            }

            // prelevo i dati dalla cache
            $age = memcacheGetKeyAge($cf['memcache']['connection'], $pid);
            $pgc = memcacheRead($cf['memcache']['connection'], $pid);


            // valuto se i dati in cache sono ancora validi
            if ($pg['timestamp_aggiornamento'] > $age || empty($pgc)) {

                // blocco dati principale
                $cf['contents']['pages'][$pid] = array(
                    'sitemap'		=> ( ( $pg['se_sitemap'] == 1 ) ? true : false ),
                    'cacheable'		=> ( ( $pg['se_cacheable'] == 1 ) ? true : false ),
                    'parent'        => array('id'        => $cid),
                    'canonical'        => $canon,
                    'template'        => array('path'    => $cf['prodotti']['pages']['scheda']['template'], 'schema' => $cf['prodotti']['pages']['scheda']['schema'], 'theme' => $cf['prodotti']['pages']['scheda']['css']),
                    'metadata'      => array('id_prodotto' => $pg['id']),
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
               memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);

            } else {

                $cf['contents']['pages'][$pid] = $pgc;
            }
        }
    }

    // timer
    timerCheck($cf['speed'], ' -> fine elaborazione prodotti prelevati dal database');

} else {

    // recupero la timestamp di aggiornamento più recente
    $cf['contents']['updated'] = mysqlSelectValue(
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
    );

    // debug
    // echo $cf['contents']['updated'] . PHP_EOL;

}
