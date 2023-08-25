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
     * @todo finire di documentare
     *
     * @file
     *
     */

    // debug
	// print_r( $_SESSION );

    // tabella della vista
	$ct['view']['table'] = '__templates__';

    $ct['view']['data']['__filesystem_mode__'] = 1;

    // id della vista
    # $ct['view']['id'] = md5( $ct['view']['table'] );

    // pagina per la gestione degli oggetti esistenti
	$ct['view']['open']['page'] = 'template.pagine.form';

    // campi della vista
	$ct['view']['cols'] = array(
	    'template' => 'template'
	);

    // stili della vista
	$ct['view']['class'] = array(
	    'template' => 'text-left'
	);

    // elenco template
    $templates = getFilteredDirList( DIR_SRC_TEMPLATES );

    // dati della vista
    foreach( $templates as $template ) {
        if( ! in_array( trim( basename( $template ), '_' ), array( 'athena' ) ) ) {
            $ct['view']['data'][] = array(
                'id' => trim( basename( $template ), '_' ),
                'template' => trim( basename( $template ), '_' )
            );
        }
    }

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.view.php';

    // ordinamento
    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['template'] ) && $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['template'] == 'DESC' ) {
        arraySortBy( 'template', $ct['view']['data'], ARRAY_SORT_DSC );
    } else {
        arraySortBy( 'template', $ct['view']['data'], ARRAY_SORT_ASC );
    }

    // filtro
    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] ) ) {
        arrayFilterBy( NULL, $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'], $ct['view']['data'] );
    }

    // debug
    // print_r( $ct['view']['data'] );
    // print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__'] );
    // print_r( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] );
    // print_r( $templates );
