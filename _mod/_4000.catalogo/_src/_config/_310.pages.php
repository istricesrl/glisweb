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
        logWrite('struttura delle categorie catalogo NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR);
    }

    // recupero le pagine dal database
    $pgs = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT categorie_prodotti.* FROM categorie_prodotti ' .
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_prodotti = categorie_prodotti.id ' .
            'INNER JOIN tipologie_pubblicazioni ON tipologie_pubblicazioni.id = pubblicazioni.id_tipologia '.
            'WHERE categorie_prodotti.id_sito = ? ' .
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) ' .
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) ' .
            'AND tipologie_pubblicazioni.se_pubblicato = 1 '.
            'GROUP BY categorie_prodotti.id ',
        array(
            array('s' => SITE_CURRENT),
            array('s' => time()),
            array('s' => time())
        )
    );

    // timer
    timerCheck($cf['speed'], ' -> fine recupero categorie catalogo dal database');

    // se ci sono pagine trovate le inserisco nell'array principale
    if (is_array($pgs)) {

        // canonical
        $canon = NULL;

        // ciclo principale
        foreach ($pgs as $pg) {

            // ID della pagina
            $pid = PREFX_CATEGORIE_PRODOTTI . $pg['id'];
            $pip = PREFX_CATEGORIE_PRODOTTI . $pg['id_genitore'];

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

            // default
            $pg['template'] = ( empty( $pg['template'] ) ) ? $cf['catalogo']['pages']['scheda']['template'] : $pg['template'];
            $pg['schema_html'] = ( empty( $pg['template'] ) ) ? $cf['catalogo']['pages']['scheda']['schema'] : $pg['schema_html'];
            $pg['tema_css'] = ( empty( $pg['template'] ) ) ? $cf['catalogo']['pages']['scheda']['css'] : $pg['tema_css'];

            // valuto se i dati in cache sono ancora validi
            if ($pg['timestamp_aggiornamento'] > $age || empty($pgc)) {

                // blocco dati principale
                $cf['contents']['pages'][$pid] = array(
                    'sitemap'        => (($pg['se_sitemap'] == 1) ? true : false),
                    'cacheable'        => (($pg['se_cacheable'] == 1) ? true : false),
                    'parent'        => array('id'        => $pip),
                    'canonical'        => $canon,
                    'template'        => array(
                        'path'      =>  $pg['template'],
                        'schema'    =>  $pg['schema_html'],
                        'theme'     =>  $pg['tema_css']
                    ),
                    'metadati'      => array('id_categoria_prodotti' => $pg['id']),
                    'macro'            => $cf['catalogo']['pages']['elenco']['macro']
                );

                // macro aggiuntiva per i prodotti
                if (in_array('4100.prodotti', $cf['mods']['active']['array'])) {
                    $cf['contents']['pages'][$pid]['macro'] = array_merge(
                        $cf['contents']['pages'][$pid]['macro'],
                        array('_mod/_4100.prodotti/_src/_inc/_macro/_prodotti.elenco.php')
                    );
                    #		    $cf['contents']['pages'][ $id ]['contents']['prodotti'] = mysqlQuery(
                    #			$cf['mysql']['connection'],
                    #			'SELECT id_prodotto AS id FROM prodotti_categorie WHERE id_categoria = ?',
                    #			array( array( 's' => $pg['id'] ) )
                    #		    );
                }

                aggiungiGruppi(
                    $cf['contents']['pages'][$pid],
                    $pg['id']
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_prodotti'
                );

             /*   aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_prodotti'
                );*/

                aggiungiImmagini(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_prodotti',
                    array(1, 3, 4, 5, 7, 8)
                );

                aggiungiMetadati(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_prodotti'
                );

                aggiungiMenu(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_prodotti'
                );

                // scrivo la pagina in cache
                memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);
            } else {

                $cf['contents']['pages'][$pid] = $pgc;
            }
        }
    }

    // timer
    timerCheck($cf['speed'], ' -> fine elaborazione categorie catalogo prelevate dal database');

} else {

    // recupero la timestamp di aggiornamento più recente
    $cf['contents']['updated'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT max( categorie_prodotti.timestamp_aggiornamento ) AS updated FROM categorie_prodotti ' .
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_prodotti = categorie_prodotti.id ' .
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
