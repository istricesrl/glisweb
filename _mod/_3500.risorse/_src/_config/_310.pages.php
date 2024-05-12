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
        logWrite('struttura delle categorie risorse NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR);
    }

    // recupero le pagine dal database
    $pgs = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT categorie_risorse.* FROM categorie_risorse ' .
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_risorse = categorie_risorse.id ' .
            'WHERE categorie_risorse.id_sito = ? ' .
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) ' .
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) ' .
            'GROUP BY categorie_risorse.id ',
        array(
            array('s' => SITE_CURRENT),
            array('s' => time()),
            array('s' => time())
        )
    );

    // timer
    timerCheck($cf['speed'], ' -> fine recupero categorie risorse dal database');

    // se ci sono pagine trovate le inserisco nell'array principale
    if (is_array($pgs)) {

        // ciclo principale
        foreach ($pgs as $pg) {

            // ID della pagina
            $pid = PREFX_CATEGORIE_RISORSE . $pg['id'];
            $pip = PREFX_CATEGORIE_RISORSE . $pg['id_genitore'];

            if (empty($pip)&&isset($pg['id_pagina'])) {
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
                    'sitemap'        => (($pg['se_sitemap'] == 1) ? true : false),
                    'cacheable'        => (($pg['se_cacheable'] == 1) ? true : false),
                    // TODO 'robots'        => $pg['robots'],
                    'parent'        => array('id'        => $pip),
                    'template'        => array(
                        'path'      =>  $pg['template'],
                        'schema'    =>  $pg['schema_html'],
                        'theme'     =>  $pg['tema_css']
                    ),
                    'metadati'      => array('id_categoria_risorse' => $pg['id']),
                    'macro'            => $cf['risorse']['pages']['elenco']['macro']
                );



                aggiungiGruppi(
                    $cf['contents']['pages'][$pid],
                    $pg['id']
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_risorse'
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_risorse'
                );

                aggiungiImmagini(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_risorse',
                    array(4, 16, 29, 14)
                );

                aggiungiMetadati(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_risorse'
                );

                aggiungiMenu(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_risorse'
                );

                // scrivo la pagina in cache
                memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);
            } else {

                $cf['contents']['pages'][$pid] = $pgc;
            }
        }
    }

    // timer
    timerCheck($cf['speed'], ' -> fine elaborazione categorie risorse prelevate dal database');

    // recupero le pagine dal database
    $pgs = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT risorse.*, risorse_categorie.id_categoria FROM risorse ' .
            'LEFT JOIN risorse_categorie ON risorse_categorie.id_risorsa = risorse.id ' .
            'INNER JOIN pubblicazioni ON pubblicazioni.id_risorsa = risorse.id ' .
            'WHERE risorse.id_sito = ? ' .
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) ' .
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) ' ,
        array(
            array('s' => SITE_CURRENT),
            array('s' => time()),
            array('s' => time())
        )
    );
    
    // timer
    timerCheck($cf['speed'], ' -> fine recupero categorie risorse dal database');

    // se ci sono pagine trovate le inserisco nell'array principale
    if (is_array($pgs)) {

        // canonical
        $canon = NULL;

        // ciclo principale
        foreach ($pgs as $pg) {

            // ID della categoria
            $cid = PREFX_CATEGORIE_RISORSE . $pg['id_categoria'];

            // ID della pagina
            $pid = $cid . '.' . PREFX_RISORSE . $pg['id'];
            // $pip = PREFX_RISORSE . $pg['id_genitore'];

            if (empty($pip)&&isset($pg['id_pagina'])) {
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
                    // TODO 'robots'        => $pg['robots'],
                    'parent'        => array('id'        => $cid),
                    'canonical'        => $canon,
                    'template'        => array('path'    => $cf['risorse']['pages']['scheda']['template'], 'schema' => $cf['risorse']['pages']['scheda']['schema'], 'theme' => $cf['risorse']['pages']['scheda']['css']),
                    'metadati'      => array('id_risorsa' => $pg['id'])
                );

                aggiungiGruppi(
                    $cf['contents']['pages'][$pid],
                    $pg['id']
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_risorsa'
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_risorsa'
                );

                aggiungiImmagini(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_risorsa',
                    array(4, 16, 29, 14)
                );

                aggiungiMetadati(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_risorsa'
                );

                // canonical
                $canon = $pid;

                // scrivo la pagina in cache
                memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);
            } else {

                $cf['contents']['pages'][$pid] = $pgc;
            }
        }
    }

    // timer
    timerCheck($cf['speed'], ' -> fine elaborazione risorse prelevate dal database');

} else {

    // recupero la timestamp di aggiornamento più recente
    $cf['contents']['updated'] = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT max( risorse.timestamp_aggiornamento ) AS updated FROM risorse ' .
            'LEFT JOIN risorse_categorie ON risorse_categorie.id_risorsa = risorse.id ' .
            'INNER JOIN pubblicazioni ON pubblicazioni.id_risorsa = risorse.id ' .
            'WHERE risorse.id_sito = ? ' .
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
