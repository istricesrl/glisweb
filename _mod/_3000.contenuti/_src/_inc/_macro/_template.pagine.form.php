<?php

    /**
     * macro form anagrafica
     *
     *
     *
     * -# definizione della tabella del modulo
     * -# popolazione delle tendine
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

    // tabella gestita
	$ct['form']['table'] =  '__templates__';

    $ct['form']['__filesystem_mode__'] = 1;

    // tendina tipologie file
	$ct['etc']['select']['tipologie'] = array( 
	    array( 'id' => 'html', '__label__' => 'schemi HTML/Twig' ),
	    array( 'id' => 'css', '__label__' => 'fogli di stile CSS' ),
	    array( 'id' => 'js', '__label__' => 'script Javascript' ),
	);

    // tendina moduli
	$ct['etc']['select']['moduli'] = array();

    // aggiungo i moduli attivi
    foreach( $cf['mods']['active']['array'] as $mod ) {
        $ct['etc']['select']['moduli'][] = array(
            'id' => $mod,
            '__label__' => str_replace( '.', ' / ', $mod )
        );
    }

    // tabella della vista
    $ct['view']['table'] = '__template_files__';

    $ct['view']['data']['__filesystem_mode__'] = 1;

    // campi della vista
    $ct['view']['cols'] = array(
        'id' => '#',
        '__label__' => 'file',
        'tipo' => 'tipo',
        'modulo' => 'modulo'
    );

    // stili della vista
    $ct['view']['class'] = array(
        'id' => 'd-none',
        'modulo' => 'text-left',
        '__label__' => 'text-left'
    );

    // inclusione filtri speciali
	$ct['etc']['include']['filters'] = 'inc/template.pagine.form.filters.html';

    // inclusione inserimento rapido
    $ct['etc']['include']['insert'][] = array(
        'name' => 'insert',
        'file' => 'inc/template.pagine.form.file.insert.html',
        'fa' => 'fa-plus-circle'
    );

    // pagina per la gestione degli oggetti esistenti
    $ct['view']['open']['page'] = 'template.pagine.form.editor';
    $ct['view']['open']['table'] = '__template_files__';
    $ct['view']['open']['field'] = 'file';

    $ct['view']['master']['table'] = '__templates__';
    $ct['view']['master']['field'] = 'id';

    $ct['view']['open']['extra'] = array(
        '__template_files__' => array( 'modulo', 'folder' )
    );

    // directory del template
    $base = DIR_BASE . '_src/_templates/_' . $_REQUEST[ $ct['form']['table'] ]['id'];

    // debug
    // die( $base );

    // file del template
    $files = getRecursiveFileList( $base, true );

    // ...
    // sort( $files );

    // debug
    // die( print_r( $files, true ) );

    // dati della vista
    foreach( $files as $file ) {
        // die( $file );
        // die( dirname( $file ) );
        $key = path2custom( $file );
        $ct['view']['data'][ $key ] = array(
            'id' => $_REQUEST[ $ct['form']['table'] ]['id'],
            'key' => str_replace( $base, '', $file ),
            'folder' => str_replace( $base, '', dirname( $file ) ),
            'file' => str_replace( $base, '', basename( $file ) ),
            'tipo' => getFileExtension( $file ),
            'template' => $_REQUEST[ $ct['form']['table'] ]['id'],
            'modulo' => NULL,
            '__label__' => str_replace( $base, '', $file )
            // '__label__' => $file
        );
    }

    // debug
    // die( print_r( $ct['view']['data'], true ) );

    // directory del template
    $base = path2custom( $base );

    // file del template
    $files = getRecursiveFileList( $base, true );

    // dati della vista
    foreach( $files as $file ) {
        $key = path2custom( $file );
        $ct['view']['data'][ $key ] = array(
            'id' => $_REQUEST[ $ct['form']['table'] ]['id'],
            'key' => str_replace( $base, '', $file ),
            'folder' => str_replace( $base, '', dirname( $file ) ),
            'file' => str_replace( $base, '', basename( $file ) ),
            'tipo' => getFileExtension( $file ),
            'template' => $_REQUEST[ $ct['form']['table'] ]['id'],
            'modulo' => NULL,
            '__label__' => str_replace( $base, '', $file )
        );
    }

    // dati della vista per i moduli
    foreach( $cf['mods']['active']['array'] as $mod ) {
        $base = DIR_MOD . '_' . $mod . '/_src/_templates/_' . $_REQUEST[ $ct['form']['table'] ]['id'];
        $files = getRecursiveFileList( $base );
        foreach( $files as $file ) {
            $key = path2custom( $file );
            $ct['view']['data'][ $key ] = array(
                'id' => $_REQUEST[ $ct['form']['table'] ]['id'],
                'key' => str_replace( $base, '', $file ),
                'folder' => str_replace( $base, '', dirname( $file ) ),
                'file' => str_replace( $base, '', basename( $file ) ),
                'tipo' => getFileExtension( $file ),
                'template' => $_REQUEST[ $ct['form']['table'] ]['id'],
                'modulo' => $mod,
                '__label__' => str_replace( $base, '', $file )
            );
        }
        $base = path2custom( $base );
        $files = getRecursiveFileList( $base, true );
        foreach( $files as $file ) {
            $key = path2custom( $file );
            $ct['view']['data'][ $key ] = array(
                'id' => $_REQUEST[ $ct['form']['table'] ]['id'],
                'key' => str_replace( $base, '', $file ),
                'folder' => str_replace( $base, '', dirname( $file ) ),
                'file' => str_replace( $base, '', basename( $file ) ),
                'tipo' => getFileExtension( $file ),
                'template' => $_REQUEST[ $ct['form']['table'] ]['id'],
                'modulo' => $mod,
                '__label__' => str_replace( $base, '', $file )
            );
        }
    }

    // debug
    // die( print_r( $files, true ) );
    // die( print_r( $ct['view']['data'], true ) );
    // die( 'righe: ' . count( $ct['view']['data'] ) );

    // gestione default
    require DIR_SRC_INC_MACRO . '_default.view.php';

    // debug
    // die( print_r( $_REQUEST['__view__'][ $ct['view']['id'] ], true ) );

    // ordinamento
    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['template'] ) && $_REQUEST['__view__'][ $ct['view']['id'] ]['__sort__']['__label__'] == 'DESC' ) {
        arraySortBy( array( 'folder', 'modulo', 'file' ), $ct['view']['data'], ARRAY_SORT_DSC );
    } else {
        arraySortBy( array( 'folder', 'modulo', 'file' ), $ct['view']['data'], ARRAY_SORT_ASC );
    }

    // filtro
    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'] ) ) {
        arrayFilterBy( NULL, $_REQUEST['__view__'][ $ct['view']['id'] ]['__search__'], $ct['view']['data'] );
    }

    // filtro
    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['moduli']['EQ'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['moduli']['EQ'] ) ) {
        arrayFilterBy( 'modulo', $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['moduli']['EQ'], $ct['view']['data'] );
    }

    // filtro
    if( isset( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['tipologie']['EQ'] ) && ! empty( $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['tipologie']['EQ'] ) ) {
        arrayFilterBy( 'tipo', '.' . $_REQUEST['__view__'][ $ct['view']['id'] ]['__filters__']['tipologie']['EQ'], $ct['view']['data'] );
    }

    // macro di default
	require DIR_MOD . '_3000.contenuti/_src/_inc/_macro/_template.pagine.form.default.php';
	require DIR_SRC_INC_MACRO . '_default.form.php';

    // debug
    // print_r( $_REQUEST[ $ct['form']['table'] ] );
