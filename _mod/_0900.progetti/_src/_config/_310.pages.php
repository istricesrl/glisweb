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
        logWrite('struttura delle categorie progetti NON presente in cache, elaborazione DAL DATABASE...', 'performances', LOG_ERR);
    }

    // recupero le pagine dal database
    $pgs = mysqlQuery(
        $cf['mysql']['connection'],
        'SELECT ( SELECT max( greatest( coalesce( pp.timestamp_aggiornamento, 0 ), if( pp.timestamp_inizio < ?, pp.timestamp_inizio, 0 ), if( pp.timestamp_fine < ?, pp.timestamp_fine, 0 ) ) ) FROM pubblicazioni AS pp WHERE pp.id_categoria_progetti = categorie_progetti.id ) AS timestamp_pubblicazione, categorie_progetti.* FROM categorie_progetti ' .
            'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_progetti = categorie_progetti.id ' .
            'WHERE categorie_progetti.id_sito = ? ' .
            'AND ( pubblicazioni.timestamp_inizio IS NULL OR pubblicazioni.timestamp_inizio < ? ) ' .
            'AND ( pubblicazioni.timestamp_fine IS NULL OR pubblicazioni.timestamp_fine > ? ) ' .
            'GROUP BY categorie_progetti.id ',
        array(
            array('s' => time()),
            array('s' => time()),
            array('s' => SITE_CURRENT),
            array('s' => time()),
            array('s' => time())
        )
    );

    // timer
    timerCheck($cf['speed'], ' -> fine recupero categorie progetti dal database');

    // se ci sono pagine trovate le inserisco nell'array principale
    if (is_array($pgs)) {

        // ciclo principale
        foreach ($pgs as $pg) {

            // le modifiche alle pubblicazioni e le finestre che si aprono valgono come aggiornamenti della pagina
            $pg['timestamp_aggiornamento'] = max( $pg['timestamp_aggiornamento'], $pg['timestamp_pubblicazione'] );

            // ID della pagina
            $pid = PREFX_CATEGORIE_PROGETTI . $pg['id'];
            $pip = PREFX_CATEGORIE_PROGETTI . $pg['id_genitore'];

            if (empty($pip)) {
                $pip = $pg['id_pagina'];
            }

            // aggiornamento delle pagine
            if ($pg['timestamp_aggiornamento'] > $cf['contents']['updated']) {
                $cf['contents']['updated'] = $pg['timestamp_aggiornamento'];
            }

            // prelevo i dati dalla cache
            $age = memcacheGetKeyAge($cf['memcache']['connection'], 'PAGE_' . $pid);
            $pgc = memcacheRead($cf['memcache']['connection'], 'PAGE_' . $pid);

            // valuto se i dati in cache sono ancora validi
            if ($pg['timestamp_aggiornamento'] > $age || empty($pgc)) {

                // blocco dati principale
                $cf['contents']['pages'][$pid] = array(
                    'sitemap'        => (($pg['se_sitemap'] == 1) ? true : false),
                    'cacheable'        => (($pg['se_cacheable'] == 1) ? true : false),
                    // TODO 'robots'        => $pg['robots'],
                    'parent'        => array('id'        => $pip),
                    'template'        => array(
                        'path'      =>  ( !empty($pg['template']) ? $pg['template'] : $ct['progetti']['pages']['elenco']['template']) ,
                        'schema'    => ( !empty($pg['schema_html'])  ? $pg['schema_html'] : $ct['progetti']['pages']['elenco']['schema']) ,
                        'theme'     => ( !empty( $pg['tema_css'] ) ? $pg['tema_css'] : $ct['progetti']['pages']['elenco']['css']) 
                    ),
                    'metadati'      => array('id_categoria_progetti' => $pg['id']),
                    'macro'            => $cf['catalogo']['pages']['elenco']['macro']
                );

                // macro aggiuntiva per i progetti
#                if (in_array('4100.progetti', $cf['mods']['active']['array'])) {
                    $cf['contents']['pages'][$pid]['macro'] = array_merge(
                        $cf['contents']['pages'][$pid]['macro'],
                        array('_mod/_0900.progetti/_src/_inc/_macro/_progetti.elenco.php')
                    );
                    #		    $cf['contents']['pages'][ $id ]['contents']['progetti'] = mysqlQuery(
                    #			$cf['mysql']['connection'],
                    #			'SELECT id_progetto AS id FROM progetti_categorie WHERE id_categoria = ?',
                    #			array( array( 's' => $pg['id'] ) )
                    #		    );
#                }

                aggiungiGruppi(
                    $cf['contents']['pages'][$pid],
                    $pg['id']
                );

                // se è soltanto in anteprima la pagina è riservata al gruppo anteprima
                aggiungiPubblicazione(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_progetti'
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_progetti'
                );

                aggiungiContenuti(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_progetti'
                );

                aggiungiImmagini(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_progetti',
                    array(1, 3, 4, 5, 7, 8)
                );

                aggiungiMetadati(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_progetti'
                );

                aggiungiMenu(
                    $cf['contents']['pages'][$pid],
                    $pg['id'],
                    'id_categoria_progetti'
                );

                // scrivo la pagina in cache
                memcacheWrite($cf['memcache']['connection'], 'PAGE_' .  $pid, $cf['contents']['pages'][$pid]);
            } else {

                $cf['contents']['pages'][$pid] = $pgc;
            }
        }
    }

    // timer
    timerCheck($cf['speed'], ' -> fine elaborazione categorie progetti prelevate dal database');

} else {

    // recupero la timestamp di aggiornamento più recente
    $cf['contents']['updated'] = max(
        $cf['contents']['updated'],
        mysqlSelectValue(
            $cf['mysql']['connection'],
            'SELECT max( greatest( coalesce( categorie_progetti.timestamp_aggiornamento, 0 ), coalesce( pubblicazioni.timestamp_aggiornamento, 0 ), if( pubblicazioni.timestamp_inizio < ?, pubblicazioni.timestamp_inizio, 0 ), if( pubblicazioni.timestamp_fine < ?, pubblicazioni.timestamp_fine, 0 ) ) ) AS updated FROM categorie_progetti ' .
                'INNER JOIN pubblicazioni ON pubblicazioni.id_categoria_progetti = categorie_progetti.id ' .
                'WHERE categorie_progetti.id_sito = ? ',
            array(
                array('s' => time()),
                array('s' => time()),
                array('s' => SITE_CURRENT)
            )
        )
    );

    // debug
    // echo $cf['contents']['updated'] . PHP_EOL;

}
