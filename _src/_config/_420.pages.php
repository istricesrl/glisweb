<?php

    /**
     * applicazione della configurazione della pagina corrente
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
     * TODO almeno una parte di queste logiche non dovrebbero stare nell'API pages?
     *
     * TODO documentare
     *
     */

    /**
     * dichiarazioni preliminari
     * =========================
     * 
     * 
     */

    // link alla pagina corrente
    $cf['contents']['page'] = &$cf['contents']['pages'][ $cf['parser']['page'] ];

    // TODO fare questa cosa con un ciclo per tutte le chiavi di $cf['contents']
    // in pratica $ct deve essere la scorciatoia per $cf['contents']

    // NOTA è una brutta asimmetria, ma giustificata dalla brevità di scrittura?

    // collego l'array delle pagine a $ct
    $ct['pages'] = &$cf['contents']['pages'];

    // collego la pagina corrente a $ct
    $ct['page'] = &$cf['contents']['page'];

    // versione canonica della pagina
    if( ! in_array( strtok( $_SERVER['REQUEST_URI'], '?' ), $cf['contents']['page']['path'] ) ) {
        $cf['contents']['page']['canonical'] = $cf['contents']['page']['id'];
    }

    /**
     * gestione del menu a tab
     * =======================
     * 
     * 
     */

    // pulitura delle tab
    if( isset( $ct['page']['etc']['tabs'] ) ) {

        if( ! is_array( $ct['page']['etc']['tabs'] ) ) {
            $ct['page']['etc']['tabs'] = $cf['contents']['pages'][ $ct['page']['etc']['tabs'] ]['etc']['tabs'];
        }

        foreach( $ct['page']['etc']['tabs'] as $key => $tab ) {
            if( isset( $cf['contents']['pages'][ $tab ]['auth']['groups'] ) &&
                ( ! isset( $_SESSION['account']['gruppi'] ) ||
                    count(
                        array_intersect(
                            $cf['contents']['pages'][ $tab ]['auth']['groups'],
                            $_SESSION['account']['gruppi']
                        )
                    ) == 0
                )
            ) {
                unset( $ct['page']['etc']['tabs'][ $key ] );
            }
        }

    }

    /**
     * gestione dei comandi di una lettera
     * ===================================
     * 
     * 
     */

    // attivo i comandi di una lettera soltanto per DEV e TEST
    if( SITE_STATUS != PRODUCTION ) {

        // forzatura del template corrente per one-char parameter debug
        if( isset( $_REQUEST['t'] ) ) {
            if( file_exists( DIR_BASE . '_src/_tpl/_' . $_REQUEST['t'] . '/' ) ) {
                $ct['page']['template']['path']    = '_src/_tpl/_' . $_REQUEST['t'] . '/';
            } elseif( file_exists( DIR_BASE . 'src/tpl/' . $_REQUEST['t'] . '/' ) ) {
                $ct['page']['template']['path']    = 'src/tpl/' . $_REQUEST['t'] . '/';
            } elseif( file_exists( DIR_BASE . '_src/_templates/_' . $_REQUEST['t'] . '/' ) ) {
                $ct['page']['template']['path']    = '_src/_templates/_' . $_REQUEST['t'] . '/';
            } elseif( file_exists( DIR_BASE . 'src/templates/' . $_REQUEST['t'] . '/' ) ) {
                $ct['page']['template']['path']    = 'src/templates/' . $_REQUEST['t'] . '/';
            }
            $ct['page']['template']['schema'] = (
                ( isset( $ct['page']['template']['default'] ) ) 
                ? 
                $ct['page']['template']['default'] 
                :
                (
                    file_exists( DIR_BASE . $ct['page']['template']['path'] . 'default.twig' )
                    ?
                    'default.twig'
                    :
                    'default.html'
                )
            );
        }

        // forzatura dello schema corrente per one-char parameter debug
        if( isset( $_REQUEST['s'] ) ) {
            if( DIR_BASE . file_exists( $ct['page']['template']['path'] . $_REQUEST['s'] . '.twig' ) ) {
                $ct['page']['template']['schema'] = $_REQUEST['s'] . '.twig';
            } elseif( file_exists( DIR_BASE . $ct['page']['template']['path'] . $_REQUEST['s'] . '.html' ) ) {
                $ct['page']['template']['schema'] = $_REQUEST['s'] . '.html';
            }
        }

        // forzatura del tema corrente per one-char parameter string
        if( isset( $_REQUEST['c'] ) ) {
            $ct['page']['template']['theme'] = $_REQUEST['c'] . '.css';
        }

        // forzatura dei contenuti correnti per one-char parameter debug
        if( isset( $_REQUEST['m'] ) ) {
            $ct['page']['content'][ $cf['localization']['language']['ietf'] ] = implode( PHP_EOL, array_fill( 0, $_REQUEST['m'], '<p>'.$cf['common']['lorem']['std'].'</p>' ) );
        }

    }

    /**
     * elaborazioni specifiche della pagina corrente
     * =============================================
     * 
     * 
     */

    // assegnazione del tema per specificità
    if( isset( $cf['site']['metadati']['theme'] ) ) {

        if( ! isset( $ct['page']['template']['theme'] ) ) {

            $ct['page']['template']['theme'] = $cf['site']['metadati']['theme'];

        }

    }

    // TODO la forzatura del nome del sito nel <title> dev'essere opzionale
    if( ! empty( TITLE_SEPARATOR ) ) {
        $ct['page']['title'][ LINGUA_CORRENTE ] = $cf['site']['name'][ LINGUA_CORRENTE ] . TITLE_SEPARATOR . $ct['page']['title'][ LINGUA_CORRENTE ];
    }

    /*
     * TODO prevedere la forzatura anche per il tema della pagina
     */

    // log
    logWrite( 'pagina corrente: ' . $cf['parser']['page'], 'rewrite' );

    /**
     * debug del runlevel
     * ==================
     * 
     * 
     */

    // debug
    // print_r( $cf['contents']['pages']['licenza']['content'] );
    // print_r( $cf['contents']['page']['path'] );
    // print_r( $cf['contents']['page'] );
    // print_r( $ct['page'] );
    // var_dump( $_SERVER['REQUEST_URI'] );
    // print_r( $ct['page']['etc']['tabs'] );
    // print_r( $_SESSION['account']['gruppi'] );
    // echo $cf['contents']['updated'];
