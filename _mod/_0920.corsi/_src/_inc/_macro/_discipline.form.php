<?php

    /**
     *
     *
     *
     * @todo documentare
     *
     * @file
     *
     */

    // tabella gestita
    $ct['form']['table'] = 'categorie_progetti';

    if( isset( $_REQUEST[ $ct['form']['table'] ]['id'] ) ){

        // tendina categorie
        $ct['etc']['select']['categorie_progetti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM discipline_view WHERE id <> ?',
            array( array( 's' => $_REQUEST[ $ct['form']['table'] ]['id'] ) )
        );

    } else {

        // tendina categorie
        $ct['etc']['select']['categorie_progetti'] = mysqlCachedIndexedQuery(
            $cf['memcache']['index'],
            $cf['memcache']['connection'],
            $cf['mysql']['connection'],
            'SELECT id, __label__ FROM discipline_view'
        );

    }

    // tendina discipline
    $ct['etc']['select']['discipline'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM discipline_view'
    );

  
    // tendina siti
    $ct['etc']['select']['siti'] = $cf['sites'];

    // tendina tipologie pubblicazioni
    $ct['etc']['select']['tipologie_pubblicazioni'] = mysqlCachedIndexedQuery(
        $cf['memcache']['index'],
        $cf['memcache']['connection'],
        $cf['mysql']['connection'],
        'SELECT id, __label__ FROM tipologie_pubblicazioni_view'
    );

    // tendina templates
    $tpl = glob( DIR_BASE . '{_,}src/{_,}templates/*', GLOB_BRACE );
    foreach( $tpl as $t ) {
        if( file_exists( $t . '/etc/template.conf' ) ) {
            $ct['etc']['select']['templates'][] = array( 'id' => str_replace( DIR_BASE, '', $t ).'/', '__label__' => basename( $t ) );
        }
    }


    // dati che dipendono dal template
    if( isset( $_REQUEST[ $ct['form']['table'] ]['template'] ) ) {

        // controllo file
        if( file_exists( DIR_BASE . $_REQUEST[ $ct['form']['table'] ]['template'] . '/etc/template.conf' ) ) {

            // ricerca schemi
            $schemi = array_merge(
                glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE ),
                glob( DIR_MOD_ATTIVI . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/*.html', GLOB_BRACE )
            );

            // tendina schemi
            foreach( $schemi as $t ) {
                $ct['etc']['select']['schemi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
            }

            // tendina temi
            $temi = glob( DIR_BASE . glob2custom( $_REQUEST[ $ct['form']['table'] ]['template'] ) . '/css/{,themes/}*.css', GLOB_BRACE );
            foreach( $temi as $t ) {
                $ct['etc']['select']['temi'][] = array( 'id' => basename( $t ), '__label__' => basename( $t ) );
            }

        }

    }
    // macro di default
	require DIR_SRC_INC_MACRO . '_default.form.php';
    