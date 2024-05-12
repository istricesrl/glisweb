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
	$ct['form']['table'] = 'pagine';

    // gruppi di controlli
    $ct['page']['contents']['metros'] = array(
        'azioni' => array(
        'label' => NULL
        )
    );

    // duplica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'duplica', 'include' => 'inc/pagine.form.tools.modal.duplica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-files-o',
	    'title' => 'duplica pagina',
	    'text' => 'duplica la pagina corrente'
	);

    // pubblica pagina
	$ct['page']['contents']['metro']['azioni'][] = array(
        'modal' => array('id' => 'pubblica', 'include' => 'inc/pagine.form.tools.modal.pubblica.html' ),
	    'icon' => NULL,
	    'fa' => 'fa-cloud-upload',
	    'title' => 'pubblica pagina',
	    'text' => 'pubblica la pagina corrente'
	);

    // stages
    $ct['etc']['stages'] = array();

    foreach( array_keys( $cf['mysql']['profiles'] ) as $stage ) {
        if( $stage != SITE_STATUS ) {
            $ct['etc']['stages'][] = array( 'id' => $stage, '__label__' => $stage );
        }
    }

    // ...
    $ct['etc']['upload']['all'] = array_merge(
        mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM immagini WHERE id_pagina = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) )
        ,
        mysqlSelectColumn( 'path', $cf['mysql']['connection'], 'SELECT path FROM file WHERE id_pagina = ?', array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) ) )
    );

    // ...
    $template = mysqlSelectValue(
        $cf['mysql']['connection'],
        'SELECT template FROM pagine WHERE id = ?',
        array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
    );

    // ...
    $ct['etc']['upload']['all'] = array_merge(
        $ct['etc']['upload']['all'],
        getRecursiveFileList( path2custom( DIR_BASE . '/' . $template ) )
    );

    // dati della vista per i moduli
    foreach( $cf['mods']['active']['array'] as $mod ) {
        $ct['etc']['upload']['all'] = array_merge(
            $ct['etc']['upload']['all'],
            getRecursiveFileList( path2custom( DIR_MOD . '_' . $mod . '/' . $template ) )
        );
    }

    // ...
    // TODO questo e gli altri file latest andrebbero spostati in var/spool/latest/
    foreach( $ct['etc']['stages'] as $stage ) {
        $stage = strtolower( $stage['id'] );
        if( file_exists( DIR_VAR .'latest.deploy.'.$stage.'.conf' ) ) {
            $refDate = filemtime( DIR_VAR .'latest.deploy.'.$stage.'.conf' );
            foreach( $ct['etc']['upload']['all'] as $file ) {
                if( filemtime( $file ) > $refDate ) {
                    $ct['etc']['upload'][ $stage ] = $file;
                }
            }
        }
    }

    // debug
    // die( $template );
    // die( print_r( $ct['etc']['upload'], true ) );

    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    require DIR_SRC_INC_MACRO . '_default.tools.php';
