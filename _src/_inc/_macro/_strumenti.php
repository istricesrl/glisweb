<?php

    /**
     * macro dashboard tools
     *
     *
     *
     * TODO documentare
     *
     */

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        '01.esportazioni' => array(
            'label' => 'esportazioni'
        ),
        '02.importazioni' => array(
            'label' => 'importazioni'
        ),
        '03.elaborazioni' => array(
            'label' => 'elaborazioni'
        ),
        '04.cache' => array(
            'label' => 'cache'
        ),
        '05.static' => array(
            'label' => 'viste statiche'
        ),
        '06.logs' => array(
            'label' => 'log'
        )
    );

    // aggiornamento cache
    if( isset( $cf['memcache']['connection'] ) ) {
        $ct['page']['contents']['metro']['04.cache'][] = array(
        'ws' => 'task/memcache.clean',
        'icon' => NULL,
        'fa' => 'fa-regular fa-clock',
        'title' => 'aggiornamento memcache',
        'text' => 'forza il flush della cache dati'
        );
        timerCheck( $cf['speed'], '-> memcache' );
    }

    if( file_exists( DIR_VAR_CACHE_TWIG ) ) {
        $ct['page']['contents']['metro']['04.cache'][] = array(
        'ws' => 'task/twig.cache.clean',
        'icon' => NULL,
        'fa' => 'fa-recycle',
        'title' => 'aggiornamento cache di Twig',
        'text' => 'cancella la cache dei template'
        );
        timerCheck( $cf['speed'], '-> cache Twig' );
    }

    if( file_exists( DIR_VAR_CACHE_PAGES ) ) {
        $ct['page']['contents']['metro']['04.cache'][] = array(
        'ws' => 'task/pages.cache.clean',
        'icon' => NULL,
        'fa' => 'fa-eraser',
        'title' => 'aggiornamento cache pagine',
        'text' => 'cancella la cache statica delle pagine'
        );
        timerCheck( $cf['speed'], '-> cache Twig' );
    }

    if( count( glob( DIR_VAR_SITEMAP . 'sitemap.*.{xml,csv}', GLOB_BRACE ) ) > 0 ) {
        $ct['page']['contents']['metro']['04.cache'][] = array(
            'ws' => 'task/sitemap.clean',
            'icon' => NULL,
            'fa' => 'fa-regular fa-file-code',
            'title' => 'pulizia delle sitemap',
            'text' => 'forza la cancellazione delle sitemap'
        );
    }

    if( count( glob( DIR_TMP . '*' ) ) > 0 ) {
        $ct['page']['contents']['metro']['04.cache'][] = array(
            'ws' => 'task/tmp.clean',
            'confirm' => true,
            'icon' => NULL,
            'fa' => 'fa-hourglass-end',
            'title' => 'pulizia dei file temporanei',
            'text' => 'svuota la cartella dei file temporanei'
        );
        timerCheck( $cf['speed'], '-> controllo file temporanei' );
    }

    if( count( glob( DIR_VAR_LOG . '{*/,}*.log', GLOB_BRACE ) ) > 0 ) {
        $ct['page']['contents']['metro']['06.logs'][] = array(
            'ws' => 'task/log.clean',
            'icon' => NULL,
            'fa' => 'fa-trash',
            'title' => 'pulizia dei log',
            'text' => 'cancella i log base del framework'
        );
        $ct['page']['contents']['metro']['06.logs'][] = array(
            'ws' => 'task/log.clean?hard=1',
            'confirm' => true,
            'icon' => NULL,
            'fa' => 'fa-trash-arrow-up',
            'title' => 'pulizia totale dei log',
            'text' => 'cancella tutti i log del framework'
        );
        timerCheck( $cf['speed'], '-> controllo log' );
    }

    // gestione di default dei tools
    require DIR_SRC_INC_MACRO . '_default/_default.tools.php';
