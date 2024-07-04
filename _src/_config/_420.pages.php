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
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // link alla pagina corrente
	$cf['contents']['page']			= &$cf['contents']['pages'][ $page ];

    // TODO fare questa cosa con un ciclo per tutte le chiavi di $cf['contents']
    // in pratica $ct deve essere la scorciatoia per $cf['contents']

    // NOTA è una brutta asimmetria, ma giustificata dalla brevità di scrittura?

    // collego l'array delle pagine a $ct
    // TODO obsoleto
	$ct['pages']				= &$cf['contents']['pages'];

    // TODO buono
    $ct['contents']				= &$cf['contents'];

    // collego la pagina corrente a $ct
	$ct['page']				= &$cf['contents']['page'];

    // versione canonica della pagina
	if( ! in_array( strtok( $_SERVER['REQUEST_URI'], '?' ), $cf['contents']['page']['path'] ) ) {
	    $cf['contents']['page']['canonical'] = $cf['contents']['page']['id'];
	}

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

    // attivo i comandi di una lettera soltanto per DEV e TEST
    if( SITE_STATUS != PRODUCTION ) {

        // forzatura del template corrente per one-char parameter debug
        if( isset( $_REQUEST['t'] ) ) {
            if( file_exists( DIR_BASE . '_src/_templates/_' . $_REQUEST['t'] . '/' ) ) {
                $ct['page']['template']['path']	= '_src/_templates/_' . $_REQUEST['t'] . '/';
            } elseif( file_exists( DIR_BASE . 'src/templates/' . $_REQUEST['t'] . '/' ) ) {
                $ct['page']['template']['path']	= 'src/templates/' . $_REQUEST['t'] . '/';
            }
            $ct['page']['template']['schema']	= 'default.html';
        }

        // forzatura dello schema corrente per one-char parameter debug
        if( isset( $_REQUEST['s'] ) ) {
            $ct['page']['template']['schema']	= $_REQUEST['s'] . '.html';
        }

        // forzatura del tema corrente per one-char parameter string
        if( isset( $_REQUEST['c'] ) ) {
            $ct['page']['template']['theme']	= $_REQUEST['c'] . '.css';
        }

        // forzatura dei contenuti correnti per one-char parameter debug
        if( isset( $_REQUEST['l'] ) ) {
            $ct['page']['content'][ $cf['localization']['language']['ietf'] ]	= implode( PHP_EOL, array_fill( 0, $_REQUEST['l'], '<p>'.$cf['common']['lorem']['std'].'</p>' ) );
        }

    }

    // assegnazione del tema per specificità
    if( isset( $cf['site']['metadati']['theme'] ) ) {

        if( ! isset( $ct['page']['template']['theme'] ) ) {

            $ct['page']['template']['theme'] = $cf['site']['metadati']['theme'];

        }

    }

    // TODO la forzatura del nome del sito nel <title> dev'essere opzionale
    if( ! empty( TITLE_SEPARATOR ) ) {
        if( ! isset( $cf['site']['metadati']['noSiteNameInTitle'] ) ) {
            $ct['page']['title'][ LINGUA_CORRENTE ] = $cf['site']['name'][ LINGUA_CORRENTE ] . TITLE_SEPARATOR . $ct['page']['title'][ LINGUA_CORRENTE ];
        }
    }

    /*
     * @todo prevedere la forzatura anche per il tema della pagina
     */

    // log
	logWrite( 'pagina corrente: ' . $page, 'rewrite' );

    // debug
	// print_r( $cf['contents']['pages']['licenza']['content'] );
	// print_r( $cf['contents']['page']['path'] );
	// print_r( $cf['contents']['page'] );
	// print_r( $ct['page'] );
	// var_dump( $_SERVER['REQUEST_URI'] );
	// print_r( $ct['page']['etc']['tabs'] );
	// print_r( $_SESSION['account']['gruppi'] );
	// echo $cf['contents']['updated'];
